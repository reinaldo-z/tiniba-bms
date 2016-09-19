MODULE DefaultInput
  
  USE DebugMod, ONLY : debug
  
  IMPLICIT NONE
  
CONTAINS
  
  SUBROUTINE getGridInput
    USE GridMod, ONLY : N1, N2, N3
    USE UtilitiesMod, ONLY : IntToChar
    USE CommandLineArgumentsMod, ONLY : adaptive, passNumber
    IMPLICIT NONE
    INTEGER :: istat
    CHARACTER(LEN=5) :: gridFilename
    CHARACTER(LEn=1) :: charTmp
    
    IF (debug) WRITE (*,'(A)') "Program Flow: Entered getGridInput"
    
    IF (adaptive .AND. (passNumber.GE.1)) THEN
       CALL IntToChar(passNumber-1,charTmp)
       gridFilename = "grid"//TRIM(charTmp)
    ELSE
       gridFilename = "grid"
    END IF
    
    IF (debug) WRITE(*,'(A)') "File control: Opening "//TRIM(gridFilename)
    OPEN (UNIT=12,FILE=gridFilename,STATUS="OLD",ACTION="READ",IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(*,*) "ERROR: Cannot open file "//TRIM(gridFilename)
       STOP "Error opening grid file."
    END IF
    
    READ(UNIT=12, FMT=*) N1, N2, N3
    
    IF (debug) WRITE(*,'(A27,3I5)') "(getGridInput) N1, N2, N3: ", N1, N2, N3
    
    CLOSE (12)
    
    RETURN
    
  END SUBROUTINE getGridInput
  
  
  SUBROUTINE getPrimitiveVectors
    USE LatticeMod, ONLY : d1, d2, d3, a, b, c
    IMPLICIT NONE
    INTEGER :: istat
    
    IF (debug) WRITE (*,'(A)') "Program Flow: Entered getPrimitiveVectors"
    
    IF ( debug ) WRITE(*,'(A)') "File control: Opening pvectors"
    OPEN (UNIT=11,FILE="pvectors",STATUS="OLD",ACTION="READ",IOSTAT=istat)
    IF ( istat.NE.0 ) THEN
       WRITE(*,*) "ERROR: Cannot open file pvectors."
       STOP "Error opening file pvectors."
    END IF
    
    READ(UNIT=11, FMT=*, ERR=998) d1(1:3)
    READ(UNIT=11, FMT=*, ERR=998) d2(1:3)
    READ(UNIT=11, FMT=*, ERR=998) d3(1:3)
    READ(UNIT=11, FMT=*, ERR=998) a, b, c
    
    d1 = a * d1
    d2 = b * d2
    d3 = c * d3
    
    IF ( debug ) WRITE(*,'(A,3F)') "(getPrimitiveVectors) d1(1:3): ", d1(1:3)
    IF ( debug ) WRITE(*,'(A,3F)') "(getPrimitiveVectors) d2(1:3): ", d2(1:3)
    IF ( debug ) WRITE(*,'(A,3F)') "(getPrimitiveVectors) d3(1:3): ", d3(1:3)
    
    CLOSE (11)
    
    RETURN
    
998 STOP ' Error reading file: pvectors '
  END SUBROUTINE getPrimitiveVectors
  
  
  SUBROUTINE getSymmetryMatrices
    USE CommandLineArgumentsMod, ONLY : printSymmetries
    USE LatticeMod, ONLY : d1, d2, d3
    USE MathMod, ONLY : invert3by3
    USE SymmetriesMod, ONLY : nSym
    USE SymmetriesMod, ONLY : G
    USE SymmetriesMod, ONLY : symMatsCt
    USE SymmetriesMod, ONLY : symMatsRL
    USE SymmetriesMod, ONLY : symMatsPL
    USE SymmetriesMod, ONLY : allocateSymmetryMatrices
    USE SymmetriesMod, ONLY : deallocateSymmetryMatrices
    USE SymmetriesMod, ONLY : allocateGMatrix
    USE SymmetriesMod, ONLY : writeOutSymmetryMatrices
    USE SymmetriesMod, ONLY : writeOutSymmetryMatricesCartesian
    
    IMPLICIT NONE
    INTEGER :: S(3,3), iSym
    INTEGER :: istat
    DOUBLE PRECISION :: tempMat(3,3), tempMat2(3,3)
    DOUBLE PRECISION :: rbas(3,3), rbasTranspose(3,3), rbasTransposeInverse(3,3)
    DOUBLE PRECISION :: gbas(3,3)
    DOUBLE PRECISION :: rprimd(3,3)
    
    IF ( debug ) WRITE(*,*) "Program flow: Entered getSymmetryMatrices"
    
    rprimd(1:3,1) = d1(1:3)
    rprimd(1:3,2) = d2(1:3)
    rprimd(1:3,3) = d3(1:3)
    
    rbas = TRANSPOSE(rprimd)
    rbasTranspose = TRANSPOSE(rbas)
    CALL invert3by3 (rbas, gbas)
    rbasTransposeInverse = TRANSPOSE(gbas)
    
    WRITE(*,*) rbasTranspose
    PAUSE
    WRITE(*,*) rbasTransposeInverse
    PAUSE
    
    OPEN (UNIT=10,FILE="symmetries",STATUS="OLD",ACTION="READ",IOSTAT=istat)
    
    IF ( istat.NE.0 ) THEN
       WRITE(*,*) "ERROR: Cannot open file symmetries."
       STOP "Error opening file symmetries."
    END IF
    
    nSym = 0
    
    ! This looping structure is outdated.
    DO
       READ(UNIT=10, FMT=*, ERR=997, IOSTAT=istat) S(1:3,1),S(1:3,2),S(1:3,3)
       IF (istat.EQ.-1) THEN
          EXIT
       END IF
       nSym = nSym + 1
    END DO
    CLOSE (10)
    
    CALL allocateSymmetryMatrices()
    CALL allocateGMatrix()
    
    ! Open symmetries file again
    OPEN (UNIT=10,FILE="symmetries",STATUS="OLD",ACTION="READ")
    
    !Now we extract the symmetries, and store them in the array G
    DO iSym = 1, NSym
       READ(UNIT=10, FMT=*, ERR=997) &
            G(iSym)%el(1:3,1), G(iSym)%el(1:3,2), G(iSym)%el(1:3,3)
    END DO
    
    CLOSE (10)
    
    DO iSym = 1, nSym
       symMatsRL(:,:,iSym) = G(iSym)%el(:,:)
       tempMat2(1:3,1:3) = symMatsRL(1:3,1:3,iSym)
       tempMat = TRANSPOSE(tempMat2)
       symMatsPL(1:3,1:3,iSym) = tempMat(1:3,1:3)
    END DO
    
    DO iSym = 1, nSym
       tempMat = REAL(symMatsPl(1:3,1:3,iSym))
       tempMat2 = MATMUL(tempMat,rbasTransposeInverse)
       symMatsCt(1:3,1:3,iSym) = MATMUL(rbasTranspose,tempMat2)
    END DO
    
    IF (printSymmetries) THEN
       CALL writeOutSymmetryMatrices()
       CALL writeOutSymmetryMatricesCartesian()
    END IF
    
    CALL deallocateSymmetryMatrices()
    
    RETURN
    
997 STOP ' Error reading file: symmetries '
  END SUBROUTINE getSymmetryMatrices
  
  SUBROUTINE getInput ()
    IMPLICIT NONE
    
    IF (debug) WRITE (*,'(A)') "Program Flow: Entered getINPUT"
    
    ! Get the primitive vectors
    CALL getPrimitiveVectors
    
    ! Get the symmetry matrices
    CALL getSymmetryMatrices
    
    ! Get the grid dimensions
    CALL getGridInput
    
  END SUBROUTINE getINPUT
  
END MODULE DefaultInput

