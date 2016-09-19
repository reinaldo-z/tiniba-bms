program brillo
implicit none 
integer, parameter :: SP = KIND(1.0)            ! single precision
integer, parameter :: DP = KIND(1.0D0)          ! double precision
integer, parameter :: SPC = KIND((1.0,1.0))     ! single precision complex
integer, parameter :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
 

integer :: ik,kMax
integer :: iv,ic
integer :: nVal,nMax
integer :: estado,l
integer :: ii,ix,iy

real(DP) :: matTemp(6)
real(DP), allocatable :: energy(:,:)

complex(DPC), allocatable :: momMatElem(:,:,:)
complex(DPC), allocatable :: posMatElem(:,:,:)
complex(DPC) :: ctmp

character(len=255) :: pmnFile
character(len=255) :: integrando

pmnFile="pmn_5_10-nospin"
integrando="integrand.d"


pmnFile=trim(pmnFile)
integrando=trim(integrando)
!!! ======= open files ======================
!!! ======= open files ======================
!!! ======= open files ======================
open(20, FILE=pmnFile, status="old", iostat=estado)
  if (estado /= 0) then
     WRITE(6,*) "Error occured trying to open:", pmnFile
     WRITE(6,*) "Error status returned is:", estado
     WRITE(6,*) "Stopping"
     STOP "Stopping: error with momentum matrix element file"
  end if 
OPEN(UNIT=62, FILE=integrando, STATUS='UNKNOWN', IOSTAT=estado)
    IF (estado.NE.0) THEN
       WRITE(6,*) "Error opening file ",trim(integrando)
       WRITE(6,*) "Stopping"
       STOP
    ELSE
       WRITE(6,*) 'Opened file: ', TRIM(integrando)
    END IF




kMax=5
nVal=4
nMax=8
!!! ======= allocate arrays =================
!!! ======= allocate arrays =================
!!! ======= allocate arrays =================
allocate (momMatElem(3,nMax,nMax), STAT=estado)
    if (estado.ne.0) then
       write(*,*) "Could not allocate momMatElem"
       write(*,*) "Stopping"
       stop
    end if 




do ik=1, kMax
 do iv = 1, nMax
  do ic = iv, nMax
     READ(20,*) (matTemp(l), l=1,6)
           momMatElem(1,iv,ic) = matTemp(1) + (0.0d0,1.0d0)*matTemp(2)
           momMatElem(2,iv,ic) = matTemp(3) + (0.0d0,1.0d0)*matTemp(4)
           momMatElem(3,iv,ic) = matTemp(5) + (0.0d0,1.0d0)*matTemp(6)
           if (ic.NE.iv) then       
             do ii=1,3
                 !momMatElem(ii,ic,iv) = CONJG(momMatElem(ii,iv,ic))
                 momMatElem(ii,ic,iv) = conjg(momMatElem(ii,iv,ic))
             end do 
           end if 
  end do !ic  
 end do  !iv 
            ! SET THE IMAGINARY PARTS OF THE DIAGONAL COMPONENTS TO ZERO BY HAND
     do iv = 1, nMax
        momMatElem(1,iv,iv)= REAL(momMatElem(1,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(2,iv,iv)= REAL(momMatElem(2,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(3,iv,iv)= REAL(momMatElem(3,iv,iv)) + 0.d0*(0.d0,1.d0)
     end do 
end do
close(20)

!!!======================
!!!======================
!!!======================

do ik=1, kMax
 do iv = 1, nVal
  do ic = nVal+1, nMax
       
          do ix=1,3
             do iy=1,3
             write(149,"(3I,2E15.7)")ik,iv,ic,real(momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)), aimag(momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic))


             end do 
          end do
   end do 
 end do 
end do


103        FORMAT(6E18.8) 

! DO ik = 1, kMax
!     DO iv = 1, nMax
!        DO ic = iv, nMax
!                 WRITE(271,103) REAL(momMatElem(1,iv,ic)),IMAG(momMatElem(1,iv,ic)) &
!                   , REAL(momMatElem(2,iv,ic)),IMAG(momMatElem(2,iv,ic)) &
!                   , REAL(momMatElem(3,iv,ic)),IMAG(momMatElem(3,iv,ic))
!
!  end do 
! end do 
!end do

DO ik = 1, kMax
  DO iv = 1, nVal
       DO ic = nVal+1, nMax
       WRITE(256,103) REAL(momMatElem(1,iv,ic)),IMAG(momMatElem(1,ic,iv)) &
                   , REAL(momMatElem(2,iv,ic)),IMAG(momMatElem(2,ic,iv)) &
                   , REAL(momMatElem(3,iv,ic)),IMAG(momMatElem(3,ic,iv))
   end do 
 end do 
end do



DO ik = 1, kMax
  DO iv = 1, nVal
       DO ic = nVal+1, nMax
                   write(280,*)ik, momMatElem(1,ic,iv), momMatElem(1,iv,ic),&
                               momMatElem(2,ic,iv), momMatElem(2,iv,ic),&
                               momMatElem(3,ic,iv), momMatElem(3,iv,ic)
                           
                  
   end do !ic 
 end do   !iv
end do
close(62)


104 FORMAT(E15.7)



deallocate (momMatElem)

end program brillo
