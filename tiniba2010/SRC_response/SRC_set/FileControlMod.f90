!!!##################
MODULE FileControlMod
!!!##################
  USE DebugMod, ONLY : debug
  USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate, spectrum_info
  IMPLICIT NONE
CONTAINS
  
!!!#############################
  SUBROUTINE openOutputDataFiles
!!!#############################
    IMPLICIT NONE
    INTEGER :: istat, i
    
    IF (debug) WRITE(*,*) "Program Flow: entered openOutputDataFiles"
    
    DO i=1, number_of_spectra_to_calculate
       IF (spectrum_info(i)%compute_integrand) THEN
          WRITE(6,*) "Trying to open: ", spectrum_info(i)%integrand_filename
          OPEN(UNIT = spectrum_info(i)%integrand_filename_unit,&
               FILE = spectrum_info(i)%integrand_filename, &
               IOSTAT = istat)
          IF (istat/=0) THEN
             WRITE(6,*) ' '
             WRITE(6,*) 'Error opening', spectrum_info(i)%integrand_filename
             WRITE(6,*) 'Assigned unit', spectrum_info(i)%integrand_filename_unit
             WRITE(6,*) 'STOPPING'
             STOP
          ELSE IF (istat.EQ.0) THEN
             WRITE(6,*) 'File opened'
          END IF
       END IF
    END DO
    
    IF (debug) WRITE(*,*) "Program Flow: exited openOutputDataFiles"
!!!#################################
  END SUBROUTINE openOutputDataFiles
!!!#################################
  
!!!##############################
  SUBROUTINE closeOutputDataFiles
!!!##############################
    IMPLICIT NONE
    INTEGER :: istat, i
    IF (debug) WRITE(*,*) "Program Flow: entered closeOutputDataFiles"
    
    DO i=1,number_of_spectra_to_calculate
       IF (spectrum_info(i)%compute_integrand) THEN
          CLOSE(spectrum_info(i)%integrand_filename_unit, IOSTAT = istat)
          IF (istat.EQ.0) THEN
             WRITE(6,*) 'Closing file ', TRIM(spectrum_info(i)%integrand_filename)
          ELSE
             WRITE(6,*) ' '
             WRITE(6,*) 'Error closing', spectrum_info(i)%integrand_filename
             WRITE(6,*) 'Assigned unit', spectrum_info(i)%integrand_filename_unit
             WRITE(6,*) 'STOPPING'
             STOP
          END IF
       END IF
    END DO
    IF (debug) WRITE(*,*) "Program Flow: exiting closeOutputDataFiles"
!!!##################################
  END SUBROUTINE closeOutputDataFiles
!!!##################################
  
!!!####################################
  SUBROUTINE writeOutputDataFileHeaders
    USE InputParametersMod, ONLY : DP, spin_factor
    USE InputParametersMod, ONLY : nSym
    USE IntegrandImChi1Mod, ONLY : Chi1_factor, Chi1DeltaFunctionFactor
    USE IntegrandSHG1Mod, ONLY : SHG1_factor, SHG1DeltaFunctionFactor
    USE IntegrandSHG2Mod, ONLY : SHG2_factor, SHG2DeltaFunctionFactor
    USE IntegrandSHG1_tranMod, ONLY : SHG1_tran_factor, SHG1_tranDeltaFunctionFactor
USE IntegrandSHG2_tranMod, ONLY : SHG2_tran_factor, SHG2_tranDeltaFunctionFactor
 !! 29 Septiembre 2008 
USE IntegrandSHG1_tranMod_Leitsman_three, ONLY : SHG1_tran_factor_Leitsman_three, SHG1_tranDeltaFunctionFactor_Leitsman_three
USE IntegrandSHG1_tranMod_Leitsman_two, ONLY : SHG1_tran_factor_Leitsman_two, SHG1_tranDeltaFunctionFactor_Leitsman_two
USE IntegrandSHG2_tranMod_Leitsman_three, ONLY : SHG2_tran_factor_Leitsman_three, SHG2_tranDeltaFunctionFactor_Leitsman_three
USE IntegrandSHG2_tranMod_Leitsman_two, ONLY : SHG2_tran_factor_Leitsman_two, SHG2_tranDeltaFunctionFactor_Leitsman_two
!!!! 
USE IntegrandSHG1Mod_Leitsman_eta_omega, ONLY : SHG1_factor_Leitsman_eta_omega, SHG1DeltaFunctionFactor_Leitsman_eta_omega
USE IntegrandSHG2Mod_Leitsman_eta_omega, ONLY : SHG2_factor_Leitsman_eta_omega, SHG2DeltaFunctionFactor_Leitsman_eta_omega
USE IntegrandSHG1_tranMod_ta_algebra, ONLY : SHG1_tran_factor_ta_algebra, SHG1_tranDeltaFunctionFactor_ta_algebra
USE IntegrandSHG2_tranMod_ta_algebra, ONLY : SHG2_tran_factor_ta_algebra, SHG2_tranDeltaFunctionFactor_ta_algebra
    IMPLICIT NONE
    REAL(DP) :: rtmp, rtmp2
    INTEGER :: i_spectra, iTmp
    integer :: isp
    
    IF (debug) WRITE(*,*) "Program Flow: entered writeOutputDataFileHeaders"
    
    rtmp = spin_factor*(1.d0/DFLOAT(nSym))
WRITE(*,*) "======================================="
WRITE(*,*) "from: writeOutputDataFileHeaders"

DO isp=1,number_of_spectra_to_calculate
WRITE(*,*) "             rtmp =",rtmp
WRITE(*,*) "number_of_spectra =",number_of_spectra_to_calculate 
WRITE(*,*) "        file name =",trim(spectrum_info(isp)%integrand_filename)
write(*,*) "   file name unit =",spectrum_info(isp)%integrand_filename_unit
write(*,*) "compute_integrand =",spectrum_info(isp)%compute_integrand
write(*,*) "    spectrum type =",spectrum_info(isp)%spectrum_type      
end do 

    DO i_spectra=1,number_of_spectra_to_calculate
       
       IF (spectrum_info(i_spectra)%compute_integrand) THEN
          
          SELECT CASE(spectrum_info(i_spectra)%spectrum_type)
         CASE(1)
              write(*,*) "======================================="
              write(*,*) "Here enter to calculate 1 JL"
              write(*,*) "subroutine writeOutputDataFileHeaders"
             rtmp2 = rtmp*Chi1_factor()
             iTmp = Chi1DeltaFunctionFactor()
          CASE(21)
             rtmp2 = rtmp*SHG1_factor()
             iTmp = SHG1DeltaFunctionFactor()
          CASE(22)
             rtmp2 = rtmp*SHG2_factor()
             iTmp = SHG2DeltaFunctionFactor()
          CASE(26)
             rtmp2 = rtmp*SHG1_tran_factor()
             iTmp = SHG1_tranDeltaFunctionFactor()
          !! transversal gauge 2 omega 
          CASE(27)
              rtmp2 = rtmp*SHG2_tran_factor()
              iTmp = SHG2_tranDeltaFunctionFactor()
          CASE(60)
             rtmp2 = rtmp*SHG1_tran_factor_Leitsman_three()
             iTmp = SHG1_tranDeltaFunctionFactor_Leitsman_three()
          CASE(61)
             rtmp2 = rtmp*SHG1_tran_factor_Leitsman_two()
             iTmp = SHG1_tranDeltaFunctionFactor_Leitsman_two()
          CASE(62)
             rtmp2 = rtmp*SHG2_tran_factor_Leitsman_three()
             iTmp = SHG2_tranDeltaFunctionFactor_Leitsman_three()
          CASE(63)
             rtmp2 = rtmp*SHG2_tran_factor_Leitsman_two()
             iTmp = SHG2_tranDeltaFunctionFactor_Leitsman_two()
          CASE(64)
             rtmp2 = rtmp*SHG1_tran_factor_ta_algebra()
             iTmp = SHG1_tranDeltaFunctionFactor_ta_algebra()
          CASE(65)
             rtmp2 = rtmp*SHG2_tran_factor_ta_algebra()
             iTmp = SHG2_tranDeltaFunctionFactor_ta_algebra()
          CASE(80)
             rtmp2 = rtmp*SHG1_factor_Leitsman_eta_omega()
             iTmp = SHG1DeltaFunctionFactor_Leitsman_eta_omega()
          CASE(81)
             rtmp2 = rtmp*SHG2_factor_Leitsman_eta_omega()
             iTmp = SHG2DeltaFunctionFactor_Leitsman_eta_omega()
           CASE DEFAULT
             STOP 'Error in calculateIntegrands: spectrum_type not available'
          END SELECT
          write(*,*)'***** in FileControlMod.f90 ********'
          WRITE (*,*) "writeOutputDataFileHeaders", i_spectra, rtmp2,iTmp
          write(*,*)spectrum_info(i_spectra)%integrand_filename_unit
          write(*,*)'********'
          WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, FMT=*) rtmp2
          WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, FMT=*) iTmp
       END IF
    END DO
    
    IF (debug) WRITE(*,*) "Program Flow: exiting writeOutputDataFileHeaders"
   
!!!########################################
  END SUBROUTINE writeOutputDataFileHeaders
!!!########################################

!!!######################  
END MODULE FileControlMod
!!!######################
