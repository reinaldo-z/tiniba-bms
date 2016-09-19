PROGRAM energyReader
!!!
!!! Rewrites the energies from case.energy
!!! Passes the case.energy file twice. First time it collects
!!! file parameters to determine how to process the file,
!!! and the second pass is to actually process the file.
!!!
  IMPLICIT NONE
  INTEGER, PARAMETER :: DP = KIND(1.0D0)      ! double precision
  !!  LOGICAL, PARAMETER :: debug = .false.
  LOGICAL, PARAMETER :: debug = .false.
  CHARACTER(LEN=120) :: definitionFilename
  INTEGER :: nol ! Number of lines in definitionFile
  CHARACTER(LEN=120), ALLOCATABLE :: energyfilename(:) ! will be allocated nol elements
  CHARACTER(LEN=120) :: outputfilename
  INTEGER :: ifile
  INTEGER :: istat
  REAL(DP) k1, k2, k3, wt
  INTEGER :: ik, itmp, ne, i, j
  CHARACTER(LEN=10) :: klabel
  INTEGER :: iband, icount
  INTEGER :: nBands, Na
  REAL(DP), ALLOCATABLE :: energy(:)
  CHARACTER(LEN=80) :: chartmp 
  
  ! Read file up to the first line that satisfies the format
  ! statement
  
  nBands = 0
  WRITE(*,*) "Definition file (contains list of input files and output file):"
  write(*,*) "and number of atoms"
  READ(*,*) definitionFilename,Na
  
  CALL numberOfLines(definitionFilename, nol)
  
  IF (debug) WRITE(*,*) "Number of lines found ", nol
  
  ALLOCATE (energyfilename(nol))
  
  OPEN(UNIT=1, FILE=definitionFilename, IOSTAT=istat, STATUS='OLD')
  IF ( istat .NE. 0 ) THEN
     WRITE(*,*) "Cannot open file ", TRIM(definitionFilename), ".  Stopping."
     STOP "Could not open file"
  END IF
  DO ifile = 1, nol-1
     READ (UNIT=1, FMT='(A)', IOSTAT=istat) energyFilename(ifile)
  END DO
  READ (UNIT=1, FMT='(A)', IOSTAT=istat) outputFilename
  CLOSE(UNIT=1)
  WRITE(*,*) "Will overwrite ", outputFilename
  
  ! Now loop over all the files listed in definitionFilename
  
!!!  outputfilename = 'energy.d'
  
  DO j=1,2
     ! j loops over the passes made.  We make two passes over the files.
     ! The first pass finds the important information, like the minumum
     ! number of bands shared by all k-points, and the second pass
     ! actually reads and writes out the required energies.
     IF (j.EQ.2) THEN
        OPEN(UNIT=2, file=outputfilename, IOSTAT=istat)
        IF (istat.NE.0) THEN
           WRITE(6,*) 'Could not open file, ', energyfilename, ' properly.'
           WRITE(6,*) 'IOSTAT is ', istat
           WRITE(6,*) 'Stopping'
           STOP
        END IF
     END IF
     
     icount=0
     
     DO ifile = 1, nol-1
        OPEN(UNIT=1, FILE=energyfilename(ifile), IOSTAT=istat, STATUS='OLD')
        IF (istat.NE.0) THEN
           WRITE(*,*) 'Could not open file, ', energyfilename(ifile), ' properly'
           WRITE(*,*) 'IOSTAT is ', istat
           WRITE(*,*) 'Stopping'
           STOP
        END IF
        
       ! WRITE(*,*) "Processing ", energyFilename(ifile)
        
!!! THE INFO BELOW IS TO RIP-OUT THE HEADER INFORMATION.  YOU NEED
!!! TO PUT IN THE NUMBER OF LINES (ATOMS) BY HAND
!!! now is read from 'echo n | instgen | awk '{print $1}' | head -1'
        DO i=1, Na*2
           READ(1, FMT='(A80)', iostat=istat) chartmp
           IF (debug) WRITE(6,*) chartmp
        END DO
        IF (debug) THEN
           WRITE(6,*) "FINISHED READING HEADER"
        END IF
        
        DO
           READ(UNIT=1, iostat=istat, FMT=1001) k1, k2, k3, klabel, itmp, ne, wt
1001       FORMAT(3E19.16,A10,I6,I6,F5.1)
           IF (debug) THEN
              WRITE(*,*) "k1 =", k1
              WRITE(*,*) "k2 =", k2
              WRITE(*,*) "k3 =", k3
              WRITE(*,*) "klabel =", klabel
              WRITE(*,*) "itmp =", itmp
              WRITE(*,*) "ne =", ne
              WRITE(*,*) "wt =", wt
              WRITE(*,*) "istat ", istat
           END IF
           
           IF (istat.EQ.0) THEN
              icount = icount + 1
              IF (j.EQ.1) THEN
                 IF (icount.EQ.1) nBands=ne
                 nBands = MIN(nBands,ne)
              END IF
!!!              IF (debug) THEN
!!!                 WRITE(6,*) "icount", icount
!!!                 WRITE(6,*) "k1, k2, k3", k1, k2, k3
!!!                 WRITE(6,*) "itmp, new, wt", itmp, ne, wt
!!!              END IF
              ALLOCATE(energy(ne))
              DO i=1,ne
                 READ (1,FMT=*, iostat=istat) iband, energy(i)
                 IF (istat.EQ.0) then
                    IF (debug) WRITE(6,*) "iband", iband, "i", i
                 ELSE
                    WRITE(6,*) "Was expecting to read bandindex and energy"
                    WRITE(6,*) "istat ", istat
                    WRITE(6,*) "Stopping"
                    STOP
                 END IF
              END DO
    IF (j.EQ.2) THEN
    WRITE(2 ,'(1i4,500f18.12)') icount,(13.605698D0*energy(1:nbands))
 !  WRITE(2 ,'(1i4,500f18.12)') icount,(energy(1:nbands))
!!!  WRITE(UNIT=2,FMT=*) icount, 13.605698D0*energy(1:nbands)
!!!  WRITE(UNIT=2,FMT='(I,12F12.7)') ik, 13.605698D0*energy(43:54)
              END IF
              DEALLOCATE(energy)
!!!              ELSE
!!!              WRITE(6,*) "ik not equal icount"
!!!              WRITE(6,*) "ik ", ik
!!!              WRITE(6,*) "icount ", icount
!!!              WRITE(6,*) "Stopping"
!!!              STOP
!!!              END IF
           ELSE IF (istat.EQ.-1) THEN
              ! END OF FILE
              IF (debug) THEN
                 WRITE(6,*) "IOSTAT is ", istat
                 WRITE(6,*) "    End of file found"
              END IF
              EXIT
           ELSE
              WRITE(6,*) "YIKES"
              WRITE(6,*) "IOSTAT is ", istat
              WRITE(6,*) "STOPPING!"
              STOP
           END IF
        END DO
        CLOSE(1)
     END DO
!!! Repeat once
     IF (j.EQ.2) CLOSE(2)
  END DO
  
  WRITE(6,*) "Number of complete bands found: ", nbands


  call system( " rm -f infoenergy2script" )
  OPEN(UNIT=16, FILE="infoenergy2script", IOSTAT=istat, STATUS='new')
  write(16,*) nbands,icount
  close(16)
write(*,*) "definitionFilename : ",trim(definitionFilename)
WRITE(6,*) "Number of k points: ", icount
write(*,*) "Outputfile :",trim(outputFilename)
write(*,*) "infoenergy2script"
write(*,*) "I found the end  energyReader"

END PROGRAM energyReader



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



SUBROUTINE numberOfLines(defFilename, nol)
  IMPLICIT NONE
  CHARACTER(LEN=120), INTENT(IN) :: defFilename
  INTEGER, INTENT(OUT) :: nol
  INTEGER :: istat
  CHARACTER(LEN=1) :: dummy
  
  nol=0
  OPEN(UNIT=1,FILE=defFilename,IOSTAT=istat,STATUS='OLD')
  IF (istat .NE. 0) THEN
     WRITE(*,*) "Definition file ", TRIM(defFilename), " cannot be opened."
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
