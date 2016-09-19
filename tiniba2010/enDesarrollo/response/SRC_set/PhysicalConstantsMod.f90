!!!########################
MODULE PhysicalConstantsMod
!!!########################
  USE ConstantsMod, ONLY : DP
  USE ConstantsMod, ONLY : pi
  IMPLICIT NONE
  !INTEGER, PARAMETER :: DP = KIND(1.0D0)  ! double precision
  
  TYPE physicalConstant
     REAL(DP) :: significand
     INTEGER :: exponent
  END TYPE physicalConstant
  
  TYPE(physicalConstant), PARAMETER :: unity = physicalConstant( 1.0, 0 )
  
  TYPE(physicalConstant), PARAMETER :: electronCharge_cgs = physicalConstant( 4.803206799d0, -10 )
  TYPE(physicalConstant), PARAMETER :: electronCharge_mks = physicalConstant( 1.602176487d0, -19 )
  
  TYPE(physicalConstant), PARAMETER :: hBar_cgs = physicalConstant( 1.054571628d0, -27 )
  TYPE(physicalConstant), PARAMETER :: hBar_mks = physicalConstant( 1.054571628d0, -34 )
  
  TYPE(physicalConstant), PARAMETER :: electronMass_cgs = physicalConstant( 9.10938215d0, -28 )
  TYPE(physicalConstant), PARAMETER :: electronMass_mks = physicalConstant( 9.10938215d0, -31 )
  
  TYPE(physicalConstant), PARAMETER :: BohrRadius_cgs = physicalConstant( 5.291772108d0, -9 )
  TYPE(physicalConstant), PARAMETER :: BohrRadius_mks = physicalConstant( 5.291772108d0, -11 )
  
  TYPE(physicalConstant), PARAMETER :: eV_cgs = physicalConstant( 1.60217653d0, -12 )
  TYPE(physicalConstant), PARAMETER :: eV_mks = physicalConstant( 1.60217653d0, -19 )
  
  TYPE(physicalConstant), PARAMETER :: speedOfLight_cgs = physicalConstant( 2.9979d0, 10 )
  
  TYPE(physicalConstant), PARAMETER :: frequency_cgs = physicalConstant( 1.519266894, 15 )  ! eV / hbar
  TYPE(physicalConstant), PARAMETER :: frequency_mks = physicalConstant( 1.519266894, 15 )  ! eV / hbar
  
  TYPE(physicalConstant), PARAMETER :: Hartree_eV = physicalConstant(27.211396, 0)
  
  TYPE(physicalConstant), PARAMETER :: positionFactor_cgs = physicalConstant( 1.439965d0, -7 ) ! hbar^2/(m a0 eV)
  TYPE(physicalConstant), PARAMETER :: positionFactor_mks = physicalConstant( 1.439965d0, -9 ) ! 
  
  TYPE(physicalConstant), PARAMETER :: genPositionFactor_cgs = physicalConstant( 2.073499d0, -14 ) ! like position squared
  
  TYPE(physicalConstant), PARAMETER :: velocityFactor_cgs = physicalConstant( 2.1875724d0, 8 ) ! hbar / (m a0)
  TYPE(physicalConstant), PARAMETER :: velocityFactor_mks = physicalConstant( 2.1875724d0, 6 ) !
  
  TYPE(physicalConstant), PARAMETER :: momentumFactor_cgs = physicalConstant( 1.9928543d0, -19 ) ! hbar / a0
  TYPE(physicalConstant), PARAMETER :: momentumFactor_mks = physicalConstant( 1.9928543d0, -24 ) ! hbar / a0
  
  TYPE(physicalConstant), PARAMETER :: spinFactor_cgs = hbar_cgs
  
  TYPE(physicalConstant), PARAMETER :: eps0_mks = physicalConstant( 8.85417818, -12 )
  
  PUBLIC :: OPERATOR(*)
  PUBLIC :: OPERATOR(/)
  PUBLIC :: OPERATOR(**)
  
  INTERFACE OPERATOR(*)
     MODULE PROCEDURE multiply
  END INTERFACE
  
  INTERFACE OPERATOR(/)
     MODULE PROCEDURE divide
  END INTERFACE
  
  INTERFACE OPERATOR (**)
     MODULE PROCEDURE pow
  END INTERFACE
  
CONTAINS
  
  FUNCTION makeDouble( physConst )
    REAL(DP) :: makeDouble
    TYPE(physicalConstant), INTENT(IN) :: physConst
    makeDouble = physConst%significand * (10.d0**(physConst%exponent))
  END FUNCTION makeDouble
  
  FUNCTION makePhysicalConstant( realNumber )
    TYPE(physicalConstant) :: makePhysicalConstant
    REAL(DP), INTENT(IN) ::realNumber
    REAL(DP) :: rtmp1
    INTEGER :: itmp1
    
    rtmp1 = LOG10(realNumber)
    itmp1 = FLOOR(rtmp1)
    makePhysicalConstant%exponent = itmp1
    rtmp1 = realNumber / 10**itmp1
    makePhysicalConstant%significand = rtmp1
  END FUNCTION makePhysicalConstant
    
  FUNCTION multiply( physConst1, physConst2)
    TYPE(physicalConstant) :: multiply
    TYPE(physicalConstant), INTENT(IN) :: physConst1, physConst2
    multiply%significand = physConst1%significand * physConst2%significand
    multiply%exponent = physConst1%exponent + physConst2%exponent
  END FUNCTION multiply
  
  FUNCTION pow( physConst, exponent)
    TYPE(physicalConstant) :: pow
    TYPE(physicalConstant), INTENT(IN) :: physConst
    INTEGER, INTENT(IN) :: exponent
    pow%significand = (physConst%significand)**exponent
    pow%exponent = exponent * physConst%exponent
  END FUNCTION pow
  
  FUNCTION divide( physConst1, physConst2)
    TYPE(physicalConstant) :: divide
    TYPE(physicalConstant), INTENT(IN) :: physConst1, physConst2
    divide%significand = physConst1%significand / physConst2%significand
    divide%exponent = physConst1%exponent - physConst2%exponent
  END FUNCTION divide
  
!!!############################
END MODULE PhysicalConstantsMod
!!!############################
