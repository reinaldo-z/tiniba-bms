!!!######################
MODULE IntegrandImChi1Mod
!!!######################
  ! 
  ! Module contains two subroutines for the calculation of Im[Chi1].
  ! First subroutine calculates the overall factor for Im[Chi1].
  ! Second subroutine calculates the integrand of Im[Chi1].
  !
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!#########################################
  INTEGER FUNCTION Chi1DeltaFunctionFactor()
!!!#########################################
    Chi1DeltaFunctionFactor = 1
!!!###################################
  END FUNCTION Chi1DeltaFunctionFactor
!!!###################################
  
!!!##############################
  REAL(DP) FUNCTION Chi1_factor()
!!!##############################
    USE PhysicalConstantsMod
    USE ConstantsMod, ONLY : pi
    TYPE(physicalConstant) :: tmp1, tmp2, tmp3
    TYPE(physicalConstant) :: tmptmp
    TYPE(physicalConstant) :: volume
    REAL(DP) :: res
    
    volume = BohrRadius_cgs ** 3
    tmp1 = (electronCharge_cgs ** 2) / hbar_cgs
    tmp1 = tmp1 * (positionFactor_cgs ** 2)
!    tmp1 = tmp1 / (electronMass_cgs ** 2)
    tmp1 = tmp1 / volume
    tmp1 = tmp1 / (frequency_cgs)
    res = makeDouble(tmp1)
    res = res*pi
    Chi1_factor = res
!    Chi1_factor = makeDouble(Hartree_eV) !atomic units
!!!#######################
  END FUNCTION Chi1_factor
!!!#######################
  
!!!###########################
  SUBROUTINE ImChi1(i_spectra)
!!!###########################
    !
    ! This computes the integrand of the imaginary part of
    ! the linear response Chi1
    !
  !!USE InputParametersMod, ONLY : nVal, nMax, nSym, tol
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    
    IMPLICIT NONE
    
    INTEGER, INTENT(IN) :: i_spectra
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: T2(3,3)
    INTEGER :: iv, ic, ip, iq
    INTEGER :: ix, iy, iz, iw
    INTEGER :: ia, ib,  id
    CHARACTER(LEN=3) :: ADV_opt
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )


    write(34,*)"NUEVA nMaxCC=",nMaxCC    
    DO iv = 1, nVal
       !!DO ic = nVal+1, nMax
         DO ic = nVal+1, nMaxCC
          ctmp = (0.d0, 0.d0)
          
          DO ia=1,3
             DO ib=1,3
                
                IF (ABS(T2(ia,ib)).LT.(1.d-6)) CYCLE
                
      ctmp = ctmp + T2(ia,ib)*posMatElem(ia,ic,iv)*posMatElem(ib,iv,ic)
                
             END DO
          END DO
          
          ! The following lines do not seem portable.  They work with most compilers.
          !!IF (ic==nMax) THEN
          IF (ic==nMaxCC) THEN
             ADV_opt = "YES"
          ELSE
             ADV_opt = "NO"
          END IF
          WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
               FMT="(E15.7)",ADVANCE=ADV_opt) REAL(ctmp)
       END DO
    END DO
    
!!!####################
  END SUBROUTINE ImChi1
!!!####################
  
!!!##########################
END MODULE IntegrandImChi1Mod
!!!##########################
