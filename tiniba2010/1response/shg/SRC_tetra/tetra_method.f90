!!!#########
PROGRAM LATM
!!!#########
  USE ConstantsMod, ONLY : DP
  
  USE InputParametersMod, ONLY : nMaxCC !! Nueva variable


  USE InputParametersMod, ONLY : paramFile
  USE InputParametersMod, ONLY : nMax
  USE InputParametersMod, ONLY : nTrans
  USE InputParametersMod, ONLY : nTetra
  USE InputParametersMod, ONLY : units_factor
  USE InputParametersMod, ONLY : energySteps
  USE InputParametersMod, ONLY : nVal
  USE InputParametersMod, ONLY : spectrum_filename
  
  USE InputParametersFileMod, ONLY : parseParamFile
  
  USE SortMod, ONLY : piksort
  
  USE LoadIntegrandMod, ONLY : Load_Integrand
  USE LoadIntegrandMod, ONLY : f
  
  USE TransitionsMod, ONLY : Initialize_Transition_Index
  USE TransitionsMod, ONLY : Which_Transitions
  USE TransitionsMod, ONLY : ind_Trans
  USE TransitionsMod, ONLY : includeTransition
  
  USE TetrahedraMod, ONLY : Load_Tetrahedra_Data
  USE TetrahedraMod, ONLY : Which_Tetrahedra
  USE TetrahedraMod, ONLY : includeTetrahedron
  USE TetrahedraMod, ONLY : tetCorner
  USE TetrahedraMod, ONLY : tetrahedronVolume
  
  USE ReadEnergiesMod, ONLY : Read_Energies
  USE ReadEnergiesMod, ONLY : ScaleEnergies
  USE ReadEnergiesMod, ONLY : Load_Transition_Energies
  USE ReadEnergiesMod, ONLY : transitionEnergy
  
  USE EnergyMeshMod, ONLY : Load_Energy_Mesh
  USE EnergyMeshMod, ONLY : energyOut
  
  IMPLICIT NONE
  
  INTEGER :: j
  INTEGER :: iTmp1
!!! variables for final output
  INTEGER :: iEnergy
  REAL(DP) :: energy
  REAL(DP), ALLOCATABLE :: pp(:,:)
!!! 
  REAL(DP), ALLOCATABLE :: preTotal(:,:)
  REAL(DP) :: total
  REAL(DP) :: cornTrans(4)
  REAL(DP) :: fh
  REAL*8 :: p(4)
  REAL*8 :: e21, e31, e42, de
!!! pp is the total contribution at one energy for one transition.
  REAL*8 :: S1, S2, S3, S4
  INTEGER :: iTetra, iTrans, ic, iv
  INTEGER :: iostat
  
  CALL getarg(1,paramFile)
  
  CALL parseParamFile
  CALL Read_Energies
  CALL Initialize_Transition_Index
  CALL Load_Integrand
  CALL scaleEnergies
  CALL Load_Transition_Energies
  CALL Which_Transitions
  CALL Load_Tetrahedra_Data
  CALL Which_Tetrahedra
  CALL Load_Energy_Mesh
  
  WRITE(6,*) 'Total transitions= ', nTrans
  WRITE(*,*) 'tetrahedron MAIN started:  here we go jl'
  WRITE(6,*) 'infront: ', units_factor
  
  ALLOCATE(pp(energySteps,nMax*nMax))
  pp = 0.d0  ! initialize pp !!!!! R E A L L Y   I M P O R T A N T
  ALLOCATE(preTotal(energySteps,nTrans))
  
!!! cycle over valence and conduction levels
  
  DO iv = 1, nVal
     !! DO ic = nVal+1, nMax
        DO ic = nVal+1, nMaxCC
        iTrans = ind_Trans(iv,ic)
        IF (.NOT.(includeTransition(iTrans))) CYCLE
        
        WRITE(6,*) iv, ic
        
!!! loop over tetrahedra
        DO iTetra = 1, nTetra
           
!!! this checks if we want to include this tetrahedron in the calculation
           IF (.NOT.(includeTetrahedron(iTetra))) CYCLE
           
!!! Store corner energy transistions in cornTrans
!!! Get integrand at corners of tetrahedron
           DO j = 1, 4
              iTmp1 = tetCorner(iTetra,j)
              cornTrans(j) = transitionEnergy(iTmp1,iTrans)
              p(j) = f(tetCorner(iTetra,j), iTrans)
!!!              p(j) = 1.d0
           END DO
!!!        
!!! Sort energies at corners into ascending order, and accordingly
!!! reorder the function values.
!!!        
           CALL piksort(4,cornTrans,p)
           
           DO ienergy=1, energySteps
              energy = energyOut(ienergy)
              IF (energy.GE.cornTrans(1).AND.energy.LT.cornTrans(2)) THEN
!!! in region I
                 pp(ienergy,iTrans)=pp(ienergy,iTrans) &
                      + S1(energy,cornTrans,p)*tetrahedronVolume(iTetra)
              ELSE IF (energy.GE.cornTrans(2).AND.energy.LT.cornTrans(3)) THEN
!!! in region II
                 pp(ienergy,iTrans)=pp(ienergy,iTrans) &
                      + S3(energy,cornTrans,p)*tetrahedronVolume(iTetra)
              ELSE IF (energy.GE.cornTrans(3).AND.energy.LT.cornTrans(4)) THEN
!!! in region III
                 pp(ienergy,iTrans)=pp(ienergy,iTrans) &
                      + S4(energy,cornTrans,p)*tetrahedronVolume(iTetra)
              END IF
           END DO     ! iEnergy
        END DO     ! iTetra
     END DO     ! ic
  END DO     ! iv
  ! output
  WRITE(*,*) 'opening: ', spectrum_filename
  OPEN(77,FILE=spectrum_filename)
  DO ienergy=1, energySteps
     energy = energyOut(ienergy)
     WRITE(77,99) energy, SUM(pp(ienergy,1:nMax*nMax))*units_factor
99   FORMAT(2E15.7)
  END DO
  CLOSE(77)
  !!!!!!!!!!!cabellos  for the script 
  call system("touch latmEND")


!!!#############
END PROGRAM LATM
!!!#############

!!!############################
FUNCTION S1(energy,cornTrans,p)
!!!############################
!!!
!!! Case 1. e1<e<e2
!!!
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  REAL(DP) :: S1, energy, cornTrans(4), p(4)
  REAL(DP) :: de, e21, e31, e41, fh
  de = energy - cornTrans(1)
  e21 = cornTrans(2) - cornTrans(1)
  e31 = cornTrans(3) - cornTrans(1)
  e41 = cornTrans(4) - cornTrans(1)
!!! choice 1
  fh = 3*p(1) + (p(2)-p(1))*de/e21 + (p(3)-p(1))*de/e31 + (p(4)-p(1))*de/e41
  fh = fh/3.d0
!!! choice 2
!!!  fh = 0.25d0*SUM(p)
  S1 = 3.d0*fh*de**2/(e21*e31*e41)
  RETURN
!!!############
END FUNCTION S1
!!!############

!!!############################
FUNCTION S2(energy,cornTrans,p)
!!!############################
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  REAL(DP) :: S2, energy, cornTrans(4), p(4)
  REAL(DP) :: de, e21, e32, e42, fh
  de = energy - cornTrans(2)
  e21 = cornTrans(2) - cornTrans(1)
  e32 = cornTrans(3) - cornTrans(2)
  e42 = cornTrans(4) - cornTrans(2)
!!!!!!!!!!!!!!!!!!!!!!!!!! CHECK THIS LINE !!!!!!!!!!!!!!!!!!!!!!!!
!fh = 3*p(2) + (p(1)-p(2))*de/e12 + (p(3)-p(2))*de/e32 + (p(4)-p(2))*de/e42
!  fh =      p(1) + (p(2)-p(1))*(energy-cornTrans(1))/e21
!  fh = fh + p(2) + (p(3)-p(2))*de/e32
!  fh = fh + p(2) + (p(4)-p(2))*de/e42
!  fh = fh/3.d0
  fh = 0.25d0*SUM(p)
  S2 = 3.d0*fh*de**2/(e21*e32*e42)
!  If (S2.GT.10.d0) pause
  RETURN
!!!############
END FUNCTION S2
!!!############

!!!############################
FUNCTION S3(energy,cornTrans,p)
!!!############################
!!!
!!! Case 2. e1<e<e2
!!!
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  REAL(DP) :: S1, S2, S3, energy, cornTrans(4), p(4)
  REAL(DP) :: e, e1, e2, e3, e4, ee1234, e1234 
  REAL(DP) :: f1, f2, f3, f4
  REAL(DP) :: de, de1, de2, de3, de4
  REAL(DP) :: tmp, tmp1, tmp2
  REAL(DP) :: fh
  REAL(DP) :: numerator, denominator
  
!!! Choice one: explicit formula for the area
  e = energy
  e1 = cornTrans(1)
  e2 = cornTrans(2)
  e3 = cornTrans(3)
  e4 = cornTrans(4)
!  ee1234 = e*e*(e1+e2-e3-e4)
!  e1234  = e*(e1*e2-e3*e4)
! 
!  fh = 0.25d0*SUM(p)
!  numerator = -e1*e2*e3 - e1*e2*e4 + e1*e3*e4 + e2*e3*e4
!  numerator = numerator + 2.d0*e1234 - ee1234
!  denominator = -(e3-e1)*(e4-e1)*(e3-e2)*(e4-e2)
!  S3 = 3.d0*fh*numerator/denominator
  
!!! Choice two: the difference of two areas
!  S3 = S1(energy,cornTrans,p) - S2(energy,cornTrans,p)
!  If you use choice two, you must uethe average of the function
!  over the entire tetrahedron!!!!!
  
!!! Choice three: Bernd and Claudia's version
  
  f1 = p(1)
  f2 = p(2)
  f3 = p(3)
  f4 = p(4)
  
  de  = e - e2
  de1 = e3 - e1
  de2 = e4 - e2
  de3 = e3 - e2
  de4 = e2 - e1
  
  tmp = de*(e3-e)/(de2*de1*de3)
  tmp1 = tmp*( f1 + 2.d0*f2 + (f3-f1)*de4/de1 + de*(    &
         (f3-f1)/de1 + (f4-f2)/de2 + (f3-f2)/de3) )
  
  de  = e - e1
!  de1 = e3 - e1  ! same as above
!  de2 = e4 - e2  ! same as above
  de3 = e4 - e1
!  de4 = e2 - e1  ! same as above
  
  tmp = de*(e4-e)/(de2*de1*de3)
  tmp2 = tmp*( f2 + 2.d0*f1 + (f2-f4)*de4/de2 + de*(     &
       (f3-f1)/de1 + (f4-f2)/de2 + (f4-f1)/de3) )
  
  S3 = tmp1 + tmp2
  
  RETURN
!!!############
END FUNCTION S3
!!!############

!!!############################
FUNCTION S4(energy,cornTrans,p)
!!!############################
!!!
!!! Case 3. e3<e<e4
!!!
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  REAL(DP) :: S4, energy, cornTrans(4), p(4)
  REAL(DP) :: de, e14, e24, e34, fh
  de = energy - cornTrans(4)
  e14 = cornTrans(1) - cornTrans(4)
  e24 = cornTrans(2) - cornTrans(4)
  e34 = cornTrans(3) - cornTrans(4)
!!! choice 1
  fh = 3*p(4) + (p(1)-p(4))*de/e14 + (p(2)-p(4))*de/e24 + (p(3)-p(4))*de/e34
  fh = fh/3.d0
!!! choice 2
!!!  fh = 0.25d0*SUM(p)
  S4 = 3.d0*fh*de**2/DABS(e14*e24*e34)
  RETURN
!!!############
END FUNCTION S4
!!!############
