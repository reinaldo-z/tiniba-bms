MODULE GridMod
!!! This module contains the variables and subroutines
!!! needed for working with the k-space grid
  
  USE DebugMod, ONLY : debug
  
  USE MyAllocateMod, ONLY : myAllocate
  
  IMPLICIT NONE
  
  ! N1, N2, and N3 are the grid dimensions.
  INTEGER :: N1, N2, N3
  
  ! NIRpts, Ncubes, and NIRtet are the number of irreducible points,
  ! irreducible tetrahedra and cubes.
  INTEGER :: NIRpts, Ncubes, NIRtet
  INTEGER :: Npts
  
  ! IRpts holds the irreducible points
  INTEGER, ALLOCATABLE :: IRpts(:,:)
  
  ! cubes hold the cubes, cubeLevel holds the pass from which the cube came
  INTEGER, ALLOCATABLE :: cubes(:,:)
  INTEGER, ALLOCATABLE :: cubeLevel(:)
  
  INTEGER, ALLOCATABLE :: IRtet(:,:) !Holds irreducible tetrahedra
  INTEGER, ALLOCATABLE :: tetrahedronMultiplicity(:) ! Holds irreducible tetrahedra multiplicities
  INTEGER, ALLOCATABLE :: IRtetPassInfo(:)
  
  ! Ndiv(1:3) is the number of divisions along each reciprocal
  ! lattice vector.  In firstPass it is (/N1-1, N2-1, N3-1/)
  INTEGER :: Ndiv(1:3)
  
  ! gridPointer holds the map between grid points and irreducible points
  INTEGER, ALLOCATABLE :: gridPointer(:)
  
  ! gridCoordinates holds the grid points for the entire mesh over
  ! the BZ.
  INTEGER, ALLOCATABLE :: gridCoordinates(:,:)
  
  ! weights holds the weight of each kpoint.  This is first
  ! allocated to the size of the entire reducable grid array
  ! Later, it is reduced to just the irreducible kpoints, and
  ! the weights are combined to give an effective weight.
  DOUBLE PRECISION, ALLOCATABLE :: weights(:)
  DOUBLE PRECISION, ALLOCATABLE :: reducibleWeights(:)
  
  ! logical irreducible is a flag that tells you whether a kpoint
  ! is reducible or not.  If it is true, then it is irreducible.
  LOGICAL, ALLOCATABLE :: irreducible(:)
  
CONTAINS
  
  SUBROUTINE calculateGridDivisions
    USE LatticeMod, ONLY : b1, b2, b3
    INTEGER :: nDivTotal
    DOUBLE PRECISION :: L1, L2, L3
    
    WRITE(*,*) "How many k-points do you want throughout the cell?"
    READ(*,*) nDivTotal
    
    L1 = SQRT (b1(1)**2 + b1(2)**2 + b1(3)**2)
    L2 = SQRT (b2(1)**2 + b2(2)**2 + b2(3)**2)
    L3 = SQRT (b3(1)**2 + b3(2)**2 + b3(3)**2)
    
    IF (debug) THEN
       WRITE(*,*) L1, L2, L3
       
       WRITE(*,*) (L1**2/(L2*L3)*REAL(nDivTotal))**(1.d0/3.d0)
       WRITE(*,*) (L2**2/(L1*L3)*REAL(nDivTotal))**(1.d0/3.d0)
       WRITE(*,*) (L3**2/(L1*L3)*REAL(nDivTotal))**(1.d0/3.d0)
    END IF
    
    N1 = 1 + INT ((L1**2/(L2*L3)*REAL(nDivTotal))**(1.d0/3.d0) + 1.d-15)
    N2 = 1 + INT ((L2**2/(L1*L3)*REAL(nDivTotal))**(1.d0/3.d0) + 1.d-15)
    N3 = 1 + INT ((L3**2/(L1*L2)*REAL(nDivTotal))**(1.d0/3.d0) + 1.d-15)
    
    WRITE(*,*) "N1 N2 N3 are:", N1, N2, N3
    
  END SUBROUTINE calculateGridDivisions
  
  SUBROUTINE checkGridDivisions ()
    ! Check symmetries and grid dimensions to ensure that satisfy
    ! the conditions outlined in the documentation
    
    ! Checks the following cases
    ! N1 .ne. N2 . ne. N3
    ! N1 .eq. N2 . ne. N3
    ! N1 .eq. N3 . ne. N2
    ! N2 .eq. N3 . ne. N1
    
    USE SymmetriesMod, ONLY : G, nSym
    
    IMPLICIT NONE
    
    ! Local variables.
    REAL :: M(3,3)
    ! Nprob counts the number of problem matrices.
    INTEGER :: i, j, k, Nprob
    
    ! bad(NSym) Holds the problem matrices.
    INTEGER, DIMENSION(nSym) :: bad
    
    ! logical PROBLEM will be false unless a conflict between
    ! matrices and grid dimensions is found.
    LOGICAL :: exitFlag, PROBLEM
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered checkDIMENSIONS"
    
    PROBLEM = .TRUE.
    Nprob = 0
    
    IF ((N1 .EQ. N2) .AND. (N1.EQ.N3) .AND. (N2.EQ.N3)) THEN
       PROBLEM = .FALSE.
       IF ( debug ) WRITE(*,*) "Program Flow: check on N1 N2 N3 not needed"
    END IF
    
    ! Case N1, N2, N3 all different
    IF ( N1 /= N2 .AND. N1 /= N3 .AND. N2 /= N3 ) THEN
       ! In this case the symmetry matrix must be diagonal
       
       ! Loop over the symmetry matrices
       DO i = 1, NSym
          
          exitFlag = .FALSE.
          
          ! loop over the symmetry matrix elements
          DO j = 1, 3
             DO k = 1, 3
                
                ! If the matrix is not diagonal add it to the list
                ! of problem matrices
                IF (j /= k .AND. G(i)%el(j,k) /= 0) THEN
                   ! then off-diagonal compnent is nonzero
                   Nprob = Nprob + 1
                   bad(Nprob) = i
                   exitFlag = .TRUE.
                   EXIT
                END IF
                
             END DO
             
             IF (exitFlag) EXIT
             
          END DO
       END DO
       
       ! If problem matrices have been found print them out
       IF ( Nprob > 0 ) THEN
          WRITE(*,*) "N1, N2, and N3 cannot all be different because"//&
               "the following matrices are not diagonal:"
          DO i = 1, Nprob
             WRITE(*,*) bad(i)
          END DO
          PROBLEM = .TRUE.
       ELSE
          PROBLEM = .FALSE.
       END IF
    END IF
    
    Nprob = 0
    
    ! Case N1 = N2 /= N3
    IF (N1 == N2 .AND. N1 /= N3) THEN
       
       ! Loop over the symmetry matrices
       DO i = 1, NSym
          M = G(i)%el
          
          ! If the matrix is not block diagonal add it to
          ! list of problem matrices
          IF ( M(1,3) /= 0 .OR. M(2,3) /= 0 .OR. &
               M(3,1) /= 0 .OR. M(3,2) /= 0 ) THEN
             Nprob = Nprob + 1
             bad(Nprob) = i
          END IF
          
       END DO
       
       !If problem matrices have been found print them out.
       IF ( Nprob > 0 ) THEN
          WRITE(*,*) "Cannot have N1 = N2 /= N3 because of symmetries:"
          DO i = 1, Nprob
             WRITE(*,*) bad(i)
          END DO
          PROBLEM = .TRUE.
       ELSE
          PROBLEM = .FALSE.
       END IF
    END IF
    
    Nprob = 0
    
    !Case N1 = N3 /= N2
    IF ( N1 == N3 .AND. N1 /= N2 ) THEN
       
       !Loop over symmetry matrices
       DO i = 1, NSym
          M = G(i)%el
          
          !If the matrix is not block diagonal add it to list of problem matrices
          IF ( M(1,2) /= 0 .OR. M(2,1) /= 0 .OR. &
               M(2,3) /= 0 .OR. M(3,2) /= 0 ) THEN
             Nprob = Nprob + 1
             bad(Nprob) = i
          END IF
          
       END DO
       
       !If problem matrices have been found print them out.
       IF ( Nprob > 0 ) THEN
          WRITE(*,*) "Cannot have N1 = N3 /= N2 because of symmetries:"
          DO i = 1, Nprob
             WRITE(*,*) bad(i)
          END DO
          PROBLEM = .TRUE.
       ELSE
          PROBLEM = .FALSE.
       END IF
       
    END IF
    
    Nprob = 0
    
    !Case N2 = N3 /= N1
    IF ( N2 == N3 .AND. N1 /= N3 ) THEN
       
       !Loop over symmetry matrices
       DO i = 1, NSym
          M = G(i)%el
          
          !If the matrix is not block diagonal add it to list of problem matrices
          IF ( M(1,2) /= 0 .OR. M(1,3) /= 0 .OR. &
               M(2,1) /= 0 .OR. M(3,1) /= 0 ) THEN
             Nprob = Nprob + 1
             bad(Nprob) = i
          END IF
          
       END DO
       
       !If problem matrices have been found print them out.
       IF ( Nprob > 0 ) THEN
          WRITE(*,*) "Cannot have N2 = N3 /= N1 because of symmetries:"
          DO i = 1, Nprob
             WRITE(*,*) bad(i)
          END DO
          PROBLEM = .TRUE.
       ELSE
          PROBLEM = .FALSE.
       END IF
       
    END IF
    
    !If conflicts have been found: stop the program
    IF ( PROBLEM) THEN
       WRITE(*,*) ""
       WRITE(*,*) " A problem has been found with the choice of (N1, N2, N3)"
       WRITE(*,*) " If the above error message is not understandable, please"
       WRITE(*,*) " contact developers."
       WRITE(*,*) ""
    END IF
    IF ( PROBLEM ) STOP 'Problem in checkDimensions'
    
  END SUBROUTINE checkGridDivisions
  
  SUBROUTINE initializeGrid
    
    IMPLICIT NONE
    INTEGER :: i, j, k, M, p
    INTEGER :: cubeIndex
    INTEGER :: iostatus
    CHARACTER(LEN=6) :: cubesfilename
    
    IF (debug) WRITE(*,*) "Program Flow: Entered initializeGrid"
    
    Npts = N1*N2*N3
    Ndiv(1) = N1-1
    Ndiv(2) = N2-1
    Ndiv(3) = N3-1
    
    ! Allocate necesseray arrays.  Set array dimensions for
    ! point reduction
    CALL myAllocate ( reducibleWeights, "reducibleWeights", Npts )
    
    CALL myAllocate ( irreducible, "irreducible", Npts )
    
    ! We initialize all the points as irreducible points.
    irreducible(:) = .TRUE.
    
    ! In subroutine transformGrid we find out which points are
    ! reducible.
    
    CALL myAllocate ( gridCoordinates, "gridCoordinates", Npts, 3 )
    
    ! Divide the k-space primitive cell into an N1 * N2 * N3 grid
    DO i = 0, Ndiv(1)
       DO j = 0, Ndiv(2)
          DO k = 0, Ndiv(3)
             M = k + (j * N3) + (i * N3 * N2) + 1  ! k-point index
             gridCoordinates(M,1:3) = (/i, j, k/)
          END DO
       END DO
    END DO
    
    ! Initialize pointer array: each point is associated with itself.
    ! Later, each point will be associated with an equivalent
    ! irreducible point.
    CALL myAllocate ( gridPointer, "gridPointer", Npts )
    
    DO i = 1, Npts
       gridPointer(i) = i
    END DO
    
    Ncubes = Ndiv(1)*Ndiv(2)*Ndiv(3)
    CALL myAllocate ( cubes, "cubes", Ncubes, 8 )
    CALL myAllocate ( cubeLevel, "cubeLevel", Ncubes)
    
    !cubesfilename = "cubes0"
    !IF ( debug ) WRITE(*,*) "File Control: Opening "//TRIM(cubesfilename)//" file to write."
    !OPEN (UNIT=14, FILE=cubesFilename, ACTION="WRITE", IOSTAT=iostatus)
    !IF (iostatus .NE. 0) THEN
    !   WRITE(*,*) "Could not open file: "//TRIM(cubesfilename)//".  Stopping"
    !   STOP 'Could not open file.  Stopping'
    !END IF
    !WRITE(14,*) Ncubes
    
    cubeIndex = 0
    DO i = 0, Ndiv(1)-1
       DO j = 0, Ndiv(2)-1
          DO k = 0, Ndiv(3)-1
             
             M = k + (j * N3) + (i * N3 * N2) + 1
             cubeIndex = cubeIndex + 1
             
             ! Define the corners of the cube
             cubes(cubeIndex, 1) = M
             cubes(cubeIndex, 2) = M + 1
             cubes(cubeIndex, 3) = M + N3
             cubes(cubeIndex, 4) = M + N3 + 1
             cubes(cubeIndex, 5) = M + N2*N3
             cubes(cubeIndex, 6) = M + N2*N3 + 1
             cubes(cubeIndex, 7) = M + N2*N3 + N3
             cubes(cubeIndex, 8) = M + N2*N3 + N3 + 1
             
             ! Write cubes
             ! WRITE(UNIT=14, FMT='(9I8)') cubes(cubeIndex, 1:8), cubeLevel(cubeIndex)
             
             ! Calculate weights
             DO p = 1, 8
                reducibleWeights( cubes(cubeIndex, p) ) = &
                            reducibleWeights( cubes(cubeIndex, p) ) + 0.125d0
             END DO
             
          END DO
       END DO
    END DO
    
    !IF ( debug ) WRITE(*,*) "File Control: Closing cubes file."
    !CLOSE(14)
    
  END SUBROUTINE initializeGrid
  
  SUBROUTINE transformGrid ()
    ! Use symmetry to map submesh onto itself, keeping track
    ! of the map in the array gridPointer
    USE SymmetriesMod, ONLY : nSym, G
    IMPLICIT NONE
    
    ! Local variables, TRANS holds a transformed k point
    INTEGER :: i, j, N, trans(3)
    INTEGER, ALLOCATABLE :: mappedPoint(:)
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered transformGrid"
    
    CALL myAllocate( mappedPoint, "mappedPoint", NSym )
    ! mappedPoint holds all the points a k-point is mapped to by
    ! each symmetry operation
    
    
    ! Loop over k-points
    
    DO i = 2, Npts
       ! Loop over symmetry matrices
       DO j = 1, NSym
          ! Transform grid point i with symmetry matrix j.
          trans = MATMUL( G(j)%el, gridCoordinates(i,1:3) )
          ! Shift the transformed vector back into the primitive cell.
          CALL shift(trans)
          ! Determine the index of this new point.
          N = trans(3) + ( trans(2) * N3 ) + ( trans(1) * N3 * N2 ) + 1
          ! Collect the star of kpoint i into mappedPoint.
          mappedPoint(j) = N
          ! One could exit the loop as soon as a related point
          ! is found, but this is a little cleaner.
       END DO
       ! Find the lowest index of all symmetry related points.
       N = MINVAL(mappedPoint)
       ! If the transformed point has an index lower than the original
       ! point we keep track of the map between these points and the
       ! first symmetry matrix that connects the two points.
       IF (N.LT.i) THEN
          ! The point i is said to be reducible to point N.
          irreducible(i) = .FALSE. ! i is reducible
          gridPointer(i) = gridPointer(N)
       END IF
    END DO
    DEALLOCATE ( mappedPoint )
    
    IF ( debug ) WRITE(*,*) "Program Flow: Exiting transformGrid"
    
  END SUBROUTINE transformGrid
  
  SUBROUTINE reduceGrid ()
    ! Find an irreducible set of k points
    IMPLICIT NONE
    
    ! Local variables
    INTEGER :: i, itmp
    INTEGER :: irrpntsCounter = 0
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered getIRpts"  !!!!! change this
    
    NIRpts = 0
    
    ! Find the number of irreducible points.
    DO i = 1, Npts
       IF (irreducible(i)) THEN
          NIRpts = NIRpts + 1
       END IF
    END DO
    
    CALL myAllocate ( IRpts, "IRpts", NIRpts, 3 )
    
    ! Loop over the k-points
    DO i = 1, Npts
       
       ! If the point was only mapped to itself then it is
       ! taken as an irreducible point
       IF (irreducible(i)) THEN
          ! Increase the number of irreducible points by 1
          irrpntsCounter = irrpntsCounter + 1
          gridPointer(i) = irrpntsCounter
       ELSE
          ! Renumber the map so that gridPointer now connects
          ! the original k point with the irreducible k point
          itmp = gridPointer(i)
          gridPointer(i) = gridPointer(itmp)
       END IF
       
    END DO
    
    DO i = 1, Npts
       ! For each irreducible point, we can chose from any of
       ! its "star of k-points".  To be consistent with Bloechl's
       ! original prescription, and the above, we use the following
       ! choice.
       IF (irreducible(i)) THEN
          IRpts(gridPointer(i), 1:3) = gridCoordinates(i,1:3)
       END IF
    END DO
    
    CALL myAllocate ( weights, "weights", NIRpts )
    
    DO i = 1, Npts
       ! Add the weights of the reducible point to the irreducible point.
       ! Reducible points can have different weights.
       weights(gridPointer(i)) = weights(gridPointer(i)) &
               + reducibleWeights(i)
    END DO

    DEALLOCATE ( reducibleWeights )
    DEALLOCATE ( irreducible )
    
  END SUBROUTINE reduceGrid
  
  SUBROUTINE shift (vec)
    ! Shifts a vector back into the primitive cell
    IMPLICIT NONE
    
    ! Calling arguments
    INTEGER, INTENT(IN OUT) :: vec(3) !Vector to shift
    
    ! Local variables
    INTEGER :: N(1:3) !Grid dimensions
    INTEGER :: i
    
    N(1:3) = (/ N1, N2, N3 /)
    ! Loop over the components of the vector checking if they are outside of the
    ! primitive cell and shifting them by a lattice vector if they are
    DO i = 1, 3
       DO WHILE ( vec(i) < 0 .OR. vec(i) >= ( N(i) - 1) )
          
          IF ( vec(i) < 0 ) THEN
             vec(i) = vec(i) + ( N(i) - 1 )
          END IF
          
          IF ( vec(i) >= (N(i) - 1) ) THEN
             vec(i) = vec(i) - ( N(i) - 1 )
          END IF
          
       END DO
    END DO
  END SUBROUTINE shift
  
END MODULE GridMod
