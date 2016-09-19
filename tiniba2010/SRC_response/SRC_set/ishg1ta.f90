!!!####################
MODULE IntegrandSHG1_tranMod_ta_algebra
!!!####################
  ! 
  ! SHG1 CORRECTED 
  ! 
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!##############################
  REAL(DP) FUNCTION SHG1_tran_factor_ta_algebra()
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
    SHG1_tran_factor_ta_algebra = res
     !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG1_tran_factor_ta_algebra=SHG1_tran_factor_ta_algebra*4.189E-4*1E12
     SHG1_tran_factor_ta_algebra=SHG1_tran_factor_ta_algebra/2.
    !######### 29 Nov. 2008 ##########


!!!#######################
  END FUNCTION SHG1_tran_factor_ta_algebra
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG1_tranDeltaFunctionFactor_ta_algebra()
!!!#########################################
    SHG1_tranDeltaFunctionFactor_ta_algebra = 1
!!!###################################
  END FUNCTION SHG1_tranDeltaFunctionFactor_ta_algebra
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1_tran_ta_algebra(i_spectra)
!!!#########################
    !
    ! This computes the integrand of the imaginary part of
    ! the nonlinear response tensor SHG1 transversal corrected 
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
    COMPLEX(DPC) :: fcv_e,fcv_e1,fcv_e2
    COMPLEX(DPC) :: fcv_i

    REAL(DP) :: omegacv,omegalv,omegacl
    REAL(DP) :: omegaclcv,omegalvcv
    REAL(DP) :: T3(3,3,3),tmp,fermilv,fermicl,scissors
    scissors=1.0d0 !!! right now just put by hand    



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
                         omegalvcv=(omegalv-2.*omegacv)
                         IF ((omegalvcv.ge.0.d0).and.(omegalvcv.le.tolSHGt))    omegalvcv=omegalvcv+tolSHGt
                         IF ((omegalvcv.le.0.d0).and.(omegalvcv.ge.(-tolSHGt))) omegalvcv=omegalvcv-tolSHGt

                         omegaclcv=(omegacl-2.*omegacv)
                         IF ((omegaclcv.ge.0.d0).and.(omegaclcv.le.tolSHGt))    omegaclcv=omegaclcv+tolSHGt
                         IF ((omegaclcv.le.0.d0).and.(omegaclcv.ge.(-tolSHGt))) omegaclcv=omegaclcv-tolSHGt

                         psym1=(momMatElem(db,c,v)*momMatElem(dc,v,l)+momMatElem(dc,c,v)*momMatElem(db,v,l))/2.
                         psym2=(momMatElem(db,l,c)*momMatElem(dc,c,v)+momMatElem(dc,l,c)*momMatElem(db,c,v))/2.
                         tmp=tmp+(T3(da,db,dc)/omegacv**3)*(aimag(momMatElem(da,l,c)*psym1)/(omegaclcv) -aimag(momMatElem(da,v,l)*psym2)/(omegalvcv)) 
                      end if
                   end do
                   psym1=-(conjg(efe(c,v,da,db))*momMatElem(dc,c,v)&
                         +conjg(efe(c,v,da,dc))*momMatElem(db,c,v))/2.
                   tmp=tmp-T3(da,db,dc)*real(psym1)/omegacv**3
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
  END SUBROUTINE SHG1_tran_ta_algebra
!!!##################
    REAL(DP) FUNCTION fermi(nVal,i)
!!!##############################
    implicit none
    integer :: nVal,nMaxCC,i,j
!!!
    if(i.le.nVal)  fermi=1.d0 !valence state
    if(i.ge.nVal+1)fermi=0.d0 !conduction state
  end FUNCTION fermi
!!! Try this 
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
    efe=-scissor*(ci*efe+derMatElem(j,i,c,v)) !!! this is tijeras auto 
  end FUNCTION efe
!!!########################
END MODULE IntegrandSHG1_tranMod_ta_algebra
!!END MODULE IntegrandSHG1_tranMod_Leitsman_two
!!!########################
