!=========================================================
PROGRAM SMEARING
!=========================================================
  !A simple smearing implementation
  USE SMEAR_MOD
  IMPLICIT NONE
  INTEGER :: nMax=20001
  REAL(DP), ALLOCATABLE :: res(:)
  REAL(DP) :: tot, h
  CHARACTER(1) :: flag
  CHARACTER(40) :: fname, ofname
  
  WRITE (6,*) 'Smearing v0.1  -- NO GARAUNTEES!'
  
  CALL GETARG(1,flag)
  IF (flag == '1') THEN
     PRINT *,'Gaussian Smearing'
  ELSE IF(flag == '2')THEN
     PRINT *,'Lorentzian Smearing'
     STOP 'CHECK CODE... not fully implemented'
  ELSE
     STOP 'Wrong option for smearing type flag'
  END IF
  CALL GETARG(2,fname)
  PRINT *,'OPENING ',fname
  CALL GETARG(3,ofname)
  PRINT *,'OUTPUT WILL BE WRITTEN TO ', ofname
  
  CALL READFILE(fname,nMax)
  
  ! x and arr should be read by now. nMax should be the array length
  
  ALLOCATE(smear(nMax),res(nMax))  ! the result goes in res
  
  ! Output some info from File
  WRITE(6,*) 'From the file, I learned that:'
  WRITE(6,*) 'o xmin is ', x(1)
  WRITE(6,*) 'o xmax is ', x(nMax)
  tot = SUM(x)
  h = tot * 2.d0/(nMax)/(nMax-1)
  WRITE(6,FMT='(A28,E18.10)') 'o spacing is approximately ',h
  
!  CALL INITIALIZE(flag,nMax,x,smear)
  IF (flag == '1') CALL GAUSSIAN_SMEAR(nMax,x,arr,smear,res,h)
  
!!!  IF (flag == '2') CALL LORENTZIAN_SMEAR(nMax,x,arr,smear,res)
  
  CALL WRITEFILE(ofname,x,res,nMax)
  
END PROGRAM SMEARING

!**************************************************

MODULE SMEAR_MOD
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = KIND(1.d0)
  REAL(DP), PARAMETER :: pi = 3.14159265358979
  REAL(DP), ALLOCATABLE :: arr(:), smear(:), x(:)
CONTAINS
!========================================================  
  SUBROUTINE READFILE(FNAME,nMax)
!========================================================
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(IN) :: fname
    INTEGER, INTENT(INOUT) :: nMax
    REAL(DP), ALLOCATABLE :: array_tmp(:)
    REAL(DP) :: tot, energy, h, intmpx, intmpf
    INTEGER :: i, ioerror
    nMax = 1
    ALLOCATE( arr(nMax), x(nMax) )
    OPEN(UNIT = 1,FILE = FNAME)
    PRINT *, 'FILE IS OPEN'
    i=0
    DO
       READ(1,FMT=*,IOSTAT=ioerror) intmpx, intmpf
       !WRITE(6,*) intmpx, intmpf
       !CALL SLEEP(1)
       !PRINT *,'ioerror ', ioerror
       IF (ioerror==0) THEN
          !PRINT *, i
          i=i+1
          !CALL PUSH(intmpx,x)
          ALLOCATE(array_tmp(i))
          array_tmp=x
          DEALLOCATE(x)
          ALLOCATE(x(i))
          x=array_tmp
          x(i)=intmpx
          !PRINT *, i, x(i)
          DEALLOCATE(array_tmp)
          !CALL PUSH(intmpf,arr)
          ALLOCATE(array_tmp(i))
          array_tmp = arr
          DEALLOCATE(arr)
          ALLOCATE(arr(i))
          arr=array_tmp
          arr(i)=intmpf
          !WRITE(6,*) x(i), arr(i)
          DEALLOCATE(array_tmp)
       ELSE IF (ioerror == -1) THEN
          IF (i == 0) THEN
             STOP 'Error:  Input file is possibly empty'
          END IF
          nMax = i
          EXIT
       ELSE
          STOP 'ERROR'
       END IF
    ENDDO
  END SUBROUTINE READFILE

!========================================================
  SUBROUTINE WRITEFILE(OUTFILE,x,res,nMax)
!========================================================
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(IN) :: OUTFILE
    INTEGER, INTENT(IN) :: nMax
    REAL(DP), INTENT(IN) :: x(nmax), res(nMax)
    INTEGER :: i
    OPEN(UNIT=2,FILE=OUTFILE)
    DO i = 1, nMax, 10
       WRITE(2,*) x(i), res(i)
    ENDDO
    CLOSE(2)    
  END SUBROUTINE WRITEFILE
!========================================================
  SUBROUTINE INITIALIZE_G(i,x,nMax,smear)
!========================================================
    IMPLICIT NONE
    INTEGER, INTENT(IN) :: i, nMax
    REAL(DP), INTENT(IN) :: x(nMax)
    REAL(DP), INTENT(OUT) :: smear(nMax)
    REAL(DP) :: fwhm = 0.030 !!! eV
    INTEGER :: j
    
    DO j=1,nMax
       smear(j) = DEXP(-log(2.d0)*(x(j)-x(i))**2/fwhm**2)
    END DO
    smear(:) = SQRT(log(2.d0)/(pi*fwhm**2))*smear(:)
    !    IF (i==501) THEN
    !       DO j=1,nMax
    !          WRITE (99,*) x(j), smear(j)
    !       END DO
    !    END IF
  END SUBROUTINE INITIALIZE_G
!========================================================
  SUBROUTINE GAUSSIAN_SMEAR(nMax,x,arr,smear,res,h)
!========================================================
    IMPLICIT NONE
    INTEGER, INTENT (IN) :: nMax
    REAL(DP), INTENT(IN) :: arr(nMax), x(nMax), h
    REAL(DP), INTENT(INOUT) :: smear(nMax)
    REAL(DP), INTENT(INOUT) :: res(nMax)
!!!    REAL(DP) :: integrand1(nMax), integrand2(nMax)
    REAL(DP) :: energy
    INTEGER :: i, j
    
!!!    DO i = 1, (nMax-1)/2, 20
    DO i = 1, nMax, 1
       WRITE(6,*) i
!       IF (i.LE.100) THEN
       IF (x(i).LE.0.10) THEN
          res(i) = arr(i)
       ELSE
          CALL INITIALIZE_G(i,x,nMax,smear)
          DO j=1,(nMax-1)/2
             res(i) = SUM(arr(:)*smear(:))
          END DO
          res(i) = res(i)*h
          ! IF (ABS(arr(i)-res(i)).GT.5.0d9) THEN
          !   WRITE (6,*) i, x(i), arr(i), res(i)
          !   STOP
          ! END IF
       END IF
    END DO
  END SUBROUTINE GAUSSIAN_SMEAR
  
END MODULE SMEAR_MOD

