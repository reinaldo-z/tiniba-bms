! This file contains the subroutines:
! - getIRtet
! - sortTetrahedra
! - getTet
! - checks

SUBROUTINE getIRtet ()
  ! Divide each primitive cell of the submesh into 6 equal
  ! volume tetrahedra, using the shortest main diagonal as a
  ! common edge of all 6, write the corners in terms of the
  ! irreducible points.  Put the corners in ascending order,
  ! then compare tetrahedra to find an irreducible set.
  
  USE DebugMod, ONLY : debug
  
  USE NextPassMod, ONLY : passNumber
  
  USE GridMod, ONLY : N1, N2, N3
  USE GridMod, ONLY : IRtet
  USE GridMod, ONLY : IRtetPassInfo
  USE GridMod, ONLY : tetrahedronMultiplicity
  USE GridMod, ONLY : NIRtet
  USE GridMod, ONLY : Ncubes
  USE GridMod, ONLY : cubes
  USE GridMod, ONLY : gridPointer
  USE GridMod, ONLY : cubeLevel
  
  USE MyAllocateMod, ONLY : myAllocate
  
  IMPLICIT NONE
  
  ! Local variables
  INTEGER :: i, tetCounter
  
  INTEGER :: TET(4,6)
  INTEGER :: istat
  INTEGER :: numberReducibleTetrahedra
  INTEGER, ALLOCATABLE :: redTet(:,:)  ! reducible Tetrahedra
  INTEGER, ALLOCATABLE :: redTetPassInfo(:)
  INTEGER, ALLOCATABLE :: redTetMult(:)
  INTEGER :: cubeCorners(8)
  DOUBLE PRECISION :: BZ_vol_check
  
  IF ( debug ) WRITE(*,*) "Program Flow: Entered getIRtet"
  
  !Set array dimensions for tetrahedra reduction
  numberReducibleTetrahedra = Ncubes*6
  
  CALL myAllocate( redTet, "redTet", numberReducibleTetrahedra, 4)
  CALL myAllocate( redTetPassInfo, "tetPassInfo", numberReducibleTetrahedra)
  
  tetCounter = 1
  ! Loop over submesh cells
  DO i = 1, Ncubes
     ! Define the tetrahedra
     cubeCorners(1:8) = cubes(i,1:8)
     CALL getTET (cubeCorners(1:8), TET(1:4,1:6))
     redTet(tetCounter:tetCounter+5,1:4) = TRANSPOSE(TET(1:4,1:6))
     redTetPassInfo(tetCounter:tetCounter+5) = cubeLevel(i)
     tetCounter = tetCounter + 6
  END DO
  
  ! First sort tetrahedra, then compare.  Also sort the pass info.
  CALL sortTetrahedra(redTet, redTetPassInfo, numberReducibleTetrahedra)
  
  ! Check that the elements are properly sorted
  CALL checks ( redTet, numberReducibleTetrahedra )
  
  CALL myAllocate( redTetMult, "redTetMult", numberReducibleTetrahedra)
  redTetMult(1:numberReducibleTetrahedra) = 0
  TET(1:4,1:6) = 0
  
  tetCounter = 1
  TET(1:4,1) = redTet(tetCounter,1:4)
  redTetMult(tetCounter) = 1
  NIRtet = 1
  
  BZ_vol_check = 1.d0/((N1-1)*(N2-1)*(N3-1)*6.d0)*(8.d0)**(passNumber - redTetPassInfo(1))
  
  ! This loop finds the irreducible tetrahedra, and counts them
  DO i=2, numberReducibleTetrahedra
     
     ! keep a running total of the net volume of the tetrahedra
     BZ_vol_check = BZ_vol_check + 1.d0/((N1-1)*(N2-1)*(N3-1)*6.d0)*(8.d0)**(passNumber - redTetPassInfo(i))
     
     IF ( ALL(redTet(i,1:4)==TET(1:4,1)) ) THEN
        ! then tetrahedra i is reducible
        redTetMult(tetCounter) = redTetMult(tetCounter) + 1
        
        ! check that the passlevelinfo is the same for all equivalent tetrahedra
        IF (redTetPassInfo(i) .NE. redTetPassInfo(tetCounter)) THEN
           WRITE(*,*) "ERROR: "
           WRITE(*,*) "redTetPassInfo(i) NOT EQUAL TO redTetPassInfo(tetCounter)"
           WRITE(*,*) "i = ", i, " tetCounter = ", tetCounter
           STOP
        END IF
     ELSE
        tetCounter = i
        NIRtet = NIRtet + 1
        redTetMult(tetCounter) = 1
        TET(1:4,1) = redTet(i,1:4)
     END IF
  END DO
  
  IF (debug) WRITE(*,*) "In getIRtet SUM(redTetMult) = ", SUM(redTetMult)
  
  ! NIRtet is now the number of irreducible tetrahedra
  
!!! Write out BZ_vol_check
  WRITE(*,*) "In getIRtet.f90 BZ_vol_check = ", BZ_vol_check
  BZ_vol_check = 0.d0
  
!!! Now collect only the irreducible tetrahedra into IRtet
  CALL myAllocate( IRtet, "IRtet", 4, NIRtet )
  CALL myAllocate( IRtetPassInfo, "tetPassInfo", NIRtet)
  
!!! Note that the dimension of IRtet are transposed from redTet!!
  CALL myAllocate( tetrahedronMultiplicity, "tetrahedronMultiplicity", NIRtet)
  
  tetCounter = 0
  DO i = 1, numberReducibleTetrahedra
     IF (redTetMult(i) .NE. 0) THEN
        ! i represents an irreducible tetrahedron
        tetCounter = tetCounter + 1
        IRtet(1:4,tetCounter) = redTet(i,1:4)
        tetrahedronMultiplicity(tetCounter) = redTetMult(i)
        IRtetPassInfo(tetCounter) = redTetPassInfo(i)
     END IF
  END DO
  
  IF (debug) WRITE(*,*) "In getIRtet SUM(redTetMult) = ", SUM(tetrahedronMultiplicity)
  
  IF (tetCounter.NE.NIRtet) THEN
     WRITE(*,*) " "
     WRITE(*,*) "The generated tetrahedra have an error."
     WRITE(*,*) " "
     STOP 'Consistency check on nmumber of tetrahedra generated failed.'
  END IF
  
  DEALLOCATE (redTet)
  DEALLOCATE (redTetMult)
  
END SUBROUTINE getIRtet

SUBROUTINE sortTetrahedra(mArr,mArrLevelInfo,M)
  
  USE DebugMod, ONLY : debug
  
  USE SortingMod, ONLY : indx, initializeIndex, destroyIndex
  USE SortingMod, ONLY : quickSortIndex, partitionIndex
  
  !
  ! The tetrahedra are a collection of M quartets of integers.
  ! Each tetrahedra is supposed to be ordered from left to right
  ! allready.
  ! For example, if M=5, we could have something like
  !  1  3  4  4
  !  1  3  3  4
  !  3  4  5  6
  !  3  3  4  5
  !  1  2  3  4
  ! as input.  Note that within each row the numbers are in
  ! ascending order.
  !
  ! The subroutine orders these tetrahedra in a simple way, so
  ! that they can be reduced later.
  !
  ! The subroutine first orders the quartets by the first integer.
  ! So, with the above exmaple, the array becomes
  !  1  3  4  4
  !  1  3  3  4
  !  1  2  3  4
  !  3  4  5  6
  !  3  3  4  5
  !
  ! The subroutine then only rearranges the subgroups that have the
  ! same first integer.  There are two such subgroups in our example.
  ! The ordering is on the second integer.  For our example, this gives
  !  1  2  3  4
  !  1  3  4  4
  !  1  3  3  4
  !  3  3  4  5
  !  3  4  5  6
  !
  ! This ordering is done for the third and fourth columns, making
  ! sure that all the integers to left are the same.  For the
  ! example, this finally gives
  !  1  2  3  4
  !  1  3  3  4
  !  1  3  4  4
  !  3  3  4  5
  !  3  4  5  6
  !
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: M
  INTEGER, INTENT(INOUT) :: mArr(M,4), mArrLevelInfo(M)
!!!  M  --> numberReducibleTetrahedra
!!!  mArr(M,4) -->  redTet( numberReducibleTetrahedra, 4 )
!!!  mArrLevelInfo(M) --> redTetLevelInfo( numberReducibleTetrahedra )
  INTEGER, ALLOCATABLE :: iArr(:)
  INTEGER, ALLOCATABLE :: jArr(:)
  INTEGER, ALLOCATABLE :: subArray(:,:)
  REAL :: timing
  INTEGER :: iCount, lBound, uBound
  INTEGER :: i, j, iColumn
  INTEGER, ALLOCATABLE :: iTmp(:)
  LOGICAL :: sortFlag
  
  sortFlag = .false.
  IF ( debug ) THEN
     CALL cpu_time(timing)
     WRITE(*,*) "Starting tetrahedra sorting:"
     WRITE(*,*) "Start time:", timing
  END IF
  
  CALL initializeIndex(M)
  
  ALLOCATE(iArr(M))
  iArr(1:M) = mArr(1:M,1)
  
  ALLOCATE(jArr(M))
  
  CALL quickSortIndex( iArr, indx, 1, M)
  
  IF ( debug ) THEN
     CALL cpu_time(timing)
     WRITE(*,*) "End time:", timing
     WRITE(*,*) "Tetrahedra sorted:", M
  END IF
  
  ! Now that iArr is arranged, and we have an indx, rearrange
  ! the entries of mArr
  mArr(:,1) = iArr(:)
  DO i=2,4
     iArr(:) = mArr(indx(:), i)
     mArr(:,i) = iArr(:)
  END DO
  
  ! And rearrange the second array
  jArr(:) = mArrLevelInfo(indx(:))
  mArrLevelInfo(:) = jArr(:)
  
  DEALLOCATE( iArr )
  DEALLOCATE( jArr )
  CALL destroyIndex
  
  ! Now sort each subset of the array (the subset that has the
  ! same first column) by the second column, and so on.
  
  DO iColumn = 1, 3
     
     ALLOCATE(iTmp(1:iColumn))
     iTmp(1:iColumn) = mArr(1,1:iColumn)
     iCount = 1 ! counts how many elements need to be sorted
     lBound = 1
     DO i=2, M
        
        ! Check that all elements to the left of the column
        ! we want to sort on are the same
        
        IF (ALL(mArr(i,1:iColumn)==iTmp(1:iColumn))) THEN
           
           iCount = iCount + 1
           sortFlag = .false.
           
        ELSE
            
           sortFlag = .true.
           
        END IF
        
        IF (i.EQ.M) THEN
           ! Make sure we sort if we reach the last element
           
           sortFlag = .true.
           
        END IF
        
        IF (sortFlag) THEN
           ! The index mArr(i,iColumn) is different than mArr(i-1,iColumn).
           ! The array we want to sort goes from lBound to i-1.
           ! We sort the list on the second entry.
           IF ( iCount .EQ. 1) THEN
              ! there is only one element.  No need to sort.
           ELSE IF (iCount .GT. 1) THEN
              ! Allocate a temporary array, subArray, of
              ! size iCount*(4-iColumn)
              ALLOCATE( subArray(1:iCount,1:4-iColumn) )
              
              ! Allocate and initialize the indexing array
              CALL initializeIndex(iCount)
              
              ! Transfer the required elements into subArray
              uBound = lBound + iCount - 1
              subArray(1:iCount, 1:4-iColumn) = mArr(lBound:uBound,iColumn+1:4)
              
              ! Sort the array on the first entry
              ALLOCATE(iArr(iCount))
              ALLOCATE(jArr(iCount))
              iArr(1:iCount) = subArray(1:iCount,1)
              CALL quickSortIndex(iArr, indx, 1, SIZE(iArr) )
              
              ! Now that we have the indx rearrange the entries
              subArray(1:iCount,1) = iArr(1:iCount)
              DO j=2, 4-iColumn
                 iArr(:) = subArray(indx(:), j)
                 subArray(:,j) = iArr(:)
              END DO
              
              jArr(:) = mArrLevelInfo(lBound:uBound)
              mArrLevelInfo(lBound:uBound) = jArr(indx(:))
              
              DEALLOCATE( iArr )
              DEALLOCATE( jArr )
              CALL destroyIndex
              ! Sub array is now sorted. Merge subArray back
              ! into the full array
              mArr(lBound:uBound, iColumn+1:4) = subArray(1:iCount,1:4-iColumn)
              
              DEALLOCATE( subArray )
              
           ELSE
              ! there is something wrong
              STOP 'Unexpected error when sorting tetrahedra.'
           END IF
           
           ! Reset counter
           iCount = 1
           
           ! Reset iTmp
           iTmp = mArr(i,1:iColumn)
           
           ! Reset lower bound lBound
           lBound = i
           
        END IF
     END DO
     
     DEALLOCATE( iTmp )
     
  END DO
  
END SUBROUTINE sortTetrahedra

!Divide a submesh cell into 6 equal volume tetrahedra, using
!the shortest main diagonal as a common edge of all 6.  Write
!tetrahedra corners in terms of irreducible k-points and put in
!ascending order with respect to index.
SUBROUTINE getTET (CORN, TET)
  
  USE DebugMod, ONLY : debug
  USE LatticeMod, ONLY : cell_type
  USE GridMod, ONLY : gridPointer
  USE SortingMod, ONLY : quickSort
  IMPLICIT NONE
  
  !Calling arguments
  INTEGER, INTENT(IN) :: CORN(8)
  INTEGER, INTENT(OUT) :: TET(4,6)
  
  ! IF (debug) WRITE(*,*) "(Program Flow): Entered getTET"
  
  !Case: (0,1,0) -> (1,0,1) diagonal shortest
  IF (cell_type == 1) THEN
     
     TET(1,1) = gridPointer( CORN(2) )
     TET(2,1) = gridPointer( CORN(3) )
     TET(3,1) = gridPointer( CORN(4) )
     TET(4,1) = gridPointer( CORN(6) )
     CALL quickSort (TET(1:4,1),1,4)
     
     TET(1,2) = gridPointer( CORN(1) )
     TET(2,2) = gridPointer( CORN(3) )
     TET(3,2) = gridPointer( CORN(5) )
     TET(4,2) = gridPointer( CORN(6) )
     CALL quickSort (TET(1:4,2),1,4)
     
     TET(1,3) = gridPointer( CORN(1) )
     TET(2,3) = gridPointer( CORN(2) )
     TET(3,3) = gridPointer( CORN(3) )
     TET(4,3) = gridPointer( CORN(6) )
     CALL quickSort (TET(1:4,3),1,4)
     
     TET(1,4) = gridPointer( CORN(3) )
     TET(2,4) = gridPointer( CORN(4) )
     TET(3,4) = gridPointer( CORN(6) )
     TET(4,4) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,4),1,4)
     
     TET(1,5) = gridPointer( CORN(3) )
     TET(2,5) = gridPointer( CORN(5) )
     TET(3,5) = gridPointer( CORN(6) )
     TET(4,5) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,5),1,4)
     
     TET(1,6) = gridPointer( CORN(3) )
     TET(2,6) = gridPointer( CORN(6) )
     TET(3,6) = gridPointer( CORN(7) )
     TET(4,6) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,6),1,4)
     
     !Case: (0,0,0) -> (1,1,1) diagonal shortest
  ELSE IF (cell_type == 2) THEN
     
     TET(1,1) = gridPointer( CORN(1) )
     TET(2,1) = gridPointer( CORN(2) )
     TET(3,1) = gridPointer( CORN(6) )
     TET(4,1) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,1),1,4)
     
     TET(1,2) = gridPointer( CORN(1) )
     TET(2,2) = gridPointer( CORN(5) )
     TET(3,2) = gridPointer( CORN(7) )
     TET(4,2) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,2),1,4)
     
     TET(1,3) = gridPointer( CORN(1) )
     TET(2,3) = gridPointer( CORN(5) )
     TET(3,3) = gridPointer( CORN(6) )
     TET(4,3) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,3),1,4)
     
     TET(1,4) = gridPointer( CORN(1) )
     TET(2,4) = gridPointer( CORN(2) )
     TET(3,4) = gridPointer( CORN(4) )
     TET(4,4) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,4),1,4)
     
     TET(1,5) = gridPointer( CORN(1) )
     TET(2,5) = gridPointer( CORN(3) )
     TET(3,5) = gridPointer( CORN(7) )
     TET(4,5) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,5),1,4)
     
     TET(1,6) = gridPointer( CORN(1) )
     TET(2,6) = gridPointer( CORN(3) )
     TET(3,6) = gridPointer( CORN(4) )
     TET(4,6) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,6),1,4)
     
     !Case: (1,1,0) -> (0,0,1) diagonal shortest
  ELSE IF (cell_type == 3) THEN
     
     TET(1,1) = gridPointer( CORN(2) )
     TET(2,1) = gridPointer( CORN(6) )
     TET(3,1) = gridPointer( CORN(7) )
     TET(4,1) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,1),1,4)
     
     TET(1,2) = gridPointer( CORN(1) )
     TET(2,2) = gridPointer( CORN(2) )
     TET(3,2) = gridPointer( CORN(5) )
     TET(4,2) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,2),1,4)
     
     TET(1,3) = gridPointer( CORN(2) )
     TET(2,3) = gridPointer( CORN(5) )
     TET(3,3) = gridPointer( CORN(6) )
     TET(4,3) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,3),1,4)
     
     TET(1,4) = gridPointer( CORN(2) )
     TET(2,4) = gridPointer( CORN(4) )
     TET(3,4) = gridPointer( CORN(7) )
     TET(4,4) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,4),1,4)
     
     TET(1,5) = gridPointer( CORN(1) )
     TET(2,5) = gridPointer( CORN(2) )
     TET(3,5) = gridPointer( CORN(3) )
     TET(4,5) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,5),1,4)
     
     TET(1,6) = gridPointer( CORN(2) )
     TET(2,6) = gridPointer( CORN(3) )
     TET(3,6) = gridPointer( CORN(4) )
     TET(4,6) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,6),1,4)
     
     !Case: (1,0,0) -> (0,1,1) diagonal shortest
  ELSE IF (cell_type == 4) THEN
     
     TET(1,1) = gridPointer( CORN(2) )
     TET(2,1) = gridPointer( CORN(4) )
     TET(3,1) = gridPointer( CORN(5) )
     TET(4,1) = gridPointer( CORN(6) )
     CALL quickSort (TET(1:4,1),1,4)
     
     TET(1,2) = gridPointer( CORN(1) )
     TET(2,2) = gridPointer( CORN(3) )
     TET(3,2) = gridPointer( CORN(4) )
     TET(4,2) = gridPointer( CORN(5) )
     CALL quickSort (TET(1:4,2),1,4)
     
     TET(1,3) = gridPointer( CORN(1) )
     TET(2,3) = gridPointer( CORN(2) )
     TET(3,3) = gridPointer( CORN(4) )
     TET(4,3) = gridPointer( CORN(5) )
     CALL quickSort (TET(1:4,3),1,4)
     
     TET(1,4) = gridPointer( CORN(4) )
     TET(2,4) = gridPointer( CORN(5) )
     TET(3,4) = gridPointer( CORN(6) )
     TET(4,4) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,4),1,4)
     
     TET(1,5) = gridPointer( CORN(3) )
     TET(2,5) = gridPointer( CORN(4) )
     TET(3,5) = gridPointer( CORN(5) )
     TET(4,5) = gridPointer( CORN(7) )
     CALL quickSort (TET(1:4,5),1,4)
     
     TET(1,6) = gridPointer( CORN(4) )
     TET(2,6) = gridPointer( CORN(5) )
     TET(3,6) = gridPointer( CORN(7) )
     TET(4,6) = gridPointer( CORN(8) )
     CALL quickSort (TET(1:4,6),1,4)
     
  END IF
  
END SUBROUTINE getTET


SUBROUTINE checks ( redTet, numberReducibleTetrahedra )
  
  USE DebugMod, ONLY : debug
  
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: numberReducibleTetrahedra
  INTEGER, INTENT(INOUT) :: redTet(numberReducibleTetrahedra,4)
  INTEGER :: j
  LOGICAL :: oneLEtwo, twoLEthree, threeLEfour
  
  DO j=1, numberReducibleTetrahedra
     
     IF ( ALL(redTet(j,1:4)==(/0,0,0,0/)) ) THEN
        WRITE(*,*) "Tetrahedra ", j, " set to zero. Incorrect."
        STOP "Tetrahedra set to zero for unknown reason."
     END IF
     
     oneLEtwo    = (redTet(j,1).LE.redTet(j,2))
     twoLEthree  = (redTet(j,2).LE.redTet(j,3))
     threeLEfour = (redTet(j,3).LE.redTet(j,4))
     IF ( (oneLEtwo.AND.twoLEthree).AND.threeLEfour ) THEN
        !! OK
     ELSE
        WRITE(*,*) " "
        WRITE(*,*) "     PROBLEM with tetrahderon", j
        WRITE(*,*) redTet(j,1:4)
        STOP "Tetrahedron not properly ordered"
     END IF
  END DO
  IF (debug) WRITE(*,*) "First check passed"
  
!!! Count irreducible tetrahedra
  
  DO j=1,numberReducibleTetrahedra - 1
     IF ( redTet(j,1).GT.redTet(j+1,1) ) THEN
        WRITE(*,*) "Problem with tetrahedron order"
        STOP "error"
     ELSE IF ( redTet(j,1).EQ.redTet(j+1,1) ) THEN
!!! Check other entries
        IF ( redTet(j,2).GT.redTet(j+1,2) ) THEN
           WRITE(*,*) "Problem with tetrahedron order"
           STOP "error"
        ELSE IF ( redTet(j,2).EQ.redTet(j+1,2) ) THEN
!!! Check other entries
           IF ( redTet(j,3).GT.redTet(j+1,3) ) THEN
              WRITE(*,*) "Problem with tetrahedron order"
              STOP "error"
           ELSE IF ( redTet(j,3).EQ.redTet(j+1,3) ) THEN
!!! Check other entries
              IF ( redTet(j,4).GT.redTet(j+1,4) ) THEN
                 WRITE(*,*) "Problem with tetrahedron order"
                 STOP "error"
              END IF
           END IF
        END IF
     END IF
  END DO
  
  IF (debug) WRITE(*,*) "Second check passed"
  
END SUBROUTINE checks
