MODULE InitializeDataMod
  
  USE DebugMod, ONLY : debug
  
  USE DefaultInput, ONLY : getInput, getGridInput
  
  USE CommandLineArgumentsMod, ONLY : wien2k, abinit, defaultFormat, mesh
  
  USE structFile, ONLY : structReader, convertWienDataToInternalData
  
  USE abinitReader, ONLY : abinitWFKReader, convertAbinitDataToInternalData
  
  IMPLICIT NONE
  
CONTAINS
  
  SUBROUTINE initializeData
    
    IF ( debug ) WRITE(*,*) "Program Flow: Entered initializeData"
    
    ! determine whether we need the wien2k struct file
    IF ( wien2k ) THEN
       
       ! Get input from WIEN code struct file
       CALL structReader ()
       CALL convertWienDataToInternalData ()
       IF ( mesh ) THEN
          CALL getGridInput
       END IF
       
    ELSEIF ( abinit ) THEN
       ! Get input from ABINIT unformatted file
       CALL abinitWFKReader ()
       CALL convertAbinitDataToInternalData ()
       IF ( mesh ) THEN
          CALL getGridInput
       END IF
       
    ELSEIF ( defaultFormat ) THEN
       ! Get user input in 'default format' from files
       CALL getInput ()
       
    ELSE
       WRITE(*,*) ""
       WRITE(*,*) "     Error: No format for input specified."
       WRITE(*,*) "     THIS IS AN INTERNAL ERROR, AND SHOULD NOT HAVE"
       WRITE(*,*) "     HAPPENED.  PLEASE CONTACT AUTHORS."
       WRITE(*,*) ""
       STOP       "     INTERNAL ERROR.  PLEASE CONTACT AUTHORS."
    END IF
    
  END SUBROUTINE initializeData
  
END MODULE InitializeDataMod
