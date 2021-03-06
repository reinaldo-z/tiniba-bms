!{\src2tex{textfont=tt}}
!!****f* ABINIT/hdr_io
!! NAME
!! hdr_io
!!
!! FUNCTION
!! This subroutine deals with the I/O of the hdr_type
!! structured variables (read/write/echo).
!! According to the value of rdwr, it reads the header
!! of a file, writes it, or echo the value of the structured
!! variable to a file.
!! Note that, when reading, different records of hdr
!! are allocated here, according to the values of the
!! read variables. Records of hdr should be deallocated
!! correctly by a call to hdr_clean when hdr is not used anymore.
!! Two instances of the hdr_io routines are defined :
!!  hdr_io_int to which only the unit number is given
!!  hdr_io_wfftype to which a wffil datatype is given
!!
!! COPYRIGHT
!! Copyright (C) 2002-2004 ABINIT group (XG)
!! This file is distributed under the terms of the
!! GNU General Public License, see ~ABINIT/Infos/copyright
!! or http://www.gnu.org/copyleft/gpl.txt .
!! For the initials of contributors, see ~ABINIT/Infos/contributors.
!!
!! INPUTS
!!  rdwr= if 1, read the hdr structured variable from the header of the file,
!!        if 2, write the header to unformatted file
!!        if 3, echo part of the header to formatted file (records 1 and 2)
!!        if 4, echo the header to formatted file
!!        if 5, read the hdr without rewinding (unformatted)
!!        if 6, read the hdr without rewinding (unformatted)
!!  unitfi=unit number of the file (unformatted if rdwr=1, 2, 5 or 6 formatted if rdwr=3,4)
!!
!! OUTPUT
!!  (see side effects)
!!
!! SIDE EFFECTS
!!  The following variables are both input or output :
!!  fform=kind of the array in the file
!!   if rdwr=1,5 : will be output ; if the reading fail, return fform=0
!!   if rdwr=2,3,4,6 : should be input, will be written or echo to file
!!  hdr <type(hdr_type)>=the header structured variable
!!   if rdwr=1,5 : will be output
!!   if rdwr=2,3,4,6 : should be input, will be written or echo to file
!!
!! NOTES
!! In all cases, the file is supposed to be open already
!! When reading (rdwr=1) or writing (rdwr=2), rewind the file
!! When echoing (rdwr=3) does not rewind the file.
!! When reading (rdwr=5) or writing (rdwr=6), DOES NOT rewind the file
!!
!! PARENTS
!!      conducti,cut3d,initaim,inwffil3,ioarr,macroave,newsp,outkss,outwf
!!      rdem1,rdkss,testepsm1,testlda,uderiv,vtorho3,wrem1
!!
!! CHILDREN
!!      leave_new,wrtout
!!
!! SOURCE

 subroutine hdr_io_wfftype(fform,hdr,rdwr,wff)

 use defs_basis
 use defs_datatypes

 implicit none
#          if defined MPI || defined MPI_FFT
           include 'mpif.h'
#          endif

!Arguments ------------------------------------
 integer,intent(inout) :: fform
 integer,intent(in) :: rdwr
 type(hdr_type),intent(inout) :: hdr
 type(wffile_type),intent(in) :: wff

!Local variables-------------------------------
 integer :: unitfi,ierr

! *************************************************************************

!DEBUG
! write(6,*)' hdr_io : enter hdr_io_wfftype '
! call flush(6)
!ENDDEBUG

 if( wff%accesswff==0                            .or. &
&   (wff%accesswff==-1 .and.wff%master==wff%me).or. &
&   (wff%accesswff==1  .and.wff%master==wff%me)    ) then
  call hdr_io_int(fform,hdr,rdwr,wff%unwff)
 end if

#          if defined MPI
!          In the parallel case, if the files were not local, need to bcast the data
           if(rdwr==1)then
            if (wff%accesswff==-1 .or. wff%accesswff==1) then
             call MPI_BCAST(fform,1,MPI_INTEGER,wff%master,wff%spaceComm,ierr)
             call hdr_comm(hdr,wff%master,wff%me,wff%spaceComm)
!            XG 040121 : I am not sure that the next line is correct
             if(wff%accesswff==1 .and. wff%master/=wff%me)then
              call hdr_skip_wfftype(wff,ierr)
             end if
            end if
           end if
#          endif

 end subroutine hdr_io_wfftype

!-----------------------------------------------------------------------------------

 subroutine hdr_io_int(fform,hdr,rdwr,unitfi)

 use defs_basis
 use defs_datatypes

 implicit none

!Arguments ------------------------------------
 integer,intent(inout) :: fform
 integer,intent(in) :: rdwr,unitfi
 type(hdr_type),intent(inout) :: hdr

!Local variables-------------------------------
 integer :: bantot,bsize,headform,iatom,ii,ikpt,ilmn,ipsp,ispden,isym
 integer :: itypat,jlmn,lloc,lmax,lmn2_size,mmax,natom,nkpt,npsp,nsppol
 integer :: nsym,ntypat
 character(len=500) :: message
 character(len=6) :: codvsn
 real(dp) :: acell(3)
 real(dp), allocatable :: buffer(:)

! *************************************************************************

!DEBUG
! write(6,*)' hdr_io : enter hdr_io_int '
! call flush(6)
!ENDDEBUG

! -------------------------------------------------------------------------
! Reading the header of an unformatted file
! -------------------------------------------------------------------------

 if(rdwr==1 .or. rdwr==5)then

  if (rdwr==1) rewind(unitfi)

! Reading the first record of the file ------------------------------------

  read(unitfi,err=1000)codvsn,fform

  if(fform==1   .or. fform==2   .or. &
&    fform==51  .or. fform==52  .or. &
&    fform==101 .or. fform==102       )then
!  This is the old format
   headform=22

  else

!  Format beyond 22 have a different first line, so need reading again the first line
   backspace (unitfi)
   read (unitfi)   codvsn,headform,fform

   if(headform/=23 .and. headform/=34 .and. headform/=40 .and. headform/=41 .and. &
&     headform/=42 .and. headform/=44                                            )then
    write(message, '(4a,i3,3a,i8,3a)' ) ch10,&
&    ' hdr_io : ERROR -',ch10,&
&    '  The first line of the (WF, DEN or POT) file read in unit ',unitfi,' is erroneous.',ch10,&
&    '  headform is ',headform,', while it should be 23, 34, 40, 41, 42, or 44.',ch10,&
&    '  Action : check the correctness of your file.'
    call wrtout(6,message,'COLL')
    call leave_new('COLL')
   end if

  end if

  hdr%codvsn=codvsn
  hdr%headform=headform
! fform is not a record of hdr_type

!DEBUG
! write(6,*)' hdr_io : debug '
! write(6,*)' hdr_io : codvsn,headform,fform',codvsn,headform,fform
!ENDDEBUG

! Reading the second record of the file ------------------------------------

! Initialize the values that are not present for all versions (exception : npsp)
  hdr%nspden=1
  hdr%nspinor=1
  hdr%occopt=1
  hdr%pertcase=1
  hdr%usepaw=0
  hdr%ecut=zero
  hdr%ecutdg=zero
  hdr%ecutsm=zero
  hdr%qptn(1:3)=zero
  hdr%stmbias=zero
  hdr%tphysel=zero
  hdr%tsmear=zero

  if(headform==22)then

    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, nsppol, nsym, ntypat,&
&    acell, hdr%ecut_eff, hdr%rprimd
    npsp=ntypat

  else if(headform==23)then

!   Compared to v2.2, add nspden, nspinor, occopt
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, ntypat, hdr%occopt,&
&    acell, hdr%ecut_eff, hdr%rprimd
    npsp=ntypat

  else if(headform==34)then

!   Compared to v2.3, subtract acell, and add npsp
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, npsp, ntypat, hdr%occopt,&
&    hdr%ecut_eff, hdr%rprimd

  else if(headform==40)then

!   Compared to v3.4, add ecut, ecutsm, tphysel, tsmear
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, npsp, ntypat, hdr%occopt,&
&    hdr%ecut, hdr%ecutsm, hdr%ecut_eff, hdr%rprimd, hdr%tphysel, hdr%tsmear

  else if(headform==41)then

!   Compared to v4.0, add pertcase and qptn(3)
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, npsp, ntypat, hdr%occopt, hdr%pertcase,&
&    hdr%ecut, hdr%ecutsm, hdr%ecut_eff, hdr%qptn(1:3), hdr%rprimd, hdr%tphysel, hdr%tsmear

  else if(headform==42)then

!   Compared to v4.1, add stmbias
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, npsp, ntypat, hdr%occopt, hdr%pertcase,&
&    hdr%ecut, hdr%ecutsm, hdr%ecut_eff, hdr%qptn(1:3), hdr%rprimd,&
&    hdr%stmbias, hdr%tphysel, hdr%tsmear

  else if(headform>=44)then

!   Compared to v4.2, add usepaw and ecutdg
    read(unitfi) bantot, hdr%date, hdr%intxc, hdr%ixc, natom, hdr%ngfft(1:3),&
&    nkpt, hdr%nspden, hdr%nspinor, nsppol, nsym, npsp, ntypat, hdr%occopt, hdr%pertcase,&
&    hdr%usepaw, hdr%ecut, hdr%ecutdg, hdr%ecutsm, hdr%ecut_eff, hdr%qptn(1:3), hdr%rprimd,&
&    hdr%stmbias, hdr%tphysel, hdr%tsmear

  end if

  hdr%bantot=bantot
  hdr%natom =natom
  hdr%nkpt  =nkpt
  hdr%npsp  =npsp
  hdr%nsppol=nsppol
  hdr%nsym  =nsym
  hdr%ntypat =ntypat

  if(hdr%ecutsm>tol6 .and. headform<44 .and. .not.(fform==51.or.fform==52.or.fform==101.or.fform==102))then
   write(message, '(4a,es16.6,9a)' ) ch10,&
&   ' hdr_io : ERROR -',ch10,&
&   '  The value of ecutsm is',hdr%ecutsm,', while the file has been produced prior to v4.4 .',ch10,&
&   '  The definition of the smearing function has changed, so that you are not allowed',ch10,&
&   '  to restart from a old wavefunction file. By contrast, you can restart from an old',ch10,&
&   '  potential or density file, and perform a self-consistent cycle with a new ABINIT version.',ch10,&
&   '  Action : produce a density or potential file using the old version of ABINIT, and restart from it.'
   call wrtout(6,message,'COLL')
   call leave_new('COLL')
  end if

!DEBUG
!  write(6,*)' hdr_io : before allocate '
!  write(6,*)' hdr_io : bantot,natom,nkpt,npsp,nsppol,nsym,ntypat',&
!&  bantot,natom,nkpt,npsp,nsppol,nsym,ntypat
!ENDDEBUG

! Allocate all parts of hdr that need to be --------------------------------

  allocate(hdr%istwfk(nkpt))
  allocate(hdr%lmn_size(npsp))
  allocate(hdr%nband(nkpt*nsppol))
  allocate(hdr%npwarr(nkpt)) ! Warning : npwarr here has only one dim
  allocate(hdr%pspcod(npsp))
  allocate(hdr%pspdat(npsp))
  allocate(hdr%pspso(npsp))
  allocate(hdr%pspxc(npsp))
  allocate(hdr%so_typat(ntypat))
  allocate(hdr%symafm(nsym))
  allocate(hdr%symrel(3,3,nsym))
  allocate(hdr%typat(natom))
  allocate(hdr%kptns(3,nkpt))
  allocate(hdr%occ(bantot))
  allocate(hdr%tnons(3,nsym))
  allocate(hdr%xred(3,natom))
  allocate(hdr%znuclpsp(npsp))
  allocate(hdr%znucltypat(ntypat))
  allocate(hdr%zionpsp(npsp))
  allocate(hdr%title(npsp))
  if(hdr%usepaw==1) allocate(hdr%atmrhoij(natom))

!DEBUG
! write(6,*)' hdr_io : after allocate '
!ENDDEBUG

! Reading the third record of the file ------------------------------------

! Initialize the values that are not present for all versions
  hdr%istwfk(:)=1
  hdr%so_typat(:)=1
  hdr%symafm(:)=1

  if(headform==22 .and. (fform==1 .or. fform==51 .or. fform==101))then

!   This is very old (pre-2.0) format !
    read(unitfi) hdr%nband(:), hdr%npwarr(:), hdr%symrel(:,:,:), &
&    hdr%typat(:), hdr%kptns(:,:), hdr%occ(:), &
&    hdr%tnons(:,:), hdr%znucltypat(:)

  else if(headform==22 .or. headform==23 .or. headform==34)then

!   Compared to pre v2.0, add istwfk
    read(unitfi) hdr%nband(:), hdr%npwarr(:), hdr%symrel(:,:,:), &
&    hdr%typat(:), hdr%istwfk(:), hdr%kptns(:,:), hdr%occ(:), &
&    hdr%tnons(:,:), hdr%znucltypat(:)

  else if(headform>=40)then

!   Compared to pre v4.0, add so_typat and symafm, and switch istwfk
    read(unitfi)  hdr%istwfk(:), hdr%nband(:), hdr%npwarr(:), &
&    hdr%so_typat(:), hdr%symafm(:), hdr%symrel(:,:,:), &
&    hdr%typat(:), hdr%kptns(:,:), hdr%occ(:), &
&    hdr%tnons(:,:), hdr%znucltypat(:)

  end if

! Reading the records with psp information ---------------------------------

! Initialize the values that are not present for all versions
  hdr%pspso(:)=1
  hdr%lmn_size(:)=0

  if(headform==22)then

   do ipsp=1,npsp
    read(unitfi) hdr%title(ipsp), hdr%znuclpsp(ipsp), &
&    hdr%zionpsp(ipsp), hdr%pspdat(ipsp), hdr%pspcod(ipsp), &
&    hdr%pspxc(ipsp), lmax, lloc, mmax
   end do

  else if(headform==23)then

!  Compared to 2.2, add pspso
   do ipsp=1,npsp
    read(unitfi) hdr%title(ipsp), hdr%znuclpsp(ipsp), &
&    hdr%zionpsp(ipsp), hdr%pspso(ipsp), hdr%pspdat(ipsp), &
&    hdr%pspcod(ipsp), hdr%pspxc(ipsp), lmax, lloc, mmax
   end do

  else if(headform==34 .or. headform==40 .or. headform==41 &
&                      .or. headform==42)then

!  Compared to 2.3, suppress lmax, lloc, mmax
   do ipsp=1,npsp
    read(unitfi) hdr%title(ipsp), hdr%znuclpsp(ipsp), &
&    hdr%zionpsp(ipsp), hdr%pspso(ipsp), hdr%pspdat(ipsp), &
&    hdr%pspcod(ipsp), hdr%pspxc(ipsp)
   end do

  else if(headform>=44)then

!  Compared to 4.2, add lmn_size
   do ipsp=1,npsp
    read(unitfi) hdr%title(ipsp), hdr%znuclpsp(ipsp), &
&    hdr%zionpsp(ipsp), hdr%pspso(ipsp), hdr%pspdat(ipsp), &
&    hdr%pspcod(ipsp), hdr%pspxc(ipsp), hdr%lmn_size(ipsp)
   end do

  end if

! Reading the final record of the header  ---------------------------------

! Initialize the values that are not present for all versions
  hdr%fermie=zero

  if(headform==22)then
   read(unitfi) hdr%residm, hdr%xred(:,:), hdr%etot
  else if(headform==23 .or. headform==34 .or. headform>=40)then
   read(unitfi) hdr%residm, hdr%xred(:,:), hdr%etot, hdr%fermie
  end if

!DEBUG
!  write(6,*)' hdr_io : read mode, hdr%so_typat(:), hdr%symafm(:)=',&
!&                                 hdr%so_typat(:), hdr%symafm(:)
!ENDDEBUG

! Reading the Rhoij tab if the PAW method was used  -----------------------
  if ((headform>= 44).and.(hdr%usepaw==1)) then
   bsize=0
   do iatom=1,hdr%natom
    itypat=hdr%typat(iatom)
    lmn2_size=hdr%lmn_size(itypat)*(hdr%lmn_size(itypat)+1)/2
    hdr%atmrhoij(iatom)%lmn2_size=lmn2_size
    hdr%atmrhoij(iatom)%nspden=hdr%nspden
    allocate(hdr%atmrhoij(iatom)%rhoij(lmn2_size,hdr%nspden))
    bsize=bsize+hdr%nspden*lmn2_size
   end do
   allocate(buffer(bsize));ii=0
   read(unitfi) buffer(:)
   do iatom=1,hdr%natom
    lmn2_size=hdr%atmrhoij(iatom)%lmn2_size
    do ispden=1,hdr%nspden
     hdr%atmrhoij(iatom)%rhoij(1:lmn2_size,ispden)=buffer(ii+1:ii+lmn2_size)
     ii=ii+lmn2_size
    end do
   end do
   deallocate(buffer)
  end if

! -------------------------------------------------------------------------
! Writing the header of an unformatted file
! -------------------------------------------------------------------------

 else if(rdwr==2 .or. rdwr==6)then

! natom,nkpt,npsp,ntypat... are not defined in this section :
! always address them from hdr

  if(rdwr==2) rewind(unitfi)

! Writing always use format 44
  headform=44
  write(unitfi) hdr%codvsn, headform, fform

  write(unitfi) hdr%bantot, hdr%date, hdr%intxc, hdr%ixc, &
&  hdr%natom, hdr%ngfft(1:3), hdr%nkpt, &
&  hdr%nspden, hdr%nspinor, &
&  hdr%nsppol, hdr%nsym, hdr%npsp, hdr%ntypat, hdr%occopt, hdr%pertcase,&
&  hdr%usepaw, hdr%ecut, hdr%ecutdg, hdr%ecutsm, hdr%ecut_eff, &
&  hdr%qptn, hdr%rprimd, hdr%stmbias, hdr%tphysel, hdr%tsmear

  write(unitfi) hdr%istwfk(:), hdr%nband(:), hdr%npwarr(:),&
&   hdr%so_typat(:), hdr%symafm(:), hdr%symrel(:,:,:), &
&   hdr%typat(:), hdr%kptns(:,:), hdr%occ(:), &
&   hdr%tnons(:,:), hdr%znucltypat(:)

!DEBUG
!   write(6,*)' hdr_io : write psp record, headform= ',hdr%headform
!ENDDEBUG

  do ipsp=1,hdr%npsp

   write(unitfi) hdr%title(ipsp), hdr%znuclpsp(ipsp), &
&   hdr%zionpsp(ipsp), hdr%pspso(ipsp), hdr%pspdat(ipsp), &
&   hdr%pspcod(ipsp), hdr%pspxc(ipsp), hdr%lmn_size(ipsp)

  end do

!DEBUG
!  write(6,*)' hdr_io : write mode, hdr%so_typat(:), hdr%symafm(:)=',&
!&                                  hdr%so_typat(:), hdr%symafm(:)
!ENDDEBUG

  write(unitfi) hdr%residm, hdr%xred(:,:), hdr%etot, hdr%fermie

  if (hdr%usepaw==1) then
   bsize=0
   do iatom=1,hdr%natom
    bsize=bsize+hdr%nspden*hdr%atmrhoij(iatom)%lmn2_size
   end do
   allocate(buffer(bsize));ii=0
   do iatom=1,hdr%natom
    lmn2_size=hdr%atmrhoij(iatom)%lmn2_size
    do ispden=1,hdr%nspden
     buffer(ii+1:ii+lmn2_size)=hdr%atmrhoij(iatom)%rhoij(1:lmn2_size,ispden)
     ii=ii+lmn2_size
    end do
   end do
   write(unitfi) buffer(:)
   deallocate(buffer)
  end if

! -------------------------------------------------------------------------
! Writing the header of a formatted file
! -------------------------------------------------------------------------

 else if(rdwr==3 .or. rdwr==4)then

  write(unitfi, '(a)' )&
&  ' ==============================================================================='
  if(rdwr==3)write(unitfi, '(a)' ) ' ECHO of part of the ABINIT file header '
  if(rdwr==4)write(unitfi, '(a)' ) ' ECHO of the ABINIT file header '
  write(unitfi, '(a)' ) ' '
  write(unitfi, '(a)' ) ' First record :'
  write(unitfi, '(a,a6,2i5)' )  ' codvsn,headform,fform = ',&
&  hdr%codvsn, hdr%headform, fform     ! Do not worry about 22 format

  write(unitfi, '(a)' ) ' '
  write(unitfi, '(a)' ) ' Second record :'
  write(unitfi, '(a,4i6)') ' bantot,intxc,ixc,natom  =',&
&                            hdr%bantot, hdr%intxc, hdr%ixc, hdr%natom
  write(unitfi, '(a,4i6)') ' ngfft(1:3),nkpt         =',&
&                            hdr%ngfft(1:3), hdr%nkpt

  if(hdr%headform>=23)then
   write(unitfi, '(a,4i6)') ' nspden,nspinor          =',&
&                            hdr%nspden, hdr%nspinor
  end if

  if(hdr%headform<=23)then
   write(unitfi, '(a,4i6)' ) ' nsppol,nsym,ntypat,occopt=',&
&                            hdr%nsppol,hdr%nsym,hdr%ntypat,hdr%occopt
  else if(hdr%headform<=40)then
   write(unitfi, '(a,5i6)' ) ' nsppol,nsym,npsp,ntypat,occopt=',&
&                            hdr%nsppol,hdr%nsym,hdr%npsp,hdr%ntypat,hdr%occopt

  else if(hdr%headform==41 .or. hdr%headform==42)then
   write(unitfi, '(a,6i6)' ) ' nsppol,nsym,npsp,ntypat,occopt,pertcase=',&
&                            hdr%nsppol,hdr%nsym,hdr%npsp,hdr%ntypat,hdr%occopt,hdr%pertcase
  else if(hdr%headform>=44)then
   write(unitfi, '(a,4i6)' ) ' nsppol,nsym,npsp,ntypat =',&
&                            hdr%nsppol,hdr%nsym,hdr%npsp,hdr%ntypat
   write(unitfi, '(a,3i6)' ) ' occopt,pertcase,usepaw  =',&
&                            hdr%occopt,hdr%pertcase,hdr%usepaw
  end if

  if(hdr%headform==40 .or. hdr%headform==41 .or. hdr%headform==42)then
   write(unitfi, '(a,2es18.10)') ' ecut,ecutsm             =',hdr%ecut, hdr%ecutsm
  else if(hdr%headform>=44)then
   write(unitfi, '(a,3es18.10)') ' ecut,ecutdg,ecutsm      =',&
&   hdr%ecut, hdr%ecutdg, hdr%ecutsm
  end if

  write(unitfi, '(a, es18.10)' ) ' ecut_eff                =',hdr%ecut_eff

  if(hdr%headform>=41)then
   write(unitfi, '(a,3es18.10)') ' qptn(1:3)               =',hdr%qptn(1:3)
  end if

  write(unitfi, '(a,3es18.10)' ) ' rprimd(1:3,1)           =',hdr%rprimd(1:3,1)
  write(unitfi, '(a,3es18.10)' ) ' rprimd(1:3,2)           =',hdr%rprimd(1:3,2)
  write(unitfi, '(a,3es18.10)' ) ' rprimd(1:3,3)           =',hdr%rprimd(1:3,3)

  if(hdr%headform==40.or.hdr%headform==41)then
   write(unitfi, '(a,2es18.10)') ' tphysel,tsmear          =',hdr%tphysel, hdr%tsmear
  else if(hdr%headform>=42)then
   write(unitfi, '(a,3es18.10)') ' stmbias,tphysel,tsmear  =',&
&   hdr%stmbias,hdr%tphysel, hdr%tsmear
  end if

  write(unitfi, '(a)' )
  if(rdwr==3)then
   write(unitfi, '(a,i3,a)' ) ' The header contain ',hdr%npsp+2,' additional records.'
  else

   write(unitfi, '(a)' ) ' Third record :'
   write(unitfi, '(a,(12i4,8x))') ' istwfk=',hdr%istwfk(:)
   write(unitfi, '(a,(12i4,8x))') ' nband =',hdr%nband(:)
   write(unitfi, '(a,(10i5,8x))') ' npwarr=',hdr%npwarr(:)

   if(hdr%headform>=40)then
    write(unitfi, '(a,(12i4,8x))') ' so_typat=',hdr%so_typat(:)
   end if

   if(hdr%headform>=40)then
    write(unitfi, '(a)') ' symafm='
    write(unitfi, '(8x,24i3,8x)') hdr%symafm(:)
   end if

   write(unitfi, '(a)' ) ' symrel='
   do isym=1,hdr%nsym/2
    write(unitfi, '(a,9i4,a,9i4)' ) '        ',hdr%symrel(:,:,2*isym-1),&
&                                         '  ',hdr%symrel(:,:,2*isym)
   end do
   if(2*(hdr%nsym/2)/=hdr%nsym)write(unitfi, '(a,9i4)' ) '        ',hdr%symrel(:,:,hdr%nsym)

   write(unitfi, '(a,(12i4,8x))') ' type  =',hdr%typat(:)
   write(unitfi, '(a)' ) ' kptns =                 (max 50 k-points will be written)'
   do ikpt=1,min(hdr%nkpt,50)
    write(unitfi, '(a,3es16.6)' ) '        ',hdr%kptns(:,ikpt)
   end do
   write(unitfi, '(a)' ) '   occ ='
   do ii=1,hdr%bantot,10
    write(unitfi, '(a,10f6.2))') '        ',hdr%occ(ii:min(hdr%bantot,ii+10-1))
   end do
   write(unitfi, '(a)' ) ' tnons ='
   do isym=1,hdr%nsym/2
    write(unitfi, '(a,3f10.6,a,3f10.6)' ) '        ',hdr%tnons(:,2*isym-1),&
&                                               '  ',hdr%tnons(:,2*isym)
   end do
   if(2*(hdr%nsym/2)/=hdr%nsym)write(unitfi, '(a,3f10.6)' ) '        ',hdr%tnons(:,hdr%nsym)
   write(unitfi, '(a,(10f6.2,8x))') '  znucl=',hdr%znucltypat(:)
   write(unitfi,'(a)')

   write(unitfi, '(a)' ) ' Pseudopotential info :'
   do ipsp=1,hdr%npsp
    write(unitfi,'(a,a)' ) ' title=',trim(hdr%title(ipsp))
    write(unitfi,'(a,f6.2,a,f6.2,a,i3,a,i6,a,i3,a,i3)' ) &
&    '  znuclpsp=',hdr%znuclpsp(ipsp),    ', zionpsp=',  hdr%zionpsp(ipsp),    &
&    ', pspso=' , hdr%pspso(ipsp),  ', pspdat=',hdr%pspdat(ipsp),  &
&    ', pspcod=', hdr%pspcod(ipsp), ', pspxc=', hdr%pspxc(ipsp)
    if(hdr%headform>=44)then
     if(hdr%usepaw==1)then
      write(unitfi,'(a,i3)' ) '  lmn_size=', hdr%lmn_size(ipsp)
     else
      write(unitfi,'(a,i3)' ) '  lmnmax  =', hdr%lmn_size(ipsp)
     end if
    end if

   end do

   write(unitfi, '(a)' ) ' '
   write(unitfi, '(a)' ) ' Last record :'
   write(unitfi, '(a,es16.6,es22.12,es16.6)' ) &
&   ' residm,etot,fermie=',hdr%residm, hdr%etot, hdr%fermie
   write(unitfi, '(a)' ) ' xred ='
   do iatom=1,hdr%natom
    write(unitfi, '(a,3es16.6)' ) '        ',hdr%xred(:,iatom)
   end do

   if(hdr%usepaw==1)then
    do iatom=1,hdr%natom
     itypat=hdr%typat(iatom)
     do ispden=1,hdr%nspden
      write(unitfi, '(a,i4,a,i1,a)' ) ' rhoij(',iatom,',',ispden,&
&           ')=  (max 10 components will be written)'
      ii=0
      do jlmn=1,min(hdr%lmn_size(itypat),12)
       write(unitfi,'(100(1x,f9.5))') &
&      (hdr%atmrhoij(iatom)%rhoij(ii+ilmn,ispden),ilmn=1,jlmn)
       ii=ii+jlmn
      end do
     end do
    end do
   end if

  if(rdwr==3)write(unitfi, '(a)' ) ' End the ECHO of part of the ABINIT file header '
  if(rdwr==4)write(unitfi, '(a)' ) ' End the ECHO of the ABINIT file header '
  write(unitfi, '(a)' )&
&  ' ==============================================================================='

  end if ! rdwr is 3 or 4

 end if ! choice read/write/echo

 return
 1000 fform=0 ; return   ! This is to allow treatment of old epsm1 format

 end subroutine hdr_io_int
!!***
