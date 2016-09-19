program brillo
USE arrays, ONLY : momMatElem
USE arrays, ONLY : allocateArrays, deallocateArrays
USE input, only : nMax
USE input, only : nVal
USE input, only : Kmax
USE constants, only : DP
USE integrands, only : calculateintegrands

implicit none 
integer :: ik,iv,ic,l,ii
integer :: estado
character(len=16) :: pmnFile
character(len=13) :: integrando
REAL(DP) :: matTemp(6)



call allocatearrays


pmnFile="pmn_5_10-nospin"
integrando="integrando.d"

 open(20, FILE=pmnFile, status="old", iostat=estado)
  if (estado /= 0) then
     WRITE(6,*) "Error occured trying to open:", pmnFile
     WRITE(6,*) "Error status returned is:", estado
     WRITE(6,*) "Stopping"
     STOP "Stopping: error with momentum matrix element file"
  end if

 open(62, FILE=integrando, status="unknown", iostat=estado)
  if (estado /= 0) then
     WRITE(6,*) "Error occured trying to open:", integrando
     WRITE(6,*) "Error status returned is:", estado
     WRITE(6,*) "Stopping"
     STOP "Stopping: error integrando file"
  end if



write(*,*)"nMax= ",nMax
write(*,*)"nVal= ",nVal
write(*,*)"kMax= ",kMax

DO ik = 1, kMax
  DO iv = 1, nMax
    DO ic = iv, nMax
        READ(20,*) (matTemp(l), l=1,6)
           momMatElem(1,iv,ic) = matTemp(1) + (0.0d0,1.0d0)*matTemp(2)
           momMatElem(2,iv,ic) = matTemp(3) + (0.0d0,1.0d0)*matTemp(4)
           momMatElem(3,iv,ic) = matTemp(5) + (0.0d0,1.0d0)*matTemp(6)
           IF (ic.NE.iv) THEN
              DO ii=1,3
                 momMatElem(ii,ic,iv) = CONJG(momMatElem(ii,iv,ic))
              END DO
           END IF
          
    end do !iv 
 end do    !ic

       do iv = 1, nMax
        momMatElem(1,iv,iv)= REAL(momMatElem(1,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(2,iv,iv)= REAL(momMatElem(2,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(3,iv,iv)= REAL(momMatElem(3,iv,iv)) + 0.d0*(0.d0,1.d0)
       end do 
end do !ik 
close(20)

!!!==================================
!!!==================================
!!!==================================

103        FORMAT(6E18.8)
!DO ik = 1, kMax
!  DO iv = 1, nVal
!       DO ic = nVal+1, nMax
!       WRITE(256,103) REAL(momMatElem(1,iv,ic)),IMAG(momMatElem(1,ic,iv)) &
!                    , REAL(momMatElem(2,iv,ic)),IMAG(momMatElem(2,ic,iv)) &
!                    , REAL(momMatElem(3,iv,ic)),IMAG(momMatElem(3,ic,iv))
!   end do 
! end do 
!end do


DO ik = 1, kMax
  !DO iv = 1, nVal
  !     DO ic = nVal+1, nMax
  !                 write(280,*)momMatElem(1,ic,iv), momMatElem(1,iv,ic),&
  !                             momMatElem(2,ic,iv), momMatElem(2,iv,ic),&
  !                             momMatElem(3,ic,iv), momMatElem(3,iv,ic)
         if (ik.eq.1) then                  
        call calculateintegrands                 
         end if 
  ! end do !ic 
 !end do   !iv
end do






close(62)
call deallocateArrays
end program brillo
