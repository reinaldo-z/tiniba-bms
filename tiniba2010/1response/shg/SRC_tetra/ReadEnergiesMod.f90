!!!###################
MODULE ReadEnergiesMod
!!!###################
  USE ConstantsMod, ONLY: DP
  
  IMPLICIT NONE
  
  REAL(DP), ALLOCATABLE :: transitionEnergy(:,:)! transition energies
  
  REAL(DP), PRIVATE, ALLOCATABLE :: energy_in(:,:)
  
CONTAINS
  
!!!#######################
  SUBROUTINE Read_Energies
!!!#######################
    USE InputParametersMod, ONLY : kMax
    USE InputParametersMod, ONLY : nMax
    USE InputParametersMod, ONLY : nVal
    USE InputParametersMod, ONLY : nMax_tetra
    USE InputParametersMod, ONLY : nVal_tetra
    USE InputParametersMod, ONLY : energys_data_filename
    USE InputParametersFileMod, ONLY : kMax_set
    USE InputParametersFileMod, ONLY : nMax_set
    USE InputParametersFileMod, ONLY : nVal_set
    USE InputParametersFileMod, ONLY : nMax_tetra_set
    USE InputParametersFileMod, ONLY : nVal_tetra_set
    
    IMPLICIT NONE
    
    INTEGER :: file_kMax
    INTEGER :: file_nVal
    INTEGER :: file_nCon
    INTEGER :: file_ik
    INTEGER :: iband
    INTEGER :: iv
    INTEGER :: ic
    INTEGER :: ik
    INTEGER :: iTrans
    INTEGER :: istat
    INTEGER :: ios
    
    WRITE(*,*) 'Entering subroutine Read_Energies'
    
    WRITE(*,'(A14,A80)') 'Opening file: ', energys_data_filename
    OPEN (UNIT=1, FILE = energys_data_filename, &
         FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT=ios)
    IF (ios /=0 ) THEN
       WRITE(*,*) ' '
       WRITE(*,*) ' Could not open file ', energys_data_filename
       WRITE(*,*) ' Error code is ', istat
       WRITE(*,*) ' Stopping '
       WRITE(*,*) ' '
       STOP
    END IF
    
    READ (1,FMT=*) file_kMax
    WRITE(*,FMT='(A,A,I8)') "Read kMax from file ", TRIM(energys_data_filename), file_kMax
    IF (kMax_set) THEN
       IF (.NOT.(file_kMax.EQ.kMax)) THEN
          WRITE(*,*) "Error: kMax from input file differs from kMax in energy file"
          STOP "Error with input parameters kMax"
       END IF
    ELSE
       kMax = file_kMax
       kMax_set = .TRUE.
    END IF
    
    READ(1,*) file_nVal
    WRITE(*,FMT='(A,A,I8)') "Read nVal from file ", TRIM(energys_data_filename), file_nVal
    IF (nVal_set) THEN
       IF (file_nVal.NE.nVal) THEN
          WRITE(*,*) "Error: nVal from input file differs from nVal in energy file"
          STOP "Error with input parameters nVal"
       END IF
    ELSE
       nVal = file_nVal
       nVal_set = .TRUE.
    END IF
    
    READ(1,*) file_nCon
    WRITE(*,FMT='(A,A,I8)') "Read nMax from file ", TRIM(energys_data_filename), file_nCon+nVal
    IF (nMax_set) THEN
       IF ((file_nCon+file_nVal).NE.nMax) THEN
          WRITE(*,*) "Error: nMax from input file differs from nMax in energy file"
          STOP "Error with input parameters nMax"
       END IF
    ELSE
       nMax = file_nCon+file_nVal
       nMax_set = .TRUE.
    END IF
    
    IF (.NOT.nVal_tetra_set) THEN
       nVal_tetra = nVal
       nVal_tetra_set = .TRUE.
    END IF
    
    IF (.NOT.nMax_tetra_set) THEN
       nMax_tetra = nMax - nVal
       nVal_tetra_set = .TRUE.
    END IF
    
    ALLOCATE( energy_in(kMax,nMax),STAT=istat )
    IF (istat /= 0) THEN
       WRITE(*,*) ' '
       WRITE(*,*) ' Could not allocate array energy_in(:,:)'
       WRITE(*,*) ' Error code is', istat
       WRITE(*,*) ' Stopping '
       WRITE(*,*) ' '
       STOP
    END IF
    
    DO ik = 1, kMax
       READ (UNIT=1,FMT=*,IOSTAT=ios) file_ik, energy_in(ik,1:nMax)
       IF (file_ik.NE.ik) THEN
          WRITE(*,*) 'ERROR IN Load_transitions file_ik .ne. ik'
          STOP
       END IF
       
       ! check that energies are in increasing order
       DO iband = 1, nMax-1
          IF (energy_in(ik,iband+1).LT.energy_in(ik,iband)) THEN
             WRITE(*,*) ik, iband
             PAUSE 'ENERGY OUT OF ORDER'
          END IF
       END DO
    END DO
    CLOSE(1)
    
    WRITE(*,*) 'Leaving subroutine Read_Energies'
!!!###########################
  END SUBROUTINE Read_Energies
!!!###########################
  
!!!#######################
  SUBROUTINE scaleEnergies
!!!#######################
    USE InputParametersMod, ONLY : kMax
    USE InputParametersMod, ONLY : nMax
    USE InputParametersMod, ONLY : deltaFunctionFactor
    INTEGER :: iband
    INTEGER :: ik 
    
    WRITE(*,*) 'Entering subroutine scaleEnergies'
    
    DO ik = 1, kMax    
       DO iband = 1, nMax-1       
          energy_in(ik,iband) = energy_in(ik,iband) / REAL(deltaFunctionFactor)
       END DO
    END DO
    
    WRITE(*,*) 'Leaving subroutine scaleEnergies'    
    
!!!###########################
  END SUBROUTINE scaleEnergies
!!!###########################
  
!!!##################################
  SUBROUTINE Load_Transition_Energies
!!!##################################
    USE ConstantsMod, ONLY : DP
    USE TransitionsMod, ONLY : ind_Trans
    USE InputParametersMod, ONLY : kMax, nMax, nVal
    
    IMPLICIT NONE
    
    INTEGER :: ik, iv, ic, iTrans
    REAL(DP) :: edifference
    
!!! cycle over energy differences to make transitions
    
    WRITE(*,*) 'Entering subroutine Load_Transition_Energies'
    
    ALLOCATE(transitionEnergy(kMax,nMax*nMax))
    
    DO ik = 1, kmax
       DO iv = 1, nMax
          DO ic = 1, nMax
             iTrans = ind_Trans(iv,ic)
             edifference = energy_in(ik,ic) - energy_in(ik,iv)
             ! WRITE(6,*) ik, iv, ic
             TransitionEnergy(ik,iTrans) = edifference
          END DO
       END DO
    END DO
    
    DEALLOCATE(energy_in)
    
    WRITE(*,*) 'Leaving subroutine Load_Transition_Energies'
    
!!!######################################
  END SUBROUTINE Load_Transition_Energies
!!!######################################
  
!!!#######################
END MODULE ReadEnergiesMod
!!!#######################
