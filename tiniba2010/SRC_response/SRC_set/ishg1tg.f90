!!!####################
MODULE IntegrandSHG1_tranMod
!!!####################
  ! 
  ! Module contains two subroutines for the calculation of
  ! the first part of the SHG tensor.
  ! First subroutine calculates the overall factor for SHG1.
  ! Second subroutine calculates the integrand of SHG1.
  ! 
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!##############################
  REAL(DP) FUNCTION SHG1_tran_factor()
!!!##############################
    USE PhysicalConstantsMod
    USE ConstantsMod, ONLY : pi
    TYPE(physicalConstant) :: tmp1, tmp2, tmp3
    TYPE(physicalConstant) :: tmptmp
    TYPE(physicalConstant) :: volume
    REAL(DP) :: res
    
    volume = BohrRadius_cgs ** 3
    tmp1 = (electronCharge_cgs ** 3)/(hbar_cgs **2) 
    tmp1 = tmp1 * (momentumFactor_cgs ** 3)
    tmp1 = tmp1 / (electronMass_cgs ** 3)
    tmp1 = tmp1 / (frequency_cgs ** 5)
    tmp1 = tmp1 / volume
    res = makeDouble(tmp1)
    res = res*pi
    SHG1_tran_factor = res
!!!#######################
  END FUNCTION SHG1_tran_factor
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG1_tranDeltaFunctionFactor()
!!!#########################################
    SHG1_tranDeltaFunctionFactor = 1
!!!###################################
  END FUNCTION SHG1_tranDeltaFunctionFactor
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1_tran(i_spectra)
!!!#########################
    !
    ! This computes the integrand of the imaginary part of
    ! the nonlinear response tensor Lambda
    !
    !!USE InputParametersMod, ONLY : nVal, nMax, nSym, tol
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    USE PhysicalConstantsMod
    USE InputParametersMod, ONLY : tolSHGt    

    IMPLICIT NONE

    INTEGER :: ii, ij, il
    INTEGER :: ia, ib, ic
    !    INTEGER :: ia, ib,  id
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(DPC) :: ctmp_ve, ctmp_vh
    COMPLEX(DPC) :: t1,t2,t4,t5
    COMPLEX(DPC) :: ctmp, ctmp1, ctmp2, ctmp3, ctmp4
    REAL(DP) :: eli, eji, ejl
    REAL(DP) :: T3(3,3,3)

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    !write(56,*)"tolSHGt",tolSHGt

    DO ii = 1, nVal
       !!DO ij = nVal+1, nMax
       DO ij = nVal+1, nMaxCC
          ejl = band(ij) - band(ii)
          eli = band(ij) - band(ii)
          ctmp = (0.d0, 0.d0)
          DO ia=1,3
             DO ib=1,3
                DO ic=1,3
!!! virtual hole
                   DO il = 1, nVal
                      !                      if(il.ne.ii) then
                      eji=band(ij) - band(il)
!!! t1=2_2
                      t1=aimag(momMatElem(ia,il,ii) * ((momMatElem(ib,ii,ij) * momMatElem(ic,ij,il)+&
                           momMatElem(ic,ii,ij) * momMatElem(ib,ij,il))/2.)) / (ejl**3 * (ejl + eji))
!!! t2=3_2
                      t2=aimag(momMatElem(ia,ii,ij) * ((momMatElem(ib,ij,il) * momMatElem(ic,il,ii)+&
                           momMatElem(ib,ij,il) * momMatElem(ic,il,ii))/2.)) / (ejl**3 * (2.d0*ejl - eji))
                      ctmp = ctmp + T3(ia,ib,ic)*(-t1+t2) !but in ghahramani is t2-t1
                   END DO
!!! virtual electron
                   DO il = nVal + 1, nMaxCC
                      eji = band(il) - band(ii)
!!! t4=3_1
                      t4=aimag(momMatElem(ia,ij,il) *(( momMatElem(ib,il,ii) * momMatElem(ic,ii,ij)+&
                           momMatElem(ic,il,ii) * momMatElem(ib,ii,ij) )/2.)) / (eli**3 * (eli + eji))
!!! t5=2_1
                      t5=aimag(momMatElem(ia,ii,ij) *(( momMatElem(ib,ij,il) * momMatElem(ic,il,ii) +&
                           momMatElem(ic,ij,il) * momMatElem(ib,il,ii))/2.)) / (eli**3 * (2.d0*eli - eji))
                      ctmp = ctmp + T3(ia,ib,ic)*(-t5+t4) !but in ghahramani is t4-t5
                   end DO

                END DO
             END DO
          END DO

          !!IF (ij==nMax) THEN
          IF (ij==nMaxCC) THEN
             ADV_opt = "YES"
          ELSE
             ADV_opt = "NO"
          END IF

          !!IF (ij==nMax) THEN
          IF (ij==nMaxCC) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF

       END DO
    END DO
104 FORMAT(E15.7)

!!!##################
  END SUBROUTINE SHG1_tran
!!!##################
  
!!!########################
END MODULE IntegrandSHG1_tranMod
!!!########################
