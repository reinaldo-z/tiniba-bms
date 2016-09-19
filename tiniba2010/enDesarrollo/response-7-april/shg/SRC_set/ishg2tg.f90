!!!####################
MODULE IntegrandSHG2_tranMod
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
  REAL(DP) FUNCTION SHG2_tran_factor()
!!!##############################
    USE PhysicalConstantsMod
    USE ConstantsMod, ONLY : pi
    TYPE(physicalConstant) :: tmp1, tmp2, tmp3
    TYPE(physicalConstant) :: tmptmp
    TYPE(physicalConstant) :: volume
    REAL(DP) :: res
    
    volume = BohrRadius_cgs ** 3
    tmp1 = (electronCharge_cgs ** 3) / (hbar_cgs ** 2)
    tmp1 = tmp1 * (momentumFactor_cgs ** 3)
    tmp1 = tmp1 / (electronMass_cgs ** 3)
    tmp1 = tmp1 / (frequency_cgs ** 5)
    tmp1 = tmp1 / volume
    res = makeDouble(tmp1)
    res = res*pi
    SHG2_tran_factor = res
!!!#######################
  END FUNCTION SHG2_tran_factor
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG2_tranDeltaFunctionFactor()
!!!#########################################
    SHG2_tranDeltaFunctionFactor = 2
!!!###################################
  END FUNCTION SHG2_tranDeltaFunctionFactor
!!!###################################
  
!!!#########################
  SUBROUTINE SHG2_tran(i_spectra)
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
    INTEGER :: ia, ib,  ic
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(DPC) :: psym
    REAL(DP) :: eji, ejl, eli,tmp
    REAL(DP) :: T3(3,3,3)

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    DO ii = 1, nVal
       DO ij = nVal+1, nMaxCC
          eji=band(ij) - band(ii)
          tmp = (0.d0, 0.d0)
          DO ia=1,3
             DO ib=1,3
                DO ic=1,3
!!virtual hole
                   DO il = 1, nVal
                      ejl = band(ij) - band(il)
                      psym=( momMatElem(ib,ij,il) * momMatElem(ic,il,ii)+&
                             momMatElem(ic,ij,il) * momMatElem(ib,il,ii))/2.
!like in ghahramani                      tmp = tmp - 16.*T3(ia,ib,ic)*aimag(momMatElem(ia,ii,ij)*psym) / (eji**3*(2.d0*ejl - eji))
                      tmp = tmp - 16.*T3(ia,ib,ic)*aimag(momMatElem(ia,ii,ij)*psym) / (eji**3*(eji-2.d0*ejl))
                   END DO

!!virtual electron
                   DO il = nVal + 1, nMaxCC
                      eli = band(il) - band(ii)
                      psym=(momMatElem(ib,ij,il) * momMatElem(ic,il,ii)+momMatElem(ic,ij,il) * momMatElem(ib,il,ii))/2.
!  like in ghahramani                    tmp = tmp + 16.*T3(ia,ib,ic)*aimag(momMatElem(ia,ii,ij)*psym) / (eji**3*(2.0*eli - eji))
                      tmp = tmp + 16.*T3(ia,ib,ic)*aimag(momMatElem(ia,ii,ij)*psym) / (eji**3*(eji-2.0*eli))
                   END DO


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
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)

!!!##################
  END SUBROUTINE SHG2_tran
!!!##################
  
!!!########################
END MODULE IntegrandSHG2_tranMod
!!!########################
