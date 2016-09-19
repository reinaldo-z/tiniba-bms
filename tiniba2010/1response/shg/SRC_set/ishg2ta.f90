!!!####################
MODULE IntegrandSHG2_tranMod_ta_algebra
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
  REAL(DP) FUNCTION SHG2_tran_factor_ta_algebra()
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
    SHG2_tran_factor_ta_algebra = res
    !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG2_tran_factor_ta_algebra=SHG2_tran_factor_ta_algebra*4.189E-4*1E12
     SHG2_tran_factor_ta_algebra=SHG2_tran_factor_ta_algebra/2.
         !######### 29 Nov. 2008 ##########



!!!#######################
  END FUNCTION SHG2_tran_factor_ta_algebra
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG2_tranDeltaFunctionFactor_ta_algebra()
!!!#########################################
    SHG2_tranDeltaFunctionFactor_ta_algebra = 2
!!!###################################
  END FUNCTION SHG2_tranDeltaFunctionFactor_ta_algebra
!!!###################################
  
!!!#########################
  SUBROUTINE SHG2_tran_ta_algebra(i_spectra)
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

    INTEGER :: v,c,cp,vp
    INTEGER :: da, db,  dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(DPC) :: psym
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacvcpv,omegacvcvp
    REAL(DP) :: T3(3,3,3),tmp,fermivl,fermicl

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!!! virtual-electron
                   do cp=nVal+1,nMaxCC
                      if((cp.ne.v).and.(cp.ne.c))then
                         omegacpv=band(cp) - band(v)
                         omegacvcpv=(omegacv-2.*omegacpv)
                         IF ((omegacvcpv.ge.0.d0).and.(omegacvcpv.le.tolSHGt))    omegacvcpv=omegacvcpv+tolSHGt
                         IF ((omegacvcpv.le.0.d0).and.(omegacvcpv.gt.(-tolSHGt))) omegacvcpv=omegacvcpv-tolSHGt

                         psym= (momMatElem(db,c,cp) * momMatElem(dc,cp,v) + momMatElem(dc,c,cp) * momMatElem(db,cp,v))/2.
                         !!tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacv-2.*omegacpv))
                         tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcpv))
                      end if
                   end do
!!!  virtual-hole 
                   do vp=1,nVal
                      if((vp.ne.v).and.(vp.ne.c))then
                         omegacvp=band(c) - band(vp)
                         omegacvcvp=(omegacv-2.*omegacvp)
                         IF ((omegacvcvp.ge.0.d0).and.(omegacvcvp.le.tolSHGt))    omegacvcvp=omegacvcvp+tolSHGt
                         IF ((omegacvcvp.le.0.d0).and.(omegacvcvp.gt.(-tolSHGt))) omegacvcvp=omegacvcvp-tolSHGt

                         psym= (momMatElem(db,c,vp) * momMatElem(dc,vp,v) + momMatElem(dc,c,vp) * momMatElem(db,vp,v))/2.
                         !!tmp=tmp-16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacv-2.*omegacvp))
                           tmp=tmp-16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcvp))
                      end if
                   end do
                   psym=(efe(c,v,db,dc)+efe(c,v,dc,db))/2.
                   tmp=tmp-4.*T3(da,db,dc)*real(momMatElem(da,v,c)*psym)/omegacv**3
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
  END SUBROUTINE SHG2_tran_ta_algebra
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
!!!########################
!!! subroutine 
  COMPLEX(DPC) FUNCTION efe(c,v,i,j)
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem
    USE InputParametersMod, ONLY : nVal,nMaxCC
    USE InputParametersMod, ONLY : scissor
    implicit none
    REAL(DP) :: deltas
    COMPLEX(DPC) :: ci
    integer :: c,v,i,j,vp,cp
    ci=cmplx(0.d0,1.d0)
    !!deltas=1.046d0 !! tijeras by mano 
    !!deltas=0.0d0 !! tijeras by mano 
    !!!deltas=6.999567592202993E-012 !!comprueba que con estos cambia 
 
    efe=cmplx(0.d0,0.d0)
    do vp=1,nVal
       if (vp.ne.v) then
          efe=efe+posMatElem(j,c,vp)*posMatElem(i,vp,v)
       end if
    end do
    do cp=nVal+1,nMaxCC
       if (cp.ne.c) then
          efe=efe-posMatElem(i,c,cp)*posMatElem(j,cp,v)
       end if
    end do
  !! efe=-deltas*(ci*efe+derMatElem(j,i,c,v))
     efe=-scissor*(ci*efe+derMatElem(j,i,c,v))
   
  end FUNCTION efe
!!!########################
!!!########################
END MODULE IntegrandSHG2_tranMod_ta_algebra
!!!########################
