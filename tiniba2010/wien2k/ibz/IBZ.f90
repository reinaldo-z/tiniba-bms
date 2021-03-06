PROGRAM IBZ
!!!
!!! Written by Matthew Strimas-Mackey and Fred Nastos (2004-2005)
!!! Use at your own risk until further notice.
!!!
  USE Global, ONLY : IRpts
  USE Global, ONLY : getRLV
  USE Global, ONLY : debug
!!!###
  USE Grid, ONLY : gridCoordinates, gridPointer
  USE Grid, ONLY : initializeGrid, transformGrid, reduceGrid
  USE Grid, ONLY : multiplicity
!!!###
  USE Symmetries, ONLY : G, containsInversion, checkForInversion,addInversion
!!!###
  USE CommandLineArguments, ONLY : parseCommandLineArguments
  USE CommandLineArguments, ONLY : printTetrahedra
  USE CommandLineArguments, ONLY : mesh
  USE CommandLineArguments, ONLY : firstPass, nextPass
!!!###
  USE InitializeDataMod, ONLY : initializeData, calculateGridDivisions
!!!###
  USE NextPassMod, ONLY : setupNextPass, readCubes
  USE NextPassMod, ONLY : readWhichCubesToDivide, readKpointsMap
  USE NextPassMod, ONLY : readKpointsInteger, divideCubes
  USE NextPassMod, ONLY : reduceNewPoints, printNextPassResults
!!!###
  IMPLICIT NONE
  INTEGER :: i
  
  ! Set debugging option
  IF ( debug ) WRITE(*,'(A)') "Program Flow: Starting Program IBZ"
  
  CALL parseCommandLineArguments
  
  ! Get the input either from the WIEN2k struct file, the ABINIT output, or
  ! in the default format.
  CALL initializeData ()
  
  ! Get reciprocal lattice primitive vectors and First Brillouin Zone volume
  CALL getRLV ()
  
  IF (.NOT.mesh) THEN
     CALL calculateGridDivisions ()
  END IF
  
  ! Determine shortest primitive cell diagonal
  CALL getDIAG ()
  
  ! ADD subroutine for user to be able to add inversion
  CALL checkForInversion ()
  IF (.NOT.containsInversion) THEN
     WRITE(*,*) "Do you want to add inversion? (1=yes, 0=no)"
     READ(*,*) i
     IF (i .EQ. 1) THEN
        CALL addInversion ()
     END IF
  END IF
  
  ! At this point should have N1, N2, N3, symmetry
  ! matrices and primitive lattice vectors
  CALL checkDimensions ()
  
  IF (firstPass) THEN
     CALL initializeGrid ()
     ! Transform the submesh onto itself using symmetry.
     CALL transformGrid ()
     ! At this point gridPointer is defined.
     CALL reduceGrid()
     ! Carry out the tetrahedra reduction.
     IF (printTetrahedra) THEN
        CALL getIRtet ()
     END IF
     ! Print irreducible points
     CALL printIRpts ()
     DEALLOCATE ( IRpts )
     DEALLOCATE ( multiplicity )
  ELSE IF (nextPass) THEN
     !     WRITE(*,*) "set up next pass"
     CALL setupNextPass
     !     WRITE(*,*) "read cubes"
     CALL readCubes
     !     WRITE(*,*) "read which cubes to divide"
     CALL readWhichCubesToDivide
     !     WRITE(*,*) "read kpoints map"     
     CALL readKpointsMap
     !     WRITE(*,*) "read Kpoints Integer"
     CALL readKpointsInteger
     !     WRITE(*,*) "divide cubes"
     CALL divideCubes
     !     WRITE(*,*) "reduce New Points"
     CALL reduceNewPoints
     !     WRITE(*,*) "printNextPassResults"
     CALL printNextPassResults
     DEALLOCATE ( gridCoordinates )
     DEALLOCATE ( multiplicity )
  END IF
  
  ! Print tetrahedra output
  IF ( printTetrahedra ) THEN
     CALL printIRtet () !!!
  END IF
  IF ( firstPass .OR. nextPass ) DEALLOCATE ( gridPointer )
  
  DEALLOCATE ( G )
END PROGRAM IBZ
