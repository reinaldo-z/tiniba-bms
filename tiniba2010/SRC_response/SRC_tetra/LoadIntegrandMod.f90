!!!####################
MODULE LoadIntegrandMod
!!!####################
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  
  REAL(DP), ALLOCATABLE :: f(:,:)                ! integrand
  
CONTAINS
  
!!!########################
  SUBROUTINE Load_Integrand
!!!########################
    USE InputParametersMod, ONLY : nMaxCC
    USE InputParametersMod, ONLY : kMax
    USE InputParametersMod, ONLY : nVal
    USE InputParametersMod, ONLY : nMax
    USE InputParametersMod, ONLY : units_factor
    USE InputParametersMod, ONLY : integrand_filename
    USE InputParametersMod, ONLY : deltaFunctionFactor
    USE TransitionsMod, ONLY: ind_Trans
    INTEGER  :: ik, iTrans, iv, ic
    CHARACTER(LEN=3) :: ADV_opt
    INTEGER :: read_status, io_status
    
    ALLOCATE(f(kMax,nMax*nMax))
    
    WRITE(6,'(A10,A80)') 'opening: ', integrand_filename
    OPEN(1, FILE = integrand_filename, STATUS = "old", IOSTAT=io_status)
    IF (io_status.NE.0) THEN
       WRITE(*,*) "Error opening file: ", TRIM(integrand_filename) 
       WRITE(*,*) "Stopping"
       STOP 'Could not open integrand file'
    END IF
    READ(UNIT=1,FMT=*) units_factor
    WRITE(*,*) 'Overall factor : ', units_factor
    READ(UNIT=1,FMT=*) deltaFunctionFactor
    WRITE(*,*) 'in LoadIntegrandMod.f90: Delta-function factor : ', deltaFunctionFactor
    
    DO ik = 1, kMax
       DO iv = 1, nVal
          !!DO ic = nVal+1, nMax
           DO ic = nVal+1, nMaxCC
             !!!IF (ic==nMax) THEN
             IF (ic==nMaxCC) THEN
                ADV_opt = "YES"
             ELSE
                ADV_opt = "NO"
             END IF
             iTrans=ind_Trans(iv,ic)
             
             !!IF (ic==nMax) THEN
             IF (ic==nMaxCC) THEN
                READ(UNIT=1,FMT='(E15.7)',ADVANCE="YES",&
                     IOSTAT=read_status) f(ik,iTrans)
                f(ik,iTrans) = f(ik,iTrans) / REAL(deltaFunctionFactor)
             ELSE
                READ(UNIT=1,FMT='(E15.7)',ADVANCE="NO",&
                     IOSTAT=read_status) f(ik,iTrans)
                f(ik,iTrans) = f(ik,iTrans) / REAL(deltaFunctionFactor)
             END IF
!!!           READ(UNIT=1,FMT='(E15.7)',ADVANCE=ADV_opt,&
!!!                IOSTAT=read_status) f(ik,iTrans)
             IF (read_status.GT.0) THEN
                WRITE(6,*) 'Error in Load_integrand'
                WRITE(6,*) read_status, ik, ic, iv, iTrans
                STOP
             ELSE IF(read_status.EQ.-1) THEN
                WRITE(*,*) ik, iv, ic
                WRITE(*,*) 'End of file', integrand_filename
             ELSE IF(read_status.LT.-1) THEN
                WRITE(*,*) read_status
                WRITE(*,*) 'Strange Error: Load Integrand'
                STOP
             END IF
          END DO
       END DO
    END DO
    CLOSE(1)
    WRITE(*,*) 'Load_Integrand DONE'
     WRITE(*,*) 'Load_Integrand in the correct way jl'
!!!############################
  END SUBROUTINE Load_Integrand
!!!############################
  
!!!########################
END MODULE LoadIntegrandMod
!!!########################
