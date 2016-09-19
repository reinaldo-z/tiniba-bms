MODULE abinitReader
  !
  ! Code to read ABINIT WFK files
  !
  USE DebugMod, ONLY : debug
  
  USE SymmetriesMod, ONLY : nSym
  
  USE defs_basis, ONLY : dp, dpc
  
  USE defs_datatypes, ONLY : hdr_type
  
!!!!!!!!!!!!!!!!!!   F R O M   A B I N I T   C O D E  !!!!!!!!!!!!!!!!
!!$  type hdr_type
!!$  integer :: bantot        ! total number of bands (sum of nband on all kpts and spins)
!!$  integer :: date          ! starting date
!!$  integer :: headform      ! format of the header
!!$  integer :: intxc,ixc,natom,nkpt,npsp,nspden        ! input variables
!!$  integer :: nspinor,nsppol,nsym,ntypat,occopt       ! input variables
!!$  integer :: pertcase      ! the index of the perturbation, 0 if GS calculation
!!$  integer :: usepaw        ! input variable (0=norm-conserving psps, 1=paw)
!!$  integer :: ngfft(3)      ! input variable
!!$
!!$! This record is not a part of the hdr_type, although it is present in the
!!$! header of the files. This is because it depends on the kind of file
!!$! that is written, while all other information does not depend on it.
!!$! It was preferred to let it be initialized or defined outside of hdr_type.
!!$! integer :: fform         ! file descriptor (or file format)
!!$
!!$  integer, pointer :: istwfk(:)    ! input variable istwfk(nkpt)
!!$  integer, pointer :: lmn_size(:)  ! lmn_size(npsp) from psps
!!$  integer, pointer :: nband(:)     ! input variable nband(nkpt*nsppol)
!!$  integer, pointer :: npwarr(:)    ! npwarr(nkpt) array holding npw for each k point
!!$  integer, pointer :: pspcod(:)    ! pscod(npsp) from psps
!!$  integer, pointer :: pspdat(:)    ! psdat(npsp) from psps
!!$  integer, pointer :: pspso(:)     ! pspso(npsp) from psps
!!$  integer, pointer :: pspxc(:)     ! pspxc(npsp) from psps
!!$  integer, pointer :: so_typat(:)  ! input variable so_typat(ntypat)
!!$  integer, pointer :: symafm(:)    ! input variable symafm(nsym)
!!$  integer, pointer :: symrel(:,:,:)! input variable symrel(3,3,nsym)
!!$  integer, pointer :: typat(:)     ! input variable typat(natom)
!!$
!!$  real(dp) :: ecut                  ! input variable
!!$  real(dp) :: ecutdg                ! input variable (ecut for NC psps, pawecutdg for paw)
!!$  real(dp) :: ecutsm                ! input variable
!!$  real(dp) :: ecut_eff              ! ecut*dilatmx**2 (dilatmx is an input variable)
!!$  real(dp) :: etot,fermie,residm    ! EVOLVING variables
!!$  real(dp) :: qptn(3)               ! the wavevector, in case of a perturbation
!!$  real(dp) :: rprimd(3,3)           ! EVOLVING variables
!!$  real(dp) :: stmbias               ! input variable
!!$  real(dp) :: tphysel               ! input variable
!!$  real(dp) :: tsmear                ! input variable
!!$  real(dp), pointer :: kptns(:,:)   ! input variable kptns(3,nkpt)
!!$  real(dp), pointer :: occ(:)       ! EVOLVING variable occ(bantot)
!!$  real(dp), pointer :: tnons(:,:)   ! input variable tnons(3,nsym)
!!$  real(dp), pointer :: xred(:,:)    ! EVOLVING variable xred(3,natom)
!!$  real(dp), pointer :: zionpsp(:)   ! zionpsp(npsp) from psps
!!$  real(dp), pointer :: znuclpsp(:)  ! znuclpsp(npsp) from psps
!!$                                    ! Note the difference between znucl
!!$                                    ! and znuclpsp !!
!!$  real(dp), pointer :: znucltypat(:)! znucltypat(ntypat) from alchemy
!!$
!!$  character(len=6) :: codvsn              ! version of the code
!!$  character(len=132), pointer :: title(:) ! title(npsp) from psps
!!$
!!$  type(hdr_rhoij_type), pointer :: atmrhoij(:) ! EVOLVING variable
!!$                                        ! paw_ij(natom)%rhoij(lmn2_size,nspden),
!!$                                        ! only for paw
!!$ end type hdr_type
!!$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  IMPLICIT NONE
  
  REAL(dp) :: rprimd(3,3)
  INTEGER, ALLOCATABLE :: symrel(:,:,:)
  
  CHARACTER(LEN=132) :: title
  
  ! variables for the wavefunction coefficients
  ! INTEGER :: bantot, nspinor, nband
  INTEGER :: isppol, ikpt
  INTEGER :: npw
  INTEGER, ALLOCATABLE :: kg(:,:)
  INTEGER :: i_tmp, ii, iband, nbandwf
  INTEGER :: jband
  
CONTAINS
  
  SUBROUTINE abinitWFKReader
    IMPLICIT NONE
    
    INTEGER :: i, j, j_lo, j_hi
    CHARACTER(LEN=50) :: filename
    TYPE(hdr_type) :: hdr
    INTEGER :: fform0, rdwr
    
    !!CALL getarg(1,filename)
    IF ( debug ) WRITE(*,*) "Program Flow: Entered readAbinitFile"
    
    WRITE(*,*) "Enter ABINIT WFK filename to read."
    READ(*,*) filename
    WRITE(*,*) "Filename is ", filename
    WRITE(*,*) "Filename is ", TRIM(filename)
    
    ! filename = "GaAso_DS2_WFK"
    OPEN(UNIT=1, FILE=filename, FORM='unformatted', ACTION='read')
    
    rdwr = 1
    CALL hdr_io_int(fform0,hdr,rdwr,1)
    
    rdwr = 4
    CALL hdr_io_int(fform0,hdr,rdwr,6)
    
    IF (debug) THEN
       
       WRITE(*,*) 'codevsn ', hdr%codvsn
       WRITE(*,*) 'headform ', hdr%headform
       WRITE(*,*) 'bantot ', hdr%bantot
       WRITE(*,*) 'date ', hdr%date
       WRITE(*,*) 'intxc ', hdr%intxc
       WRITE(*,*) 'ixc ', hdr%ixc
       WRITE(*,*) 'natom ', hdr%natom
       WRITE(*,*) 'ngfft(1:3) ', hdr%ngfft(1:3)
       WRITE(*,*) 'nkpt ', hdr%nkpt
       WRITE(*,*) 'nspden ', hdr%nspden
       WRITE(*,*) 'nspinor ', hdr%nspinor
       WRITE(*,*) 'nsppol', hdr%nsppol
       WRITE(*,*) 'nsym', hdr%nsym
       WRITE(*,*) 'npsp', hdr%npsp
       WRITE(*,*) 'ntypat', hdr%ntypat
       WRITE(*,*) 'occopt', hdr%occopt
       WRITE(*,*) 'ecut', hdr%ecut
       WRITE(*,*) 'ecutsm', hdr%ecutsm
       WRITE(*,*) 'ecut_eff', hdr%ecut_eff
       WRITE(*,'(A,3E20.13)') 'rprimd(1:3,1)', hdr%rprimd(1:3,1)
       WRITE(*,'(A,3E20.13)') 'rprimd(1:3,2)', hdr%rprimd(1:3,2)
       WRITE(*,'(A,3E20.13)') 'rprimd(1:3,3)', hdr%rprimd(1:3,3)
       WRITE(6,*) 'tphysel ', hdr%tphysel
       WRITE(6,*) 'tsmear ', hdr%tsmear
    END IF
    
    nSym = hdr%nsym
    ALLOCATE( symrel(3,3,nSym) )
    
    symrel = hdr%symrel
    rprimd = hdr%rprimd
    
    CLOSE(1)
    
  END SUBROUTINE abinitWFKReader
  
  SUBROUTINE convertAbinitDataToInternalData
    USE CommandLineArgumentsMod, ONLY : printSymmetries
    USE LatticeMod, ONLY : d1, d2, d3
    USE MathMod, ONLY : invert3by3
    USE SymmetriesMod, ONLY : G
    USE SymmetriesMod, ONLY : symMatsCt
    USE SymmetriesMod, ONLY : symMatsPL
    USE SymmetriesMod, ONLY : symMatsRL
    USE SymmetriesMod, ONLY : allocateSymmetryMatrices
    USE SymmetriesMod, ONLY : deallocateSymmetryMatrices
    USE SymmetriesMod, ONLY : allocateGMatrix
    USE SymmetriesMod, ONLY : writeOutSymmetryMatrices
    USE SymmetriesMod, ONLY : writeOutSymmetryMatricesCartesian
    IMPLICIT NONE
    
    INTEGER :: iSym
    DOUBLE PRECISION :: tempMat(3,3), tempMat2(3,3)
    DOUBLE PRECISION :: rbas(3,3), rbasTranspose(3,3), rbasTransposeInverse(3,3)
    DOUBLE PRECISION :: gbas(3,3)
    
    IF (debug) WRITE(*,*) "Program Flow: Entered convertAbinitDataToInternalData"
    
!!! Use rprimd(1:3,1:3)
    
    d1(1:3) = rprimd(1:3,1)
    d2(1:3) = rprimd(1:3,2)
    d3(1:3) = rprimd(1:3,3)
    
!!! rbas is used for the transformations below.
    
    rbas = TRANSPOSE(rprimd)
    rbasTranspose = TRANSPOSE(rbas)
    CALL invert3by3 (rbas, gbas)
    rbasTransposeInverse = TRANSPOSE(gbas)
    
!!! Symmetry matrices
    
    CALL allocateSymmetryMatrices()
    
    CALL allocateGMatrix()
    
    DO iSym=1, nSym
       symMatsPL(1:3,1:3,iSym) = symrel(1:3,1:3,iSym)
    END DO
    
    DO iSym=1, nSym
       ! Symmetry matrices in Cartesian basis
       tempMat = REAL(symMatsPl(1:3,1:3,iSym))
       tempMat2 = MATMUL(tempMat,rbasTransposeInverse)
       symMatsCt(1:3,1:3,iSym) = MATMUL(rbasTranspose,tempMat2)
    END DO
    
    DO iSym=1, nSym
       ! inverse Symmetry matrices in Reciprocal lattice basis
       tempMat(1:3,1:3) = symMatsPL(1:3,1:3,iSym)
       tempMat2 = TRANSPOSE(tempMat)
       symMatsRL(1:3,1:3,iSym) = tempMat2(1:3,1:3)
    END DO
    
    IF (printSymmetries) THEN
       CALL writeOutSymmetryMatrices()
       CALL writeOutSymmetryMatricesCartesian()
    END IF
    
    DO iSym=1, nSym
       G(iSym)%el(:,:) = symMatsRL(:,:,iSym)
    END DO
    
    CALL deallocateSymmetryMatrices()
    
  END SUBROUTINE convertAbinitDataToInternalData
  
END MODULE abinitReader
