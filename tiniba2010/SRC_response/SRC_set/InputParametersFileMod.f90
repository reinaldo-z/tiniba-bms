MODULE InputParametersFileMod
  
  USE ConstantsMod, ONLY : DP, pi
  
  USE DebugMod, ONLY : debug
  USE InputParametersMod, ONLY : nMaxCC
  !! Nueva variable 
  USE InputParametersMod, ONLY : tolSHGt
  !! Nueva variable              tolSHGt
  USE InputParametersMod, ONLY : tolSHGL
  !! Nueva variable
  USE InputParametersMod, ONLY : nVal
  USE InputParametersMod, ONLY : nMax
  USE InputParametersMod, ONLY : kMax
  USE InputParametersMod, ONLY : nSpinor
  USE InputParametersMod, ONLY : scissor
  USE InputParametersMod, ONLY : actual_band_gap
  USE InputParametersMod, ONLY : tol
  USE InputParametersMod, ONLY : energy_data_filename
  USE InputParametersMod, ONLY : energys_data_filename
  USE InputParametersMod, ONLY : pmn_data_filename
  USE InputParametersMod, ONLY : smn_data_filename
  USE InputParametersMod, ONLY : rmn_data_filename
  USE InputParametersMod, ONLY : der_data_filename
  USE InputParametersMod, ONLY : nTrans
  USE InputParametersMod, ONLY : spin_factor
  USE InputParametersMod, ONLY : paramFile
  
  LOGICAL :: nVal_set
  LOGICAL :: nMax_set
  LOGICAL :: kMax_set
  LOGICAL :: nMaxCC_set
  LOGICAL :: tolSHGt_set
  LOGICAL :: tolSHGL_set


  LOGICAL :: actual_band_gap_set
  LOGICAL, PRIVATE :: nSpinor_set
  LOGICAL, PRIVATE :: scissor_set
  LOGICAL, PRIVATE :: tol_set
  LOGICAL, PRIVATE :: energy_data_filename_set
  LOGICAL, PRIVATE :: energys_data_filename_set
  LOGICAL, PRIVATE :: pmn_data_filename_set
  LOGICAL, PRIVATE :: smn_data_filename_set
  LOGICAL, PRIVATE :: rmn_data_filename_set
  LOGICAL, PRIVATE :: der_data_filename_set
  LOGICAL, PRIVATE :: spin_factor_set
  
CONTAINS
  
  SUBROUTINE parseParamFile
    IMPLICIT NONE
    CHARACTER(LEN=255) thisLine
    CHARACTER(LEN=255) string1, string2, tmpString
    CHARACTER(LEN=1), PARAMETER :: commentSignal = '#'
    INTEGER :: ios, lineCounter, lineLength
    INTEGER :: iTmp
    
    IF (debug) WRITE(*,*) "Beginning to parse parameter file."
    write(*,*) "========================="
    write(*,*) "subroutine parseParamFile"
    write(*,*) "========================="
    OPEN(UNIT=1, FILE=paramFile, FORM='FORMATTED', STATUS='OLD', IOSTAT=ios)
    IF (ios.NE.0) THEN
       WRITE(6,*) "Error opening file: ", TRIM(paramFile)
       WRITE(6,*) "This should be the parameter file and be the first argument."
       WRITE(6,*) "Stopping"
       STOP
    ELSE
      !WRITE(6,'(2A)') "   Opening file: ",TRIM(paramFile)
       WRITE(*,*) "   Opening file = ",TRIM(paramFile)
    END IF
    
    lineCounter = 0
    
    DO
       lineCounter = lineCounter + 1
       READ(UNIT=1,FMT='(A)',IOSTAT=ios) thisLine
       IF (ios.EQ.-1) THEN
         !WRITE(*,*) "   Opening file = ",TRIM(paramFile)
          WRITE(*,*) "   End of file found"
          WRITE(*,*) "---------------------------------"
          EXIT
       END IF
       
       IF (debug) WRITE(*,'(A)') TRIM(thisLine)
       
       thisLine = ADJUSTL(thisLine) ! move any leading white space to the back.       
       
       CALL remove_comments(thisLine, commentSignal)
       
       IF (debug) WRITE(*,'(A)') TRIM(thisLine)
       
       lineLength = LEN_TRIM(thisLine)
       
       IF (lineLength.EQ.0) THEN
          IF (debug) WRITE(*,'(A,I3)') "Blank line found on line number", lineCounter
          CYCLE
       END IF
       
       CALL reduce_white_space(thisLine, LEN(thisLine))
       
       CALL check_for_two_strings(thisLine,lineCounter)
       
       READ(thisLine,FMT=*) string1, string2
       
       IF (TRIM(string1) .EQ. "tolSHGL") THEN
           READ(string2,FMT='(E16.8)') tolSHGL
           tolSHGL_set = .TRUE.    
       ELSEIF (TRIM(string1) .EQ. "tolSHGt") THEN
           READ(string2,FMT='(E16.8)') tolSHGt
           tolSHGt_set = .TRUE.  
       ELSEIF (TRIM(string1) .EQ. "nMaxCC") THEN
           READ(string2,FMT='(I)') nMaxCC
           nMaxCC_set = .TRUE.  
       ELSEIF (TRIM(string1) .EQ. "nVal") THEN
          READ(string2,FMT='(I)') nVal
          nVal_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "nMax") THEN
          READ(string2,FMT='(I)') nMax
          nMax_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "kMax") THEN
          READ(string2,FMT='(I)') kMax
          kMax_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "scissor") THEN
          READ(string2,FMT=*) scissor
          scissor_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "actual_band_gap") THEN
          READ(string2,FMT=*) actual_band_gap
          actual_band_gap_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "nSpinor") THEN
          READ(string2,FMT='(I)') nSpinor
          nSpinor_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "tol") THEN
          READ(string2,FMT='(E16.8)') tol
          tol_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "energy_data_filename") THEN
          READ(string2,FMT=*) energy_data_filename
          energy_data_filename_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "energys_data_filename") THEN
          READ(string2,FMT=*) energys_data_filename
          energys_data_filename_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "pmn_data_filename") THEN
          READ(string2,FMT=*) pmn_data_filename
          pmn_data_filename_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "smn_data_filename") THEN
          READ(string2,FMT=*) smn_data_filename
          smn_data_filename_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "rmn_data_filename") THEN
          READ(string2,FMT=*) rmn_data_filename
          rmn_data_filename_set = .TRUE.
       ELSEIF (TRIM(string1) .EQ. "der_data_filename") THEN
          READ(string2,FMT=*) der_data_filename
          WRITE(*,*) TRIM(string1), TRIM(der_data_filename)
       ELSE
          WRITE(*,*) "Error with keyword ", TRIM(string1)
          STOP 'Keyword not identified'
       END IF
    END DO
    
    CLOSE(1)
    
    IF (.NOT.nMaxCC_set) THEN
       write(*,*) "------------28 Enero 2008 ------------"
       WRITE(*,*) "Variable nMaxCC not set in input."
       WRITE(*,*) "The default value is going to be nMax."
       write(*,*) "------------28 Enero 2008 ------------"
    END IF

    IF (.NOT.tolSHGt_set) THEN
        tolSHGt=0.030d0
       write(*,*) "------------15 Febrero 2008 ------------"
       WRITE(*,*) "Variable tolSHGt not set "
       WRITE(*,*) "The default value is going to be tolSHGt=",tolSHGt
       write(*,*) "------------15 Febrero 2008 ------------"
    END IF
    IF (.NOT.tolSHGL_set) THEN
        tolSHGL=0.0001d0
       write(*,*) "------------4 Marzo 2008 ------------"
       WRITE(*,*) "Variable tolSHGL not set "
       WRITE(*,*) "The default value is going to be tolSHGL=",tolSHGL
       write(*,*) "------------------------"
    END IF
    






    IF (.NOT.nVal_set) THEN
       WRITE(*,*) "Variable nVal not set in input.  Will obtain value from energy file."
    END IF
    
    IF (.NOT.nMax_set) THEN
       WRITE(*,*) "Variable nMax not set in input.  Will obtain value from energy file."
    END IF
    
    IF (.NOT.kMax_set) THEN
       WRITE(*,*) "Variable kMax not set in input.  Will obtain value from energy file."
    END IF
    
    IF (.NOT.scissor_set) THEN
       WRITE(*,*) "Variable scissor not set in input file.  Using default value of 0.0."
       scissor = 0.d0
    END IF
    
    IF (scissor_set .AND. actual_band_gap_set) THEN
       WRITE(*,*) "Please specify only one of scissor or actual_band_gap.  Stopping"
       STOP "Both scissor and actual_band_gap set."
    END IF
    
    IF (.NOT.nSpinor_set) THEN
       WRITE(*,*) "Error with input file: must specify nSpinor."
       STOP
    END IF
    
    IF (.NOT.tol_set) THEN
       WRITE(*,*) "Variable tol not set in input file.  Using default value."
       tol = 0.030d0
    END IF
    
    IF (.NOT.energy_data_filename_set) THEN
       WRITE(*,*) "Variable energy_data_filename not set.  using default value."
       energy_data_filename = "energy.d"
       !WRITE(*,*) "Error with input file: must specify energy_data_filename"
       !STOP
    END IF
    
    IF (.NOT.energys_data_filename_set) THEN
       WRITE(*,*) "Error with input file: must specify energys_data_filename"
       STOP
    END IF
    
    IF (.NOT.pmn_data_filename_set) THEN
       WRITE(*,*) "Error with input file: must specify pmn_data_filename"
       STOP
    END IF
    
    nTrans = nVal*(nMax-nVal)
    !WRITE(6,FMT='(A,I5)') 'nTrans = ', nTrans
    WRITE(*,*) "   nTrans = nVal*(nMax-nVal)"
    WRITE(*,*) "   nTrans = ",nTrans
    
    SELECT CASE (nspinor)
    CASE(1) ! no spin-orbit included
       spin_factor = 2.d0
    CASE(2) ! spin-orbit included
       spin_factor = 1.d0
    CASE DEFAULT
       STOP 'nspinor makes no sense'
    END SELECT
    
    IF ((actual_band_gap_set).AND.(actual_band_gap .LT. 0.d0)) THEN
       WRITE(*,*) "Variable actual_band_gap cannot be negative.  Stopping"
       STOP "Variable actual_band_gap cannot be negative.  Stopping"
    END IF
    
   !WRITE(6,'(A,F)') 'spin_factor = ', spin_factor
    WRITE(*,*) "   spin_factor = ",spin_factor
    WRITE(*,*) "   nMaxCC = ",nMaxCC
    WRITE(*,*) "   tolSHGt = ",tolSHGt
    WRITE(*,*) "   tolSHGL = ",tolSHGL
     
  END SUBROUTINE parseParamFile
  
  
  SUBROUTINE remove_comments(inString,commentSignal)
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(INOUT) :: inString
    CHARACTER(LEN=1), INTENT(IN) :: commentSignal
    INTEGER :: i, commentLoc
    
    ! remove comments
    commentLoc = INDEX(TRIM(inString),commentSignal)
    
    !WRITE(*,*) "commentLoc: ", commentLoc
    IF (commentLoc.GT.0) THEN
       inString = inString(1:commentLoc-1)
       !WRITE(*,'(A,I3)') "Comment found on line number", lineCounter
    ELSE IF (commentLoc.LT.0) THEN
       STOP 'Variable commentLoc is negative!  Error in parser.'
    END IF
  END SUBROUTINE remove_comments
  
  
  SUBROUTINE reduce_white_space(inString, inStringLength)
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(INOUT) :: inString
    INTEGER, INTENT(IN) :: inStringLength
    CHARACTER(LEN=inStringLength) :: tmpString
    INTEGER :: i, stringLength, lengthCounter
    CHARACTER(LEN=1) :: thisChar, lastChar, space
    
    !WRITE(*,*) "TRIM(inString): ", TRIM(inString)
    
    space = ' '
    thisChar = inString(1:1)
    IF (thisChar.EQ.space) THEN
       STOP 'Error in reduce_white_space.  Not expecting a leading blank.'
    END IF
    lengthCounter = 1
    tmpString = thisChar
    stringLength = LEN_TRIM(inString)
    IF (stringLength.GT.1) THEN
       DO i=2,stringLength
          lastChar = thisChar
          thisChar = inString(i:i)
          IF (.NOT.((thisChar.EQ.lastChar).AND.(thisChar.EQ.space))) THEN
             lengthCounter = lengthCounter + 1
             tmpString(1:lengthCounter) = tmpString(1:lengthCounter-1) // thisChar
          END IF
       END DO
    END IF
    inString = tmpString
  END SUBROUTINE reduce_white_space
  
  
  SUBROUTINE check_for_two_strings(inString,lineNumber)
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(IN) :: inString
    INTEGER, INTENT(IN) :: lineNumber
    INTEGER :: spaceLoc
    
    ! Check that there are only two strings in the line.  To do this
    ! first locate the first space, and then check for a second one
    spaceLoc = INDEX(TRIM(inString),' ')  ! first blank location
    IF ((spaceLoc.EQ.0).OR.(spaceLoc.EQ.1)) THEN
       WRITE(*,*) "ERROR: spaceLoc found to be ", spaceLoc
       STOP "Error in parser"
    END IF
    spaceLoc = INDEX( TRIM(inString(spaceLoc+1:)),' ') ! second blank location
    IF (spaceLoc .GT. 0) THEN
       WRITE(*,'(A,I3)') "Found too many arguments on line number ", lineNumber
       STOP "Incorrect input file format"
    END IF
  END SUBROUTINE check_for_two_strings
  
END MODULE InputParametersFileMod
