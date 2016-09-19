MODULE LatticeMod
  
  USE ConstantsMod, ONLY : PI
  USE DebugMod, ONLY : debug
  
  ! Direct lattice and reciprocal lattice primitive vectors
  DOUBLE PRECISION, DIMENSION(3) :: d1, d2, d3, b1, b2, b3
  
  ! Lattice parameters and Brillouin zone volume
  DOUBLE PRECISION :: a, b, c, BZ_VOL
  
  ! cell_type specifies which body diagonal
  ! of the primitive cell is shortest and hence how to divide
  ! the submesh cells into tetrahedra.
  INTEGER :: cell_type
  
CONTAINS
  
  SUBROUTINE getRLV ()
    ! Get reciprocal lattice primitive vectors from direct
    ! lattice primitive vectors.
    ! Also find Brillouin zone volume
    IMPLICIT NONE
    
    !Local variables
    DOUBLE PRECISION :: tmp(3)
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered getRLV"
    
    !  PI = ACOS(-1.d0)
    
    !Use the standard formular for reciprocal lattice primitive vectors
    CALL XPROD (d2, d3, tmp)
    b1 = 2*PI*(1/(DOT_PRODUCT(d1, tmp)))*tmp
    
    CALL XPROD (d3, d1, tmp)
    b2 = 2*PI*(1/(DOT_PRODUCT(d2, tmp)))*tmp
    
    CALL XPROD (d1, d2, tmp)
    b3 = 2*PI*(1/(DOT_PRODUCT(d3, tmp)))*tmp
    
    CALL XPROD (b2, b3, tmp)
    BZ_VOL = DABS(DOT_PRODUCT(b1, tmp))
    
  END SUBROUTINE getRLV
  
  SUBROUTINE XPROD (v1, v2, x)
    !Sets x to the cross product of v1 and v2
    
    IMPLICIT NONE
    
    !Calling arguments
    DOUBLE PRECISION,INTENT(IN) :: v1(3),v2(3)
    DOUBLE PRECISION, INTENT(OUT) :: x(3)
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered XPROD"
    
    x(1) = v1(2)*v2(3) - v1(3)*v2(2)
    x(2) = v1(3)*v2(1) - v1(1)*v2(3)
    x(3) = v1(1)*v2(2) - v1(2)*v2(1)
    
  END SUBROUTINE XPROD
  
  
  SUBROUTINE getDIAG ()
    !Find the shortest diagonal of the primitive cell
    IMPLICIT NONE
    
    !Local variables
    INTEGER :: i
    !diagonal() is the body diagonal vector, length is the norm of this vector
    DOUBLE PRECISION :: diagonal(3), length(4)
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered getDIAG"
    
    !(0,1,0) -> (1,0,1) diagonal
    diagonal = b1 + b3 - b2
    length(1) = SQRT( diagonal(1)**2 + diagonal(2)**2 + diagonal(3)**2 )
    
    !(0,0,0) -> (1,1,1) diagonal
    diagonal = b1 + b2 + b3
    length(2) = SQRT( diagonal(1)**2 + diagonal(2)**2 + diagonal(3)**2 )
    
    !(1,1,0) -> (0,0,1) diagonal
    diagonal = b3 - b1 - b2
    length(3) = SQRT( diagonal(1)**2 + diagonal(2)**2 + diagonal(3)**2 )
    
    !(1,0,0) -> (0,1,1) diagonal
    diagonal = b2 + b3 - b1
    length(4) = SQRT( diagonal(1)**2 + diagonal(2)**2 + diagonal(3)**2 )
    
    !Find the shortest diagonal
    cell_type = 1
    DO i = 2, 4
        IF (length(i).LT.length(cell_type)) THEN
            cell_type = i
        END IF
    END DO
    
  END SUBROUTINE getDIAG
  
END MODULE LatticeMod
