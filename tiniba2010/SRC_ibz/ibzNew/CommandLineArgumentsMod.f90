MODULE CommandLineArgumentsMod
  
  USE DebugMod, ONLY : debug
  USE UtilitiesMod, ONLY : charToInt, convertToLowerCase
  
  IMPLICIT NONE
  
  ! wien2k is a logical that controls whether wien style kpoints should be
  ! output or not.
  LOGICAL :: wien2k
  
  ! abinit is a logical that controls whether abinit style kpoints should
  ! be output or not.  It also determines whether the input file should be
  ! an abinit input file.
  LOGICAL :: abinit
  
  ! defaultFormat is a logical that controls whether data should be provided
  ! in the default format.  It is only made true if neither wien2k or abinit
  ! formats are specified.
  LOGICAL :: defaultFormat
  
  ! cartesian is a logical that controls whether the kpoints in Cartesian
  ! cooridnates are output or not
  LOGICAL :: cartesian
  
  ! reduced is a logical that controls whether the kpoints in reduced
  ! coordinates are output.  Reduced coordinates means in the basis of the
  ! reciprocal lattive vectors
  LOGICAL :: reduced
  
  ! reducedInteger is a logical that controls whether the kpoints in
  ! reduced coordinates, but in terms of integer ratios are print out.
  ! This is not necessarily the same as the wien2k format.
  ! The kpoints are written to the kpoints.integer
  LOGICAL :: reducedInteger
  
  ! printSymmetries is a logical that controls whether the symmetries are
  ! printed.  If true, then the point group symmetries are printed twice
  ! One file, IBZsymmetries, contains a large list of the symmetries and
  ! the other file, Symmetries.Cartesian, contains just the symmetries
  ! in Cartesian coordinates.  The Symmetries.Cartesian is used by
  ! my (Fred's) tetrahedron integration code.
  LOGICAL :: printSymmetries
  
  ! printTetrahedra is a logical that determines whether to print out
  ! the tetrahedra.  The tetrahedra are required for the linear analytic
  ! tetrahedron method.
  LOGICAL :: printTetrahedra
  
  ! printCubes is a logical that determines whether to print out
  ! the cubes.  The cubes are required for the adaptive scheme.
  LOGICAL :: printCubes
  
  ! printMap is a logical that determines whether the kpoint map is
  ! printed out.  The kpoint map contains the information on which
  ! kpoint on the full grid was transformed to the irreducible grid
  ! and a symmerty matrix that took it there.  Of course, multiple
  ! symmetry matrices can relate two kpoints.
  LOGICAL :: printMap
  
  ! adaptive is a logical that the user cannot directly set.  It is
  ! set to true if the user sets a pass number
  LOGICAL :: adaptive
  
  ! passNumber is set by the user, and indicates which level of
  ! adaptation we are on.
  INTEGER :: passNumber
  
  ! mesh is a logical that is used to specify whether a file should
  ! be specified with the divisions in it, or whether that should
  ! be found automatically.  If mesh is true then the program looks
  ! for a file called "gridX" where X is the number of the previous
  ! pass
  LOGICAL :: mesh
  
CONTAINS
  
  SUBROUTINE parseCommandLineArguments
    IMPLICIT NONE
    
    INTEGER :: numberOfArguments, i, j
    CHARACTER(LEN=12) :: charArray(0:9)
    CHARACTER(LEN=12), ALLOCATABLE :: commandLineArgument(:)
    !CHARACTER(LEN=12), knownCommandLineArguments(10)
    CHARACTER(LEN=1) :: charArrayFixed(0:9)=(/'0','1','2','3','4','5','6','7','8','9'/)
    INTEGER, EXTERNAL :: IARGC
    
    debug = .FALSE.
    
    numberOfArguments = IARGC()
    
    ALLOCATE(commandLineArgument(numberOfArguments))
    
    cartesian = .FALSE.
    reduced   = .FALSE.
    reducedInteger = .FALSE.
    wien2k = .FALSE.
    abinit = .FALSE.
    printSymmetries = .FALSE.
    printTetrahedra = .FALSE.
    printCubes = .FALSE.
    printMap = .FALSE.
    adaptive = .FALSE.
    passNumber  = -1
    
    ! First get all command line arguments, and scan for the -help option
    DO i=1, numberOfArguments
       
       CALL GETARG(i, commandLineArgument(i))
       
       CALL convertToLowerCase( commandLineArgument(i) )
       
       ! Should something here to scan the commandLineArgments and reject
       ! them, with an error message, if the commandLineArgument is not
       ! valid.
       
       IF (commandLineArgument(i) .EQ. '-help') THEN
          CALL printHelp
          STOP
       END IF
       
    END DO
    
    ! If no command line arguments, then quit with help message
    IF (0==numberOfArguments) THEN
       CALL printHelp
       STOP
    END IF
    
    ! Scan for debug
    DO i=1, numberOfArguments
       IF (commandLineArgument(i) .EQ. '-debug') THEN
          WRITE(*,*) "Debugging turned on."
          debug = .TRUE.
       END IF
    END DO
    
    ! Scan for adaptive flag
    DO i=1, numberOfArguments
       IF (commandLineArgument(i) .EQ. '-pass') THEN
          adaptive = .TRUE.
          printMap = .TRUE.
          printCubes = .TRUE.
          charArray(0:9) = commandLineArgument(i+1)
          IF (ANY( charArray(0:9).EQ.charArrayFixed(0:9))) THEN
             CALL CharToInt(commandLineArgument(i+1), passNumber)
          ELSE
             WRITE(*,*) ""
             WRITE(*,*) "   ERROR"
             WRITE(*,*) "   Bad command line format."
             WRITE(*,*) "   Read integer ", commandLineArgument(i)
             WRITE(*,*) "   Stopping"
             STOP
          END IF
          EXIT
       END IF
    END DO
    
    ! If adaptive is not specified, treat run as a default first pass without reducedInteger
    IF (.NOT.adaptive) THEN
       passNumber = 0
    END IF
    
    ! If we're doing a refinement pass in the adaptive mode we set mesh = .TRUE.
    IF (passNumber.GE.1) THEN
       mesh = .TRUE.
    END IF
    
    ! Scan for rest of flags
    DO i=1, numberOfArguments
       IF (commandLineArgument(i) .EQ. '-cartesian') THEN
          cartesian = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-reduced') THEN
          reduced = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-reducedint') THEN
          reducedInteger = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-wien2k') THEN
          wien2k = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-abinit') THEN
          abinit = .TRUE.
          reduced = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-symmetries') THEN
          printSymmetries = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-tetrahedra') THEN
          printTetrahedra = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-cubes') THEN
          printCubes = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-grid') THEN
          mesh = .TRUE.
       ELSE IF (commandLineArgument(i) .EQ. '-map') THEN
          printMap = .TRUE.
       END IF
    END DO
    
    IF (wien2k .AND. abinit) THEN
       WRITE(*,*) ""
       WRITE(*,*) "     ERROR"
       WRITE(*,*) "     -wien2k and -abinit were specified.  Choose only one option."
       WRITE(*,*) "     Stopping."
       WRITE(*,*) ""
       STOP
    END IF
    
    IF ((.NOT.wien2k).AND.(.NOT.abinit)) THEN
       defaultFormat = .TRUE.
    END IF
    
    IF (adaptive .AND. (passNumber .EQ. -1)) THEN
       WRITE(*,*) ""
       WRITE(*,*) "     ERROR"
       WRITE(*,*) "     -pass was specified without an iteration number."
       WRITE(*,*) "     Stopping"
       STOP
    END IF
    
    DEALLOCATE(commandLineArgument)
    
  END SUBROUTINE parseCommandLineArguments
  
  SUBROUTINE printHelp
    IMPLICIT NONE
    WRITE(*,*) " "
    WRITE(*,*) "ibz: tetrahedral grid maker"
    WRITE(*,*) "USAGE: ibz [options]"
    WRITE(*,*) "Where options can be any of: "
    WRITE(*,*) ""
    WRITE(*,*) "-pass passNum    Use this to sepcify which pass you are on. passNum 0"
    WRITE(*,*) "                 corresponds to firstPass, passNum 1 is the first level"
    WRITE(*,*) "                 of refinement and so on."
    WRITE(*,*) ""
    WRITE(*,*) "-cartesian       Use to print out a list of kpoints in Cartesian"
    WRITE(*,*) "                 coordinates."
    WRITE(*,*) ""
    WRITE(*,*) "-reduced         Use to print out the list of kpoints in terms of the"
    WRITE(*,*) "                 reciprocal lattice, or so called reduced coordinates."
    WRITE(*,*) ""
    WRITE(*,*) "-reducedint      Use to print out the list of irreducible kpoints in"
    WRITE(*,*) "                 reduced cordinates but with the coordinates expressed"
    WRITE(*,*) "                 as integer ratios."
    WRITE(*,*) ""
    WRITE(*,*) "-wien2k          Use to print out the list of kpoints to be used with"
    WRITE(*,*) "                 the WIEN code.  The resulting file kpoints.klist can be"
    WRITE(*,*) "                 used with lapw1."
    WRITE(*,*) ""
    WRITE(*,*) "-abinit          Use to print out the list of kpoint to be used with"
    WRITE(*,*) "                 the ABINIT code.  Also expects an ABINIT WFK file to"
    WRITE(*,*) "                 be present so that it can process it for relevant info."
    WRITE(*,*) ""
    WRITE(*,*) "-symmetries      Use to print out the symmetry matrices as read from the"
    WRITE(*,*) "                 Wien2k code case.struct file.  Two files are made.  One"
    WRITE(*,*) "                 contains the symmetry matrices in a variety of bases,"
    WRITE(*,*) "                 the other has the Symmetry matrices in only the"
    WRITE(*,*) "                 Cartesian basis."
    WRITE(*,*) ""
    WRITE(*,*) "-tetrahedra      Use this option to print out the tetrahedra to file"
    WRITE(*,*) "                 called tetrahedra."
    WRITE(*,*) ""
    WRITE(*,*) "-cubes           Use this option to print out the cubes to file called cubes."
    WRITE(*,*) ""
    WRITE(*,*) "-map             Use this option to print the map of original grid"
    WRITE(*,*) "                 points to irreducible grid points."
    WRITE(*,*) ""
    WRITE(*,*) "-grid            Use this option if you want to specify the mesh grid"
    WRITE(*,*) "                 divisions in a file called grid.  Otherwise, the"
    WRITE(*,*) "                 the program will ask you how many total kpoints you"
    WRITE(*,*) "                 want and will calculate the divisions automatically."
    WRITE(*,*) ""
    WRITE(*,*) "-debug           Use this to turn on debugging information."
    WRITE(*,*) " "
  END SUBROUTINE printHelp
  
END MODULE CommandLineArgumentsMod
