program guagua
!!! cabellos Miercoles 12 Agosto 2009 
!!! last modification  Viernes 14 Agosto 2009 a las 11:38 
implicit none 
  INTEGER, PARAMETER :: SP = KIND(1.0)            ! single precision
  INTEGER, PARAMETER :: DP = KIND(1.0D0)          ! double precision
  INTEGER, PARAMETER :: SPC = KIND((1.0,1.0))     ! single precision complex
  INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex 
  REAL(DP), PARAMETER :: pi = 3.1415926535897932384626433832795d0            ! pi
  CHARACTER(LEN=255) ::  energy_data_filename  ! energy input file
  INTEGER :: istat, ArgC
  REAL(DP), ALLOCATABLE :: energy(:,:), difer(:),difer1(:)
  DOUBLE PRECISION :: unscissored_band_gap
  DOUBLE PRECISION :: highest_valence_energy
  DOUBLE PRECISION :: direct_gap,minimo,maximo,cual,tini
  INTEGER :: kMax, nMax, file_ik,i,ik,nVal,ikdifer, valencia,conduccion
  INTEGER :: direct_gap_kpoint,CCC,counter,nCon,NofL,nValwish
   DOUBLE PRECISION :: Deltita, bajoNivel, altoNivel,Evv,Ecc

  

  kMax=391
  nMax=40
  file_ik=391
  nVal=8
  CCC=5

   !kMax=16215
   !nMax=40
   !file_ik=16215
   !nVal=8






    ArgC=IArgC() !number of arguemnts
     if (ArgC==1) then
     CALL GETARG(1,energy_data_filename)
     else
     write(*,*)"Usage : progrma 'energy data file]" 
     stop
     end if  

     energy_data_filename=trim(energy_data_filename)
     
     call NumberofLines(kMax,energy_data_filename)
     write(*,*)"Your Number of Kpoints are: is it true...? ",kMax
     file_ik=kMax
     call  NumberofCol(nMax,energy_data_filename)
     write(*,*)"Your Number of Bnands: is it true...? ",nMax-1
      nMax=nMax-1
     !write(*,*)"Right now is impossible for my to know how many valence bands this file has"
     !write(*,*)"How many valence bands does this file has?"
     read(119,*)nVal  
     write(*,*)"Your Number Valence Bandas : is it true...? ",nVal
     write(*,*)"Then you have conductions bands  ", nMax-nVal
     write(*,*)"=============================================================="
     write(*,*)"which conduction band do you want to make the plot ? 1-",nMax-nVal
     write(*,*)"NOTE: 1 is the lowest conduction band .."
     read(*,*)CCC     
     write(*,*)"which valence band do you want to make the plot? ","1-",nVal
     write(*,*)"NOTE:",nVal,"is the highest valence band .."
     read(*,*)nValwish
               WRITE(*,*) "===================================="
               WRITE(*,*) "Program Flow: entered read EnergyFile"
               WRITE(*,*) "===================================="
    
   OPEN(UNIT=10, FILE=energy_data_filename, STATUS='OLD', IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) "Could not open file ", TRIM(energy_data_filename)
       WRITE(6,*) "Stopping"
       STOP
    ELSE
       WRITE(6,*) 'Opened file: ', TRIM(energy_data_filename)
    END IF


  ALLOCATE (energy(kMax,nMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF
   ALLOCATE (difer(kMax), STAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Could not allocate energy'
       WRITE(6,*) 'Stopping'
       STOP
    END IF







 DO ik = 1, kMax
         READ(UNIT=10,FMT=*, IOSTAT=istat) file_ik, (energy(ik,i), i = 1, nMax)
     IF (istat.EQ.0) THEN
         IF ((ik<11).OR.(MOD(ik,100).EQ.0).OR.(ik.EQ.kMax)) THEN
             WRITE(6,*) ik, file_ik
         END IF
      ELSE IF (istat.EQ.-1) THEN
          WRITE(6,*) 'Prematurely reached end of file ', TRIM(energy_data_filename)
          WRITE(6,*) 'Stopping'
          STOP
      ELSE IF (istat.EQ.1) THEN
          WRITE(6,*) 'Problem reading file', TRIM(energy_data_filename)
          WRITE(6,*) 'Stopping'
          STOP
      ELSE
          WRITE(6,*) 'Unexpected error reading file', TRIM(energy_data_filename)
          WRITE(6,*) 'IOSTAT error is: ', istat
      END IF
 end do 
       READ(UNIT=10,FMT=*, IOSTAT=istat) file_ik
    IF (istat.EQ.-1) THEN
       WRITE(*,*)
       WRITE(*,*) "Reached end of energy file ",TRIM(energy_data_filename)
       WRITE(*,*)
    ELSE
       ! File did not end
       WRITE(*,*) 
       WRITE(*,*) "Energy file ", TRIM(energy_data_filename), " was not at End Of File"
       WRITE(*,*) "Stopping"
       STOP
    END IF
    CLOSE(UNIT=10)


!!!!!! =====================================
!!!!!! =====================================
!!!!!! =====================================
!!!!!! =====================================
!!!!!! =====================================

   highest_valence_energy = MAXVAL(energy(:,nValwish)) 
    unscissored_band_gap = MINVAL(energy(:,nVal+CCC)) - highest_valence_energy
   
    
    WRITE(*,*) 'Unscissored band gap is (direct or indirect): ', unscissored_band_gap
   ! find direct gap
    direct_gap_kpoint = 0.d0
    direct_gap = 999.0d9
    DO ik=1,kMax
       IF ((energy(ik,nVal+CCC)-energy(ik,nValwish)).LT.direct_gap) THEN
          direct_gap = energy(ik,nVal+CCC)-energy(ik,nValwish)
          direct_gap_kpoint = ik
       END IF
    END DO
    IF (direct_gap_kpoint .EQ. 0) THEN
       STOP 'Error finding direct gap'
    END IF
   !WRITE(*,*) "Direct gap found at k-point:", direct_gap_kpoint
    WRITE(*,*) "============================================"
    WRITE(*,*) "Direct gap found to be:", direct_gap,"in K point", direct_gap_kpoint 
    WRITE(*,*) "============================================"
   !!! right now find all k points that contribute in the range of loewst=direct_gap-Deltita
   !!! right now find all k points that contribute in the range of highest=direct_gap+Deltita
    DO ik=1,kMax
          difer(ik)=(energy(ik,nVal+CCC)-energy(ik,nValwish))
   END DO
   maximo= MAXVAL(difer(:))
   minimo= minVAL(difer(:))
   DO ik=1,kMax
          if (maximo.eq.difer(ik)) then
          write(*,*)"maximo",difer(ik),"en el punto K", ik 
          end if 
          if (minimo.eq.difer(ik)) then
          write(*,*)"minimo",difer(ik),"en el punto K", ik  
          end if       
   END DO  
   write(*,*)"What value of Eo do you want?"
   read(*,*) cual
   write(*,*)"What value of Delta do you want?"
   read(*,*)Deltita

   bajoNivel= cual-Deltita
   altoNivel= cual+Deltita
   !write(*,*)"bajo nivel", bajoNivel
   !write(*,*)"bajo nivel", altoNivel
   write(*,*)"Rango de energias", 2*Deltita
   write(*,*)"centro en : ",cual
   write(*,*)"bajo nivel", bajoNivel
   write(*,*)"alto nivel", altoNivel
   Evv=energy(direct_gap_kpoint,nValwish)
   Ecc=energy(direct_gap_kpoint,nVal+CCC)
   
   write(34,*)"set term pslatex color solid aux"
   write(34,*)"set output 'fig.tex'"
   write(34,*)"set multiplot"
   write(34,*)"set lmargin 0"
   write(34,*)"set origin .0,-.4"
   write(34,*)"set size 0.8,0.9"
   write(34,*)"set ylabel '\Large  energy (eV)' .5,0"
   write(34,*)"set xrange [1.4:4]"
   write(34,*)"set yrange [-.2:.60]"
   write(34,*)"set  ytics nomirror"  
   write(34,*)"set xzeroaxis"
   write(34,*)"set key spacing 1.75"
   write(34,*)"set auto"
   write(34,*)"set nokey"
   write(34,*)"set grid xtics"
   write(34,*)"COGAP=3"
   write(34,*)"Evv=",Evv
   write(34,*)"Ecc=",Ecc
   
    counter=0
    DO ik=1,kMax
      IF ((energy(ik,nVal+CCC)-energy(ik,nValwish)).gt.bajoNivel) THEN
       IF ((energy(ik,nVal+CCC)-energy(ik,nValwish)).LT.altoNivel) THEN
        counter=counter+1
      write(34,'(a9,1I6,a5,1I8,a2,1f8.3,a4,1I6,a2,1f8.3,a9)')"set arrow",counter,"from",ik,",",(energy(ik,nValwish))-Evv,"to",ik,",",(energy(ik,nVal+CCC))-Evv,"nohead"
      write(*,'(a9,1I6,a5,1I8,a2,1f8.3,a4,1I6,a2,1f8.3,a10)')"set arrow",counter,"from",ik,",",(energy(ik,nValwish))-Evv,"to",ik,",",(energy(ik,nVal+CCC))-Evv,"nohead"
      write(120,*)ik
          END IF
        END IF
     END DO                                                
  ! write(34,'(*)'set label "x=',Deltita,'at',nMax/2,'5'
   write(34,'(a4,1f4.2)')"E0=",cual
   write(34,'(a7,1f4.2)')"Delta=",Deltita
   write(34,*)"Arows=",counter 
   write(34,*)"plot '",trim(energy_data_filename),"' u 1:($",nValwish+1,"-Evv) title '1' w l lt 1 lw 2,\"
   write(34,*)"     '",trim(energy_data_filename),"' u 1:($",(nVal+1+CCC),"-Evv) title '1' w l lt 1 lw 2"
   
   call system('mv fort.34 salida.g')
   write(*,*)"Number of Arows= ",counter 

deallocate (energy,difer)

 write(*,*)"The k points are in fort.120, check it ", counter
 write(*,*)"salida es: salida.g ", counter

end program guagua

subroutine NumberofLines(NofL,filein) 
!! function :: count the number of lines of the file "zeta.dat"
!!             the same with  awk '{print NR}' zeta.dat
implicit none
integer,PARAMETER :: DP=KIND(1.d0)
REAL(DP) :: intmpx, intmpf(6)
REAL(DP) :: inputdata(2) 
integer, intent(out) :: NofL
integer :: i,ioerror
character(len=255) :: filein
 
 OPEN(10,FILE=filein ) 
 i=0 
do 
 READ(10,FMT=*,IOSTAT=ioerror)inputdata(1:2) 
  IF (ioerror==0) THEN 
      i=i+1
    ELSE IF (ioerror == -1) THEN
          IF (i == 0) THEN
           close(10)
           return
          END IF
        NofL = i
          close(10)
          return
       ELSE
          STOP 'ERROR,line=130 mysmear4.f90 your file is empty  Maybe... '
       END IF
    ENDDO   
end subroutine NumberofLines
 subroutine NumberofCol(NofC,filein)
 !! Cabellos Agosto 13 2009 
 integer, intent(out) :: NofC
 character(len=255) :: filein
 real :: value
  integer::i,j,number,error
  character(2800) :: s
  OPEN(10,FILE=filein ) 
    read (10,'(a)') s
  do i=1, 180
      read(s, *, iostat = error) ( value, j=1,i)
      if ( error.ne.0) then
         number = i - 1
         exit
      endif
  end do
  NofC = number
  close(10)
 end subroutine NumberofCol
