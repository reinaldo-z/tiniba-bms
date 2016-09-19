!!!####################
MODULE IntegrandSHG2_tranMod_Leitsman_three
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
  REAL(DP) FUNCTION SHG2_tran_factor_Leitsman_three()
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
    res = -res*pi
    SHG2_tran_factor_Leitsman_three = res

  END FUNCTION SHG2_tran_factor_Leitsman_three
  
!!!#########################################
  INTEGER FUNCTION SHG2_tranDeltaFunctionFactor_Leitsman_three()
    SHG2_tranDeltaFunctionFactor_Leitsman_three = 2
  END FUNCTION SHG2_tranDeltaFunctionFactor_Leitsman_three
!!!###################################
  
!!!#########################
  SUBROUTINE SHG2_tran_Leitsman_three(i_spectra)
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    USE PhysicalConstantsMod
    USE InputParametersMod, ONLY : tolSHGt    
    USE ArraysMod, ONLY : Delta

    IMPLICIT NONE
    INTEGER :: ivv,icc,inn    
    REAL(DP) :: omegacv,omeganv,omegacn

    INTEGER :: n,v,c
    INTEGER :: da, db,  dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt    
    COMPLEX(DPC) :: psym,dsym
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: tmp
    COMPLEX(DPC) :: deltacv
!!!<><><><><><><><><><> begin code <><><><><><><><><><>
!!!<><><><><><><><><><> begin code <><><><><><><><><><>

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp=0.0
          DO da=1,3
             DO db=1,3
                DO dc=1,3           
!!! ============= Leitsman ============================
                   dsym=(Delta(db,c,v)*momMatElem(dc,c,v)+Delta(dc,c,v)*momMatElem(db,c,v))/2.
                   tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*dsym)/omegacv**4
                   DO n = 1, nMaxCC !! sobre v y c
!                      if((n.ne.v).and.(n.ne.c)) then
                         omeganv=band(n) - band(v)
                         omegacn=band(c) - band(n)
                         psym=(momMatElem(db,c,n)*momMatElem(dc,n,v)+momMatElem(dc,c,n)*momMatElem(db,n,v))/2.
                         tmp = tmp + 16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv**3*(omeganv - omegacn))
!                      end if
                   end do

!!! ============= Leitsman ============================

                END DO
             END DO
          END DO

          IF (c==nMaxCC) THEN
             ADV_opt = "YES"
          ELSE
             ADV_opt = "NO"
          END IF


          IF (c==nMaxCC) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)





  END SUBROUTINE SHG2_tran_Leitsman_three
!!!##################

END MODULE IntegrandSHG2_tranMod_Leitsman_three
