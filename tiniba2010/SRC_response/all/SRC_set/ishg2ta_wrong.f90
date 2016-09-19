!!!####################
MODULE IntegrandSHG2_tranMod_Leitsman_two
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
  REAL(DP) FUNCTION SHG2_tran_factor_Leitsman_two()
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
    SHG2_tran_factor_Leitsman_two = res
      !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG2_tran_factor_Leitsman_two=SHG2_tran_factor_Leitsman_two*4.189E-4*1E12
     SHG2_tran_factor_Leitsman_two=SHG2_tran_factor_Leitsman_two/2.
    !######### 29 Nov. 2008 ##########
       
 
!!!#######################
  END FUNCTION SHG2_tran_factor_Leitsman_two
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG2_tranDeltaFunctionFactor_Leitsman_two()
!!!#########################################
    SHG2_tranDeltaFunctionFactor_Leitsman_two = 2
!!!###################################
  END FUNCTION SHG2_tranDeltaFunctionFactor_Leitsman_two
!!!###################################
  
!!!#########################
  SUBROUTINE SHG2_tran_Leitsman_two(i_spectra)
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
    INTEGER :: da, db,  dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt
    
    COMPLEX(DPC) :: psym
    REAL(DP) :: omegacv,omegalv,omegacl,omegacvlv,omegacvcl
    REAL(DP) :: T3(3,3,3),tmp,fermivl,fermicl
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   do l=1,nMaxCC
                      if((l.ne.v).and.(l.ne.c)) then
                         omegalv=band(l) - band(v)
                         omegacl=band(c) - band(l)
                         omegacvlv=(omegacv-2.*omegalv)
                         IF ((omegacvlv.ge.0.d0).and.(omegacvlv.le.tolSHGt)) omegacvlv=omegacvlv+tolSHGt
                         IF ((omegacvlv.le.0.d0).and.(omegacvlv.gt.(-tolSHGt))) omegacvlv=omegacvlv-tolSHGt
                         omegacvcl=(omegacv-2.*omegacl)
                         IF ((omegacvcl.ge.0.d0).and.(omegacvcl.le.tolSHGt)) omegacvcl=omegacvcl+tolSHGt
                         IF ((omegacvcl.le.0.d0).and.(omegacvcl.gt.(-tolSHGt))) omegacvcl=omegacvcl-tolSHGt
                         psym= (momMatElem(db,c,l) * momMatElem(dc,l,v) + momMatElem(dc,c,l) * momMatElem(db,l,v))/2.
                         fermivl=fermi(nVal,v)-fermi(nVal,l)
                         fermicl=fermi(nVal,c)-fermi(nVal,l)
                         tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/omegacv**3*(fermivl/(omegacvlv) + fermicl/(omegacvcl))
     
                      end if
                   END DO
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
  END SUBROUTINE SHG2_tran_Leitsman_two
!!!##################
!!!##############################
  REAL(DP) FUNCTION fermi(nVal,i)
!!!##############################
    implicit none  
    integer :: nVal,nMaxCC,i,j
!!!
    if(i.le.nVal)  fermi=1.d0 !valence state
    if(i.ge.nVal+1)fermi=0.d0 !conduction state
  end FUNCTION fermi
!!!########################
END MODULE IntegrandSHG2_tranMod_Leitsman_two
!!!########################
