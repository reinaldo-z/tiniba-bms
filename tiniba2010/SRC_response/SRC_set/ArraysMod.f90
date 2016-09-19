!!!#############
MODULE ArraysMod
!!!#############
  USE ConstantsMod, ONLY : DP, DPC
  USE DebugMod, ONLY : debug
  
  USE InputParametersMod, ONLY : oldStyleScissors
  
  USE InputParametersMod, ONLY : nVal
  USE InputparametersMod, ONLY : nMax
  USE InputParametersMod, ONLY : nSym
  USE InputParametersMod, ONLY : kMax
  USE InputParametersMod, ONLY : nVal
  USE InputParametersMod, ONLY : nMax
  USE InputParametersFileMod, ONLY : kMax_set
  USE InputParametersFileMod, ONLY : nVal_set
  USE InputParametersFileMod, ONLY : nMax_set
  USE InputParametersMod, ONLY : scissor
  USE InputParametersMod, ONLY : actual_band_gap
  USE InputParametersFileMod, ONLY : actual_band_gap_set
  USE InputParametersMod, ONLY : tol
  USE InputParametersMod, ONLy : crystal_class
  USE InputParametersMod, ONLY : energy_data_filename
  USE InputParametersMod, ONLY : energys_data_filename
  USE InputParametersMod, ONLY : pmn_data_filename
  USE InputParametersMod, ONLY : rmn_data_filename
  USE InputParametersMod, ONLY : der_data_filename
  USE InputParametersMod, ONLY : smn_data_filename
  USE InputParametersMod, ONLY : nSpinor
  
  IMPLICIT NONE
  
  COMPLEX(DPC), ALLOCATABLE :: momMatElem(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: posMatElem(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: derMatElem(:,:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: pderMatElem(:,:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: spiMatElem(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: magMatElem(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: Delta(:,:,:)
  REAL(DP), ALLOCATABLE :: energy(:,:), energys(:,:)
  REAL(DP), ALLOCATABLE :: band(:)   ! is actually all band energies
!!!                                  ! for a given kpoint
  INTEGER, PARAMETER :: tolchoice = 0
CONTAINS
  
!!!########################
  SUBROUTINE allocateArrays
!!!########################
    IMPLICIT NONE
    INTEGER :: istat
    
    IF (debug) WRITE(*,*) "Program Flow: entered allocateArrays"
    
    ALLOCATE (momMatElem(3,nMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate momMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    ALLOCATE (posMatElem(3,nMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate posMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    ALLOCATE (derMatElem(3,3,nMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate derMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    ALLOCATE (pderMatElem(3,3,nMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate pderMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    ALLOCATE (Delta(3,nMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energy'
       WRITE(6,*) 'Stopping'
    END IF
    
    !
    ! Moved ALLOCATE(energy) and ALLOCATE(energys)
    ! to readEnergyFile subroutine
    ! 
    
    ALLOCATE (band(nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    
    IF (nSpinor == 2) THEN
       ALLOCATE (spiMatElem(3,nMax,nMax), STAT=istat)
       IF (istat.NE.0) THEN
          WRITE(6,*) 'Could not allocate spiMatElem'
          WRITE(6,*) 'Stopping'
       END IF
       
       ALLOCATE (magMatElem(3,nMax,nMax), STAT=istat)
       IF (istat.NE.0) THEN
          WRITE(6,*) 'Could not allocate magMatElem'
          WRITE(6,*) 'Stopping'
       END IF
       
    END IF
    
    IF (debug) WRITE(*,*) "Program Flow: exiting allocateArrays"
    
!!!############################
  END SUBROUTINE allocateArrays
!!!############################
  
!!!##########################
  SUBROUTINE deallocateArrays
!!!##########################
    IMPLICIT NONE
    INTEGER :: istat
    DEALLOCATE (momMatElem, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate momMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (posMatElem, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate posMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (derMatElem, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate derMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (pderMatElem, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate pderMatElem'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (Delta, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate energy'
       WRITE(6,*) 'Stopping'
    END IF
    DEALLOCATE (energy, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (energys, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate energys'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    DEALLOCATE (band, STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not deallocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    
    IF (nSpinor == 2) THEN
       DEALLOCATE (spiMatElem, STAT=istat)
       IF (istat.NE.0) THEN
          WRITE(6,*) 'Could not deallocate spiMatElem'
          WRITE(6,*) 'Stopping'
       END IF
    END IF
    
!!!##############################
  END SUBROUTINE deallocateArrays
!!!##############################
  
!!!########################
  SUBROUTINE readEnergyFile
!!!########################
    IMPLICIT NONE
    INTEGER :: ik, i, istat
    INTEGER :: file_kMax
    INTEGER :: file_nVal
    INTEGER :: file_nCon
    INTEGER :: file_ik
    
               WRITE(*,*) "===================================="
               WRITE(*,*) "subroutine readEnergyFile()"
    IF (debug) WRITE(*,*) "Program Flow: entered readEnergyFile"
               WRITE(*,*) "===================================="
    OPEN(UNIT=10, FILE=energy_data_filename, STATUS='OLD', IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) "Could not open file ", TRIM(energy_data_filename)
       WRITE(6,*) "Stopping"
       STOP
    ELSE
       WRITE(6,*) 'Opened file: ', TRIM(energy_data_filename)
    END IF

    OPEN(UNIT=69, FILE='info_shg', STATUS='OLD', IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) "Could not open file info_shg"
       WRITE(6,*) "Stopping"
       STOP
    ELSE
       WRITE(6,*) 'Opened file: info_shg'
    END IF
    
    READ(69,*) file_kMax
    WRITE(*,FMT='(A,A,I8)') "Read kMax from file ", TRIM(energy_data_filename), file_kMax
    IF (kMax_set) THEN
       IF (file_kMax.NE.kMax) THEN
          WRITE(*,*) "Error: kMax from input file differs from kMax in energy file"
          WRITE(*,*) "kMax=",Kmax
          WRITE(*,*) "kMax_set=",Kmax_set
          STOP "Error with input parameters kMax"
       END IF
    ELSE
       kMax = file_kMax
       kMax_set = .TRUE.
    END IF
    
    READ(69,*) file_nVal
    WRITE(*,FMT='(A,A,I8)') "Read nVal from file ", TRIM(energy_data_filename), file_nVal
    IF (nVal_set) THEN
       IF (file_nVal.NE.nVal) THEN
          WRITE(*,*) "Error: nVal from input file differs from nVal in energy file"
          STOP "Error with input parameters nVal"
       END IF
    ELSE
       nVal = file_nVal
       nVal_set = .TRUE.
    END IF
    
    READ(69,*) file_nCon
    WRITE(*,FMT='(A,A,I8)') "Read nMax from file ", TRIM(energy_data_filename), file_nCon+nVal
    IF (nMax_set) THEN
       IF ((file_nCon+file_nVal).NE.nMax) THEN
          WRITE(*,*) "Error: nMax from input file differs from nMax in energy file"
          STOP "Error with input parameters nMax"
       END IF
    ELSE
       nMax = file_nCon+file_nVal
       nMax_set = .TRUE.
    END IF
    
    ALLOCATE (energy(kMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    ALLOCATE (energys(kMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energys'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    
    DO ik = 1, kMax
       READ(UNIT=10,FMT=*, IOSTAT=istat) file_ik, (energy(ik,i), i = 1, nMax)
       IF (istat.EQ.0) THEN
          IF ((ik<11).OR.(MOD(ik,100).EQ.0).OR.(ik.EQ.kMax)) THEN
             WRITE(6,*) ik, file_ik
          END IF
!!!       IF (ik.NE.fik) THEN
!!!          WRITE(6,*) ik, fik, energy(ik,1:nMax)
!!!          WRITE(6,*) 'PROBLEM'
!!!          STOP
!!!       END IF
       ELSE IF (istat.EQ.-1) THEN
          WRITE(6,*) 'Prematurely reached end of file ', TRIM(energy_data_filename)
          WRITE(6,*) 'Stopping'
          STOP
       ELSE IF (istat.EQ.1) THEN
          WRITE(6,*) 'Problem reading file', TRIM(energy_data_filename)
          WRITE(6,*) 'Stopping'
          STOP
       ELSE
          WRITE(6,*) 'Unexpected error reading file', TRIM(energy_data_filename)
          WRITE(6,*) 'IOSTAT error is: ', istat
       END IF
    END DO
    
    READ(UNIT=10,FMT=*, IOSTAT=istat) file_ik
    IF (istat.EQ.-1) THEN
       WRITE(*,*)
       WRITE(*,*) "Reached end of energy file ",TRIM(energy_data_filename)
       WRITE(*,*)
    ELSE
       ! File did not end
       WRITE(*,*) 
       WRITE(*,*) "Energy file ", TRIM(energy_data_filename), " was not at End Of File"
       WRITE(*,*) "Stopping"
       STOP
    END IF
    CLOSE(UNIT=10)
    
    IF (debug) WRITE(*,*) "Program Flow: exiting readEnergyFile"
    
!!!############################
  END SUBROUTINE readenergyfile
!!!############################
  
!!!#########################
  SUBROUTINE scissorEnergies
!!!#########################
    IMPLICIT NONE
    INTEGER :: ik, i, istat
    DOUBLE PRECISION :: unscissored_band_gap
    DOUBLE PRECISION :: highest_valence_energy
    DOUBLE PRECISION :: direct_gap
    INTEGER :: direct_gap_kpoint
    
    IF(debug) WRITE(*,*) "Program Flow: entered scissorEnergies"
    WRITE(*,*) "===================================="
    WRITE(*,*) "subroutine scissorEnergies()"
    WRITE(*,*) "===================================="
    ! find indirect gap
    
    highest_valence_energy = MAXVAL(energy(:,nVal))
    
    unscissored_band_gap = MINVAL(energy(:,nVal+1)) - highest_valence_energy
    
    WRITE(*,*) 'Unscissored band gap is (direct or indirect): ', unscissored_band_gap
    
    ! find direct gap
    direct_gap_kpoint = 0.d0
    direct_gap = 999.0d9
    DO ik=1,kMax
       IF ((energy(ik,nVal+1)-energy(ik,nVal)).LT.direct_gap) THEN
          direct_gap = energy(ik,nVal+1)-energy(ik,nVal)
          direct_gap_kpoint = ik
       END IF
    END DO
    IF (direct_gap_kpoint .EQ. 0) THEN
       STOP 'Error finding direct gap'
    END IF
    WRITE(*,*) "Direct gap found at k-point:", direct_gap_kpoint
    WRITE(*,*) "Direct gap found to be:", direct_gap
    
    IF ((actual_band_gap_set).AND.(actual_band_gap .LT. unscissored_band_gap)) THEN
       WRITE(*,*) "  Specified unscissored band gap is less than unscissored"
       WRITE(*,*) "  band gap.  This indicates an error.  Stopping"
       STOP "Specified unscissored band gap is less than unscissored band gap."
    END IF
    
    IF (actual_band_gap_set) THEN
       scissor = actual_band_gaP - unscissored_band_gap
    END IF
    
    OPEN(UNIT=14, FILE=energys_data_filename, STATUS='UNKNOWN', IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) "Error opening file ", TRIM(energys_data_filename)
       WRITE(6,*) "Stopping"
       STOP
    ELSE
       WRITE(6,*) 'Opened file: ', TRIM(energys_data_filename)
    END IF
    
    WRITE(14,*) kMax
    WRITE(14,*) nVal
    WRITE(14,*) nMax - nVal
    
    IF (nMax.GT.300) STOP 'nMax is greater than 200.  Must modify code. See soubroutine: scissorEnergies'
    DO ik = 1, kMax
       energys(ik,1:nVal) = energy(ik,1:nVal) - highest_valence_energy
       energys(ik,nVal+1:nMax) = energy(ik,nVal+1:nMax) + scissor - highest_valence_energy
       WRITE(UNIT=14,FMT=102) ik, (energys(ik,i), i = 1, nMax)
    END DO
102 FORMAT(I6,300F21.16)
    
    WRITE(6,*) 'Scissor Shift is ', scissor
    WRITE(6,*) 'Adjusted Band Gap is', unscissored_band_gap + scissor
    
    IF(debug) WRITE(*,*) "Program Flow: exiting scissorEnergies"
    
    CLOSE(14)
!!!#############################
  END SUBROUTINE scissorEnergies
!!!#############################
  
!!!#################
END MODULE ArraysMod
!!!#################
