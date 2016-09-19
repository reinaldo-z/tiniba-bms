MODULE SMEAR_MOD
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = KIND(1.d0)
  REAL(DP), PARAMETER :: pi = 3.14159265358979
!!!  REAL(DP), ALLOCATABLE :: arr(:), smear(:), x(:)
  REAL(DP), ALLOCATABLE :: arr(:), x(:)
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
    INTEGER :: oldSize, newSize
    nMax = 1
    ALLOCATE( arr(nMax), x(nMax) )
    OPEN(UNIT = 1,FILE = FNAME)
    PRINT *, 'FILE IS OPEN'
    i=0
    oldSize=0
    newSize=0
    DO
       READ(1,FMT=*,IOSTAT=ioerror) intmpx, intmpf
       ! WRITE(6,*) intmpx, intmpf
       ! CALL SLEEP(1)
       !
       !PRINT *,'ioerror ', ioerror
       ! 
       IF (ioerror==0) THEN ! all the arrays should increase.
          ! First copy the old arrays into temptorary arrays
          oldSize = i
          i=i+1
          newSize = i
          
          ALLOCATE(array_tmp(oldSize))
          array_tmp(1:oldSize)=x(1:oldSize)
          DEALLOCATE(x)
          
          ! Now increase size of x to store new value
          ! WRITE(*,*) 'i = ', i
          ALLOCATE(x(newSize))
          
          ! Copy back temporary array into x
          x(1:oldSize)=array_tmp(1:oldSize)
          
          ! And place new varable in ith location
          x(i)=intmpx
          
          ! Do the same with the actual function
          DEALLOCATE(array_tmp)
          ALLOCATE(array_tmp(oldSize))
          array_tmp(1:oldSize) = arr(1:oldSize)
          DEALLOCATE(arr)
          ALLOCATE(arr(newSize))
          arr(1:oldSize) = array_tmp(1:oldSize)
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
    DO i = 1, nMax, 1
       WRITE(2,*) x(i), res(i)
    ENDDO
    CLOSE(2)    
  END SUBROUTINE WRITEFILE
!!!!========================================================
!!!  SUBROUTINE INITIALIZE_G(i,x,nMax,smear)
!!!!========================================================
!!!    IMPLICIT NONE
!!!    INTEGER, INTENT(IN) :: i, nMax
!!!    REAL(DP), INTENT(IN) :: x(nMax)
!!!    REAL(DP), INTENT(OUT) :: smear(nMax)
!!!    REAL(DP) :: fwhm = 0.030 ! eV
!!!    INTEGER :: j
!!!    
!!!    DO j=1,nMax
!!!       smear(j) = DEXP(-log(2.d0)*(x(j)-x(i))**2/fwhm**2)
!!!    END DO
!!!    smear(:) = SQRT(log(2.d0)/(pi*fwhm**2))*smear(:)
!!!    !    IF (i==501) THEN
!!!    !       DO j=1,nMax
!!!    !          WRITE (99,*) x(j), smear(j)
!!!    !       END DO
!!!    !    END IF
!!!  END SUBROUTINE INITIALIZE_G
!!!========================================
  SUBROUTINE INITIALIZE_G2(fwhm,x,nMax,smear,tMax)
!!!========================================
    IMPLICIT NONE
    INTEGER, INTENT(IN) :: nMax, tMax
    REAL(DP), INTENT(IN) :: x(nMax)
    REAL(DP), INTENT(OUT) :: smear(-tMax:tMax)
    REAL(DP), INTENT(IN) :: fwhm
    INTEGER :: j
    
    ! j =-N  =>  x(N+1)
    ! j =-1  =>  x(2)=h
    ! j = 0  =>  x(1)=0
    ! j = 1  =>  x(2)=h
    ! j = N  =>  x(N+1)
    
    DO j=-tMax,-1
       smear(j) = DEXP(-4.d0*log(2.d0)*(x(-j+1))**2/fwhm**2)
    END DO
    DO j=0,tMax
       smear(j) = DEXP(-4.d0*log(2.d0)*(x(j+1))**2/fwhm**2)
    END DO
    smear(-tMax:tMax) = 2.d0/fwhm*SQRT(log(2.d0)/pi)*smear(-tMax:tMax)
  END SUBROUTINE INITIALIZE_G2
!!!=================================================
  SUBROUTINE GAUSSIAN_SMEAR(nMax,x,arr,res,h)
!!!=================================================
    IMPLICIT NONE
    INTEGER, INTENT (IN) :: nMax
    REAL(DP), INTENT(IN) :: arr(nMax), x(nMax), h
    REAL(DP), INTENT(INOUT) :: res(nMax)
!!!    REAL(DP), ALLOCATABLE, INTENT(INOUT) :: smear(:)
    REAL(DP), ALLOCATABLE :: smear(:)
    REAL(DP), ALLOCATABLE :: partToSmear(:)
!!! for simplicity we define a new array newArr which will extend
!!! beyond the limits of arr, so that the integration can be done
!!! easily for the endpoints of the resulting function.
    REAL(DP), ALLOCATABLE :: newArr(:)
    INTEGER :: tMax
    REAL(DP) :: integrand1(nMax), integrand2(nMax)
    REAL(DP) :: energy
    INTEGER :: i, j, k
    REAL(DP) :: fwhm = 0.030 ! eV
    
    tMax = NINT(2.d0*fwhm/h)
    WRITE(6,*)'tMax = ', tMax
    ALLOCATE ( partToSmear(-tMax:tMax) )
    ALLOCATE ( smear(-tMax:tMax) )
    ALLOCATE ( newArr(1-tMax:nMax+tMax) )
!!! Since the function is even, and we assume that the input function
!!! extends to x(1)=0.0d0.
    k=1
    DO j = 0, 1-tMax, -1
       k = k + 1
       newArr( j ) = arr( k )
    END DO
    newArr( 1 : nMax ) = arr(1:nMax)
    newArr( nMax + 1 : nMax + tMax) = 0.d0
    
!!! write out function to look at for debugging
    DO j= -tMax + 1, nMax
       IF (j .LE. 0) write(10,*) -x(-j+2), newArr(j)
       IF (j .GE. 1) write(10,*) x( j  ), newArr(j)
    END DO
    
    CALL INITIALIZE_G2(fwhm,x,nMax,smear,tMax)
    
    DO i= 1, nMax    ! this upper bound can be safely changed I think
!!! Find part to smear
       partToSmear(-tMax : tMax) = newArr( i - tMax : i + tMax)
       
       ! For Simpson's Rule
       ! partToSmear(-tMax) = partToSmear(-tMax)
       ! partToSmear( tMax) = partToSmear( tMax)
       ! partToSmear(-tMax+1:tMax-1:2) = 4.d0*partToSmear(-tMax+1:tMax-1:2)
       ! partToSmear(-tMax+2:tMax-2:2) = 2.d0*partToSmear(-tMax+2:tMax-2:2)
       
       res(i) = SUM(partToSmear(:)*smear(:))
       res(i) = res(i)*h
       
    END DO
    DEALLOCATE ( partToSmear )
    DEALLOCATE ( smear )
    DEALLOCATE ( newArr )
  END SUBROUTINE GAUSSIAN_SMEAR
  
END MODULE SMEAR_MOD
