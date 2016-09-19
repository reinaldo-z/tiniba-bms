MODULE NextPassMod
  
  USE DebugMod, ONLY : debug
  
  USE UtilitiesMod, ONLY : IntToChar
  
  USE GridMod, ONLY : IRpts
  USE GridMod, ONLY : cubes, cubeLevel, Ncubes
  ! Ncubes is the number of cubes that will exist after the pass.
  USE GridMod, ONLY : Npts, NIRpts
  USE GridMod, ONLY : N1, N2, N3
  
  USE MyAllocateMod, ONLY : myAllocate
  
  IMPLICIT NONE
  
  INTEGER :: passNumber
  
  INTEGER :: NptsNew, NptsOld
  INTEGER :: numberOfCubesToDivide, numOldCubes
  INTEGER :: N1old, N2old, N3old
  INTEGER, ALLOCATABLE :: oldCubes(:,:), oldCubeLevel(:)
  LOGICAL, ALLOCATABLE :: divideThisCube(:)
  
CONTAINS
  
  SUBROUTINE nextPass(itmp)
    INTEGER, INTENT(IN) :: iTmp
    
    CALL setPassNumber(iTmp)
    CALL setupNextPass
    CALL readCubes
    CALL readWhichCubesToDivide
    CALL readKpointsMap
    CALL divideCubes
    CALL reduceNewPoints
    
  END SUBROUTINE nextPass
  
  SUBROUTINE setPassNumber(itmp)
    INTEGER, INTENT(IN) :: itmp
    passNumber = itmp
  END SUBROUTINE setPassNumber
  
  SUBROUTINE setupNextPass
    IF (debug) WRITE(*,*) "Program Flow: Entered setupNextPass"
    NptsNew = 0
    N1old = N1
    N2old = N2
    N3old = N3
  END SUBROUTINE setupNextPass
  
  SUBROUTINE readCubes
    ! This subroutine reads the list of cube corners from the previous pass
    IMPLICIT NONE
    INTEGER :: j
    CHARACTER(LEN=5) :: charTemp
    CHARACTER(LEN=6) :: cubesFilename
    CHARACTER(LEN=26) :: charTemp26
    CHARACTER(LEN=1) :: charTemp1
    LOGICAL :: fileExists
    
    IF (debug) WRITE(*,*) "Program Flow: Entered readCubes"
    
    CALL IntToChar(passNumber-1,charTemp1)
    cubesFilename = "cubes"//TRIM(charTemp1)
    INQUIRE(FILE=cubesFilename, EXIST=fileExists)
    IF (.NOT.fileExists) THEN
       WRITE(*,*) ""
       WRITE(*,*) "      ERROR: File "//TRIM(cubesFilename)//" does not exist."
       WRITE(*,*) "      STOPPING"
       WRITE(*,*) ""
       STOP "Cubes file from previous pass does not exist."
    END IF
    
    IF ( debug ) WRITE(*,*) "Opening cubes file: ", cubesFilename
    OPEN(UNIT=10, FILE=cubesFilename, ACTION="READ")
    
    IF (debug) WRITE(*,*) "We are on iteration ", passNumber
    READ(10,*) numOldCubes
    
    CALL myAllocate( oldCubes, "oldCubes", numOldCubes, 8 )
    CALL myAllocate( oldCubeLevel, "oldCubeLevel", numOldCubes )
    
    DO j = 1, numOldCubes
       READ(UNIT=10, FMT=*) oldCubes(j,1:8), oldCubeLevel(j)
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE readCubes
  
  SUBROUTINE readWhichCubesToDivide
!!! This subroutine reads the cubesToDivide file and stores
!!! the information from it.  The cubesToDivide filename needs
!!! to be appended with the Pass number.  For the first refinement
!!! pass, the program need cubesToDivide0.  For the second it needs
!!! cubesToDivide1, etc...
    
    IMPLICIT NONE
    
    INTEGER :: iTemp, j
    LOGICAL :: fileExists
    CHARACTER(LEN=1) :: charTemp1
    CHARACTER(LEN=14) :: cubesToDivideFilename
    
    IF (debug) WRITE(*,*) "Program Flow: Entered readWhichCubesToDivide"
    
    CALL IntToChar(passNumber-1,charTemp1)
    cubesToDivideFilename = "cubesToDivide"//TRIM(charTemp1)
    INQUIRE(FILE=cubesToDivideFilename, EXIST=fileExists)
    IF (.NOT.fileExists) THEN
       WRITE(*,*) ""
       WRITE(*,*) "      ERROR: File "//TRIM(cubesToDivideFilename)//" does not exist."
       WRITE(*,*) "      STOPPING"
       WRITE(*,*) ""
       STOP "cubesToDivide file does not exist."
    END IF
    OPEN(UNIT=10, FILE=cubesToDivideFilename, ACTION="READ")
    READ(10,*) iTemp
    IF (iTemp.NE.numOldCubes) THEN
       WRITE(*,*) "Inconsistency with the cubes file and cubesToDivide file"
       WRITE(*,*) "Stopping"
       STOP "Inconsistency with the cubes file and cubesToDivide file"
    END IF
    CALL myAllocate ( divideThisCube, "divideThisCube", iTemp )
    
    numberOfCubesToDivide = 0
    
    DO iTemp = 1, numOldCubes
       READ(10,*) j, divideThisCube(iTemp)
       IF (j .NE. iTemp) THEN
          WRITE(*,*) "File cubesToDivide does not list cubes in order."
          WRITE(*,*) "Stopping"
          STOP "File cubesToDivide does not list cubes in order."
       END IF
       IF (divideThisCube(iTemp)) THEN
          numberOfCubesToDivide = numberOfCubesToDivide + 1
       END IF
    END DO
    
    CLOSE(10)
    
    Ncubes = numOldCubes - numberOfCubesToDivide + 8*numberOfCubesToDivide
    
  END SUBROUTINE readWhichCubesToDivide
  
  SUBROUTINE readKpointsMap
    ! Reads kpoint.map file and stores coordinates in gridCoordinates.
    ! Also doubles the integers describing the point, to make them
    ! consistent with the new grid.
    USE GridMod, ONLY : gridCoordinates, gridPointer
    IMPLICIT NONE
    INTEGER :: sizeEstimate
    INTEGER :: i
    LOGICAL :: fileExists
    CHARACTER(LEN=12) :: kpointsMapFile
    CHARACTER(LEN=1) :: charTemp1
    
    IF (debug) WRITE(*,*) "Program Flow: Entered readKpointsMap"
    
    ! Double the grid
    N1 = N1*2 - 1  ! (N1-1)*2+1
    N2 = N2*2 - 1  ! (N2-1)*2+1
    N3 = N3*2 - 1  ! (N3-1)*2+1
    
    ! Estimate size of grid we will need.
    sizeEstimate = 64*Ncubes  ! This is the most we could need
    
    CALL myAllocate( gridCoordinates, "gridCoordinates", sizeEstimate, 3 )
    CALL myAllocate( gridPointer, "gridPointer", sizeEstimate )
    
    gridCoordinates(1:sizeEstimate,1:3) = 0
    gridPointer(1:sizeEstimate) = 0
    
    CALL IntToChar(passNumber-1,charTemp1)
    kpointsMapFile = "kpoints.map"//TRIM(charTemp1)
    INQUIRE(FILE=kpointsMapFile, EXIST=fileExists)
    IF (.NOT.fileExists) THEN
       WRITE(*,*) ""
       WRITE(*,*) "      ERROR: File "//kpointsMapFile//" does not exist."
       WRITE(*,*) "      STOPPING"
       WRITE(*,*) ""
       STOP "kpoints.map file does not exist."
    END IF
    OPEN(UNIT=10,FILE=kpointsMapFile,ACTION="READ")
    READ(10,*) NptsOld
    ! In the first iteration of nextPass, after running firstPass, NptsOld = N1*N2*N3.
    ! In the second iteration of nextPass, NptsOld = oldN1*oldN2*oldN3 + numberOfNewPoints
    
    DO i=1,NptsOld
       READ(UNIT=10,FMT='(3I8)') gridCoordinates(i,1:3)
       ! We double the integer values since the coordinates are for
       ! the old grid parameters N1, N2, and N3.
       gridCoordinates(i,1:3) = 2*gridCoordinates(i,1:3)
       gridPointer(i) = 1 + gridCoordinates(i,3) + N3*gridCoordinates(i,2) &
                          + N2*N3*gridCoordinates(i,1)
    END DO
    CLOSE(10)
    
  END SUBROUTINE readKpointsMap
  
  
  SUBROUTINE divideCubes
    USE GridMod, ONLY : Npts
    USE GridMod, ONLY : gridCoordinates, gridPointer
    USE GridMod, ONLY : weights
    
    IMPLICIT NONE
    
    INTEGER :: iCube, M, iCounter, newCubeCounter, oldCubeCounter
    INTEGER :: i, j, k
    INTEGER :: corn(27)
    INTEGER, ALLOCATABLE :: tempCoordinates(:,:)
    DOUBLE PRECISION, ALLOCATABLE :: tempWeights(:)
    
    IF (debug) WRITE(*,*) "Program Flow: Entered divideCubes"
    
    CALL myAllocate(cubes, "cubes", Ncubes, 8)
    CALL myAllocate(cubeLevel, "cubeLevel", Ncubes)
    CALL myAllocate(weights, "weights", 8*Ncubes)
    
    newCubeCounter = numOldCubes - numberOfCubesToDivide
    oldCubeCounter = 0
    
    DO iCube = 1, numOldCubes
       
       IF (.NOT.divideThisCube(iCube)) THEN
          ! This is an old cube that should not be divided and so we include it as is.
          oldCubeCounter = oldCubeCounter + 1
          cubes(oldCubeCounter,1:8) = oldCubes(iCube,1:8)
          cubeLevel(oldCubeCounter) = oldCubeLevel(iCube)
          
       ELSE IF (divideThisCube(iCube)) THEN
          
          ! The array corn(1:27) holds the 27 grid points which constitute
          ! the corners of the 8 new cubes.  Here we get the 8 old grid
          ! points which define the old cube to be divided.
          
          corn(1)  = oldCubes(iCube, 1)
          corn(3)  = oldCubes(iCube, 2)
          corn(7)  = oldCubes(iCube, 3)
          corn(9)  = oldCubes(iCube, 4)
          corn(19) = oldCubes(iCube, 5)
          corn(21) = oldCubes(iCube, 6)
          corn(25) = oldCubes(iCube, 7)
          corn(27) = oldCubes(iCube, 8)
          
          iCounter = 0
          
          ! We define the 19 new grid points and check to ensure that
          ! they are not duplicates
          DO i=0,2
             DO j=0,2
                DO k=0,2
                   
                   iCounter = iCounter + 1
                   
                   ! This IF statement is to avoid points that are corners
                   ! of the large old cube.
                   IF ( ANY((/i,j,k/).EQ.(/1,1,1/)) ) THEN
                      
                      NptsNew = NptsNew + 1
                      M = NptsOld + NptsNew
                      corn(iCounter) = M
                      gridCoordinates(M,1:3) = gridCoordinates(oldCubes(iCube,1),1:3) &
                           + (/i,j,k/)
                      gridPointer(M) = 1 + gridCoordinates(M,3) &
                                         + N3*gridCoordinates(M,2) &
                                         + N2*N3*gridCoordinates(M,1)
                   END IF
                END DO
             END DO
          END DO
          
          cubes(newCubeCounter + 1,1:8) = &
               (/corn(1),corn(2),corn(4),corn(5),corn(10),corn(11),corn(13),corn(14)/)
          cubes(newCubeCounter + 2,1:8) = &
               (/corn(2),corn(3),corn(5),corn(6),corn(11),corn(12),corn(14),corn(15)/)
          cubes(newCubeCounter + 3,1:8) = &
               (/corn(4),corn(5),corn(7),corn(8),corn(13),corn(14),corn(16),corn(17)/)
          cubes(newCubeCounter + 4,1:8) = &
               (/corn(5),corn(6),corn(8),corn(9),corn(14),corn(15),corn(17),corn(18)/)
          cubes(newCubeCounter + 5,1:8) = &
               (/corn(10),corn(11),corn(13),corn(14),corn(19),corn(20),corn(22),corn(23)/)
          cubes(newCubeCounter + 6,1:8) = &
               (/corn(11),corn(12),corn(14),corn(15),corn(20),corn(21),corn(23),corn(24)/)
          cubes(newCubeCounter + 7,1:8) = &
               (/corn(13),corn(14),corn(16),corn(17),corn(22),corn(23),corn(25),corn(26)/)
          cubes(newCubeCounter + 8,1:8) = &
               (/corn(14),corn(15),corn(17),corn(18),corn(23),corn(24),corn(26),corn(27)/)
          
          newCubeCounter = newCubeCounter + 8
          
       END IF ! IF(divideThisCube(iCube))
    END DO ! iCube
    
    DEALLOCATE ( divideThisCube )
    DEALLOCATE ( oldCubes )
    DEALLOCATE ( oldCubeLevel )
    
    cubeLevel(oldCubeCounter+1:newCubeCounter) = passNumber
    
    Npts = NptsOld + NptsNew
    
    CALL sortPoints
    CALL findDuplicates
    
    !Relabel cube corners to correspond to new grid w/o duplicates
    DO i = 1, 8
       cubes(1:Ncubes,i) = gridPointer(cubes(1:Ncubes,i))
    END DO
    
    weights(:) = 0.d0
    DO i = 1, Ncubes
       DO j = 1, 8
          weights( cubes(i,j) ) = &
               weights( cubes(i,j) ) &
               + 0.125d0 *((8.0d0)**(passNumber - cubeLevel(i)))
       END DO
    END DO
    
    !DO i=1, npts
    !   WRITE(*,*) weights(i)
    !END DO
    
    
    !Reallocate arrays to the actual number of kpoints, rather then sizeEstimate
    CALL myAllocate( tempCoordinates, "tempCoordinates", Npts, 3 )
    tempCoordinates(1:Npts,1:3) = gridCoordinates(1:Npts,1:3)
    DEALLOCATE(gridCoordinates)
    
    CALL myAllocate( gridCoordinates, "gridCoordinates", Npts, 3 )
    gridCoordinates(1:Npts,1:3) = tempCoordinates(1:Npts,1:3)
    DEALLOCATE(tempCoordinates)
    
    CALL myAllocate( tempWeights, "tempWeights", Npts )
    tempWeights(1:Npts) = weights(1:Npts)
    DEALLOCATE(weights)
    
    CALL myAllocate( weights, "weights", Npts)
    weights(1:Npts) = tempWeights(1:Npts)
    DEALLOCATE(tempWeights)
    
    DEALLOCATE(gridPointer)
    CALL myAllocate( gridPointer, "gridPointer", Npts )
    gridPointer(:) = 0
    
    IF (debug) WRITE(*,*) "In nextPassMod.f90 sum of reducible weights:", SUM(weights(1:Npts))
    
  END SUBROUTINE divideCubes
  
  SUBROUTINE sortPoints
    
    USE SortingMod, ONLY : indx
    USE SortingMod, ONLY : initializeIndex, destroyIndex
    USE SortingMod, ONLY : quickSortIndex, partitionIndex
    
    USE GridMod, ONLY : Npts
    USE GridMod, ONLY : gridCoordinates, gridPointer
    
    IMPLICIT NONE
    
    INTEGER, ALLOCATABLE :: iArr(:)
    INTEGER :: i
    
    CALL myAllocate(iArr, "iArr", Npts)
    iArr(1:Npts) = gridPointer(1:Npts)
    
    CALL initializeIndex(Npts)
    CALL quickSortIndex(iArr, indx, 1, Npts)
    
    gridPointer(1:Npts) = indx(1:Npts)
    DO i=1,3
       iArr(1:Npts) = gridCoordinates(indx(1:Npts), i)
       gridCoordinates(1:Npts,i) = iArr(1:Npts)
    END DO
    
    DEALLOCATE(iArr)
    CALL destroyIndex
    
  END SUBROUTINE sortPoints
  
  
  SUBROUTINE findDuplicates
    
    USE GridMod, ONLY : Npts
    USE GridMod, ONLY : gridCoordinates, gridPointer
    
    IMPLICIT NONE
    
    INTEGER :: i, numUniquePts
    INTEGER, ALLOCATABLE :: tempGridPointer(:)
    
    CALL myAllocate( tempGridPointer, "tempGridPointer", Npts )
    tempGridPointer(:) = gridPointer(:)
    
    numUniquePts = 1
    gridPointer(tempGridPointer(1)) = numUniquePts
    
    DO i = 2, Npts
        IF ( ALL(gridCoordinates(i,1:3) == gridCoordinates(numUniquePts,1:3) ) ) THEN
            gridPointer(tempGridPointer(i)) = numUniquePts
        ELSE
            numUniquePts = numUniquePts + 1
            gridCoordinates(numUniquePts,1:3) = gridCoordinates(i,1:3)
            gridPointer(tempGridPointer(i)) = numUniquePts
        END IF
    END DO
    
    Npts = numUniquePts
    DEALLOCATE(tempGridPointer)
    
  END SUBROUTINE findDuplicates
  
  
  SUBROUTINE reduceNewPoints
    ! A symmetry reduction of the new grid points is now done
    USE SymmetriesMod, ONLY : G, nSym
    
    USE GridMod, ONLY : NIRpts, IRpts
    
    USE GridMod, ONLY : gridCoordinates, gridPointer, shift
    USE GridMod, ONLY : weights
    USE GridMod, ONLY : N1, N2, N3
    
    IMPLICIT NONE
    
    INTEGER :: i, j, k, trans(3), trans_tmp(3)
    INTEGER :: newPoint, lowestIndex, N
    INTEGER, ALLOCATABLE :: IRptsPointer(:), mappedPoints(:)
    INTEGER, ALLOCATABLE :: tempCoordinates(:,:)!!!!, tempWeights(:)
    DOUBLE PRECISION, ALLOCATABLE :: tempWeights(:)
    LOGICAL :: reducedFlag
    DOUBLE PRECISION :: oldWeightsSum, newWeightsSum
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered reduceNewPoints"
    
    CALL myAllocate(IRpts, "IRpts", Npts, 3) ! this is oversized for convenience
    CALL myAllocate(mappedPoints, "mappedPoints", nSym) ! for each k-point this holds the symmetry mapped points
    CALL myAllocate(IRptsPointer, "IRptsPointer", Npts) ! holds the index of the irreducible point
    
    NIRpts = 1
    IRpts(NIRpts,1:3) = gridCoordinates(1,1:3)
    IRptsPointer(NIRpts) =  IRpts(NIRpts,3) + N3*IRpts(NIRpts,2) + N2*N3*IRpts(NIRpts,1) + 1
    gridPointer(1) = 1
    
    oldWeightsSum = SUM(weights(:))
    
    DO i= 2, Npts
       N = gridCoordinates(i,3) + N3*gridCoordinates(i,2) + N2*N3*gridCoordinates(i,1) + 1
       ! WRITE(*,*) "*", i, gridCoordinates(i,1), gridCoordinates(i,2), gridCoordinates(i,3)
       reducedFlag = .FALSE.
       ! Loop over symmetry matrices
       DO j= 1, nSym
          ! Transform grid point i with symmetry matrix j
          trans = MATMUL( G(j)%el, gridCoordinates(i,1:3))
          trans_tmp(1:3) = trans(1:3)
          
          ! Shift the transformed point back into the primitive cell
          CALL shift( trans )
          
          ! Determine the index of this new point
          mappedPoints(j) = trans(3) + N3*trans(2) + N2*N3*trans(1) + 1
          
          !IF (61==N .AND. 11==mappedPoints(j)) THEN
          !   WRITE(*,*) "N = ", N
          !   WRITE(*,*) G(j)
          !   WRITE(*,*) " "
          !   WRITE(*,*) "orig: ", gridCoordinates(i,1:3)
          !   WRITE(*,*) "trtp: ", trans_tmp(1:3)
          !   WRITE(*,*) "tran: ", trans(1:3)
          !   WRITE(*,*) "mapd: ", mappedPoints(j)
          !   WRITE(*,*) " "
          !END IF
          
       END DO
       lowestIndex = MINVAL(mappedPoints)
       
       IF (lowestIndex.LT.N) THEN
          IF (NIRpts .GE. N) STOP 'ERROR: Contact developers.'
          DO j = 1, NIRpts
             DO k=1,nSym ! new
                IF (mappedPoints(k).EQ.IRptsPointer(j)) THEN ! new
!!!!              IF (lowestIndex.EQ.IRptsPointer(j)) THEN
                   weights(j) = weights(j) + weights(i)
                   weights(i) = 0.d0
                   gridPointer(i) = j
                   reducedFlag = .TRUE.
                   EXIT
!!!!              END IF
                END IF
             END DO
          END DO
       ELSE
          NIRpts = NIRpts + 1
          IRpts(NIRpts,1:3) = gridCoordinates(i,1:3)
          IRptsPointer(NIRpts) =  IRpts(NIRpts,3) + N3*IRpts(NIRpts,2) + N2*N3*IRpts(NIRpts,1) + 1
          gridPointer(i) = NIRpts
          weights(NIRpts) = weights(i)
          IF (i.NE.NIRpts) weights(i) = 0.d0
          reducedFlag = .TRUE.
       END IF
       
       IF (.NOT. reducedFlag) THEN
          IF (passNumber .EQ. 0) STOP 'ERROR: Contact developers.'
          !################  Warning message ###################
          IF (passNumber .NE. 0) THEN
             WRITE(*,*) ""
             WRITE(*,*) "     WARNING"
             WRITE(*,*) "     N = ", N
!!!             WRITE(*,*) "     lowest index = ", lowestIndex
!!!             WRITE(*,*) "     Point is ", gridCoordinates(i,1:3)
!!!             WRITE(*,*) "     Are you sure you want this to happen?"
!!!             WRITE(*,*) "     This warning usually occurs when you have selected only a"
!!!             WRITE(*,*) "     subset of equivalent BZ regions are selected for refinement."
!!!             WRITE(*,*) "     If you are sure you want to proceed just push Enter to"
!!!             WRITE(*,*) "     continue.  Good luck."
             WRITE(*,*) ""
!!!             PAUSE
          END IF
          !!####################################################
          NIRpts = NIRpts + 1
          IRpts(NIRpts,1:3) = gridCoordinates(i,1:3)
          IRptsPointer(NIRpts) =  IRpts(NIRpts,3) + N3*IRpts(NIRpts,2) + N2*N3*IRpts(NIRpts,1) + 1
          gridPointer(i) = NIRpts
          weights(NIRpts) = weights(i)
          IF (i.NE.NIRpts) weights(i) = 0.d0
       END IF
       
       newWeightsSum = SUM(weights(:))
       
       IF (ABS(oldWeightsSum-newWeightsSum).GT.1.0d-8) THEN
          WRITE(*,*) "ERROR: Internal check on weights failed"
          WRITE(*,*) "Contact developers"
          WRITE(*,*) i, oldWeightsSum, newWeightsSum
          STOP
       END IF
    END DO
    
    DEALLOCATE(IRptsPointer)
    DEALLOCATE(mappedPoints)
    
    CALL myAllocate(tempWeights, "tempWeights", NIRpts)
    tempWeights(1:NIRpts) = weights(1:NIRpts)

    DEALLOCATE(weights)    
    CALL myAllocate(weights, "weights", NIRpts)
    weights(1:NIRpts) = tempWeights(1:NIRpts)
    DEALLOCATE(tempWeights)
    
    WRITE(*,*) "weights: ", SUM(weights(:))
    
    CALL myAllocate(tempCoordinates, "tempCoordinates", NIRpts, 3)
    tempCoordinates(1:NIRpts,1:3) = IRpts(1:NIRpts,1:3)
    DEALLOCATE(IRpts)
    
    CALL myAllocate(IRpts, "IRpts", NIRpts, 3)
    IRpts(1:NIRpts,1:3) = tempCoordinates(1:NIRpts,1:3)
    DEALLOCATE(tempCoordinates)
    
  END SUBROUTINE reduceNewPoints
  
END MODULE NextPassMod
