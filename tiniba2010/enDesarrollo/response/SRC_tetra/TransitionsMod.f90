!!!##################
MODULE TransitionsMod
!!!##################
  
  IMPLICIT NONE
  
  INTEGER,  ALLOCATABLE :: ind_Trans(:,:)        ! array to index transitions
  LOGICAL,  ALLOCATABLE :: includeTransition(:)  ! choose which transitions to use
  
CONTAINS
  
!!!#####################################
  SUBROUTINE Initialize_Transition_Index
!!!#####################################
    USE InputParametersMod, ONLY : nMax
    IMPLICIT NONE
    INTEGER iv, ic, iTrans
    
    ALLOCATE( ind_Trans(nMax,nMax) )
    
    iTrans=0
    DO iv = 1,nMax
       DO ic = 1,nMax
          iTrans = iTrans+1
          ind_Trans(iv,ic)=iTrans
       END DO
    END DO
    WRITE(6,*) 'initializeTransitionIndex DONE'
!!!#########################################
  END SUBROUTINE Initialize_Transition_Index
!!!#########################################
  
!!!###########################
  SUBROUTINE Which_Transitions
!!!###########################
!!! Determine which transition to include in the calculation.  Subroutine looks
!!! for a file called "transitionsToInclude" and if found it uses that file to
!!! determine which transistions.  Alternativelt, the transitions can be manually
!!! specified here.
    USE InputParametersMod, ONLY : nMax
    USE InputParametersMod, ONLY : nVal
    USE InputParametersMod, ONLY : nMax_tetra
    USE InputParametersMod, ONLY : nVal_tetra
    
    IMPLICIT NONE
    
    INTEGER :: iTrans
    INTEGER :: iv
    INTEGER :: ic
    INTEGER :: low_band
    INTEGER :: high_band
    LOGICAL :: fileExists
    INTEGER :: numberOfLines
    INTEGER :: istat
    INTEGER :: i
    
    low_band = nVal + 1 - nVal_tetra
    high_band = nVal + nMax_tetra
    
    ALLOCATE(includeTransition(nMax*nMax))
    
    DO iv = 1, nMax
       DO ic = 1, nMax
          iTrans = ind_Trans(iv,ic)
          includeTransition(iTrans)=.TRUE.
          IF ((iv.LT.low_band).OR.(ic.GT.high_band)) includeTransition(iTrans)=.FALSE.
       END DO
    END DO
    
    WRITE(*,*) "Looking for file: transitionsToInclude"
    INQUIRE(FILE="transitionsToInclude",EXIST=fileExists)
    IF (fileExists) THEN
       ! will get which transitions to include from file
       OPEN(UNIT=24, FILE='transitionsToInclude', IOSTAT=istat)
       IF (istat.EQ.0) THEN
          WRITE(*,*)
          WRITE(*,*) "  Found transitionsToInclude file.  Will use "//&
               "it to determine which transitions to include."
          WRITE(*,*)
       ELSE
          WRITE(*,*) "Error opening transitionsToInclude file.  Stopping."
          STOP
       END IF
       includeTransition(:)=.FALSE.
       READ(24,*) numberOfLines
       DO i=1,numberOfLines
          READ(24,*) iv, ic
          IF ((iv.LT.1).OR.(iv.GT.nVal)) THEN
             WRITE(*,*) "Value for iv not allowed.  Stopping."
             STOP
          END IF
          IF ((ic.LT.nVal+1).OR.(ic.GT.nMax)) THEN
             WRITE(*,*) "Value for ic not allowed.  Stopping."
             STOP
          END IF
          iTrans = ind_Trans(iv,ic)
          includeTransition(iTrans)=.TRUE.
       END DO
    END IF
    
    WRITE(6,*) 'Which_Transitions DONE'
!!!###############################
  END SUBROUTINE Which_Transitions
!!!###############################
  
!!!######################
END MODULE TransitionsMod
!!!######################
