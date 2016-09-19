MODULE SymmetryOperationsMod
!!!#########################
  USE DebugMod, ONLY : debug
  USE InputParametersMod, ONLY : DP, nSym
  USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate, spectrum_info
  USE SpectrumParametersMod, ONLY : spectrum
  IMPLICIT NONE
  REAL(DP), ALLOCATABLE :: SymOp(:,:,:)
  REAL(DP), ALLOCATABLE :: dSymOp(:)
  
CONTAINS
!!!##########################
  SUBROUTINE initializeSymOps
!!!##########################
    USE InputParametersMod, ONLY : crystal_class
    IMPLICIT NONE
    INTEGER :: i_spectra
    LOGICAL :: old_style_symmetries
    
    IF (debug) WRITE(*,*) "Program Flow: Entered initializeSymOps"
    
    CALL getSymOpsFromFile
    
       
    DO i_spectra=1,number_of_spectra_to_calculate
       SELECT CASE(spectrum_info(i_spectra)%spectrum_type)
       CASE(1)
          CALL transformationLinearResponse(i_spectra)
       CASE(21,22,26,27,28,29,30,60,61,62,63,64,65,80,81)
          CALL transformationSecondOrderResponse(i_spectra)
       CASE DEFAULT
          WRITE(6,*) 'Error in initializeSymOps:'
          WRITE(6,*) '   No tranformation for case i_spectra ', i_spectra,' is coded yet'
          WRITE(6,*) '   Stopping'
          STOP 'Error in initializeSymOps: spectrum_type is not coded yet'
       END SELECT
    END DO
    
!!!******************************
  END SUBROUTINE initializeSymOps
!!!******************************
  
  
!!!###########################
  SUBROUTINE getSymOpsFromFile
!!!###########################
    IMPLICIT NONE
    INTEGER :: ios, iSym
    
    OPEN(UNIT=89, FILE="Symmetries.Cartesian", STATUS="old", IOSTAT=ios)
    IF (ios.NE.0) THEN
       WRITE(*,*) "Could not open file Symmetries.Cartesian"
       WRITE(*,*) "Stopping"
       STOP "Stopping: Could not open file Symmetries.Cartesian"
    END IF
    READ(89,*) nSym
    WRITE(*,*) "Number of symmetry operations determined from file: ", nSym
    
    ALLOCATE(SymOp(nSym,3,3))
    ALLOCATE(dSymOp(nSym))
    
    DO iSym = 1, nSym
       READ(89,*) SymOp(iSym,1,1:3)
       READ(89,*) SymOp(iSym,2,1:3)
       READ(89,*) SymOp(iSym,3,1:3)
       
       IF (debug) THEN
          WRITE(*,*) SymOp(iSym,1,1:3), SymOp(iSym,2,1:3), SymOp(iSym,3,1:3)
       END IF
       
       dSymOp(iSym) = SymOp(iSym,1,1) * &
            ( SymOp(iSym,2,2)* SymOp(iSym,3,3)-SymOp(iSym,3,2)* SymOp(iSym,2,3) ) &
            - SymOp(iSym,1,2) * &
            ( SymOp(iSym,2,1)* SymOp(iSym,3,3)-SymOp(iSym,3,1)* SymOp(iSym,2,3) ) &
            + SymOp(iSym,1,3) * &
            ( SymOp(iSym,2,1)* SymOp(iSym,3,2)-SymOp(iSym,3,1)* SymOp(iSym,2,2) )
       
    END DO
    
    CLOSE(89)
!!!*******************************
  END SUBROUTINE getSymOpsFromFile
!!!*******************************
  
  
!!$!!!####################
!!$  SUBROUTINE znblSymOps
!!$!!!####################
!!$    IMPLICIT NONE
!!$    
!!$    ALLOCATE(SymOp(24,3,3))
!!$    ALLOCATE(dSymOp(24))
!!$    
!!$    SymOp(1,1,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(1,2,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(1,3,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    dSymOp(1) = 1.d0
!!$    ! 
!!$    SymOp(2,1,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(2,2,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(2,3,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    dSymOp(2) = 1.d0
!!$    !
!!$    SymOp(3,1,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(3,2,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(3,3,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    dSymOp(3) = 1.d0
!!$    !
!!$    SymOp(4,1,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(4,2,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(4,3,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    dSymOp(4) = 1.d0
!!$    !
!!$    SymOp(5,1,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(5,2,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(5,3,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    dSymOp(5) = 1.d0
!!$    !
!!$    SymOp(6,1,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(6,2,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(6,3,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    dSymOp(6) = -1.d0
!!$    !
!!$    SymOp(7,1,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(7,2,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(7,3,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    dSymOp(7) = -1.d0
!!$    !
!!$    SymOp(8,1,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(8,2,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(8,3,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    dSymOp(8) = -1.d0
!!$    !
!!$    SymOp(9,1,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(9,2,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(9,3,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    dSymOp(9) = -1.d0
!!$    !
!!$    SymOp(10,1,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(10,2,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(10,3,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    dSymOp(10) = 1.d0
!!$    !
!!$    SymOp(11,1,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(11,2,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(11,3,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    dSymOp(11) = -1.d0
!!$    !
!!$    SymOp(12,1,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(12,2,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(12,3,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    dSymOp(12) = 1.d0
!!$    !
!!$    SymOp(13,1,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(13,2,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(13,3,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    dSymOp(13) = -1.d0
!!$    !
!!$    SymOp(14,1,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(14,2,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(14,3,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    dSymOp(14) = -1.d0
!!$    !
!!$    SymOp(15,1,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(15,2,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(15,3,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    dSymOp(15) = 1.d0
!!$    !
!!$    SymOp(16,1,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(16,2,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(16,3,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    dSymOp(16) = -1.d0
!!$    !
!!$    SymOp(17,1,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(17,2,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(17,3,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    dSymOp(17) = -1.d0
!!$    !
!!$    SymOp(18,1,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(18,2,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(18,3,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    dSymOp(18) = -1.d0
!!$    !
!!$    SymOp(19,1,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    SymOp(19,2,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(19,3,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    dSymOp(19) = -1.d0
!!$    !
!!$    SymOp(20,1,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(20,2,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(20,3,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    dSymOp(20) = -1.d0
!!$    !
!!$    SymOp(21,1,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    SymOp(21,2,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    SymOp(21,3,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    dSymOp(21) = 1.d0
!!$    !
!!$    SymOp(22,1,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(22,2,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(22,3,1:3) = (/ 1.d0, 0.d0, 0.d0/)
!!$    dSymOp(22) = 1.d0
!!$    !
!!$    SymOp(23,1,1:3) = (/ 0.d0, 0.d0,-1.d0/)
!!$    SymOp(23,2,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(23,3,1:3) = (/ 0.d0, 1.d0, 0.d0/)
!!$    dSymOp(23) = 1.d0
!!$    !
!!$    SymOp(24,1,1:3) = (/-1.d0, 0.d0, 0.d0/)
!!$    SymOp(24,2,1:3) = (/ 0.d0,-1.d0, 0.d0/)
!!$    SymOp(24,3,1:3) = (/ 0.d0, 0.d0, 1.d0/)
!!$    dSymOp(24) = 1.d0
!!$    !
!!$!!!########################    
!!$  END SUBROUTINE znblSymOps
!!$!!!########################
  
!!$!!!####################
!!$  SUBROUTINE wrtzSymOps
!!$!!!####################
!!$    IMPLICIT NONE
!!$    REAL(DP), PARAMETER :: t = 0.8660254037844385d0  ! sqrt(3)/2
!!$    REAL(DP), PARAMETER :: h = 0.5d0                 ! 1/2
!!$    REAL(DP), PARAMETER :: z = 0.d0
!!$    REAL(DP), PARAMETER :: u = 1.d0
!!$    
!!$    ALLOCATE(SymOp(12,3,3))
!!$    ALLOCATE(dSymOp(12))
!!$    
!!$    SymOp( 1,1,1:3) = (/-h,-t, z/)
!!$    SymOp( 1,2,1:3) = (/ t,-h, z/)
!!$    SymOp( 1,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 1) = 1.d0
!!$    !
!!$    SymOp( 2,1,1:3) = (/-h, t, z/)
!!$    SymOp( 2,2,1:3) = (/ t, h, z/)
!!$    SymOp( 2,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 2) =-1.d0
!!$    !
!!$    SymOp( 3,1,1:3) = (/-h,-t, z/)
!!$    SymOp( 3,2,1:3) = (/-t, h, z/)
!!$    SymOp( 3,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 3) =-1.d0
!!$    !
!!$    SymOp( 4,1,1:3) = (/-h, t, z/)
!!$    SymOp( 4,2,1:3) = (/-t,-h, z/)
!!$    SymOp( 4,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 4) = 1.d0
!!$    !
!!$    SymOp( 5,1,1:3) = (/ u, z, z/)
!!$    SymOp( 5,2,1:3) = (/ z, u, z/)
!!$    SymOp( 5,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 5) = 1.d0
!!$    !
!!$    SymOp( 6,1,1:3) = (/ u, z, z/)
!!$    SymOp( 6,2,1:3) = (/ z,-u, z/)
!!$    SymOp( 6,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 6) =-1.d0
!!$    !
!!$    SymOp( 7,1,1:3) = (/ h,-t, z/)
!!$    SymOp( 7,2,1:3) = (/ t, h, z/)
!!$    SymOp( 7,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 7) = 1.d0
!!$    !
!!$    SymOp( 8,1,1:3) = (/-u, z, z/)
!!$    SymOp( 8,2,1:3) = (/ z, u, z/)
!!$    SymOp( 8,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 8) =-1.d0
!!$    !
!!$    SymOp( 9,1,1:3) = (/ h, t, z/)
!!$    SymOp( 9,2,1:3) = (/ t,-h, z/)
!!$    SymOp( 9,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 9) =-1.d0
!!$    !
!!$    SymOp(10,1,1:3) = (/ h,-t, z/)
!!$    SymOp(10,2,1:3) = (/-t,-h, z/)
!!$    SymOp(10,3,1:3) = (/ z, z, u/)
!!$    dSymOp(10) =-1.d0
!!$    !
!!$    SymOp(11,1,1:3) = (/-u, z, z/)
!!$    SymOp(11,2,1:3) = (/ z,-u, z/)
!!$    SymOp(11,3,1:3) = (/ z, z, u/)
!!$    dSymOp(11) = 1.d0
!!$    !
!!$    SymOp(12,1,1:3) = (/ h, t, z/)
!!$    SymOp(12,2,1:3) = (/-t, h, z/)
!!$    SymOp(12,3,1:3) = (/ z, z, u/)
!!$    dSymOp(12) = 1.d0
!!$    !
!!$!!!########################
!!$  END SUBROUTINE wrtzSymOps
!!$!!!########################
  
!!$!!!########################
!!$  SUBROUTINE c6_SymOps
!!$!!!########################
!!$    IMPLICIT NONE
!!$    REAL(DP), PARAMETER :: t = 0.8660254037844385d0  ! sqrt(3)/2
!!$    REAL(DP), PARAMETER :: h = 0.5d0                 ! 1/2
!!$    REAL(DP), PARAMETER :: z = 0.d0
!!$    REAL(DP), PARAMETER :: u = 1.d0
!!$    
!!$    ALLOCATE(SymOp(6,3,3))
!!$    ALLOCATE(dSymOp(6))
!!$    !
!!$    SymOp( 1,1,1:3) = (/ u, z, z/)
!!$    SymOp( 1,2,1:3) = (/ z, u, z/)
!!$    SymOp( 1,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 1) = 1.d0
!!$    !
!!$    SymOp( 2,1,1:3) = (/-h,-t, z/)
!!$    SymOp( 2,2,1:3) = (/ t,-h, z/)
!!$    SymOp( 2,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 2) = 1.d0
!!$    !
!!$    SymOp( 3,1,1:3) = (/-h, t, z/)
!!$    SymOp( 3,2,1:3) = (/-t,-h, z/)
!!$    SymOp( 3,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 3) = 1.d0
!!$    !
!!$    SymOp( 4,1,1:3) = (/-u, z, z/)
!!$    SymOp( 4,2,1:3) = (/ z,-u, z/)
!!$    SymOp( 4,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 4) = 1.d0
!!$    !
!!$    SymOp( 5,1,1:3) = (/ h, t, z/)
!!$    SymOp( 5,2,1:3) = (/-t, h, z/)
!!$    SymOp( 5,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 5) = 1.d0
!!$    !
!!$    SymOp( 6,1,1:3) = (/ h,-t, z/)
!!$    SymOp( 6,2,1:3) = (/ t, h, z/)
!!$    SymOp( 6,3,1:3) = (/ z, z, u/)
!!$    dSymOp( 6) = 1.d0
!!$    !
!!$!!!***********************
!!$  END SUBROUTINE c6_SymOps
!!$!!!***********************

!!!! JL
!!!#################################################
  SUBROUTINE transformationLinearResponse_CAB(i_spectra)
!!!#################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: T2(3,3)
    INTEGER :: ia, ib
    INTEGER :: ix, iy
    INTEGER :: i
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    T2(1:3,1:3) = 0.d0
    DO ix = 1, 3
       DO iy = 1, 3
          DO i = 1, nSym
             T2(ix,iy) = T2(ix,iy) + SymOp(i,ia,ix)*SymOp(i,ib,iy)
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:9) = reshape((/T2(1:3,1:3)/),(/9/))
    
    WRITE(99,FMT='(A2,I2,I4)') "T2", ia, ib
    WRITE(99,*) " "
    !WRITE(99,FMT='(9F10.5)') spectrum_info(i_spectra)%transformation_elements(1:9)
    DO ix = 1, 3
       DO iy = 1, 3
          IF (ABS(T2(ix,iy)).LT.1d-8) CYCLE
          WRITE(99,FMT='(2I4,F10.5)')  ix, iy, T2(ix,iy)
       END DO
    END DO
    WRITE(99,*) " "
    
!!!******************************************
  END SUBROUTINE transformationLinearResponse_CAB
!!!******************************************
!!!! JL




  
!!!#################################################
  SUBROUTINE transformationLinearResponse(i_spectra)
!!!#################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: T2(3,3)
    INTEGER :: ia, ib
    INTEGER :: ix, iy
    INTEGER :: i
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    T2(1:3,1:3) = 0.d0
    DO ix = 1, 3
       DO iy = 1, 3
          DO i = 1, nSym
             T2(ix,iy) = T2(ix,iy) + SymOp(i,ia,ix)*SymOp(i,ib,iy)
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:9) = reshape((/T2(1:3,1:3)/),(/9/))
    
    WRITE(99,FMT='(A2,I2,I4)') "T2", ia, ib
    WRITE(99,*) " "
    !WRITE(99,FMT='(9F10.5)') spectrum_info(i_spectra)%transformation_elements(1:9)
    DO ix = 1, 3
       DO iy = 1, 3
          IF (ABS(T2(ix,iy)).LT.1d-8) CYCLE
          WRITE(99,FMT='(2I4,F10.5)')  ix, iy, T2(ix,iy)
       END DO
    END DO
    WRITE(99,*) " "
    
!!!******************************************
  END SUBROUTINE transformationLinearResponse
!!!******************************************
  
!!!######################################################
  SUBROUTINE transformationSecondOrderResponse(i_spectra)
!!!######################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: T3(3,3,3)
    INTEGER :: ia, ib, ic
    INTEGER :: ix, iy, iz
    INTEGER :: i
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    ic = spectrum_info(i_spectra)%spectrum_tensor_component(3)
    
    T3(1:3,1:3,1:3) = 0.d0
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             DO i = 1, nSym
                T3(ix,iy,iz) = T3(ix,iy,iz) + SymOp(i,ia,ix)*SymOp(i,ib,iy)*SymOp(i,ic,iz)
             END DO
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:27) = reshape(T3,(/27/))    
    
    WRITE(99,FMT='(A2,I2,2I4)') "T3", ia, ib, ic
    WRITE(99,*) " "
    !WRITE(99,FMT='(27F10.5)') spectrum_info(i_spectra)%transformation_elements(1:27)
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             IF (ABS(T3(ix,iy,iz)).LT.1d-8) CYCLE
             WRITE(99,FMT='(3I4,F10.5)')  ix, iy, iz, T3(ix,iy,iz)
          END DO
       END DO
    END DO
    WRITE(99,*) " "
    
!!!***********************************************
  END SUBROUTINE transformationSecondOrderResponse
!!!***********************************************
  
!!!#######################################################
  SUBROUTINE transformationOneBeamSpinInjection(i_spectra)
!!!#######################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: PT3(3,3,3)
    INTEGER :: ia, ib, ic
    INTEGER :: ix, iy, iz
    INTEGER :: i    
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    ic = spectrum_info(i_spectra)%spectrum_tensor_component(3)
    
    PT3(1:3,1:3,1:3) = 0.d0
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             DO i = 1, nSym
                PT3(ix,iy,iz) = PT3(ix,iy,iz) +                              &
                     SymOp(i,ia,ix)*SymOp(i,ib,iy)*SymOp(i,ic,iz)*dSymOp(i)
             END DO
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:27) = reshape(PT3,(/27/))    
    
    WRITE(99,FMT='(A4,I2,2I4)') "PT3", ia, ib, ic
    WRITE(99,*) " "
    !WRITE(99,FMT='(27F10.5)') spectrum_info(i_spectra)%transformation_elements(1:27)
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             IF (ABS(PT3(ix,iy,iz)).LT.1d-8) CYCLE
             WRITE(99,FMT='(3I4,F10.5)')  ix, iy, iz, PT3(ix,iy,iz)
          END DO
       END DO
    END DO
    WRITE(99,*) " "
    
!!!************************************************
  END SUBROUTINE transformationOneBeamSpinInjection
!!!************************************************
  
  
!!!#####################################################
  SUBROUTINE transformationOneBeamSpinCurrent(i_spectra)
!!!#####################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: PT4(3,3,3,3)
    INTEGER :: ia, ib, ic, id
    INTEGER :: ix, iy, iz, iw
    INTEGER :: i    
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    ic = spectrum_info(i_spectra)%spectrum_tensor_component(3)
    id = spectrum_info(i_spectra)%spectrum_tensor_component(4)
    
    PT4(1:3,1:3,1:3,1:3) = 0.d0
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             DO iw = 1, 3
                DO i = 1, nSym
                   PT4(ix,iy,iz,iw) = PT4(ix,iy,iz,iw) +         &
                        SymOp(i,ia,ix)*SymOp(i,ib,iy)*SymOp(i,ic,iz)*SymOp(i,id,iw)*dSymOp(i)
                END DO
             END DO
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:81) = reshape(PT4,(/81/))
    
    WRITE(99,FMT='(A4,I2,3I4)') "PT4", ia, ib, ic, id
    WRITE(99,*) " "
    !WRITE(99,FMT='(81F10.5)') spectrum_info(i_spectra)%transformation_elements(1:81)
    DO ix = 1, 3
       DO iy = 1, 3
          DO iz = 1, 3
             DO iw = 1, 3
                IF (ABS(PT4(ix,iy,iz,iw)).LT.1d-8) CYCLE
                WRITE(99,FMT='(4I4,F10.5)')  ix, iy, iz, iw, PT4(ix,iy,iz,iw)
             END DO
          END DO
       END DO
    END DO
    WRITE(99,*) " "
    
!!!**********************************************
  END SUBROUTINE transformationOneBeamSpinCurrent
!!!**********************************************
  
!!!###################################################
  SUBROUTINE transformationCurrentInjection(i_spectra)
!!!###################################################
    IMPLICIT NONE
    INTEGER :: i_spectra
    REAL(DP) :: T4(3,3,3,3)
    INTEGER :: ia, ib, ic, id
    INTEGER :: ix, iy, iz, iw
    INTEGER :: i
    
    ia = spectrum_info(i_spectra)%spectrum_tensor_component(1)
    ib = spectrum_info(i_spectra)%spectrum_tensor_component(2)
    ic = spectrum_info(i_spectra)%spectrum_tensor_component(3)
    id = spectrum_info(i_spectra)%spectrum_tensor_component(4)
    
    T4(1:3,1:3,1:3,1:3) = 0.d0
    DO ix = 1,3
       DO iy = 1,3
          DO iz = 1,3
             DO iw = 1,3
                DO i = 1,nSym
                   T4(ix,iy,iz,iw) = T4(ix,iy,iz,iw) +         &
                        SymOp(i,ia,ix)*SymOp(i,ib,iy)*SymOp(i,ic,iz)*SymOp(i,id,iw)
                END DO
             END DO
          END DO
       END DO
    END DO
    
    spectrum_info(i_spectra)%transformation_elements(1:81) = reshape(T4,(/81/))
    
    WRITE(99,FMT='(A3,I2,3I5)') "T4", ia, ib, ic, id
    !WRITE(99,FMT='(81F10.5)') spectrum_info(i_spectra)%transformation_elements(1:81)
    DO ix = 1,3
       DO iy = 1,3
          DO iz = 1,3
             DO iw = 1,3
                IF (ABS(T4(ix,iy,iz,iw)).LT.1d-8) CYCLE
                WRITE(99,FMT='(4I4,F10.5)')  ix, iy, iz, iw, T4(ix,iy,iz,iw)
             END DO
          END DO
       END DO
    END DO
!!!********************************************
  END SUBROUTINE transformationCurrentInjection
!!!********************************************
  
!!!*****************************
END MODULE SymmetryOperationsMod
!!!*****************************
