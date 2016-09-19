PROGRAM mmeReader
!!!
!!! Rewrites the momentum matrix elements from case.mme files
!!! Passes the case.mee files twice. First time it collects
!!! file parameters to determine how to process the files,
!!! and the second pass is to actually process the files.
!!!
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = KIND(1.0D0)      ! double precision
  INTEGER, PARAMETER :: SP = KIND(1.0E0)      ! single precision
!!LOGICAL, PARAMETER :: debug = .true.
  LOGICAL, PARAMETER :: debug = .false.
!!!  LOGICAL, PARAMETER :: debug = .false.
  CHARACTER(LEN=120) :: definitionFilename
  INTEGER :: nol  !  number of lines in definitionFilename
  CHARACTER(LEN=120), ALLOCATABLE :: mmefilename(:)
  CHARACTER(LEN=120) :: outputfilename
  INTEGER :: ifile
  INTEGER :: istat
  REAL(DP) emin, emax
!!!  INTEGER :: ik
  INTEGER :: iktmp, itmp, bandmin, bandmax
  INTEGER :: i, j, ii, jj, iii, jjj
  REAL(SP) :: px1, px2, py1, py2, pz1, pz2
  INTEGER :: iband, icount
  INTEGER :: nBands
  REAL(DP), ALLOCATABLE :: energy(:)
  CHARACTER(LEN=84), PARAMETER :: headerLine = "          6  " // &
       "Re <x>       Im <x>       Re <y>       Im <y>       Re <z>       Im <z>"
  CHARACTER(LEN=84) :: char84
  CHARACTER(LEN=3) :: char3
  CHARACTER(LEN=3) :: A1
  CHARACTER(LEN=1) :: char1
  CHARACTER(LEN=14) :: Ane
  CHARACTER(LEN=4) :: Ade
  CHARACTER(LEN=40) :: chartmp 
  CHARACTER(LEN=72) :: char72
  CHARACTER(LEN=6) :: ctmp6
  CHARACTER(LEN=2) :: kTag
  CHARACTER(LEN=10) :: kLabel
  integer :: istatk
  ! Read file up to the first line that satisfies the format
  ! statement
  
 

  nBands = 0
!!!  mmefilename = 'liio3_50k.mme'
!!!  WRITE(*,*) "Enter case.mme file to process"
  WRITE(*,*) "Definition file (contains list of input files and output file):"
  READ(*,*) definitionFilename
  write(*,*)"definitionFilename :  ",trim(definitionFilename)
  CALL numberOfLines(definitionFilename, nol)
  
  IF (debug) WRITE(*,*) "Number of lines found ", nol
  
  ALLOCATE (mmefilename(nol))
  
  OPEN(UNIT=1, FILE=definitionFilename, IOSTAT=istat, STATUS='OLD')
  IF ( istat .NE. 0 ) THEN
WRITE(*,*) "Cannot OPEN file ", TRIM(definitionFilename), ". Stopping"
call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
WRITE(19,*) "mmReader.f90 L=63"
WRITE(19,*) "Cannot OPEN file ", TRIM(definitionFilename), ". Stopping"
WRITE(19,*) "Could not open definition file."
     STOP "Could not open definition file."
  END IF
  
  DO ifile = 1, nol-1
     READ (UNIT=1, FMT='(A)', IOSTAT=istat) mmeFilename(ifile)
     IF (istat .NE. 0) THEN
        WRITE(*,*) "Error READing line ", ifile, " of ", mmeFilename(ifile)
     END IF
  END DO
  READ (UNIT=1, FMT='(A)', IOSTAT=istat) outputFilename
  CLOSE(UNIT=1)
  
  IF (debug) WRITE(*,*) "Will overwrite ", outputfilename
  
  ! Now loop over all the files listed in definition files
  
  DO j=1,2
     
     ! j loops over the passes made.  We make two passes over the files.
     ! The first pass finds the imporant information, like the minimum
     ! number of bands shared by all k-points, and the second pass
     ! actually reads and writes out the required momenta.
     
     IF (j.EQ.2) THEN
        OPEN(UNIT=2, file=outputfilename, IOSTAT=istat)
        IF (istat .NE. 0) THEN
           WRITE(6,*) 'Could not open file, ', outputfilename, ' properly'
           WRITE(6,*) 'IOSTAT is ', istat
           WRITE(6,*) 'Stopping'

     call system ("rm -f  killme ")
      OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
      WRITE(19,*) 'Could not open file, ', outputfilename, ' properly'
      WRITE(19,*) 'IOSTAT is ', istat
      WRITE(19,*) 'Stopping'
     close(19)
           STOP
        END IF
     END IF
     
     icount = 0
     
     DO ifile = 1, nol-1
        
        ! Open file to process
        
        OPEN(UNIT=1, FILE=mmeFilename(ifile), STATUS='OLD', IOSTAT=istat)
        IF (istat .NE. 0) THEN
           WRITE(6,*) 'Could not open file, ', mmeFilename(ifile), ' properly.'
           WRITE(6,*) 'IOSTAT is ', istat
           WRITE(6,*) 'Stopping'
 call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
  WRITE(19,*) 'Could not open file, ', mmeFilename(ifile), ' properly.'
           WRITE(19,*) 'IOSTAT is ', istat
           WRITE(19,*) 'Stopping'
 close(19)
           STOP
        END IF
        
       ! WRITE(*,*) "Processing ", TRIM(mmeFilename(ifile))
        
        ! Read the header of the file
        
        READ(UNIT=1,FMT='(A84)', IOSTAT=istat) char84
        IF (istat .NE. 0) THEN
           WRITE(*,*) "Could not read header from file ", TRIM(mmeFilename(ifile)), &
                " properly. Stopping."
 call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
 WRITE(19,*) "Could not read header from file ", TRIM(mmeFilename(ifile))
 close(19)


           STOP "Stopping"
        END IF
        IF ( char84 == headerLine ) THEN
           IF (debug) WRITE(*,*) "Header is as expected."
        ELSE
           WRITE(*,*) "Header is not as expected!"
           WRITE(*,*) "Header is:",  TRIM(char84)
           WRITE(*,*) "Stopping."
 call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
 WRITE(19,*) "Header is not as expected!"
 WRITE(19,*) "Header is:",  TRIM(char84)
 WRITE(19,*) "Stopping because of header conflict"
 WRITE(19,*) "Stopping."
 close(19)


           STOP "Stopping because of header conflict."
        END IF
        IF (debug) WRITE(*,*) "FINISHED READING HEADER"
        
        ! Start reading kpoints
        
        DO
           READ(UNIT=1,FMT='(A72)', IOSTAT=istat) char72
           IF (istat .EQ.-1) THEN
              ! End of file
              !WRITE(*,*) "Reached end of file:", TRIM(mmeFilename(ifile))
              EXIT
           ELSE IF (istat .NE. 0) THEN
              WRITE(*,*) "Could not read line from file ", TRIM(mmeFilename(ifile)), &
                   " properly."
              WRITE(*,*) "istat is: ", istat
              WRITE(*,*) "Stopping"
    call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
   WRITE(19,*) "Could not read line from file ", TRIM(mmeFilename(ifile)), &
                   " properly."
              WRITE(19,*) "istat is: ", istat
              WRITE(19,*) "Stopping"
 close(19)

              STOP "Stopping"
           END IF
           
           ! Should read a blank line
           
           IF (debug) WRITE(6,*) "Line read is: ",TRIM(char72)
           
           READ(UNIT=1, iostat=istat, FMT=1001) char3, A1, iktmp, char1, Ane, bandmin, &
                bandmax, char1, Ade, emin, emax, char1, kTag, kLabel
1001       FORMAT(A3,A3,I6,A1,A14,2I5,A1,A3,2F5.2,A1,A2,A10)
           
!!!1001    FORMAT("   KP:",I6," NEMIN NEMAX  : ",2I3," dE:",2F4.2," K:     ",I5)
           
           IF (istat .NE. 0) THEN
              WRITE(*,*) "Could not read from description line in file ", &
                   TRIM(mmeFilename(ifile)), " properly."
              WRITE(*,*) "istat is: ", istat
              WRITE(*,*) "Stopping"
             call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
        WRITE(*,*) "Could not read from description line in file ", &
                   TRIM(mmeFilename(ifile)), " properly."
              WRITE(*,*) "istat is: ", istat
              WRITE(*,*) "Stopping"

  close(19)

              STOP "Stopping"
           END IF
!!!1234561234561234567890123451234512345123412345123451234567812345
!!!   KP:     1 NEMIN NEMAX :     1   31 dE:-5.00 3.00 K:         1
           IF (debug) THEN
              WRITE(6,'(A3,I6)') A1,  iktmp
              WRITE(6,'(A14,2I5)') Ane, bandmin, bandmax
              WRITE(6,'(A3,2F5.2)') Ade, emin, emax
              WRITE(6,'(A2,A10)') kTag, kLabel
              WRITE(6,*) "istat ", istat
           END IF
           IF (.NOT.( A1 == "KP:" )) THEN
              WRITE(*,*) "Could not read default string properly"
              WRITE(*,*) "Was expecting:    KP:"
              WRITE(*,*) "but found: ", A1
              WRITE(*,*) "Stopping."
  call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
 WRITE(*,*) "Could not read default string properly"
              WRITE(19,*) "Was expecting:    KP:"
              WRITE(19,*) "but found: ", A1
              WRITE(19,*) "Stopping."
 close(19)

              STOP "Error reading mme file"
           ENDIF
           IF (.NOT.( Ane == "NEMIN NEMAX : ")) THEN
              WRITE(*,*) "Could not read default string properly"
              WRITE(*,*) "Was expecting: NEMIN NEMAX : "
              WRITE(*,*) "but found: ", Ane
              WRITE(*,*) "Stopping."
  call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
 WRITE(*,*) "Could not read default string properly"
              WRITE(19,*) "Was expecting: NEMIN NEMAX : "
              WRITE(19,*) "but found: ", Ane
              WRITE(19,*) "Stopping."
 close(19)


              STOP "Error reading mme file"
           END IF
           
           ! Now that we have read the line propely, we increase icount
           icount = icount + 1
           
           ! Should read a blank line
           
           READ(UNIT=1,FMT='(A72)',IOSTAT=istat) char72
           IF (debug) WRITE(*,*) "Line read: ", TRIM(char72)
           
           IF (istat.EQ.0) THEN
!!!              IF (ik.EQ.icount) THEN
!!!              IF (debug) WRITE(6,*) "ik ", ik, "bandmax ", bandmax
              IF (debug) WRITE(*,*) "icount ", icount, "bandmax ", bandmax
              IF (j.EQ.1) THEN
                 IF (icount.EQ.1) THEN
                    nBands=bandmax
                 ELSE
                    nBands = MIN(Nbands,bandmax)
                 END IF
              END IF
              IF (debug) WRITE(6,*) "icount =", icount
              DO ii=1, bandmax
                 DO jj=ii,bandmax
                    READ(UNIT=1,FMT=1002,IOSTAT=istat) &
                         iii,jjj,px1,px2,py1,py2,pz1,pz2
1002                FORMAT(I7,I4,6E13.6)
                    IF (istat.NE.0) THEN
                       WRITE(6,*) "istat ", istat
           call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
  WRITE(19,*) "linea=282 mmReader "
  WRITE(19,*) "istat ", istat   
 close(19)

                       STOP
                    END IF
                    IF (j.EQ.1) THEN
!!!                       IF (debug) WRITE(6,*) "ii jj", ii, jj, "iii jjj", iii, jjj
!!!                       IF (debug) WRITE(6,*) px1, px2, py1, py2, pz1, pz2
                       IF ((ii.NE.iii).OR.(jj.NE.jjj)) THEN
                          WRITE(6,*) "Band indices read from file do not "// &
                               "agree with expected index."
                          WRITE(6,*) "Stopping"
 call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
WRITE(19,*) "Band indices read from file do not "// &
                               "agree with expected index."
                          WRITE(19,*) "Stopping"
close(19)


                          STOP
                       END IF
                    ELSE IF (j.EQ.2) THEN
                       ! WRITE OUT THE MATRIX ELEMENTS
                       IF ((ii.LE.nbands).AND.(jj.LE.nbands)) THEN
                          WRITE(2,1003) px1, px2, py1, py2, pz1, pz2
1003                      FORMAT(6E15.6)
                       END IF
                    END IF
                 END DO
              END DO
!              ELSE
!                 WRITE(6,*) "ik not equal icount"
!                 WRITE(6,*) "ik ", ik
!                 WRITE(6,*) "icount ", icount
!                 WRITE(6,*) "Stopping"
!                 STOP
!              END IF
!           ELSE IF (istat.EQ.-1) THEN
!              ! END IF FILE
!              IF (debug) THEN
!                 WRITE(6,*) "        IOSTAT is ", istat
!                 WRITE(6,*) "        End of file found"
!              END IF
!              EXIT
           ELSE
              WRITE(6,*) "    YIKES   "
              WRITE(6,*) "IOSTAT is ", istat
              WRITE(6,*) "Stopping"
 call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
   WRITE(19,*) "    YIKES   "
              WRITE(19,*) "IOSTAT is ", istat
              WRITE(19,*) "Stopping"
 close(19)

              STOP
           END IF
        END DO
        IF (j.EQ.1) CLOSE(UNIT=1)
     END DO
     IF (j.EQ.2) CLOSE(UNIT=2)
  END DO         !!! Repeat once





  
WRITE(6,*) "Number of complete bands found: ", nbands
WRITE(6,*) "Number of k points : ", icount
write(7,*)nbands,icount

call system( " rm -f infomm2script" )
  OPEN (UNIT=16, FILE="infomm2script", IOSTAT=istat, STATUS='new')
  write(16,*) nbands,icount
  close(16)
!write(*,*)" for to script  :  infomm2script"
write(*,*)" Outputfilename : ",trim(outputfilename)
WRITE(*,*) "I found the end  mmeReader"
write(*,*) "=========================="

END PROGRAM mmeReader




!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




SUBROUTINE numberOfLines(defFilename, nol)
  IMPLICIT NONE
  CHARACTER(LEN=120), INTENT(IN) :: defFilename
  INTEGER, INTENT(OUT) :: nol
  INTEGER :: istat
  CHARACTER(LEN=1) :: dummy
  integer :: istatk
  nol=0
  OPEN(UNIT=1,FILE=defFilename,IOSTAT=istat,STATUS='OLD')
  IF (istat .NE. 0) THEN
     WRITE(*,*) "Definition file ", TRIM(defFilename), " cannot be opened."
     call system ("rm -f  killme ")
 OPEN(UNIT=19, FILE="killme", IOSTAT=istatk, STATUS='new')
    WRITE(19,*) "Definition file ", TRIM(defFilename), " cannot be opened."
close(19)
     STOP "Definition file cannot be opened."
  END IF
  DO
     READ(UNIT=1, FMT=*, IOSTAT=istat) dummy
     IF (istat.EQ.-1) THEN
        EXIT
     END IF
     nol = nol + 1
  END DO
  CLOSE(UNIT=1)
END SUBROUTINE numberOfLines
 

