MODULE arrays
  USE constants, ONLY : DP, DPC
  USE input, ONLY : nMax
  
  IMPLICIT NONE
  COMPLEX(DPC), ALLOCATABLE :: momMatElem(:,:,:)

contains 
  

  SUBROUTINE allocateArrays
    IMPLICIT NONE
    INTEGER :: istat
    WRITE(*,*) " Entered allocateArrays momMatElem"
    ALLOCATE (momMatElem(3,nMax,nMax), STAT=istat)

    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate momMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
 END SUBROUTINE allocateArrays
!!!****************************
!!!****************************
!!!****************************

  SUBROUTINE deallocateArrays
    IMPLICIT NONE
    INTEGER :: istat
    WRITE(*,*) " Entered deallocateArrays momMatElem"
    DEALLOCATE (momMatElem, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate momMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
  END SUBROUTINE deallocateArrays

END MODULE arrays
