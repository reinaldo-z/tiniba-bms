
MODULE IntegrandsMod

  USE debugMod, ONLY : debug
  USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
  USE SpectrumParametersMod, ONLY : spectrum_info
  USE IntegrandImChi1Mod, ONLY : ImChi1
!!! here i begin JL
!  USE SRC_CHi1Mod, ONLY : ImChi1_CAB
!  USE SRC_CHi1Mod_A, ONLY : ImChi1_A
!  USE SRC_CHi1Mod_B, ONLY : ImChi1_B
  USE IntegrandSHG1Mod, ONLY : SHG1
  USE IntegrandSHG2Mod, ONLY : SHG2
!  USE SHG1_IntERbandLength, ONLY : SHG1_intERband
!  USE SHG1_IntERbandLength_1, ONLY : SHG1_intERband_1
!  USE SHG1_IntERbandLength_2, ONLY : SHG1_intERband_2
!  USE SHG1_IntRAbandLength, ONLY : SHG1_intRAband
!  USE SHG1_IntRAbandLength_1, ONLY : SHG1_intRAband_1
!  USE SHG1_IntRAbandLength_2, ONLY : SHG1_intRAband_2
!  USE SHG1_IntRAbandLength_3, ONLY : SHG1_intRAband_3
  !! 2 omega interband SHG2_IntERband
!  USE SHG2_IntERbandLength, ONLY : SHG2_IntERband
!  USE SHG2_IntRAbandLength, ONLY : SHG2_IntRAband
!  USE SHG2_IntRAbandLength_1, ONLY : SHG2_IntRAband_1
!  USE SHG2_IntRAbandLength_2, ONLY : SHG2_IntRAband_2
  !! transversal gauge 1 omega   
  USE IntegrandSHG1_tranMod, ONLY : SHG1_tran
  USE IntegrandSHG2_tranMod, ONLY : SHG2_tran
!!! Rabc1
!  USE IntegrandSHG2_Rabc1Mod, ONLY : SHG2_Rabc1
!  USE IntegrandSHG2_Rabc2Mod, ONLY : SHG2_Rabc2
!  USE IntegrandSHG2_Rabc3Mod, ONLY : SHG2_Rabc3
!  USE IntegrandETA2, ONLY : ETA2
!  USE IntegrandImLambdaMod, ONLY : ImLambda
  USE IntegrandSHG1_tranMod_Leitsman_three, ONLY : SHG1_tran_Leitsman_three
  USE IntegrandSHG1_tranMod_Leitsman_two, ONLY : SHG1_tran_Leitsman_two
  USE IntegrandSHG2_tranMod_Leitsman_three, ONLY : SHG2_tran_Leitsman_three
  USE IntegrandSHG2_tranMod_Leitsman_two, ONLY : SHG2_tran_Leitsman_two
  !!! 
  USE IntegrandSHG1Mod_Leitsman_eta_omega, ONLY : SHG1_Leitsman_eta_omega
  USE IntegrandSHG2Mod_Leitsman_eta_omega, ONLY : SHG2_Leitsman_eta_omega
  !!!domingo 
  USE IntegrandSHG1_tranMod_ta_algebra, ONLY : SHG1_tran_ta_algebra
  USE IntegrandSHG2_tranMod_ta_algebra, ONLY : SHG2_tran_ta_algebra
   IMPLICIT NONE
   CONTAINS
  
   SUBROUTINE calculateIntegrands
    IMPLICIT NONE
    
    INTEGER :: i_spectra
    
    IF (debug) WRITE(*,*) "Program Flow: entered calculateIntegrands"

   ! WRITE(87,*) "Program Flow: entered calculateIntegrands"  
    
    DO i_spectra = 1, number_of_spectra_to_calculate
       IF (spectrum_info(i_spectra)%compute_integrand) THEN
          SELECT CASE(spectrum_info(i_spectra)%spectrum_type)
          CASE(1)
             CALL ImChi1(i_spectra)
           CASE(21) 
             CALL SHG1(i_spectra)
           CASE(22)
             CALL SHG2(i_spectra)
           CASE(26)
             CALL SHG1_tran(i_spectra)
           CASE(27)
             CALL SHG2_tran(i_spectra)
          CASE(60)
             CALL SHG1_tran_Leitsman_three(i_spectra)
            CASE(61)
             CALL SHG1_tran_Leitsman_two(i_spectra)
            CASE(62)
             CALL SHG2_tran_Leitsman_three(i_spectra)
            CASE(63)
             CALL SHG2_tran_Leitsman_two(i_spectra)
            CASE(64)
             CALL SHG1_tran_ta_algebra(i_spectra)
            CASE(65)
             CALL SHG2_tran_ta_algebra(i_spectra)
            CASE(80) 
             CALL SHG1_Leitsman_eta_omega(i_spectra)
            CASE(81) 
             CALL SHG2_Leitsman_eta_omega(i_spectra)

          CASE DEFAULT
             STOP 'Error in calculateIntegrands: spectrum_type not available'
          END SELECT
       END IF
    END DO
    
!!!IF (debug) WRITE(*,*) "Program Flow: exited calculateIntegrands"

  END SUBROUTINE calculateintegrands

  

END MODULE IntegrandsMod
!#######################
