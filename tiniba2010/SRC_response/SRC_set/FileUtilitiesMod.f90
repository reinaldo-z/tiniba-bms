!!!####################
MODULE FileUtilitiesMod
!!!####################
  USE debugMod, ONLY : debug
  IMPLICIT NONE
  
CONTAINS
  
!!!#############################
  SUBROUTINE myInquire(filename)
!!!#############################
    CHARACTER(LEN=*), INTENT(IN) :: filename
    LOGICAL :: fileExists
    INQUIRE(FILE=filename, EXIST=fileExists)
    
    IF (.NOT.fileExists) THEN
       WRITE(*,*) "=========================="
       WRITE(*,*) "    Cannot find file: ", TRIM(filename)
       WRITE(*,*) "    subroutine myInquire()"
       WRITE(*,*) "=========================="
       STOP "     Stopping right now ..."
    END IF
    
    RETURN
!!!#######################
  END SUBROUTINE myInquire
!!!#######################
  
!!!##############################################
  SUBROUTINE myOpen(fileunit, filename, filestatus)
!!!##############################################
    CHARACTER(LEN=*), INTENT(IN) :: filename
    INTEGER, INTENT(IN) :: fileunit
    CHARACTER(LEN=*), INTENT(IN) :: filestatus
    INTEGER :: io_status
    IF (debug) WRITE(*,*) "==========================="
    IF (debug) WRITE(*,*) "Program Flow: entered myOpen"
    IF (debug) WRITE(*,*) "Trying to open file ", TRIM(filename)
    
    OPEN(UNIT=fileunit, FILE=filename, STATUS=filestatus, IOSTAT=io_status)
    IF (io_status /= 0) THEN
       WRITE(*,*) "Error occured trying to open:", filename
       WRITE(*,*) "Error status returned is:", io_status
       WRITE(*,*) "Stopping"
       STOP "Stopping: Error trying to open file"
    else 
        IF (debug) WRITE(*,*) "open file succefully..:", TRIM(filename)
        IF (debug) WRITE(*,*) "==========================="
    END IF
!!!####################
  END SUBROUTINE myOpen
!!!####################
  
!!!###################################################
  SUBROUTINE checkEndOfFileAndClose(fileUnit,filename)
!!!###################################################
    INTEGER, INTENT(IN) :: fileUnit
    CHARACTER(LEN=*), INTENT(IN) :: filename
    INTEGER :: io_status
    CHARACTER(LEN=80) :: tempChar
    
    READ(fileUnit,*,IOSTAT=io_status) tempChar
    IF (debug) WRITE(*,*) "ios ", io_status
    IF (io_status.LT.0) THEN
       WRITE(*,*) 'End of file ', TRIM(filename), ' reached'
       if (fileUnit.eq.11) then  !! cabellos 
        call system( " touch pmnEND ")
       end if 
       if (fileUnit.eq.14) then  !! cabellos 
        call system( " touch spinEND ")
       end if 
       !!WRITE(*,*) "fileUnit =",fileUnit
       CLOSE(fileUnit)
    ELSE IF(io_status.EQ.0) THEN
       WRITE(*,*) 'Error with file ', TRIM(filename)
       WRITE(*,*) tempChar
       STOP 'File contains more data than expected'
    ELSE
       STOP 'Reading end of file caused an error.'
    END IF
!!!####################################
  END SUBROUTINE checkEndOfFileAndClose
!!!####################################
  
  
!!!#########################
  SUBROUTINE myClose(unitNo)
!!!#########################
    INTEGER, INTENT(IN) :: unitNo
    CLOSE(unitNo)
!!!#####################
  END SUBROUTINE myClose
!!!#####################

!!!########################
END MODULE FileUtilitiesMod
!!!########################
