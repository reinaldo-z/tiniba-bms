MODULE printResultsMod
  
  USE DebugMod, ONLY : debug
  
  IMPLICIT NONE
  
CONTAINS
  
  SUBROUTINE printResults
    
    !USE ConstantsMod, ONLY : PI
    
    USE LatticeMod, ONLY : b1, b2, b3
    
    USE UtilitiesMod, ONLY : IntToChar
    
    USE GridMod, ONLY : IRtet, tetrahedronMultiplicity
    USE GridMod, ONLY : Ncubes, cubes, cubeLevel
    USE GridMod, ONLY : N1, N2, N3
    USE GridMod, ONLY : Npts, NIRpts, IRpts
    USE GridMod, ONLY : gridCoordinates, gridPointer
    USE GridMod, ONLY : weights
    
    USE NextPassMod, ONLY : NptsOld, numOldCubes, numberOfCubesToDivide
    USE NextPassMod, ONLY : passNumber
    
    USE StructFile, ONLY : ortho, a1, a2, a3
    
    USE CommandLineArgumentsMod, ONLY : wien2k
    USE CommandLineArgumentsMod, ONLY : reduced, cartesian, reducedInteger
    USE CommandLineArgumentsMod, ONLY : printTetrahedra, printCubes, printMap
    
    IMPLICIT NONE
    
    CHARACTER(LEN=5) :: gridFile
    CHARACTER(LEN=1) :: charTemp
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered printResults"
    
    !Print basic information to the screen
    
    CALL printInfo
    
    ! Print grid Dimensions to be used for next pass
    CALL IntToChar(passNumber, charTemp)
    gridFile = "grid"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=gridFile, ACTION="WRITE")
    WRITE(UNIT=10,FMT='(3I6)')  N1, N2, N3
    CLOSE(10)
    
    !Print cube corners
    IF ( printCubes ) THEN
       CALL printCubeCorners
    END IF
    
    DEALLOCATE(cubes)
    DEALLOCATE(cubeLevel)
    
    ! Print tetrahedra results.
    IF ( printTetrahedra ) THEN
       CALL printIRtet
       DEALLOCATE(IRtet)
       DEALLOCATE(tetrahedronMultiplicity)
    END IF
    
    ! Print kpoints in various formats.
    IF (printMap) THEN
       CALL printOutMap
    END IF

    IF (reduced) THEN
       CALL printOutRL
    END IF

    IF (cartesian) THEN
       CALL printOutCartesian
    END IF

    IF (reducedInteger) THEN
       CALL printOutRLInt
    END IF

    IF (wien2k) THEN
       CALL printOutWien2k
    END IF

  END SUBROUTINE printResults


  SUBROUTINE printInfo
    
    USE GridMod, ONLY : NIRpts, IRpts
    USE GridMod, ONLY : NIRtet, Ncubes
    USE GridMod, ONLY : Npts
    USE GridMod, ONLY : weights
    
    USE NextPassMod, ONLY : NptsOld, numOldCubes, numberOfCubesToDivide
    USE NextPassMod, ONLY : passNumber
    
    USE CommandLineArgumentsMod, ONLY : printTetrahedra
    
    IMPLICIT NONE
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered printInfo"
    
    IF (passNumber.EQ.0) THEN
       
       WRITE(*,*) "Total number of points: ", Npts
       WRITE(*,*) "Number of irreducible points: ", NIRpts
       
       !Amount of reduction is the ratio of total points to irreducible points
       WRITE(*,*) "Amount of Reduction: ", Npts/REAL(NIRpts)
       
       WRITE(*,*) "Sum of irreducible weights:", SUM(weights(:))
       WRITE(*,*) "Number of cubes: ", Ncubes
       
       IF (printTetrahedra) THEN
          WRITE(*,*) "Total number of tetrahedra:", Ncubes*6
          WRITE(*,*) "Number of irreducible tetrahedra:", NIRtet
          ! Amount of reduction is the ratio of total tetra to irreducible tetra.
          WRITE(*,*) "Amount of Reduction:", REAL(Ncubes*6)/REAL(NIRtet)
       END IF
       
    ELSE
       
       WRITE(*,*) "Total number of old points: ", NptsOld
       WRITE(*,*) "Total number of new points:", Npts - NptsOld
       WRITE(*,*) "Total number of points: ", Npts
       
       WRITE(*,*) "Number of irreducible points: ", NIRpts
       
       !Amount of reduction is the ratio of total points to irreducible points
       WRITE(*,*) "Amount of Reduction: ", Npts/REAL(NIRpts)
       
       WRITE(*,*) "Sum of irreducible weights:", SUM(weights(:))
       
       WRITE(*,*) "Number of old cubes:", numOldCubes
       WRITE(*,*) "Number of new cubes:", 8*numberOfCubesToDivide
       WRITE(*,*) "Number of cubes: ", Ncubes
       
       IF (printTetrahedra) THEN
          WRITE(*,*) "Total number of tetrahedra:", Ncubes*6
          WRITE(*,*) "Number of irreducible tetrahedra:", NIRtet
          ! Amount of reduction is the ratio of total tetra to irreducible tetra.
          WRITE(*,*) "Amount of Reduction:", REAL(Ncubes*6)/REAL(NIRtet)
       END IF
       
    END IF
    
  END SUBROUTINE printInfo
  
  
  SUBROUTINE printCubeCorners
    
    USE GridMod, ONLY : cubes, cubeLevel
    USE GridMod, ONLY : Ncubes
    USE UtilitiesMod, ONLY : IntToChar
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    CHARACTER(LEN=11) :: cubesFile
    CHARACTER(LEN=1) :: charTemp
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered printCubeCorners"
    
    CALL IntToChar(passNumber, charTemp)
    cubesFile = "cubes"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=cubesFile, ACTION="WRITE")
    
    WRITE(UNIT=10,FMT=*) Ncubes
    
    !Print cube corners and pass from which they came
    DO i = 1, Ncubes
       WRITE(UNIT=10, FMT='(9I8)') cubes(i,1:8), cubeLevel(i)
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printCubeCorners
  
  
  SUBROUTINE printIRtet
    
    USE LatticeMod, ONLY : BZ_vol
    USE UtilitiesMod, ONLY : IntToChar
    USE GridMod, ONLY : N1, N2, N3
    USE GridMod, ONLY : NIRtet
    USE GridMod, ONLY : IRtet, tetrahedronMultiplicity
    USE GridMod, ONLY : Ncubes
    USE GridMod, ONLY : IRtetPassInfo
    
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    CHARACTER(LEN=11) :: tetrahedraFile
    CHARACTER(LEN=1) :: charTemp
    DOUBLE PRECISION :: BZ_vol_check
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered printIRtet"
    
    CALL IntToChar(passNumber, charTemp)
    tetrahedraFile = "tetrahedra"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=tetrahedraFile, ACTION="WRITE")
    
    WRITE(UNIT=10,FMT=*) NIRtet
    
    !Check tetrahedra volumes
    BZ_vol_check = 0.d0
    DO i = 1, NIRtet
       BZ_vol_check = BZ_vol_check &
            + tetrahedronMultiplicity(i)*1.d0/((N1-1)*(N2-1)*(N3-1)*6.d0)*(8.d0)**(passNumber - IRtetPassInfo(i))
    END DO
    WRITE(*,*) "Tetrahedra volume summation check: ", BZ_vol_check
    
    
    !Print irreducible tetrahedra
    DO i = 1, NIRtet
       
       WRITE(UNIT=10, FMT='(4I7,I10,E20.10)')           &
            IRtet(1:4,i), tetrahedronMultiplicity(i),  &
            BZ_VOL/((N1-1)*(N2-1)*(N3-1)*6.d0)*(8.d0)**(passNumber - IRtetPassInfo(i))
       
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printIRtet
  
  
  SUBROUTINE printOutMap
    
    USE UtilitiesMod, ONLY : IntToChar
    USE GridMod, ONLY : Npts
    USE GridMod, ONLY : gridCoordinates, gridPointer
    
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    CHARACTER(LEN=12) :: kpointsMapFile
    CHARACTER(LEN=1) :: charTemp
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered printOutMap"
    
    CALL IntToChar(passNumber, charTemp)
    kpointsMapFile = "kpoints.map"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=kpointsMapFile, ACTION="WRITE")
    
    WRITE(10,*) Npts
    ! Print k-point map
    DO i = 1, Npts
       WRITE(UNIT=10,FMT='(3I8,I10)')  gridCoordinates(i,1:3), gridPointer(i)
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printOutMap
  
  
  SUBROUTINE printOutRL
    
    USE UtilitiesMod, ONLY : IntToChar
    USE GridMod, ONLY : NIRpts, IRpts
    USE GridMod, ONLY : N1, N2, N3
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    DOUBLE PRECISION :: tmp(3)
    CHARACTER(LEN=19) :: kpointsReciprocalFile
    CHARACTER(LEN=1) :: charTemp
    
    IF (debug) WRITE(*,*) "Program Flow: Entered printOutRL"
    
    CALL IntToChar(passNumber, charTemp)
    kpointsReciprocalFile = "kpoints.reciprocal"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=kpointsReciprocalFile, ACTION="WRITE")
    
    DO i = 1, NIRpts
       
       !Print irreducible points in primitive reciprocal lattice basis
       tmp(1) = IRpts(i,1)/REAL(N1-1)
       tmp(2) = IRpts(i,2)/REAL(N2-1)
       tmp(3) = IRpts(i,3)/REAL(N3-1)
       
       WRITE(UNIT=10, FMT='(3F15.8)') tmp
       
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printOutRL
  
  SUBROUTINE printOutCartesian
    
    USE LatticeMod, ONLY : b1, b2, b3
    USE UtilitiesMod, ONLY : IntToChar
    USE GridMod, ONLY : NIRpts, IRpts
    USE GridMod, ONLY : N1, N2, N3
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    DOUBLE PRECISION :: tmp(3)
    CHARACTER(LEN=18) :: kpointsCartesianFile
    CHARACTER(LEN=1) :: charTemp
    
    IF (debug) WRITE(*,*) "Program Flow: Entered printOutCartesian"
    
    CALL IntToChar(passNumber, charTemp)
    kpointsCartesianFile = "kpoints.cartesian"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=kpointsCartesianFile, ACTION="WRITE")
    
    DO i = 1, NIRpts
       
       !Print irreducible points in cartesian coordinates
       tmp = ( IRpts(i,1) / REAL(N1-1) ) * b1 &
            + ( IRpts(i,2) / REAL(N2-1) ) * b2 &
            + ( IRpts(i,3) / REAL(N3-1) ) * b3
       
       WRITE(UNIT=10, FMT='(3F15.8)') tmp
       
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printOutCartesian
  
  SUBROUTINE printOutRLInt
    
    USE UtilitiesMod, ONLY : IntToChar
    USE GridMod, ONLY : NIRpts, IRpts
    USE GridMod, ONLY :  N1, N2, N3
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    CHARACTER(LEN=16) :: kpointsIntegerFile
    CHARACTER(LEN=1) :: charTemp
    
    IF (debug) WRITE(*,*) "Program Flow: Entered printOutRL"
    
    CALL IntToChar(passNumber, charTemp)
    kpointsIntegerFile = "kpoints.integer"//TRIM(charTemp)
    OPEN (UNIT=10, FILE=kpointsIntegerFile, ACTION="WRITE")
    
    WRITE(UNIT=10, FMT='(I10)') NIRpts
    WRITE(UNIT=10, FMT='(A10,3I6)') "Divide by:", N1-1, N2-1, N3-1
    DO i = 1, NIRpts
       
       !Print integer representation of k-points
       WRITE(UNIT=10,FMT='(TR10,3I6)') IRpts(i,1:3)
       
    END DO
    
    CLOSE(10)
    
  END SUBROUTINE printOutRLInt

  SUBROUTINE printOutWien2k
    
    USE ConstantsMod, ONLY : PI
    USE LatticeMod, ONLY : b1, b2, b3
    USE UtilitiesMod, ONLY : IntToChar
    USE MathMod, ONLY : greatestCommonDivisor
    USE GridMod, ONLY : NIRpts, IRpts
    USE GridMod, ONLY : N1, N2, N3
    USE GridMod, ONLY : weights
    USE StructFile, ONLY : ortho, a1, a2, a3
    USE NextPassMod, ONLY : passNumber
    
    IMPLICIT NONE
    
    INTEGER :: i
    DOUBLE PRECISION :: tmp(3)
    INTEGER :: itmp(3)
    INTEGER :: gcd1, gcd2, lcm1, lcm2 , fact, divisor
    CHARACTER(LEN=15) :: kpointsWien2kFile
    CHARACTER(LEN=1) :: charTemp
    
    IF (debug) WRITE(*,*) "Program Flow: Entered printOutWien2k"
    
    CALL IntToChar(passNumber, charTemp)
    kpointsWien2kFile = "kpoints.wien2k"//TRIM(charTemp)
    OPEN(UNIT=10, FILE=kpointsWien2kFile, ACTION="WRITE")
    
    ! Find lowest common multiple of N1-1, N2-1, and N3-1.
    CALL greatestCommonDivisor(N1-1,N2-1,gcd1)
    lcm1 = (N1-1)*(N2-1)/gcd1
    CALL greatestCommonDivisor(lcm1,N3-1,gcd2)
    lcm2 = (N3-1)*lcm1/gcd2
    
    ! Fact is the factor you need to divide (N1-1)*(N2-1)*(N3-1) by
    ! to get lcm2.
    fact = (N1-1)*(N2-1)*(N3-1)/lcm2
    divisor = (N1-1)*(N2-1)*(N3-1)
    divisor = divisor/fact
    
    DO i = 1, NIRpts
       
       ! Print integer representation of k-points in WIEN coordinates
       IF (ortho) THEN
          tmp =  ( IRpts(i,1) / REAL(N1-1) ) * b1 &
               + ( IRpts(i,2) / REAL(N2-1) ) * b2 &
               + ( IRpts(i,3) / REAL(N3-1) ) * b3
          
          tmp(1) = tmp(1)*a1/(2.d0*PI)*REAL(N1-1)*REAL(N2-1)*REAL(N3-1)
          tmp(2) = tmp(2)*a2/(2.d0*PI)*REAL(N1-1)*REAL(N2-1)*REAL(N3-1)
          tmp(3) = tmp(3)*a3/(2.d0*PI)*REAL(N1-1)*REAL(N2-1)*REAL(N3-1)
          itmp(:) = NINT(tmp(:))
       ELSE
          itmp(1) = IRpts(i,1)*(N2-1)*(N3-1)
          itmp(2) = IRpts(i,2)*(N1-1)*(N3-1)
          itmp(3) = IRpts(i,3)*(N1-1)*(N2-1)
       END IF
       
       itmp(1:3) = itmp(1:3)/fact
       !WRITE(UNIT=10,FMT='(I10,4I5,F5.1)') i, itmp(1:3), divisor, weights(i)
     WRITE(UNIT=10,FMT='(I10,4I5,F10.1)') i, itmp(1:3), divisor, weights(i)
       
    END DO
    
    WRITE(UNIT=10,FMT='(A3)') "END"
    
    CLOSE(10)
    
  END SUBROUTINE printOutWien2k
  
  
  SUBROUTINE reducePoint (kpoint, divisor)
    ! This reduces the ratio that describes the point in the WIEN notation
    IMPLICIT NONE
    
    !Calling arguments
    INTEGER, INTENT (INOUT) :: kpoint(3), divisor
    
    !Local variables, primeARRAY will hold the prime numbers that
    !will be divided out as common factors.
    INTEGER :: i, p, t1, t2, t3, t4
    INTEGER, PARAMETER :: primeArray(26) = (/ 2, 3, 5, 7, 11, &
         13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, &
         73, 79, 83, 89, 97, 101/)
    
    DO i = 1, 20
       p = primeArray(i)
       DO
          IF ((MOD(kpoint(1),p) == 0).AND.(MOD(kpoint(2),p) == 0).AND.&
               (MOD(kpoint(3),p) == 0).AND.(MOD(divisor,p) == 0)) THEN
             kpoint(1:3)=kpoint(1:3)/p
             divisor = divisor/p
          ELSE
             EXIT
          END IF
       END DO
    END DO
    
  END SUBROUTINE reducePoint
  
END MODULE printResultsMod
