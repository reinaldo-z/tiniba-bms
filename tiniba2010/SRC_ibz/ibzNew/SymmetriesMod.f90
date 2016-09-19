MODULE SymmetriesMod
  
  USE DebugMod, ONLY : debug
  
  USE MathMod, ONLY : matrix3by3
  
  USE MyAllocateMod, ONLY : myAllocate
  
  IMPLICIT NONE
  
  ! nSym is the number of symmetry matrices
  INTEGER :: nSym
  
  ! G contains the symmetry matrices
  TYPE(matrix3by3), ALLOCATABLE :: G(:)
  
  ! containsInversion is true if the system has inversionSymmetry
  ! or if the user demands inversionSymmetry is present
  LOGICAL :: containsInversion
  
  ! The symmetry Matrices
!!! SymMatsCt - The symmetry matrices in the Cartesian basis
!!! SymMatsPl - The symmetry matrices in the direct lattice basis
!!! SymMatsRl - The symmetry matrices in the reciprocal lattice basis
  DOUBLE PRECISION, ALLOCATABLE :: symMatsCt(:,:,:)
  INTEGER, ALLOCATABLE :: symMatsPL(:,:,:)
  INTEGER, ALLOCATABLE :: symMatsRL(:,:,:)
  
CONTAINS
  
  SUBROUTINE allocateSymmetryMatrices
    
    IF (debug) WRITE(*,*) "Program Flow: Entered allocateSymmetryMatrice"
    
    ALLOCATE( symMatsCt(3,3,nSym) )
    ALLOCATE( symMatsPL(3,3,nSym) )
    ALLOCATE( symMatsRL(3,3,nSym) )
    
    symMatsCt(1:3,1:3,1:nSym) = 0.d0
    symMatsPL(1:3,1:3,1:nSym) = 0
    symMatsRL(1:3,1:3,1:nSym) = 0
    
    IF (debug) WRITE(*,*) "Program Flow: Exiting allocateSymmetryMatrice"
    
  END SUBROUTINE allocateSymmetryMatrices
  
  SUBROUTINE deallocateSymmetryMatrices
    IF (debug) WRITE(*,*) "Program Flow: Entered deallocateSymmetryMatrice"
    DEALLOCATE( symMatsCt )
    DEALLOCATE( symMatsPL )
    DEALLOCATE( symMatsRL )
    IF (debug) WRITE(*,*) "Program Flow: Exiting deallocateSymmetryMatrice"
  END SUBROUTINE deallocateSymmetryMatrices
  
  SUBROUTINE allocateGMatrix
    IF (debug) WRITE(*,*) "Program Flow: Entered allocateGMatrix"
    ALLOCATE( G(nSym) )
    IF (debug) WRITE(*,*) "Program Flow: Exiting allocateGMatrix"
  END SUBROUTINE allocateGMatrix
  
  SUBROUTINE deallocateGMatrix
    IF (debug) WRITE(*,*) "Program Flow: Entered deallocateGMatrix"
    DEALLOCATE( G )
    IF (debug) WRITE(*,*) "Program Flow: Exiting deallocateGMatrix"    
  END SUBROUTINE deallocateGMatrix
  
  SUBROUTINE checkForInversion
    INTEGER :: iSym, jSym
    
    ! inverseMap is an array that, for each matrix, points to its inverse.
    INTEGER, ALLOCATABLE :: inverseMap(:)
    
    ! thisSymmetryMatrix is matrix we are currently analysing
    TYPE(matrix3by3) :: thisSymmetryMatrix
    
    LOGICAL :: inverseExists
    LOGICAL, ALLOCATABLE :: inverseTest(:), refArray(:)
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered checkForInversion"
    
    ! Loop over symmetry matrices.  Check that they are unique
    DO iSym  = 1, nSym-1
       DO jSym = iSym+1, nSym
          IF (ALL (G(iSym)%el(:,:) .EQ. G(jSym)%el(:,:))) THEN
             WRITE(*,*) ""
             WRITE(*,*) "Error: Found two equal symmetry matrices ", iSym, jSym
             WRITE(*,*) "Stopping"
             STOP "Symmetry matrices are not unique"
          END IF
       END DO
    END DO
    
    IF ( debug ) WRITE(*,*) "Check: Symmetry Matrices are unique."
    
    ! Initialize containsInversion
    containsInversion = .FALSE.
    
    ! Initialize inverseMap(1:nSym) to
    CALL myAllocate( inverseMap, "inverseMap", nSym )
    DO iSym = 1, nSym
       inverseMap(iSym) = iSym
    END DO
    
    CALL myAllocate( inverseTest, "inverseTest", nSym )
    CALL myAllocate( refArray, "refArray", nSym )
    
    inverseTest(1:nSym) = .FALSE.
    refArray(1:nSym) = .TRUE.
    
    ! Loop over symmetry matrices.  Check that each one has
    ! only one inversion pair, or that no inversion exists.
    DO iSym = 1, nSym-1
       inverseExists = .FALSE.
       DO jSym = 2, nSym
          
          ! compare thisSymmetryMatrix to G(jSym)
          IF (ALL (G(jSym)%el(1:3,1:3) .EQ. -G(iSym)%el(1:3,1:3))) THEN
             
             IF ( inverseExists ) THEN
                WRITE(*,*) "Found multiple inversion pairs!"
                STOP "Error with Symmetry matrices."
             ELSE
                inverseExists = .TRUE.
                inverseTest(iSym) = .TRUE.
                inverseTest(jSym) = .TRUE.
             END IF
          END IF
          
       END DO
       
    END DO
    
    IF (ALL(inverseTest(1:nSym) .EQ. refArray(1:nSym))) THEN
       containsInversion = .TRUE.
    ELSE IF (ALL(inverseTest(1:nSym) .NE. refArray(1:nSym))) THEN
       containsInversion = .FALSE.
    ELSE
       ! Error !
       WRITE(*,*) "Some, but not all symmetries have an inversion!"
       STOP
    END IF
    
    DEALLOCATE(inverseMap)
    DEALLOCATE(inverseTest)
    DEALLOCATE(refArray)
    
  END SUBROUTINE checkForInversion
  
  SUBROUTINE addInversion
    
    TYPE (matrix3by3), ALLOCATABLE :: tempSymmetries(:)
    INTEGER :: nSymOld, iSym, i
    
    IF (containsInversion) THEN
       WRITE(*,*) "Cannot add inversion.  Structure is centrosymmetric."
       WRITE(*,*) "Error!"
       STOP "Error.  Tried to add inversion to centrosymmetric structure."
    END IF
    
    ! copy the symmetry matrices to a temporary array
    CALL myAllocate( tempSymmetries, "tempSymmetries", nSym)
    tempSymmetries(1:nSym) = G(1:nSym)
    
    ! double the number of Symmetries
    nSymOld = nSym
    nSym = 2*nSym
    DEALLOCATE(G)
    CALL myAllocate( G, "G", nSym)
    !ALLOCATE(G(nSym))
    
    i=0
    DO iSym=1, nSymOld
       i=i+1
       G(i) = tempSymmetries(iSym)
       i=i+1
       G(i)%el(1:3,1:3) = -tempSymmetries(iSym)%el(1:3,1:3)
    END DO
    
    DEALLOCATE(tempSymmetries)
    
  END SUBROUTINE addInversion
  
  SUBROUTINE writeOutSymmetryMatrices
    INTEGER :: iSym
    
    IF (debug) WRITE(*,*) "Program Flow: Entered writeOutSymmetryMatrices"
    
    OPEN(UNIT=1,FILE="IBZsymmetries")
    WRITE(1,*) "The symmetry matrices in various coordinate systems"
    WRITE(1,*) "===========  Cartesian Basis ================="
    DO iSym=1,nSym
       WRITE(1,*) "Symmetry ", iSym
       WRITE(1,'(3F15.8)') symMatsCt(1,1:3,iSym)
       WRITE(1,'(3F15.8)') symMatsCt(2,1:3,iSym)
       WRITE(1,'(3F15.8)') symMatsCt(3,1:3,iSym)
    END DO
    WRITE(1,*) "===========  Direct Primitive Basis ================="
    DO iSym=1,nSym
       WRITE(1,*) "Symmetry ", iSym
       WRITE(1,*) symMatsPl(1,1:3,iSym)
       WRITE(1,*) symMatsPl(2,1:3,iSym)
       WRITE(1,*) symMatsPl(3,1:3,iSym)
    END DO
    WRITE(1,*) "===========  Reciprocal Primitive Basis ================="
    WRITE(1,*) "NOTE: These are the symmetry operations satisfied by"
    WRITE(1,*) "       the energy eigenvalues in the BZ "
    DO iSym=1,nSym
       WRITE(1,*) "Symmetry ", iSym
       WRITE(1,*) symMatsRl(1,1:3,iSym)
       WRITE(1,*) symMatsRl(2,1:3,iSym)
       WRITE(1,*) symMatsRl(3,1:3,iSym)
    END DO
    CLOSE(1)
    
    IF (debug) WRITE(*,*) "Program Flow: exiting writeOutSymmetryMatrices"
    
  END SUBROUTINE writeOutSymmetryMatrices
  
  
  SUBROUTINE writeOutSymmetryMatricesCartesian
    INTEGER :: iSym
    
    IF (debug) WRITE(*,*) "Program Flow: Entered writeOutSymmetryMatricesCartesian"
    
    OPEN(UNIT=1, FILE="Symmetries.Cartesian")
    WRITE(1,*) nSym
    DO iSym=1,nSym
       WRITE(1,'(3F15.8)') symMatsCt(1,1:3,iSym)
       WRITE(1,'(3F15.8)') symMatsCt(2,1:3,iSym)
       WRITE(1,'(3F15.8)') symMatsCt(3,1:3,iSym)
    END DO
    CLOSE(1)
    
    IF (debug) WRITE(*,*) "Program Flow: exiting writeOutSymmetryMatricesCartesian"
    
  END SUBROUTINE writeOutSymmetryMatricesCartesian
  
END MODULE SymmetriesMod
