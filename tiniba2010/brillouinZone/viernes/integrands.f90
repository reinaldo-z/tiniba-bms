MODULE integrands
  USE constants, ONLY : DP, DPC
  USE input, ONLY : nVal, nMax, kMax
  USE arrays, ONLY: momMatElem
  
  
  IMPLICIT NONE
  INTEGER :: iv, ic,iq,ip
  INTEGER :: ix, iy, iz, iw
  
CONTAINS

!!!#############################
!!!#############################
!!!#############################

  SUBROUTINE calculateintegrands

    IMPLICIT NONE
    
    CHARACTER(LEN=3) :: ADV_opt
    REAL(DP) :: omegamp, omeganp, omegapn
   
      !SELECT CASE(1)
      !    CASE(1) ! linear response
             CALL ImChi1
      !     CASE DEFAULT
      !       STOP 'Error in calculateIntegrands: spectrum_type not available'
      !END SELECT
    END SUBROUTINE calculateintegrands

!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  SUBROUTINE ImChi1
    ! This computes the integrand of the imaginary part of
    ! the linear response Chi1
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: omegamn,omeganm,fsc,Delta
    REAL(DP) :: T2(3,3)
    
    !T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
    
    !read(69,*)Delta
    !close(69)
!    write(*,*)'Delta=',Delta
!    stop
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
         ! omegamn = band(iv) - band(ic)
         ! omeganm = band(ic) - band(iv)
         ! fsc = (omeganm/(omeganm-Delta))**2
         ! IF (DABS(omeganm).LT.tol) THEN
             ! NOTE: the position operator matrix elements are set to
             ! zero at functions.f90, se we don't do anything here
             ! Set matrix element to zero, 
             ! which is equivalent to take
         !    fsc=0.
         !    IF (iv.EQ.nVal.AND.ic.EQ.nVal+1) THEN
         !       write(6,*)'############################'
         !       write(6,*)'integrands.f90@ImChi1: Hold on! The tol value is bigger than the gap'
         !       WRITE(6,*)'matrix elements set to zero'
                !             STOP
         !    END IF
         ! end IF
!!!
          DO ix=1,3
             DO iy=1,3
                 !written in terms of the position matrix elements
                 !ctmp = ctmp + T2(ix,iy)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,ic)
                 !ctmp = ctmp + momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)
                 ctmp = ctmp + momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)
                 ! written in terms of the momentum matrix elements
                 !ctmp = ctmp - fsc*T2(ix,iy)*momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)/(omegamn*omeganm)
             END DO
       END DO
          
          IF (ic==nMax) THEN
             WRITE(62, FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(62, FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
  END SUBROUTINE ImChi1




END MODULE integrands
