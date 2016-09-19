!!!####################
MODULE IntegrandSHG1_tranMod_Leitsman_two
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
  REAL(DP) FUNCTION SHG1_tran_factor_Leitsman_two()
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
    SHG1_tran_factor_Leitsman_two = res
     !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG1_tran_factor_Leitsman_two=SHG1_tran_factor_Leitsman_two*4.189E-4*1E12
     SHG1_tran_factor_Leitsman_two=SHG1_tran_factor_Leitsman_two/2.
    !######### 29 Nov. 2008 ##########


!!!#######################
  END FUNCTION SHG1_tran_factor_Leitsman_two
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG1_tranDeltaFunctionFactor_Leitsman_two()
!!!#########################################
    SHG1_tranDeltaFunctionFactor_Leitsman_two = 1
!!!###################################
  END FUNCTION SHG1_tranDeltaFunctionFactor_Leitsman_two
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1_tran_Leitsman_two(i_spectra)
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
    
    INTEGER :: v,c,l
    INTEGER :: da, db, dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt
    
    COMPLEX(DPC) :: psym1,psym2
    REAL(DP) :: omegacv,omegalv,omegacl,omegacvlv,omegacvcl
    REAL(DP) :: T3(3,3,3),tmp
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    

    DO v = 1, nVal
        DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   do l=1,nMaxCC
                      if((l.ne.v).and.(l.ne.c))then
                         omegacl=band(c)-band(l)
                         omegalv=band(l)-band(v)
                         omegacvlv=(2.*omegacv-omegalv)
                         IF ((omegacvlv.ge.0.d0).and.(omegacvlv.le.tolSHGt))    omegacvlv=omegacvlv+tolSHGt
                         IF ((omegacvlv.le.0.d0).and.(omegacvlv.ge.(-tolSHGt))) omegacvlv=omegacvlv-tolSHGt
                        
                         omegacvcl=(2.*omegacv-omegacl)

                         IF ((omegacvcl.ge.0.d0).and.(omegacvcl.le.tolSHGt))    omegacvcl=omegacvcl+tolSHGt
                         IF ((omegacvcl.le.0.d0).and.(omegacvcl.ge.(-tolSHGt))) omegacvcl=omegacvcl-tolSHGt
                        
                         psym1=(momMatElem(db,l,c)*momMatElem(dc,c,v)+momMatElem(dc,l,c)*momMatElem(db,c,v))/2.
                         psym2=(momMatElem(db,c,v)*momMatElem(dc,v,l)+momMatElem(dc,c,v)*momMatElem(db,v,l))/2.
                         tmp=tmp+(T3(da,db,dc)/omegacv**3)*(aimag(momMatElem(da,v,l)*psym1)/(omegacvlv) -aimag(momMatElem(da,l,c)*psym2)/(omegacvcl))
  
                      end if
                   end do
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
    
!!!##################
  END SUBROUTINE SHG1_tran_Leitsman_two
!!!##################
  
!!!########################
END MODULE IntegrandSHG1_tranMod_Leitsman_two
!!!########################
