program perro
implicit none 
INTEGER, PARAMETER :: DP = KIND(1.d0)
!REAL(DP), ALLOCATABLE :: input(:)
!REAL(DP), ALLOCATABLE :: inputa(:,:)
double precision, ALLOCATABLE :: input(:)
double precision, ALLOCATABLE :: inputa(:,:)
REAL(DP) :: zeta(1:360)
INTEGER :: ioerror
CHARACTER(LEN=255) :: fname,oname 
integer :: NofR,i,nMax,NofL,j
logical :: flag



!fname='17-gaas110-relax-H.xyz'
!fname='25-gaas110-relax-H.xyz'
!fname='33-gaas+sb_ELORIGINAL.xyz'
!fname='25-gaas110-relax-H_EL_ORIGINAL.xyz'
fname='si100_6L_2x1.xyz'
fname='si1002x1_5L.xyz'
fname='si100_8L_2x1.xyz'
oname=trim(fname)//'_THE_SAME_FILE.xyz'
oname=trim(oname)

      inquire(file= trim(fname),exist=flag)
       if (.NOT.flag) then
        write(*,*)"I cant find FILE :  ",trim(fname)
        write(*,*)"Stop right now ...  "
        stop
       end if





call NumberofRows(fname,NofR)
CALL NumberofLines(fname,NofL) 
write(*,*)NofR
write(*,*)NofL



    open(UNIT = 1,FILE = fname)
    write(*,*)"file is open :",trim(fname)

allocate(input(NofR))
allocate(inputa(1000,NofR))


i=0
do
!  READ(1,FMT=*,IOSTAT=ioerror) input(1:NofR)
  READ(1,*,IOSTAT=ioerror) input(1:NofR)
      i=i+1  
        !write(*,*)input(1:3)
         inputa(i,1:3)=input(1:3)
         IF (ioerror == -1) THEN
          nMax=i-1
          exit 
         end if 
end do 
!deallocate(input)


!! very importante allocate zeta 




 DO i = 1, nMax
     !WRITE(45,'(5F24.16)')inputa(i,1),inputa(i,2),inputa(i,3)
     WRITE(45,*)inputa(i,1),inputa(i,2),inputa(i,3)
     zeta(i)=(inputa(i,3))
 ENDDO

 DO i = 1, nMax
     !WRITE(*,'(I5,5F16.8)')i,inputa(i,1),inputa(i,2),inputa(i,3)
    write(*,*) i,zeta(i),(inputa(i,3))
 ENDDO


!write(*,*)"Atomo numero ",(maxloc(zeta))," es el mas alto"
!write(*,*)"Atomo numero ",(minloc(zeta))," es el mas bajo"

write(*,*)"maximo valor en zeta ",maxval(zeta)
write(*,*)"minimo valor en zeta ",minval(zeta)

write(*,*)NofR,nMax




deallocate(inputa,INPUT)
end program perro




 subroutine NumberofRows(filein, NofR)
!! Cabellos 28 Septiembre 2008 a 16:20
implicit none
character(len=255), intent(IN) :: filein
integer, intent(out) :: NofR
!!----local variables
integer :: n, error,i,j
character(len=255) :: s
real :: value
!!!===begin to count the number of columns of file========
 ! write(*,*)"Openeing ESTE",trim(filein)
   open(99,FILE=filein,status="unknown")
    do
      read (99,'(a)',end=100)s
       !write(*,*)"s",s
        do i =1,254 ! The very maximum that the string can contain
           read( s, *, iostat=error ) ( value,j=1,i )
            if ( error .ne. 0 ) then
             NofR =i-1
             !write(*,*)NofR
              exit
            endif
        enddo
    end do
100 continue
    !write(*,*)NofR
   close(99)
end subroutine NumberofRows

subroutine NumberofLines(filein,NofL) 
!! function :: count the number of lines of the file "zeta.dat"
!!             the same with  awk '{print NR}' zeta.dat
implicit none
integer,PARAMETER :: DP=KIND(1.d0)
REAL(DP) :: intmpx, intmpf(6)
REAL(DP) :: inputdata(2) 
integer, intent(out) :: NofL
integer :: i,ioerror
character(len=200) :: filein
 
 OPEN(10,FILE=filein ) 
 i=0 
do 
 READ(10,FMT=*,IOSTAT=ioerror)inputdata(1:2) 
  IF (ioerror==0) THEN 
      i=i+1
    ELSE IF (ioerror == -1) THEN
          IF (i == 0) THEN
           close(10)
           return
          END IF
        NofL = i
          close(10)
          return
       ELSE
          STOP 'ERROR,line=130 mysmear4.f90 your file is empty  Maybe... '
       END IF
    ENDDO   
end subroutine NumberofLines

