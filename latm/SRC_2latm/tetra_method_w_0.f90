!!!#########
PROGRAM LATM
!!!#########
  USE globals
!!!  USE energy_mesh
  IMPLICIT NONE
  INTEGER :: j, iTmp1
!!! variables for final output
  INTEGER :: iEnergy
  REAL(DP) :: energy
  REAL(DP), ALLOCATABLE :: pp(:)
! 
  REAL(DP) :: total
  REAL(DP) :: cornTrans(4), fh
  INTEGER :: flag1, ibug1
  REAL*8 :: p(4)
  REAL*8 :: e21, e31, e42, de
! pp is the total contribution at one energy for one transition.
  CHARACTER(LEN=4) :: int2cha
  REAL*8 :: S1, S2, S3, S4
  INTEGER :: iTetra, iTrans, ic, iv
  INTEGER :: iostat
  INTEGER :: deltaFunctionFactor
  
  CALL getarg(1,paramFile)
!!! don't change the order of below calls  
  CALL readParamFile
  CALL Allocate_Global_Arrays
  CALL Transition_Index
  CALL Load_Tetrahedra_Data
  CALL Which_Tetrahedra
!!!
!!! for response 1(2)-omega deltaFunctionFactor=1(2)
!!! chose the appropriate value in inparams.f90@subroutine deltaFactor
!!!
  CALL deltaFactor(deltaFunctionFactor)
  write(6,*)'tetra_method_w_0.f90: deltaFunctionFactor= ',deltaFunctionFactor
!!!
  CALL Load_Transition_Energies(deltaFunctionFactor)
  CALL Which_Transitions
  CALL Load_Integrand(deltaFunctionFactor)
  CALL Load_Energy_Mesh
!!! don't change the order of above calls  
  
  WRITE(6,*) 'tetra_method_w_0.f90: Total transitions@LATM= ', nTrans
  WRITE(*,*) 'tetra_method_w_0.f90: tetrahedron MAIN started'
  WRITE(6,*) 'tetra_method_w_0.f90: prefactor@LATM: ', units_factor
  
  ALLOCATE(pp(nMax*nMax))
  pp = 0.d0  ! initialize pp !!!!! R E A L L Y   I M P O R T A N T
  ! cycle over valence and conduction levels
  DO iv = 1, nVal
     DO ic = nVal+1, nMax
        iTrans = ind_Trans(iv,ic)
        IF (includeTransition(iTrans)) THEN
           ! cycle over tetrahedra
           DO iTetra = 1, nTetra
              ! this determines if we want to include this tetrahedron in the
              ! calculation
              IF (includeTetrahedron(iTetra)) THEN
                 ! Get integrand at corners of tetrahedron
                 DO j = 1, 4
                    p(j) = f(tetCorner(iTetra,j), iTrans)
                 END DO
                 !!BMSVer3.1d mar/29/16
                 ! We average the value of the integrand for the 4 cornes of
                 ! the tetrahedron
                 pp(iTrans)=pp(iTrans)+ (SUM(p(1:4))/4.d0)*tetrahedronVolume(iTetra)
                 !!BMSver3.1u mar/29/16
              END IF     ! includeTetrahedron
           END DO     ! iTetra
        END IF     ! includeTransition
     END DO    ! ic
  END DO     ! iv
  ! output
  WRITE(6,*) 'opening: ', spectrum_filename_w_0
  OPEN(77,FILE=spectrum_filename_w_0)
  WRITE(77,99) SUM(pp(1:nMax*nMax))*units_factor
99 FORMAT(E15.7)
  CLOSE(77)
  WRITE(6,*) 'finish writing: ', spectrum_filename_w_0
!***************
END PROGRAM LATM
!***************

!##########################
SUBROUTINE Transition_Index
!##########################
  USE globals, ONLY : ind_Trans, nMax
  IMPLICIT NONE
  INTEGER iv, ic, iTrans
  
  iTrans=0
  DO iv = 1,nMax
     DO ic = 1,nMax
        iTrans = iTrans+1
        ind_Trans(iv,ic)=iTrans
     END DO
  END DO
  WRITE(6,*) 'Transition_Index DONE'
!!!****************************
END SUBROUTINE Transition_Index
!!!****************************

!!!############################
SUBROUTINE Load_Tetrahedra_Data
!!!############################
!!! Reads tetrahedra indices and tetrahedra volumes

  USE globals, ONLY : tetCorner, tetrahedronVolume, tet_list_filename
  USE globals, ONLY : includeTetrahedron
  USE globals, ONLY : nTetra
  USE globals, ONLY : DP, PI
  IMPLICIT NONE
  INTEGER :: file_nTetra, iTetra
  REAL(DP) :: tVolume
  REAL(DP), ALLOCATABLE :: tetrahedraWeight(:)
  
  WRITE(6,'(A10,A80)') 'opening: ', tet_list_filename
  OPEN (1,FILE = tet_list_filename,FORM = 'formatted',STATUS = 'old')
  READ (1,*) file_nTetra
!!!  IF (file_nTetra.NE.nTetra) THEN
!!!     WRITE(6,*) ' '
!!!     WRITE(6,*) 'Inconsistency of first line of', &
!!!          tet_list_filename, 'with internal value for nTetra'
!!!     WRITE(6,*) 'First line of', tet_list_filename, ' is ', file_nTetra
!!!     WRITE(6,*) 'Internal value of nTetra is ', nTetra
!!!     WRITE(6,*) 'STOPPING'
!!!     WRITE(6,*) ' '
!!!     STOP
!!!  END IF
  
  nTetra = file_nTetra
  
  ALLOCATE( tetrahedraWeight(nTetra) )
  ALLOCATE(includeTetrahedron(nTetra))
  ALLOCATE(tetrahedronVolume(nTetra))
  ALLOCATE(tetCorner(nTetra,4))

  tetCorner(:,:) = 0 ! initialize tetCorner array
  tetrahedronVolume(1:nTetra) = 0.d0 ! initialize tetVolume array
    
  DO iTetra = 1, nTetra
     ! New format, that has the real actual volume of the tetrahedron, in atomic
     ! units, not the relative volume
     READ(1,*)  tetCorner(iTetra,1:4), tetrahedraWeight(iTetra), &
          tetrahedronVolume(iTetra)
!!!     READ(1,*)  tetCorner(iTetra,1:4), tetrahedronVolume(iTetra)
!!!     WRITE(6,1001) tetCorner(iTetra,1:4), tetrahedronVolume(iTetra)
     tetrahedronVolume(iTetra) = tetrahedraWeight(iTetra) * &
          tetrahedronVolume(iTetra)/(8.d0*PI**3)
  END DO
1001 FORMAT(4I6,E18.8)
  CLOSE(1)
  
  !tVolume = SUM(tetrahedronVolume(1:nTetra))
!!!   For old format, check that relative volumes add up to 1.
  !IF (ABS(tVolume-1.d0).GT.1d-6) THEN
  !   STOP 'Tetrahedra volumes do not add to one'
  !ELSE
  !   WRITE(6,*) 'Tetrahedra volumes add to ', tVolume
  !END IF
  
  DEALLOCATE( tetrahedraWeight )
  
  WRITE(6,*) 'Load_Tetrahedra_Data DONE'
!!!********************************
END SUBROUTINE Load_Tetrahedra_Data
!!!********************************

!!!########################
SUBROUTINE Which_Tetrahedra
!!!########################
!!! specify which tetrahedra to include in the calculation
  USE globals
  IMPLICIT NONE
  INTEGER :: iTetra
  
!!! Initialize all as false
  includeTetrahedron(1:nTetra) = .false.
  
!!! Initialize all as true
  includeTetrahedron(1:nTetra) = .true.
  
  !! dihydride surface 81 kpts include gamma point only
  !! includeTetrahedron(1:3) = .true.
  !! includeTetrahedron(91:96) = .true.

  WRITE(6,*) 'Which_Tetrahedra DONE'
!!!****************************
END SUBROUTINE Which_Tetrahedra
!!!****************************

!!!##################################
SUBROUTINE Load_Transition_Energies(deltaFunctionFactor)
!!!##################################
  USE constants, ONLY: DP
  USE globals, ONLY: ind_Trans,energys_data_filename, kMax, nMax
  USE globals, ONLY: Transition_Energy
  IMPLICIT NONE
  REAL(DP) :: rdummy, edifference
  REAL(DP), ALLOCATABLE :: energy(:,:)
  INTEGER :: file_ik, iband, iv, ic, ik, iTrans, istat, ios
  INTEGER :: deltaFunctionFactor
  
  WRITE(6,*) 'subroutine Load_Transition_Energies started'
  WRITE(6,*) 'deltaFunctionFactor= ',deltaFunctionFactor
  
  ALLOCATE(energy(kMax,nMax),STAT=istat)
  
  IF (istat /= 0) THEN
     WRITE(6,*) ' '
     WRITE(6,*) ' Could not allocate array energy(:,:)'
     WRITE(6,*) ' Error code is', istat
     WRITE(6,*) ' Stopping '
     WRITE(6,*) ' '
     STOP
  END IF
  
  WRITE(6,'(A10,A80)') 'opening: ', energys_data_filename
  OPEN (1, FILE = energys_data_filename, &
       FORM = 'FORMATTED', STATUS = 'OLD', IOSTAT=ios)
  IF (ios /=0 ) THEN
     WRITE(6,*) ' '
     WRITE(6,*) ' Could not open file ', energys_data_filename
     WRITE(6,*) ' Error code is ', istat
     WRITE(6,*) ' Stopping '
     WRITE(6,*) ' '
     STOP
  END IF
  DO ik = 1, kMax
     READ (UNIT=1,FMT=*,IOSTAT=ios) file_ik, energy(ik,1:nMax)
     IF (file_ik.NE.ik) THEN
        WRITE(6,*) 'ERROR IN Load_transitions file_ik .ne. ik'
        STOP
     END IF
     DO iband = 1, nMax-1
        IF (energy(ik,iband+1).LT.energy(ik,iband)) THEN
           WRITE(*,*) ik, iband
           PAUSE 'ENERGY OUT OF ORDER'
        END IF
     END DO
  END DO
  CLOSE(1)
  
!!!  WRITE(6,*) 'Transitions energies between HOVB and LUCB'
!!!  WRITE(6,*) energy(1:kMax,nVal+1)-energy(1:kMax,nVal)
  
!!! cycle over energy differences to make transitions
  
  DO ik = 1, kmax
     DO iv = 1, nMax
        DO ic = 1, nMax
           iTrans = ind_Trans(iv,ic)
           edifference = energy(ik,ic) - energy(ik,iv)
           Transition_Energy(ik,iTrans) = edifference/REAL(deltaFunctionFactor)
        END DO
     END DO
  END DO
  
  WRITE(6,*) 'Load_Transition_Energies DONE'
!!!************************************
END SUBROUTINE Load_Transition_Energies
!!!************************************

!!!###########################
SUBROUTINE Which_Transitions
!!!###########################
!!! determine which transition to include in the calculation
  USE globals, ONLY: ind_Trans, nMax, nVal, nMax_tetra, nVal_tetra
  USE globals, ONLY: includeTransition
  IMPLICIT NONE
  INTEGER :: iTrans, iv, ic, low_band, high_band
!!! Dic 6 2011 bms
  integer :: includeValenceBands(1000)
  integer :: includeConductionBands(1000)
  INTEGER :: opt,Nv,Nc
!!!
  OPEN(69, FILE="opt.dat")
  read(69,*)opt,Nv,Nc
!!! selects all valence bands to all conduction bands from Nv+1...Nc 
  if ( opt.eq.1 ) then
     includeValenceBands(:)=1
     includeConductionBands(:)=1
  end if
!!! selects from a given valence band to a given conduction band 
  if ( opt.eq.2 ) then
     includeValenceBands(:)=0
     includeConductionBands(:)=0
     includeValenceBands(Nv)=1
     includeConductionBands(Nc)=1
  end if
  
  DO iv = 1, nMax
     DO ic = 1, nMax
        iTrans = ind_Trans(iv,ic)
        includeTransition(iTrans)=.false.
     END DO
  END DO
  low_band = nVal + 1 - nVal_tetra
  high_band = nVal + nMax_tetra
  DO iv = low_band, nVal
     DO ic = nVal+1, high_band
        IF (includeValenceBands(iv).eq.1) THEN
           IF (includeConductionBands(ic).eq.1) THEN
              includeTransition(ind_Trans(iv,ic))=.true.
           END IF
        END IF
     END DO
  END DO

  WRITE(6,*) 'Which_Transitions DONE'
!!!*****************************
END SUBROUTINE Which_Transitions
!!!*****************************

!!!######################
SUBROUTINE Load_Integrand(deltaFunctionFactor)
!!!######################
  USE globals, ONLY: ind_Trans, kMax, nVal, nMax, units_factor
  USE globals, ONLY: integrand_filename_w_0, f
!!!  USE globals, ONLY: optical_property
  IMPLICIT NONE
  INTEGER  :: ik, iTrans, iv, ic
  CHARACTER(LEN=3) :: ADV_opt
  INTEGER :: read_status
  INTEGER :: deltaFunctionFactor
!!!  IF (optical_property.EQ.0) THEN
!!!     WRITE(6,*) 'Calculating joint so not loading integrand'
!!!     f(:,:) = 1.d0
!!!  ELSE

  write(6,*)'tetra_method_w_0.f90: deltaFunctionFactor@Load_Integrand ',deltaFunctionFactor

  WRITE(6,'(A10,A80)') 'opening: ', integrand_filename_w_0
  OPEN(1, FILE = integrand_filename_w_0, STATUS = "old")
  READ(UNIT=1,FMT=*) units_factor
  WRITE(6,*) 'Overall factor : ', units_factor 
  DO ik = 1, kMax
!!!        WRITE(6,*) ik
     DO iv = 1, nVal
        DO ic = nVal+1, nMax
           IF (ic==nMax) THEN
              ADV_opt = "YES"
           ELSE
              ADV_opt = "NO"
           END IF
           iTrans=ind_Trans(iv,ic)
           IF (ic==nMax) THEN
              READ(UNIT=1,FMT='(E15.7)',ADVANCE="YES",&
                   IOSTAT=read_status) f(ik,iTrans)
                f(ik,iTrans) = f(ik,iTrans) !/ REAL(deltaFunctionFactor)
           ELSE
              READ(UNIT=1,FMT='(E15.7)',ADVANCE="NO",&
                   IOSTAT=read_status) f(ik,iTrans)
              f(ik,iTrans) = f(ik,iTrans) !/ REAL(deltaFunctionFactor)
           END IF
           IF (read_status.GT.0) THEN
              WRITE(6,*) 'Error in Load_integrand'
              WRITE(6,*) read_status, ik, ic, iv, iTrans
              STOP
           ELSE IF(read_status==-1) THEN
              WRITE(6,*) ik, iv, ic
              WRITE(6,*) 'End of file', integrand_filename_w_0
           ELSE IF(read_status.LT.-1) THEN
              WRITE(6,*) read_status
              WRITE(6,*) 'Strange Error: Load Integrand'
              STOP
           END IF
           ! WRITE(6,*) ik, iTrans, f(ik,iTrans)
        END DO
     END DO
  END DO
  CLOSE(1)
  !  END IF
  WRITE(6,*) 'Load_Integrand DONE'
!!!**************************
END SUBROUTINE Load_Integrand
!!!**************************

!!!########################
SUBROUTINE Load_Energy_Mesh
!!!########################
  USE globals
  IMPLICIT NONE
  REAL(DP) :: eStepsize
  INTEGER :: i
  eStepsize = (energy_Max-energy_Min)/(energy_Steps-1)
  DO i=1, energy_Steps
     energy_Out(i) = energy_Min+DFLOAT(i-1)*eStepSize
  END DO
  WRITE(6,*) 'Load_Energy_Mesh DONE'
!!!****************************
END SUBROUTINE Load_Energy_Mesh
!!!****************************

