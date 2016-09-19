!!!#########################
MODULE SpectrumParametersMod
!!!#########################
  
  USE ConstantsMod, ONLY : DP
  USE ConstantsMod, ONLY : pi
  
  IMPLICIT NONE
  
  CHARACTER(LEN=255) :: spectrumFile
  
  INTEGER :: number_of_spectra_to_calculate
  
  TYPE spectrum
     CHARACTER(LEN=80) :: integrand_filename
     INTEGER :: integrand_filename_unit
     INTEGER :: spectrum_type
     ! 1 ImChi1
     LOGICAL :: compute_integrand
     INTEGER, POINTER :: spectrum_tensor_component(:)
     REAL(DP), POINTER :: transformation_elements(:)
  END TYPE spectrum
  
  TYPE(spectrum), ALLOCATABLE :: spectrum_info(:)
  
!!!*****************************
END MODULE SpectrumParametersMod
!!!*****************************
