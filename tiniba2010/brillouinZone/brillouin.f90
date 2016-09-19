 program brillouin
  implicit none
  INTEGER, PARAMETER :: SP = KIND(1.0)            ! single precision
  INTEGER, PARAMETER :: DP = KIND(1.0D0)          ! double precision
  INTEGER, PARAMETER :: SPC = KIND((1.0,1.0))     ! single precision complex
  INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex

  integer :: IArgC,ArgC,isthis
  integer :: iteracion,i,j,NofL
  integer :: ioerror
  REAL(DP) :: inputdata(2) 
  REAL(DP),allocatable :: mydato(:) 
  REAL(DP),allocatable :: fx(:) 
  REAL(DP),allocatable :: xx(:) 
  REAL(DP) :: lambda 



  character :: ArgV(4)*200
  character(len=200) :: filein
  character(len=255) :: fileout
  character(len=255) :: option
!!!==================================

  character(len=255) :: pmnFile
  character(len=255) :: pnnFile
  character(len=255) :: eigenFile
  character(len=255) :: energysFile
  character(len=255) :: halfenergysFile
  character(len=255) :: integrando
  character(len=10) :: ckmax
  character(len=10) :: cnval
  character(len=10) :: cncon

!!!==================================



  integer :: io_status
  REAL(DP) :: matTemp(6)
  COMPLEX(DPC), ALLOCATABLE :: momMatElem(:,:,:)
  REAL(DP), ALLOCATABLE :: velMatElem(:,:)
  COMPLEX(DPC), ALLOCATABLE :: posMatElem(:,:,:)
  REAL(DP), ALLOCATABLE :: energy(:,:), energys(:,:)
  REAL(DP), ALLOCATABLE :: energy_Out(:)
  REAL(DP), ALLOCATABLE :: temMax(:)
  COMPLEX(DPC), ALLOCATABLE :: omega(:)  
  COMPLEX(DPC), ALLOCATABLE :: ctmp3(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: Delta(:,:,:)
  COMPLEX(DPC), ALLOCATABLE :: calMomMatElem(:,:,:)

  logical :: filexist
  REAL(DP) :: divide
!!!==================================
  integer :: kMax                 !! number of kpoints
  integer :: nMax                 !! total number of bands
  integer :: nCon                 !! number of conduction bands
  integer :: nVal                 !! number of valence bands
  REAL(DP) :: actualBandGap=0.d0  !! actual band gap in eV
  REAL(DP) :: scissor             !! scissor shift in eV
  REAL(DP) :: tol                 !! tolerance for degeneracy
  INTEGER :: nSym                 !! number of symmetry operations
  REAL(DP) :: eStepsize           !! energy step 
  REAL(DP) :: energy_Max          !! energy max 
  REAL(DP) :: energy_Min          !! energy min 
  INTEGER  :: energy_Steps        !! energy steps
  integer ::  ienergy                    !! ienergy   
  REAL(DP) :: step           !! step
  integer :: counter  
  REAL(DP) :: omegavc
  REAL(DP) :: fsc   
  COMPLEX(DPC) :: tmp
  COMPLEX(DPC) :: meavc
  COMPLEX(DPC) :: ctmp
  REAL(DP) :: deltata

  integer :: iv,ic,ik
  integer :: istat,l,ii,jj
  integer :: fik
  integer :: ix,iy
  integer, parameter :: tolchoice = 0
  integer :: indexOmega
  integer :: iw,iwMax

  ArgC=IArgC() !number of arguemnts
  if (ArgC==6) then
     call GETARG(1,eigenFile)
     call GETARG(2,pmnFile)   
     call GETARG(3,pnnFile)   
     call GETARG(4,ckmax)   
     call GETARG(5,cnVal)   
     call GETARG(6,cnCon)
     read(ckmax,*)kmax
     read(cnval,*)nval
     read(cncon,*)ncon
  else
     write(*,*) " Usage: brillouin [Energy File] [Momentum File] "       
     stop
  endif

  energy_Min=0
  energy_Max=20
  energy_Steps=2001

!  kMax=55
!  nVal=4
!  nCon=4
  nMax=nVal+nCon
  tol= 0.03
  actualBandGap=0.d0
  !!actualBandGap=1.52 !!! better experimental band gap jjeje 
  energysFile="energys.d"
  halfenergysFile="halfenergys.d" 
  integrando="integrand.d"
  !!despues este tiene que entrar por un archivo ...
!!!==================================
105 FORMAT(6E18.8) 


!!!==========begin executable===============

!!!==========ALLOCATE ARRAYS ===============

  ALLOCATE (momMatElem(3,nMax,nMax), STAT=istat)
  if (istat.NE.0) then
     write(6,*) 'Could not allocate momMatElem'
     write(6,*) 'Stopping'
     stop
  end if
  ALLOCATE (velMatElem(3,nMax), STAT=istat)
  if (istat.NE.0) then
     write(6,*) 'Could not allocate velMatElem'
     write(6,*) 'Stopping'
     stop
  end if
  ALLOCATE (posMatElem(3,nMax,nMax), STAT=istat)
  IF (istat.NE.0) THEN
     WRITE(*,*) 'Could not allocate posMatElem'
     WRITE(*,*) 'Stopping'
     STOP
  END IF


  ALLOCATE (energy(kMax,nMax), STAT=istat)
  IF (istat.NE.0) THEN
     WRITE(6,*) 'Could not allocate energy'
     WRITE(6,*) 'Stopping'
     STOP
  END IF
  ALLOCATE (energys(kMax,nMax), STAT=istat)
  IF (istat.NE.0) THEN
     WRITE(6,*) 'Could not allocate energys'
     WRITE(6,*) 'Stopping'
     STOP
  END IF
  ALLOCATE (Delta(3,nMax,nMax), STAT=istat)
  IF (istat.NE.0) THEN
     WRITE(6,*) 'Could not allocate Delta'
     WRITE(6,*) 'Stopping'
     stop
  END IF



!!!==========ALLOCATE ARRAYS ===============
!!!==========ALLOCATE ARRAYS ===============
!!!==========ALLOCATE ARRAYS ===============

!!!==========OPEN FILES ====================
!!!==========OPEN FILES ====================
!!!==========OPEN FILES ====================

  OPEN(UNIT=60, FILE=energysFile, STATUS='UNKNOWN', IOSTAT=istat)
  IF (istat.NE.0) THEN
     WRITE(6,*) "Error opening file ", TRIM(energysFile)
     WRITE(6,*) "Stopping"
     STOP
  ELSE
     WRITE(6,*) 'Opened file: ', TRIM(energysFile)
  END IF
  OPEN(UNIT=61, FILE=halfenergysFile, STATUS='UNKNOWN', IOSTAT=istat)
  IF (istat.NE.0) THEN
     WRITE(6,*) "Error opening file ", TRIM(halfenergysFile)
     WRITE(6,*) "Stopping"
     STOP
  ELSE
     WRITE(6,*) 'Opened file: ', TRIM(halfenergysFile)
  END IF

  OPEN(UNIT=89, FILE="Symmetries.Cartesian",IOSTAT=istat)
  IF (istat.NE.0) THEN
     WRITE(*,*) "Could not open file Symmetries.Cartesian"
     WRITE(*,*) "Stopping"
     STOP "Stopping: Could not open file Symmetries.Cartesian"
  END IF


!!!==========OPEN FILES ====================
!!!==========OPEN FILES ====================
!!!==========OPEN FILES ====================





  eigenFile=trim(eigenFile)
    pmnFile=trim(pmnFile)
    pnnFile=trim(pnnFile)

  inquire (file=eigenFile,exist=filexist)
  if (.NOT. filexist) then
     write(*,*)'Error, missing file: ',trim(eigenFile)
     stop
  else 
     write(*,*)"Energy file  : ",trim(eigenFile)
  end if
  inquire (file=pmnFile,exist=filexist)
  if (.NOT. filexist) then
     write(*,*)'Error, missing file : ',trim(pmnFile)
     stop
  else 
     write(*,*)"pmn file     : ",trim(pmnFile)
  end if
  WRITE(*,*) "Program Flow: entered read PmnFile  : ", trim(pmnFile)
  inquire (file=pnnFile,exist=filexist)
  if (.NOT. filexist) then
     write(*,*)'Error, missing file : ',trim(pnnFile)
     stop
  else 
     write(*,*)"pnn file     : ",trim(pnnFile)
  end if
  WRITE(*,*) "Program Flow: entered read PnnFile  : ", trim(pnnFile)
!!!========== read pmn =============       
  open (11, FILE=pmnFile, STATUS='OLD', IOSTAT=io_status) 
  if (io_status /= 0) then
     write(*,*)"Error trying to open:",trim(pmnFile)
     stop "Stopping"
  end if

  write(*,*)"Pmn File: ",trim(pmnFile)

  do ik = 1, kMax
     write(*,*)"ik=",ik
     do iv = 1,nMax
        do ic = iv,nMax 

           READ(11,*) (matTemp(l), l=1,6)
           momMatElem(1,iv,ic) = matTemp(1) + (0.0d0,1.0d0)*matTemp(2)
           momMatElem(2,iv,ic) = matTemp(3) + (0.0d0,1.0d0)*matTemp(4)
           momMatElem(3,iv,ic) = matTemp(5) + (0.0d0,1.0d0)*matTemp(6)
           IF (ic.NE.iv) THEN
              DO ii=1,3
                 momMatElem(ii,ic,iv) = CONJG(momMatElem(ii,iv,ic))
              END DO
           END IF
        end do  !! iv
     end do   !! ic

     !! set the imaginary parts of the diagonal componenets to zero by hand
     do iv = 1, nMax
        momMatElem(1,iv,iv)= REAL(momMatElem(1,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(2,iv,iv)= REAL(momMatElem(2,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(3,iv,iv)= REAL(momMatElem(3,iv,iv)) + 0.d0*(0.d0,1.d0)
     end do

     !! calculate the deltas 
     do iv = 1, nVal
        do ic = nVal+1, nMax
           Delta(1,ic,iv) = momMatElem(1,ic,ic)-momMatElem(1,iv,iv)
           Delta(2,ic,iv) = momMatElem(2,ic,ic)-momMatElem(2,iv,iv)
           Delta(3,ic,iv) = momMatElem(3,ic,ic)-momMatElem(3,iv,iv)
           !IF ( layeredCalculation ) then
           !   calDelta(1,ic,iv) = calmomMatElem(1,ic,ic)-calmomMatElem(1,iv,iv)
           !   calDelta(2,ic,iv) = calmomMatElem(2,ic,ic)-calmomMatElem(2,iv,iv)
           !   calDelta(3,ic,iv) = calmomMatElem(3,ic,ic)-calmomMatElem(3,iv,iv)
           !END IF
        end do
     end do

  end do !! ik

!!! check the end of input pmn file 
  matTemp(1:6) = 0.d0
  READ(11,*,IOSTAT=io_status) (matTemp(l), l=1,6)
  IF (io_status.LE.0) THEN
     WRITE(*,*) "   End of pnm matrix elements file reached"
     CLOSE(11)
  ELSE IF(io_status.EQ.0) THEN
     WRITE(*,*) (matTemp(l), l=1,6)
     STOP 'pmn file contains more data than expected'
  ELSE
     STOP 'reading end of pmn file caused an error.'
  END IF


!!!========== read pnn =============       
  open (12, FILE=pnnFile, STATUS='OLD', IOSTAT=io_status) 
  if (io_status /= 0) then
     write(*,*)"Error trying to open:",trim(pnnFile)
     stop "Stopping"
  end if

  write(*,*)"Pnn File: ",trim(pnnFile)

  do ik = 1, kMax
     write(*,*)"ik=",ik
     do iv = 1,nMax
        do ic = iv,nMax 
           if(iv.eq.ic)then
              READ(12,*) (matTemp(l), l=1,3)
              velMatElem(1,iv) = matTemp(1)
              velMatElem(2,iv) = matTemp(2)
              velMatElem(3,iv) = matTemp(3)
           end if
        end do  !! iv
     end do   !! ic
  end do !! ik


!!! check the end of input pnn file 
  matTemp(1:6) = 0.d0
  READ(12,*,IOSTAT=io_status) (matTemp(l), l=1,6)
  IF (io_status.LE.0) THEN
     WRITE(*,*) "   End of pnn matrix elements file reached"
     CLOSE(12)
  ELSE IF(io_status.EQ.0) THEN
     WRITE(*,*) (matTemp(l), l=1,6)
     STOP 'pnn file contains more data than expected'
  ELSE
     STOP 'reading end of pnn file caused an error.'
  END IF

!!!========== read pmn =============
!!!========== read pmn =============
!!!========== read pmn =============
!!!========== read eigen =============
!!!========== read eigen =============
!!!========== read eigen =============

  write(*,*)
  write(*,*) "Program Flow: entered read EnergyFile  : ", trim(eigenFile)

  open(UNIT=10, FILE=eigenFile, STATUS='OLD', IOSTAT=istat)
  if (istat.NE.0) then
     write(*,*) "Could not open file ", trim(eigenFile)
     write(*,*) "Stopping"
     stop
  else
     write(6,*) 'Opened file: ', trim(eigenFile)
  end if

  do ik = 1, kMax
     read(UNIT=10,FMT=*, IOSTAT=istat) fik, (energy(ik,i), i = 1, nMax)

     if (istat.eq.0) then 
        write(*,*)ik,fik
     else if (istat.EQ.-1) then 
        write(*,*)"Prematurely reached end of file", trim(eigenFile)
        stop "Stopping"
     else if (istat.EQ.1) then 
        write(*,*)"Problem reading file", trim(eigenFile)
        stop "Stopping"
     else 
        write(*,*)"Problem reading file", trim(eigenFile)
        stop "Stopping"
     end if
  end do
  READ(UNIT=10,FMT=*, IOSTAT=istat) fik
  if (istat.EQ.-1) then 
     write(*,*)"reached end of file  : ", trim(eigenFile)
     close(10)
  else 
     write(*,*)"Problem reading file was not EOF : ", trim(eigenFile)
     stop "Stopping"
  end if

!!! ========= scissors energy ================
!!! ========= scissors energy ================
!!! ========= scissors energy ================
  write(*,*)actualBandGap
  if ( actualBandGap.lt.(energy(1, nVal+1) - energy(1,nVal)))then
     actualBandGap=abs((energy(1, nVal+1) - energy(1,nVal)))
  end if


  scissor = actualBandGaP - (energy(1, nVal+1) - energy(1,nVal))
  if ( scissor.lt.1.d-3) then 
     scissor=0.d0 ! better zero 
  end if
  DO ik = 1, kMax
     energys(ik,1:nVal) = energy(ik,1:nVal)
     energys(ik,nVal+1:nMax) = energy(ik,nVal+1:nMax)+scissor
     WRITE(60,*) ik, (energys(ik,i), i = 1, nMax)       !!energys (scissors)
     WRITE(61,*) ik, (0.5d0*energys(ik,i), i = 1, nMax) !!half energys
  END DO

  write(*,*) "Program Flow: entered scissorEnergies" 
  write(*,*) 'Energy diffs between the HOVB and LUCB are:'
  write(*,*) energy(1, nVal+1) - energy(1,nVal)    
  write(*,*) 'Scissor Shift is ', scissor 
  WRITE(6,*) 'Adjusted Band Gap is', energy(1, nVal+1) - energy(1,nVal) + scissor  
!!!========== calcualte rmn ========
!!!========== calcualte rmn ========
!!!========== calcualte rmn ========
!!! Use unscissored band energies to calculate rmn
!!! Use unscissored band energies to calculate rmn
!!! Use unscissored band energies to calculate rmn
  do ik = 1, kMax
     write(*,*)"ik=",ik," calculating position matrix elements"
     do iv = 1,nMax
        do ic = iv,nMax
           do ii=1,3

              tmp = (0.d0, 0.d0)
              if (iv.ne.ic) then 
                 omegavc = energy(ik,iv) - energy(ik,ic)
                 select case(tolchoice)
                 case(0)
                    if (DABS(omegavc).LT.tol) THEN
                       tmp = (0.d0, 0.d0)
                       if (iv.eq.nVal.and.ic.eq.nVal+1) then 
                          write(*,*)"The tol value is bigger than the gap"
                          stop 
                       end if
                    else   
                       meavc = momMatElem(ii,iv,ic)
                       tmp = meavc/omegavc
                       tmp = tmp/(0.d0, 1.d0)
                    end if
                 case(1)
                    if (DABS(omegavc).LT.tol) THEN
                       if (omegavc.lt.0.d0) omegavc =-tol
                       if (omegavc.gt.0.d0) omegavc = tol
                    end if
                    if (DABS(omegavc).gt.0.d0) THEN
                       meavc = momMatElem(ii,iv,ic)
                       tmp = meavc/omegavc
                       tmp = tmp/(0.d0, 1.d0)
                    else 
                       tmp = (0.d0, 0.d0)
                    end if
                 case default 
                    stop "problem with tolchoice"
                 end select

              else if (iv.eq.ic) then
                 tmp = (0.d0, 0.d0)
              else 
                 stop "problem with position"
              end if
              posMatElem(ii,iv,ic)=tmp
              posMatElem(ii,ic,iv)=conjg(tmp)
           end do !! ii
        end do   !! ic
     end do     !! iv
  end do       !! ik
!!!-------------------------
!!!write posMatElem 
  !103        FORMAT(6E18.8) 
  ! DO ik = 1, kMax
  !   write(*,*)"ik=",ik," Written  position  matrix elements"
  !     DO iv = 1, nMax
  !        DO ic = iv, nMax
  !                 WRITE(68,103) REAL(posMatElem(1,iv,ic)),aimag(posMatElem(1,iv,ic)) &
  !                   , REAL(posMatElem(2,iv,ic)),aimag(posMatElem(2,iv,ic)) &
  !                   , REAL(posMatElem(3,iv,ic)),aimag(posMatElem(3,iv,ic))
  !
  !  end do 
  ! end do 
  !end do
!!!-------------------------
!!!write momMatElem 
  !do ik = 1, kMax
  !   write(*,*)"ik=",ik," Written  momentum  matrix elements"
  !   do iv = 1,nMax
  !    do ic = iv,nMax
  !     write(67,103) real(momMatElem(1,iv,ic)),aimag(momMatElem(1,iv,ic)) &
  !                  ,real(momMatElem(2,iv,ic)),aimag(momMatElem(2,iv,ic)) &
  !                  ,real(momMatElem(3,iv,ic)),aimag(momMatElem(3,iv,ic))
  !    end do   !! ic
  !  end do     !! iv
  !end do       !! ik
!!! 
!!!========== calcualte rmn ========
!!!========== calcualte rmn ========
!!!========== calcualte rmn ========
!!!========== viernes ==============
!!!========== viernes ==============
!!!========== viernes ==============
!!!========== integrand ============
!!!========== integrand ============
!!!========== integrand ============
  ALLOCATE (ctmp3(3,3000,50000), STAT=istat)
  if (istat.NE.0) then
     write(6,*) 'Could not allocate momMatElem'
     write(6,*) 'Stopping'
     stop
  end if


  deltata=0.05
  !104 FORMAT(E15.7)
  ctmp3(:,:,:) =(0.d0,0.d0)
  do ik = 1, kMax
     !   write(*,*)"ik=",ik," calculating Integrand "
     do  iv = 1, nVal
        do ic = nVal+1, nMax
           iw =int((energy(ik,ic)-energy(ik,iv))/deltata) !! here we dont know the size of the grid !!!!
           ctmp3(1,ik,iw) = ctmp3(1,ik,iw) + (velMatElem(2,ic)-velMatElem(2,iv))*posMatElem(2,ic,iv)*posMatElem(1,iv,ic) !! just one comp. yyx

           !          if (ik.eq.22)then
           !             if((iv.eq.48).and.(ic.eq.49))write(*,*)energy(ik,ic)-energy(ik,iv),iw 
           !          end if


        end do  !! ic
     end do    !! iv
     write(32,*)ik,real(ctmp3(1,ik,iw)),aimag(ctmp3(1,ik,iw))
  end do       !! ik
  !
  iwMax=20/deltata !! eV
  !write(*,*)"Max",iwMax


  ! perro(:,:)=(0,0)
  do iw=  1, iwMax
     ctmp=(0.d0,0.d0)
     do ik = 1, kMax
        !    write(*,*)"Max",iw,iwMax
        ctmp=ctmp+ctmp3(1,ik,iw)
     end do
     ! write(*,*)(iw*delta), real(ctmp),aimag(ctmp)
     write(31,*)(iw*deltata), real(ctmp),aimag(ctmp)
  end do





  stop 

!!!========== viernes ==============
!!!========== integrand ============
!!!========== integrand ============
!!!========== integrand ============
  !delta=0.05
  !104 FORMAT(E15.7)
  ! ctmp(:,:,:) =(0.d0,0.d0)
  ! do ik = 1, kMax
  !   write(*,*)"ik=",ik," calculating Integrand "
  !     do  iv = 1, nVal
  !       do ic = nVal+1, nMax
  !         iw =int((energy(ik,ic)-energy(ik,iv))/delta)
  !           !do ix=1,3
  !           !  do iy=1,3
  !                 !!ctmp = ctmp + T2(ix,iy)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,ic)
  !                 ctmp(1,ik,iw) = ctmp(1,ik,iw) + posMatElem(1,ic,iv)*posMatElem(1,iv,ic)
  !                 ctmp(2,ik,iw) = ctmp(2,ik,iw) + posMatElem(2,ic,iv)*posMatElem(2,iv,ic)
  !                 ctmp(3,ik,iw) = ctmp(3,ik,iw) + posMatElem(3,ic,iv)*posMatElem(3,iv,ic)
  !            ! end do
  !           !end do 
  !            !  if (ic==nMax) then
  !            !    write(unit=,FMT=104,ADVANCE="YES")real(ctmp)
  !            !  else 
  !            !    write(UNIT=,FMT=104,ADVANCE="NO") real(ctmp)
  !            !  end if 
  !     end do  !! ic
  !   end do    !! iv
  !end do       !! ik
  !
  !iwMax=20/delta !! eV
  ! perro(:,:)=(0,0)
  !do iw=  1, iwMax
  !  do ik = 1, kMax
  !  perro(1,iw)=perro(1,iw)+ctmp(1,ik,iw)
  !  perro(2,iw)=perro(2,iw)+ctmp(2,ik,iw)
  !  perro(3,iw)=perro(3,iw)+ctmp(3,ik,iw)
  !  end do 
  !write(*,*)iw*delta, perro(1,iw),perro(2,iw),perro(3,iw)
  !end do 



  deallocate (posMatElem, STAT=istat)  
  deallocate (momMatElem, STAT=istat)
  deallocate (energy, STAT=istat)
  deallocate (energys, STAT=istat)
  deallocate(energy_Out)
  deallocate(omega)
end program brillouin

