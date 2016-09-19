
MODULE CommandLineArgumentsMod

  USE DebugMod, ONLY : debug
  USE InputParametersMod, ONLY : paramFile
  USE SpectrumParametersMod, ONLY : spectrumFile  
  USE FileUtilitiesMod, ONLY : myInquire
  
  IMPLICIT NONE
  
  CONTAINS
  
  SUBROUTINE parseCommandLineArguments
    
    INTEGER :: numberOfArguments
    INTEGER :: i
    CHARACTER(LEN=80), ALLOCATABLE :: commandLineArgument(:)
    INTEGER, EXTERNAL :: IARGC
    
   

    numberOfArguments = IARGC()
    !write(*,*) "print numberOfArguments :",numberOfArguments
     write(*,*) "======================================"
     write(*,*) "subroutine parseCommandLineArguments()"
     write(*,*) "======================================"
    IF (2 > numberOfArguments) THEN
       CALL printHelp
       STOP
    END IF
    
    ALLOCATE(commandLineArgument(numberOfArguments))
   
    DO i=1, numberOfArguments
       
    CALL GETARG(i, commandLineArgument(i))
       
       IF (commandLineArgument(i) .EQ. '-help') THEN
          CALL printHelp
          STOP
       END IF
       
       IF (commandLineArgument(i) .EQ. '-debug') THEN
          WRITE(*,*) "Debugging turned on."
          debug = .TRUE.
          IF (3 > numberOfArguments) THEN
             WRITE(*,*) "Error with number or types of passed arguments"
             CALL printHelp
             STOP
          END IF
       END IF
       
    END DO
    
    paramFile = TRIM(commandLineArgument(numberOfArguments-1))
    spectrumFile = TRIM(commandLineArgument(numberOfArguments))
    
    CALL myInquire(paramFile)
    CALL myInquire(spectrumFile)
    write(*,*) "--------------------------------"
    write(*,*) "   paramFile = ",trim(paramFile)   
    write(*,*) "spectrumFile = ",trim(spectrumFile)
    write(*,*) "--------------------------------"

    DEALLOCATE(commandLineArgument)
    
  END SUBROUTINE parseCommandLineArguments
  
  
  SUBROUTINE printHelp
    WRITE(*,*) " "
    WRITE(*,*) "USAGE: setinput [options] parameterfile spectrumfile"
    WRITE(*,*) " "
    WRITE(*,*) "Where options can be any of:"
    WRITE(*,*) " "
    WRITE(*,*) "-debug            Turn on debugging messages"
    WRITE(*,*) " "
    WRITE(*,*) "-help             Print this message and exit"
    WRITE(*,*) " "
    WRITE(*,*) "The necessary input files are:"
    WRITE(*,*) " "
    WRITE(*,*) "parameterfile     contains the system parameters"
    WRITE(*,*) " "
    WRITE(*,*) "spectrumfile      contains the information on which spectra to calcualte"
    WRITE(*,*) "response numbers"
    write(*,*) "================================ contributions 1 OMEGA" 
    WRITE(*,*) "Length Gauge  OMEGA(1) = 21(intERband+intRAband) "
    WRITE(*,*) "(intERband has 2 terminos)"
    WRITE(*,*) "(intRAband has 3 terminos)"
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(1+2) SHG1_IntERbandLength   intErband(e)= 40"   
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(1)   SHG1_IntERbandLength_1 intErband(e)= 42"
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(2)   SHG1_IntERbandLength_2 intErband(e)= 43"
    WRITE(*,*) " NOTA: 40+41=21,las respuestas !! "
    WRITE(*,*) " NOTA: 42+43=40,las respuestas !! "
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(1+2+3) SHG1_IntRAbandLength.  intrAband(i)= 41"
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(1)     SHG1_IntRAbandLength_1 intrAband(i)= 44"
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(2)     SHG1_IntRAbandLength_2 intrAband(i)= 45"
    WRITE(*,*) "Length Gauge  OMEGA(1) TERMINO(3)     SHG1_IntRAbandLength_3 intrAband(i)= 46"
    WRITE(*,*) " NOTA: 44+45+46=41,las respuestas !! "

    write(*,*) "================================ contributions 2 OMEGA" 
    WRITE(*,*) "Length Gauge  OMEGA(2) = 22(intERband+intRAband) "
    WRITE(*,*) "(intERband(e) has 1 terminos) pag. 19"
    WRITE(*,*) "(intRAband(i) has 2 terminos) pag. 20"
    WRITE(*,*) "Length Gauge  OMEGA(2) TERMINO(1)   SHG2_IntERbandLength    intErband(e)= 47"
    WRITE(*,*) " NOTA: 47+48=22,las respuestas !! "
    write(*,*) "------------------ "    
    WRITE(*,*) "Length Gauge  OMEGA(2) TERMINO(1+2) SHG2_IntRAbandLength    intRAband(i)= 48"
    WRITE(*,*) "Length Gauge  OMEGA(2) TERMINO(1)   SHG2_IntRAbandLength_1  intRAband(i)= 49"
    WRITE(*,*) "Length Gauge  OMEGA(2) TERMINO(2)   SHG2_IntRAbandLength_2  intRAband(i)= 50"
    
    WRITE(*,*) " NOTA: 49+50=48,las respuestas !! "
    write(*,*) " "    
  END SUBROUTINE printHelp
  
END MODULE CommandLineArgumentsMod

