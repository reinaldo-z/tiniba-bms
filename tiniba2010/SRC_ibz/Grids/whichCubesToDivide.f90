PROGRAM Main
!!!
  USE FileStuff, ONLY : MyInquire
  IMPLICIT NONE
  
  INTEGER :: iostatus
  LOGICAL :: L
  DOUBLE PRECISION, ALLOCATABLE :: energy(:,:)
  INTEGER :: nBands
  INTEGER :: nValenceBands
  INTEGER :: nConductionBands
  INTEGER :: nKpts  
  INTEGER :: iKpt
  INTEGER :: iKpt_file
  INTEGER :: nPts
  INTEGER :: passNumber
  INTEGER :: nCubes
  INTEGER :: iCube
  INTEGER, ALLOCATABLE :: cubeCorners(:,:)
  INTEGER, ALLOCATABLE :: gridCoordinates(:,:)
  CHARACTER(LEN=255) :: cubesToDivideFilename
  CHARACTER(LEN=1) :: passNumberChar  
  CHARACTER(LEN=255) :: kpointsmapFilename
  CHARACTER(LEN=255) :: cubesFilename
  CHARACTER(LEN=255) :: energyFilename
  CHARACTER(LEN=255) :: gridFilename
  CHARACTER(LEN=255) :: infoPass
  
  DOUBLE PRECISION :: energyC, energyV, transitionEnergy(1:8)
  INTEGER :: iCorner
  INTEGER :: iCounter
  DOUBLE PRECISION :: bandGap = 0.d0
  DOUBLE PRECISION :: targetEnergy = 0.d0
  
  targetEnergy = 5.0d0
  WRITE(*,*) " Energy target: "  
  READ(*,*) targetEnergy

  WRITE(*,*) " E= ",targetEnergy
  WRITE(*,*) "Please enter the pass number you want to process."
  WRITE(*,*) " "
  READ(*,*) passNumber
  
  WRITE(passNumberChar,'(I1)') passNumber
  infoPass = "infoPass"//passNumberChar
  OPEN (UNIT=12,FILE=infopass,STATUS='unknown')


  kpointsmapFilename = "kpoints.map"//passNumberChar
  cubesFilename = "cubes"//passNumberChar
  gridFilename = "grid"//passNumberChar
  energyFilename = "energys.d"
  cubesToDivideFilename = "cubesToDivide"//passNumberChar
  
  CALL myInquire(kpointsmapFilename)
  CALL myInquire(cubesFilename)
  CALL myInquire(gridFilename)
  CALL myInquire(energyFilename)
  
  ! get energy data
  OPEN(UNIT=1,FILE=energyFilename,STATUS="OLD",ACTION="READ")

  READ(35,*) nKpts
  READ(35,*) nValenceBands
  READ(35,*) nConductionBands
  !modificated by cabellos jl on Jueves 22 April 2010
  !READ(1,*) nKpts
  !READ(1,*) nValenceBands
  !READ(1,*) nConductionBands

  nBands = nValenceBands + nConductionBands
  WRITE(12,*) "pass number = ",trim(passNumberChar) 
  WRITE(12,*) "target energy = ",targetEnergy 
  write(12,*) "nkpts =",nKpts 
  write(12,*) "nValenceBands =",nValenceBands
  write(12,*) "nConductionBands=",nConductionBands


  ALLOCATE(energy(nKpts,nBands))
  DO iKpt = 1, nKpts
     READ(1,*) iKpt_file, energy(iKpt,1:nBands)
     IF (iKpt .NE. iKpt_file) THEN
        STOP "kpoints to d not line up in energy file"
     END IF
  END DO
  CLOSE(1)
  
  ! get grid data
  ! OPEN(1,FILE=gridFilename)
  ! CLOSE(1)
  
  ! get cubes data
  OPEN (UNIT=1,FILE=cubesFilename,STATUS="OLD",ACTION="READ")
  READ(1,*) nCubes
  WRITE(*,*) "Number of cubes to read: ", nCubes
  write(12,*) "Number of cubes to read=",nCubes
  ALLOCATE (cubeCorners(nCubes,8))
  DO iCube = 1, Ncubes
     READ(UNIT=1, FMT=*, IOSTAT=iostatus) cubeCorners(iCube,1:8), passNumber
     IF (iostatus.NE.0) THEN
        WRITE(*,*) "Error reading from cubes file."
        STOP "Error reading from cubes file."
     END IF
  END DO
  CLOSE(1)
  
  ! get kpoints map data
  OPEN (UNIT=1,FILE=kpointsmapFilename,STATUS="OLD",ACTION="READ")
  READ(1,*) Npts
  ALLOCATE( gridCoordinates(Npts,4) )
  DO iKpt = 1, Npts
     READ(UNIT=1, FMT=*, IOSTAT=iostatus) gridCoordinates(iKpt,1:4)
     IF (iostatus.NE.0) THEN
        WRITE(*,*) "Error reading from kpoints.map file."
        STOP "Error reading from kpoints.map file."
     END IF
  END DO
  CLOSE(1)
  
  ! ====  At this point we have the input we need ====
  
  OPEN (UNIT=2, FILE=cubesToDivideFilename, ACTION="WRITE", IOSTAT=iostatus)
  IF (iostatus.NE.0) THEN
     WRITE(*,*) ""
     WRITE(*,*) "      ERROR: Cannot open file "//TRIM(cubesToDivideFilename)
     WRITE(*,*) "      STOPPING"
     WRITE(*,*)
     STOP
  END IF
  WRITE(2,*) Ncubes
  
  iCounter = 0
  ! loop over all the old cubes
  bandGap = 100.d0 ! set to abnormally large number
  
  DO iCube = 1, Ncubes
     
     ! Initialize L to false
     L = .FALSE.
     
     ! For each cube we test if it is a cube to divide.
     DO iCorner = 1, 8
        energyC = energy( gridCoordinates(cubeCorners(iCube,iCorner),4), nValenceBands+1 )
        energyV = energy( gridCoordinates(cubeCorners(iCube,iCorner),4), nValenceBands )
        transitionEnergy(iCorner) = energyC - energyV
        If (transitionEnergy(iCorner) .LT. bandGap) THEN
           bandGap = transitionEnergy(iCorner)
           WRITE(*,*) "Band gap is now: ", bandGap
           WRITE(12,*) "Band gap is now: ", bandGap
        END IF
     END DO
     
     IF (MINVAL(transitionEnergy(1:8)) .LE. targetEnergy) THEN
        L = .TRUE.
        ! WRITE(*,*) "     ", gridCoordinates(cubeCorners(iCube,iCorner),4)
        ! WRITE(*,*) "     ", energyC, energyV
        ! PAUSE
     END IF
     
     WRITE(2,*) iCube, L
     
     IF (L) iCounter = iCounter + 1
     
  END DO   ! cubes
  
  WRITE(*,*) "Number of cubes to divide: ", iCounter
  WRITE(12,*) "Number of cubes to divide: ", iCounter
  write(*,*) "info = ",trim(infoPass)
  
  CLOSE(2)
  close(12)
END PROGRAM Main
