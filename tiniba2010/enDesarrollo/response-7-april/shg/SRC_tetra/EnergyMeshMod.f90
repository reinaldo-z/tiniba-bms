!!!#################
MODULE EnergyMeshMod
!!!#################
  USE ConstantsMod, ONLY : DP
  
  IMPLICIT NONE
  
  REAL(DP), ALLOCATABLE :: energyOut(:)         ! output energy mesh
  
CONTAINS
  
!!!##########################
  SUBROUTINE Load_Energy_Mesh
!!!##########################
    USE InputParametersMod, ONLY : energyMax
    USE InputParametersMod, ONLY : energyMin
    USE InputParametersMod, ONLY : energySteps
    IMPLICIT NONE
    REAL(DP) :: eStepsize
    INTEGER :: i
    
    ALLOCATE(energyOut(energySteps))
    
    eStepsize = (energyMax-energyMin)/(energySteps-1)
    DO i=1, energySteps
       energyOut(i) = DFLOAT(i-1)*eStepSize
    END DO
    WRITE(6,*) 'Load_Energy_Mesh DONE'
!!!##############################
  END SUBROUTINE Load_Energy_Mesh
!!!##############################
  
  
!!!#####################
END MODULE EnergyMeshMod
!!!#####################
