PROGRAM IBZ
!!!
!!! Written by Matthew Strimas-Mackey and Fred Nastos (2004-2006)
!!! Use at your own risk until further notice.
!!!
  
  USE LatticeMod, ONLY : getRLV
  USE LatticeMod, ONLY : getDIAG
  
  USE GridMod, ONLY : IRpts
  USE GridMod, ONLY : cubes
  USE GridMod, ONLY : cubeLevel
  USE GridMod, ONLY : gridCoordinates, gridPointer
  USE GridMod, ONLY : initializeGrid, transformGrid, reduceGrid
  USE GridMod, ONLY : weights
  USE GridMod, ONLY : calculateGridDivisions, checkGridDivisions
  
  USE SymmetriesMod, ONLY : G
  USE SYmmetriesMod, ONLY : containsInversion, checkForInversion, addInversion
  
  USE CommandLineArgumentsMod, ONLY : parseCommandLineArguments
  USE CommandLineArgumentsMod, ONLY : printTetrahedra
  USE CommandLineArgumentsMod, ONLY : mesh
  USE CommandLineArgumentsMod, ONLY : adaptive, passNumber
  
  USE InitializeDataMod, ONLY : initializeData
  
  USE NextPassMod, ONLY : nextPass
  
  USE PrintResultsMod, ONLY : printResults
  
  IMPLICIT NONE
  INTEGER :: i
  
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
     IF (1 .EQ. i) THEN
        CALL addInversion ()
     END IF
  END IF
  
  ! At this point should have N1, N2, N3, symmetry
  ! matrices and primitive lattice vectors
  
  ! checkGridDivisions is a subroutine to check that the number of
  ! divisions along each axis doesn't conflict with the symmetry operations
  CALL checkGridDivisions ()
  
  IF (passNumber.EQ.0) THEN
     
     CALL initializeGrid ()
     ! At this point we have cubic grid through the full FBZ, with
     ! weights at each point.
     
     ! Transform the submesh onto itself using symmetry.
     CALL transformGrid ()
     
     ! At this point gridPointer is defined.
     CALL reduceGrid()
     
  ELSE IF ((adaptive).AND.passNumber.GE.1) THEN
     
     CALL nextPass(passNumber)
     
  END IF
  
  ! Carry out the tetrahedra reduction.
  IF (printTetrahedra) THEN
     CALL getIRtet ()
  END IF
  
  CALL printResults
  
  DEALLOCATE ( gridCoordinates )
  DEALLOCATE ( gridPointer )
  DEALLOCATE ( IRpts )
  DEALLOCATE ( weights )
  DEALLOCATE ( G )
  
END PROGRAM IBZ
