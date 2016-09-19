MODULE UtilitiesMod
  ! Just a collection of utility subroutines and functions that are used.
  
  ! Contains:
  !   CharToInt
  !   IntToChar
  !   convertToLowerCase
  !
  
CONTAINS
  
  SUBROUTINE CharToInt(inChar,outInt)
    ! Turns the character 0, 1, 2, etc. to its respective digit integer 0, 1, 2, etc.
    
    IMPLICIT NONE
    CHARACTER(LEN=1), INTENT(IN) :: inChar
    INTEGER, INTENT(OUT) :: outInt
    
    ! Add a check for inChar, using ACHAR
    
    READ(inChar,*) outInt
    
  END SUBROUTINE CharToInt
  
  SUBROUTINE IntToChar(inInt, outChar)
    ! Turns the integer 1, 2, 3, etc. into characters.
    
    IMPLICIT NONE
    CHARACTER(LEN=1), INTENT(OUT) :: outChar
    INTEGER, INTENT(IN) :: inInt
    
    IF ((inInt .LT. 0) .OR. (inInt.GT.9)) THEN
       WRITE(*,*) ""
       WRITE(*,*) "    ERROR: Passed illegal value to IntToChar subroutine"
       WRITE(*,*) "    Passed variable: ",inInt," not allowed"
       WRITE(*,*) "    STOPPING"
       WRITE(*,*) ""
       STOP "Illegal value passed to IntToChar subroutine"
    END IF
    
    WRITE(outChar,'(i1)') inInt
    
  END SUBROUTINE IntToChar
  
  SUBROUTINE convertToLowerCase( string )
    ! with help from http://www.jcameron.com/vms/source/UPCASE.FOR
    CHARACTER*(*) string
    INTEGER*4 string_length, i
    
    string_length = LEN( string )
    
    DO i = 1, string_length
       
       IF (LGE( string(i:i),'A') .AND. LLE( string(i:i),'Z')) THEN
          string (i:i) = CHAR(ICHAR( string (i:i) ) + 32)
       ELSE
       ENDIF
       
    END DO
    RETURN
    
  END SUBROUTINE convertToLowerCase
  
END MODULE UtilitiesMod
