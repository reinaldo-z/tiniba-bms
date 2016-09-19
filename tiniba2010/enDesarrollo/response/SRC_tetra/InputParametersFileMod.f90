MODULE InputParametersFileMod
  
  USE ConstantsMod, ONLY : DP, pi
  
  USE DebugMod, ONLY : debug
  USE InputParametersMod, ONLY : nMaxCC  


  USE InputParametersMod, ONLY : nVal
  USE InputParametersMod, ONLY : nMax
  USE InputParametersMod, ONLY : nVal_tetra
  USE InputParametersMod, ONLY : nMax_tetra
  USE InputParametersMod, ONLY : kMax
  USE InputParametersMod, ONLY : nTetra
  USE InputParametersMod, ONLY : energyMin
  USE InputParametersMod, ONLY : energyMax
  USE InputParametersMod, ONLY : energySteps
  USE InputParametersMod, ONLY : energy_data_filename
  USE InputParametersMod, ONLY : energys_data_filename
  USE InputParametersMod, ONLY : half_energys_data_filename
  USE InputParametersMod, ONLY : tet_list_filename
  USE InputParametersMod, ONLY : integrand_filename
  USE InputParametersMod, ONLY : spectrum_filename
  USE InputParametersMod, ONLY : nTrans
  USE InputParametersMod, ONLY : paramFile
  
  LOGICAL :: nMaxCC_set = .false.
  LOGICAL :: nVal_set = .false.
  LOGICAL :: nMax_set = .false.
  LOGICAL :: nVal_tetra_set = .false.
  LOGICAL :: nMax_tetra_set = .false.
  LOGICAL :: kMax_set = .false.
  LOGICAL :: nTetra_set = .false.
  LOGICAL, PRIVATE :: energy_min_set = .false.
  LOGICAL, PRIVATE :: energy_max_set = .false.
  LOGICAL, PRIVATE :: energy_Steps_set = .false.
  LOGICAL, PRIVATE :: energy_data_filename_set = .false.
  LOGICAL, PRIVATE :: energys_data_filename_set = .false. 
  LOGICAL, PRIVATE :: half_energys_data_filename_set = .false.
  LOGICAL, PRIVATE :: tet_list_filename_set = .false.
  LOGICAL, PRIVATE :: integrand_filename_set = .false.
  LOGICAL, PRIVATE :: spectrum_filename_set = .false.
  
CONTAINS
  
  SUBROUTINE parseParamFile
    IMPLICIT NONE
    CHARACTER(LEN=255) thisLine
    CHARACTER(LEN=255) string1, string2
    CHARACTER(LEN=1), PARAMETER :: commentSignal = '#'
    INTEGER :: ios
    INTEGER :: lineLength, lineCounter
    INTEGER :: iTmp
    
    IF (debug) WRITE(*,*) "Beginning to parse parameter file."
    
    OPEN(UNIT=1, FILE=paramFile, FORM='FORMATTED', STATUS='OLD', IOSTAT=ios)
    IF (ios.NE.0) THEN
       WRITE(*,*) "Error opening file: ", TRIM(paramFile)
       WRITE(*,*) "This should be the parameter file and be the first argument."
       WRITE(*,*) "Stopping"
       STOP
    ELSE
       WRITE(*,'(2A)') "Opened file: ", TRIM(paramFile)
    END IF
    
    WRITE(*,'(2A)') "Opened file: ", TRIM(paramFile)
    
    lineCounter = 0
    
    DO
       lineCounter = lineCounter + 1
       READ(UNIT=1,FMT='(A)',IOSTAT=ios) thisLine
       IF (ios.EQ.-1) THEN
          ! end of file
          WRITE(*,*) "End of file found"
          EXIT
       END IF
       
       IF (debug) WRITE(*,'(A)') TRIM(thisLine)
       
       thisLine = ADJUSTL(thisLine) ! move any leading white space to the back.
       
       CALL remove_comments(thisLine, commentSignal)
       
       IF (Debug) WRITE(*,'(A)') TRIM(thisLine)
       
       lineLength = LEN_TRIM(thisLine)
       
       IF (lineLength.EQ.0) THEN
          IF (debug) WRITE(*,'(A,I3)') "Blank line found on line number", lineCounter
          CYCLE
       END IF
       
       CALL reduce_white_space(thisLine, LEN(thisLine))
       
       CALL check_for_two_strings(thisLine,lineCounter)
       
       ! thisLine should contain just two sets of non-blank characters
       
       READ(thisLine,FMT=*) string1, string2
       IF (TRIM(string1) .EQ. "nMaxCC") THEN
          READ(string2,FMT='(I)') nMaxCC
          nMaxCC_set = .true.       
       ELSEIF (TRIM(string1) .EQ. "nVal") THEN
          READ(string2,FMT='(I)') nVal
          nVal_set = .true.
       ELSEIF (TRIM(string1) .EQ. "nMax") THEN
          READ(string2,FMT='(I)') nMax
          nMax_set = .true.
       ELSEIF (TRIM(string1) .EQ. "nVal_tetra") THEN
          READ(string2,FMT='(I)') nVal_tetra
          nVal_tetra_set = .true.
       ELSEIF (TRIM(string1) .EQ. "nMax_tetra") THEN
          READ(string2,FMT='(I)') nMax_tetra
          nMax_tetra_set = .true.
       ELSEIF (TRIM(string1) .EQ. "kMax") THEN
          READ(string2,FMT='(I)') kMax
          kMax_set = .true.
       ELSEIF (TRIM(string1) .EQ. "nTetra") THEN
          READ(string2,FMT='(I)') nTetra
          nTetra_set = .true.
       ELSEIF (TRIM(string1) .EQ. "energy_data_filename") THEN
          READ(string2,FMT=*) energy_data_filename
          energy_data_filename_set = .true.
       ELSEIF (TRIM(string1) .EQ. "energys_data_filename") THEN
          READ(string2,FMT=*) energys_data_filename
          energys_data_filename_set = .true.
       ELSEIF (TRIM(string1) .EQ. "tet_list_filename") THEN
          READ(string2,FMT=*) tet_list_filename
          tet_list_filename_set = .true.
       ELSEIF (TRIM(string1) .EQ. "integrand_filename") THEN
          READ(string2,FMT='(A)') integrand_filename
          integrand_filename_set = .true.
       ELSEIF (TRIM(string1) .EQ. "spectrum_filename") THEN
          READ(string2,FMT='(A)') spectrum_filename
          spectrum_filename_set = .true.
       ELSEIF (TRIM(string1) .EQ. "energy_min") THEN
          READ(string2,FMT=*) energyMin
          energy_min_set = .true.
       ELSEIF (TRIM(string1) .EQ. "energy_max") THEN
          READ(string2,FMT=*) energyMax
          energy_max_set = .true.
       ELSEIF (TRIM(string1) .EQ. "energy_steps") THEN
          READ(string2,FMT=*) energySteps
          energy_steps_set = .true.
       ELSE
          WRITE(*,*) "Error with keyword ", TRIM(string1)
          STOP 'Keyword not identified'
       END IF
    END DO
    
    CLOSE(1)
   IF (.NOT.nMaxCC_set) THEN
       WRITE(*,*) "Variable nMaxCC not set in input"
    END IF  
  

    IF (.NOT.nVal_set) THEN
       WRITE(*,*) "Variable nVal not set in input.  Will obtain value from energy file."
    END IF
    
    IF (.NOT.nMax_set) THEN
       WRITE(*,*) "Variable nMax not set in input.  Will obtain value from energy file."
    END IF
    
    IF (nVal_set) THEN
       IF (.NOT.nVal_tetra_set) THEN
          WRITE(*,*) "Variable nVal_tetra not set.  Using default value."
          nVal_tetra = nVal
       END IF
    END IF
    
    IF (nMax_set) THEN
       IF (.NOT.nMax_tetra_set) THEN
          WRITE(*,*) "Variable nVal_tetra not set.  Using default value."
          nMax_tetra = nMax - nVal
       END IF
    END IF
    
    IF (.NOT.kMax_set) THEN
       WRITE(*,*) "Variable kMax not set in input.  Will obtain value from energy file."
    END IF
    
    IF (.NOT.nTetra_set) THEN
       WRITE(*,*) "Variable nTetra not set in input.  Will obtain value from tetrahedra file."
    END IF
    
    IF (.NOT.energy_data_filename_set) THEN
       WRITE(*,*) "WARNING: Variable energy_data_filename not specified in input"
       WRITE(*,*) "         file.  Alright to continue if careful."
    END IF
    
    IF (.NOT.energys_data_filename_set) THEN
       WRITE(*,*) "Error with input file: must specify enegys_data_filename"
       STOP
    END IF
    
    IF (.NOT.half_energys_data_filename_set) THEN
       WRITE(*,*) "WARNING: Variable enegys_data_filename not specified in input"
       WRITE(*,*) "         file.  Alright to continue if careful."
    END IF
    
    IF (.NOT.tet_list_filename_set) THEN
       WRITE(*,*) "Error with input file: must specify tet_list_filename"
       STOP
    END IF
    
    IF (.NOT.integrand_filename_set) THEN
       WRITE(*,*) "Error with input file: must specify integrand_filename"
       STOP
    END IF
    
    IF (.NOT.spectrum_filename_set) THEN
       WRITE(*,*) "Variable spectrum_filename not set.  Using default value."
       spectrum_filename = "spectrum.output"
    END IF
    
    IF (.NOT.energy_min_set) THEN
       energyMin = 0.d0
       WRITE(*,'(A,F13.8)') "Variable energy_min not specified. "//&
            "Using default value of", energyMin
    END IF
    
    IF (.NOT.energy_max_set) THEN
       energyMax = 20.d0
       WRITE(*,'(A,F13.8)') "Variable energy_max not specified. "//&
            "Using default value of", energyMax
    END IF
    
    IF (.NOT.energy_steps_set) THEN
       energySteps = 2001
       WRITE(*,'(A,I8)') "Variable energy_steps not specified. "//&
            "Using default value of", energySteps
    END IF
    
    nTrans = nVal*(nMax-nVal)
    WRITE(6,FMT='(A,I5)') 'nTrans = ', nTrans
    
    WRITE(*,*)"nMaxCC = ",nMaxCC

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
    
    !WRITE(*,*) "Entered reduce_white_space"
    
    !WRITE(*,*) "TRIM(inString): ", TRIM(inString)
    
    space = ' '
    thisChar = inString(1:1)
    !WRITE(*,*) "thisChar: ", thisChar
    IF (thisChar.EQ.space) THEN
       STOP 'Error in reduce_white_space.  Not expecting a leading blank.'
    END IF
    lengthCounter = 1
    tmpString = thisChar
    stringLength = LEN_TRIM(inString)
    IF (stringLength.GT.1) THEN
       DO i=2,stringLength
          !WRITE(*,*) inString(i:i)
          lastChar = thisChar
          thisChar = inString(i:i)
          !WRITE(*,*) "lastChar thisChar ", lastChar, thisChar
          IF (.NOT.((thisChar.EQ.lastChar).AND.(thisChar.EQ.space))) THEN
             !WRITE(*,*) "Char to append: ", thisChar
             lengthCounter = lengthCounter + 1
             tmpString(1:lengthCounter) = tmpString(1:lengthCounter-1) // thisChar
          END IF
       END DO
    END IF
    inString = tmpString
    !WRITE(*,*) "TRIM(outString): ", TRIM(outString)
    !WRITE(*,*) "Exiting reduce_white_space"
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
