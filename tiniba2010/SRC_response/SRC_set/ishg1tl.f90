!!!####################
MODULE IntegrandSHG1_tranMod_Leitsman_three
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
  REAL(DP) FUNCTION SHG1_tran_factor_Leitsman_three()
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
    SHG1_tran_factor_Leitsman_three = res

  END FUNCTION SHG1_tran_factor_Leitsman_three
  
!!!#########################################
  INTEGER FUNCTION SHG1_tranDeltaFunctionFactor_Leitsman_three()
    SHG1_tranDeltaFunctionFactor_Leitsman_three = 1
  END FUNCTION SHG1_tranDeltaFunctionFactor_Leitsman_three
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1_tran_Leitsman_three(i_spectra)
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
    REAL(DP) :: omegacv,omegavn,omeganc

    INTEGER :: n,v,c
    INTEGER :: da, db,  dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt    
    COMPLEX(DPC) :: psym1,psym2,dsym
    !    COMPLEX(DPC) :: ctmp, ctmp1, ctmp2, ctmp3, ctmp4
    REAL(DP) :: T3(3,3,3)
!    REAL(DP) :: tmp2,tmp3
    complex(DP) :: tmp2,tmp3,t1,t2
    COMPLEX(DPC) :: deltacv
!!!<><><><><><><><><><> begin code <><><><><><><><><><>
!!!<><><><><><><><><><> begin code <><><><><><><><><><>

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp3 = 0.d0
          tmp2 = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3           
!!! ============= Leitsman ============================
                   dsym=(Delta(db,c,v)*momMatElem(dc,c,v)+Delta(dc,c,v)*momMatElem(db,c,v))/2.
                   tmp2=tmp2-T3(da,db,dc)*aimag(momMatElem(da,v,c)*dsym)/omegacv**4
                   DO n = 1,nMaxCC !! sobre v y c
                      if((n.ne.v).and.(n.ne.c)) then
                         omeganc=band(n) - band(c)
                         omegavn=band(v) - band(n)
                         psym1=(momMatElem(db,n,c)*momMatElem(dc,c,v)+momMatElem(dc,n,c)*momMatElem(db,c,v))/2.
                         psym2=(momMatElem(db,c,v)*momMatElem(dc,v,n)+momMatElem(dc,c,v)*momMatElem(db,v,n))/2.
                         t1=aimag(momMatElem(da,v,n)*psym1)/(omegacv**3*(omegacv - omeganc))
                         t2=aimag(momMatElem(da,n,c)*psym2)/(omegacv**3*(omegavn - omegacv))
                         tmp3 = tmp3 - T3(da,db,dc)*(t1+t2)
                      end if
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
                  FMT=104,ADVANCE="YES") real(tmp3)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") real(tmp3)
          END IF

       END DO
    END DO
104 FORMAT(E15.7)





  END SUBROUTINE SHG1_tran_Leitsman_three
!!!##################

END MODULE IntegrandSHG1_tranMod_Leitsman_three
