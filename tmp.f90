!!!#################
  SUBROUTINE caleta2
!!!################# 
    IMPLICIT NONE
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: tmp
    T3(1:3,1:3,1:3) = reshape(spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
!!!!!!!!!!!!!!!!!
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   if (iv.ne.ic)then 
                      tmp = tmp +  T3(ix,iy,iz)* &
                           ! #BMSVer3.0d, used to confirm that both methods agree
                           !However curMatElem is much faster as it does not
                           !requier C^\ell_{nm}
                           ( real(calVsig(ix,ic,ic))-real(calVsig(ix,iv,iv)) )* & 
                           !#BMSVer3.0u
                           !( curMatElem(ix,ic)-curMatElem(ix,iv) )* & 
                           aimag( PosMatElem(iy,ic,iv)*PosMatElem(iz,iv,ic) )
                   end if

                END DO
             END DO
          END DO

          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES")tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO")tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
92  format(2i5,6e14.5)     
    
!!!#####################
  END SUBROUTINE caleta2
!!!#####################

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!!!##################
  SUBROUTINE sigma
!!!##################
!!!
!!! This computes the integrand of 
!!! the nonlinear response tensor for the shift-current
!!! \sigma^{abc}_2
!!! according to the notes of BMS
!!! that come from the notes of Benjamin M. Fregoso
!!! which correct Eq. (57) of
!!! J. E. Sipe and A. I. Shkrebtii, Phys. Rev. B 61, 5337 (2000).
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c
    INTEGER :: da, db, dc
    REAL(DP) :: T3(3,3,3),tmp
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90:sigma'
!    write(*,*)'*********'

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMax
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   tmp=tmp+T3(da,db,dc)*aimag(posMatElem(db,c,v)*derMatElem(dc,da,v,c) &
                   - posMatElem(dc,v,c)*derMatElem(db,da,c,v))
                END DO
             END DO
          END DO
          
          IF (c==nMax) THEN
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
  END SUBROUTINE sigma
!!!##################

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!!!##############
  SUBROUTINE eta_acdfg
!!!##############
!!!
!!! 
!!! 
!!! 
!!! 
!!!
    IMPLICIT NONE

    INTEGER :: v,c,cp,vp
    INTEGER :: da,dc,dd,df,dg
    INTEGER :: m,n

    COMPLEX(DPC) :: psym
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacvcpv,omegacvcvp,omegavn,omegavm
    REAL(DP) :: T3(3,3,3,3,3),num,den,tmp,omega
    REAL(DP) :: tolSHGt


    T3(1:3,1:3,1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:243), (/3,3,3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v) !! Check if it can be out of the loop
          tmp = 0.d0                !! Check if it can be out of the loop
          DO da=1,3
             DO dc=1,3
                DO dd=1,3
                  DO df=1,3
                    DO dg=1,3
                       do cp=nVal+1,nMax
                       !    if((cp.ne.v).and.(cp.ne.c))then
                       !       omegacpv=band(cp) - band(v)
                       !       omegacvcpv=(omegacv-2.*omegacpv)
                       !       IF ((omegacvcpv.ge.0.d0).and.(omegacvcpv.le.tolSHGt))    omegacvcpv=omegacvcpv+tolSHGt
                       !       IF ((omegacvcpv.le.0.d0).and.(omegacvcpv.gt.(-tolSHGt))) omegacvcpv=omegacvcpv-tolSHGt
    
                       !       psym= (momMatElem(db,c,cp) * momMatElem(dc,cp,v) + momMatElem(dc,c,cp) * momMatElem(db,cp,v))/2.
                       !       tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcpv))
                       !    end if
                       ! end do
                       ! do vp=1,nVal
                       !    if((vp.ne.v).and.(vp.ne.c))then
                       !       omegacvp=band(c) - band(vp)
                       !       omegacvcvp=(omegacv-2.*omegacvp)
                       !       IF ((omegacvcvp.ge.0.d0).and.(omegacvcvp.le.tolSHGt))    omegacvcvp=omegacvcvp+tolSHGt
                       !       IF ((omegacvcvp.le.0.d0).and.(omegacvcvp.gt.(-tolSHGt))) omegacvcvp=omegacvcvp-tolSHGt
                       !       psym= (momMatElem(db,c,vp)*momMatElem(dc,vp,v) + momMatElem(dc,c,vp)*momMatElem(db,vp,v))/2.
                       !       tmp=tmp-16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcvp))
                       !   end if

                       num = (momMatElem(da,cp,c)*momMatElem(dc,m,cp)*momMatElem(dd,v,m)*momMatElem(df,c,n)*momMatElem(dg,n,v))
                       den = omega**4(omegacv/2+omegavn)(omegacpv/2+omegavm)
                       end do
                    END DO
                  END DO
                END DO
             END DO
          END DO

          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)


!!!######################
  END SUBROUTINE eta_acdfg
!!!######################

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!!!##############
  SUBROUTINE mu_abcdfg
!!!##############
!!!
!!! 
!!! 
!!! 
!!! 
!!!
    IMPLICIT NONE

    INTEGER :: v,c,cp,vp
    INTEGER :: da,dc,dd,df,dg
    INTEGER :: m,n

    COMPLEX(DPC) :: psym
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacvcpv,omegacvcvp,omegavn,omegavm
    REAL(DP) :: T3(3,3,3,3,3),num,den,tmp,omega
    REAL(DP) :: tolSHGt


    T3(1:3,1:3,1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:729), (/3,3,3,3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v) !! Check if it can be out of the loop
          tmp = 0.d0                !! Check if it can be out of the loop
          DO da=1,3
            DO db=1,3
              DO dc=1,3
                 DO dd=1,3
                   DO df=1,3
                     DO dg=1,3
                        do cp=nVal+1,nMax
                        num = 
                        den = 
                        end do
                     END DO
                   END DO
                 END DO
              END DO
            END DO
          END DO

          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)


!!!######################
  END SUBROUTINE eta_acdfg
!!!######################

