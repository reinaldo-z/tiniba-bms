MODULE constants
  IMPLICIT NONE
  INTEGER, PARAMETER :: SP = KIND(1.0)            ! single precision
  INTEGER, PARAMETER :: DP = KIND(1.0D0)          ! double precision
  INTEGER, PARAMETER :: SPC = KIND((1.0,1.0))     ! single precision complex
  INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
END MODULE constants

