MODULE FileStuff
  IMPLICIT NONE
CONTAINS
  SUBROUTINE MyInquire(inFile)
    CHARACTER(LEN=*), INTENT(IN) :: inFile
    LOGICAL :: fileExists
    INQUIRE(FILE=inFile, EXIST=fileExists)
    IF (.NOT. fileExists) THEN
       WRITE(*,*) ""
       WRITE(*,*) "      ERROR: Could not find file "//TRIM(inFile)
       WRITE(*,*) "      STOPPING"
       WRITE(*,*) ""
       STOP
    END IF
  END SUBROUTINE MyInquire
END MODULE FileStuff
