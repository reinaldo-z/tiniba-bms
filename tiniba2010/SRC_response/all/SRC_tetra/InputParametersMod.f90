!!!######################
MODULE InputParametersMod
!!!######################
  
  USE ConstantsMod, ONLY : DP, pi
  
  IMPLICIT NONE
  INTEGER :: nMaxCC        !! Partial number total  bandas  


  INTEGER :: nVal          ! number of valence bands
  INTEGER :: nMax          ! total number of bands
  INTEGER :: nVal_tetra    ! number of valence bands in tetra_method
  INTEGER :: nMax_tetra    ! total number of bands in tetra_method
  INTEGER :: kMax          ! number of kpoints
  INTEGER :: nTetra         ! number of tetrahedra
  INTEGER :: nTrans          ! number of transitions
  
  CHARACTER(LEN=80) :: paramFile
  
  CHARACTER(LEN=80) ::  energy_data_filename  ! energy input file
  CHARACTER(LEN=80) ::  energys_data_filename ! scissored energy file
  CHARACTER(LEN=80) ::  half_energys_data_filename ! scissored energy times 0.5 file
  
  REAL(DP) :: units_factor
  
  INTEGER :: deltaFunctionFactor
  
  ! FILES ONLY FOR TETRAHEDRON METHOD
  CHARACTER(LEN=80) :: tet_list_filename
  CHARACTER(LEN=80) :: integrand_filename
  CHARACTER(LEN=80) :: spectrum_filename
  
  ! ENERGY MESH
  REAL(DP) :: energyMin
  REAL(DP) :: energyMax
  INTEGER  :: energySteps
  
!!!##########################
END MODULE InputParametersMod
!!!##########################
