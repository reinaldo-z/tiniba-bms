PROGRAM set_input
!!! 
!!!DebugMod.f90
!!!DebugMod.f90
!!!DebugMod.f90
   USE DebugMod, ONLY : debug
!!!ConstantsMod.f90
!!!ConstantsMod.f90
!!!ConstantsMod.f90
   USE ConstantsMod, ONLY : DP, DPC
!!!CommandLineArgumentsMod.f90
!!!CommandLineArgumentsMod.f90
!!!CommandLineArgumentsMod.f90 
   USE CommandLineArgumentsMod, ONLY : parseCommandLineArguments
!!!InputParametersFileMod.f90
!!!InputParametersFileMod.f90
!!!InputParametersFileMod.f90
   USE InputParametersFileMod, ONLY : parseParamFile
!!!SpectrumParametersFileMod.f90
!!!SpectrumParametersFileMod.f90
!!!SpectrumParametersFileMod.f90
   USE SpectrumParametersFileMod, ONLY : parseSpectrumFile
!!!InputParametersMod.f90
!!!InputParametersMod.f90
!!!InputParametersMod.f90
   USE InputParametersMod, ONLY : oldStyleScissors
   USE InputParametersMod, ONLY : pmn_data_filename
   USE InputParametersMod, ONLY : smn_data_filename
   USE InputParametersMod, ONLY : nSpinor
   USE InputParametersMod, ONLY : kMax
   USE InputParametersMod, ONLY : nMax
   USE InputParametersMod, ONLY : scissor
   USE InputParametersMod, ONLY : nVal
   USE InputParametersMod, ONLY : tolSHGt !! TOL IN SHG 1,2 TRANSV
!!!ArraysMod.f90
!!!ArraysMod.f90
!!!ArraysMod.f90
   USE ArraysMod, ONLY : readenergyfile
   USE ArraysMod, ONLY : allocateArrays
   USE ArraysMod, ONLY : scissorenergies
   USE ArraysMod, ONLY : band
   USE ArraysMod, ONLY : energy
   USE ArraysMod, ONLY : momMatElem
   USE ArraysMod, ONLY : posMatElem
   USE ArraysMod, ONLY : spiMatElem
   USE ArraysMod, ONLY : Delta
   USE ArraysMod, ONLY : derMatElem
   USE ArraysMod, ONLY : pderMatElem
   USE ArraysMod, ONLY : energys
   USE ArraysMod, ONLY : deallocateArrays
!!!FileUtilitiesMod.f90
!!!FileUtilitiesMod.f90
!!!FileUtilitiesMod.f90
   USE FileUtilitiesMod, ONLY : myInquire
   USE FileUtilitiesMod, ONLY : myOpen
   USE FileUtilitiesMod, Only : checkEndOfFileAndClose
!!!FileControlMod.f90
!!!FileControlMod.f90
!!!FileControlMod.f90
   USE FileControlMod, ONLY : openOutputDataFiles
   USE FileControlMod, ONLY : writeOutputDataFileHeaders
   USE FileControlMod, ONLY : closeOutputDataFiles
!!!SymmetryOperationsMod.f90
!!!SymmetryOperationsMod.f90
!!!SymmetryOperationsMod.f90
   USE SymmetryOperationsMod, ONLY : initializeSymOps
!!!FunctionsMod.f90
!!!FunctionsMod.f90
!!!FunctionsMod.f90
   USE FunctionsMod, ONLY : position
   USE FunctionsMod, ONLY : genderiv
   USE FunctionsMod, ONLY : pgenderiv
!!!IntegrandsMod.f90
!!!IntegrandsMod.f90
!!!IntegrandsMod.f90
 USE IntegrandsMod, ONLY : calculateintegrands
!!!============================================ 
!!!============================================ 
!!!============================================ 
  IMPLICIT NONE
   INTEGER :: l,ii,iii
   INTEGER :: ik, iv, ic
   INTEGER :: io_status
   REAL(dp) :: matTemp(6)
   INTEGER :: iTrans
   REAL(dp) :: scissorFactor
  
  call system('rm -f resta.dat')
  call system('rm -f sumatoria.dat')
  open(67,file='resta.dat',status='unknown')
  open(68,file='sumatoria.dat',status='unknown')

  CALL parseCommandLineArguments()
  
  IF (oldStyleScissors) THEN
     WRITE(*,*) 'Using Hughes and Sipe version of scissors correction'
  END IF
 
  CALL parseParamFile
  CALL parseSpectrumFile
  CALL myInquire("Symmetries.Cartesian")
  CALL readenergyfile
  CALL allocateArrays
  CALL scissorenergies  
  CALL myOpen(11,pmn_data_filename,'OLD')
   if (nSpinor == 2) then    
      CALL myOpen(14,smn_data_filename,'OLD')
   end if
  CALL openOutputDataFiles  
  CALL initializeSymOps  
  CALL writeOutputDataFileHeaders
   


!!!============================================ 
!!!===============over k point ================
!!!============================================ 
  DO ik = 1, kMax
     IF ((ik<6).OR.(MOD(ik,50).EQ.0).OR.(ik.EQ.kMax)) THEN
        WRITE(*,*) ik
     END IF
!!!Use unscissored band energies to calculate rmn     
!!!Use unscissored band energies to calculate rmn
!!!Use unscissored band energies to calculate rmn
     band(1:nMax) = energy(ik,1:nMax)
     iTrans = 0
     DO iv = 1, nMax
        DO ic = iv, nMax
           
          matTemp(1:6) = 0.d0
           READ(UNIT=11,FMT=*,iostat=io_status) (matTemp(l), l=1,6)
            IF (io_status /= 0) THEN
              WRITE(*,*) "ios ", io_status
           WRITE(*,*) "Error reading momentum matrix elements.  Stopping"
               STOP 'Error reading momentum matrix elements'
            END IF
            momMatElem(1,iv,ic) = matTemp(1) + (0.0d0,1.0d0)*matTemp(2)
            momMatElem(2,iv,ic) = matTemp(3) + (0.0d0,1.0d0)*matTemp(4)
            momMatElem(3,iv,ic) = matTemp(5) + (0.0d0,1.0d0)*matTemp(6)
            matTemp(1:6) = 0.d0
           
!!!reduced input begin
           IF (ic.NE.iv) THEN
              DO ii=1,3
                 momMatElem(ii,ic,iv) = CONJG(momMatElem(ii,iv,ic))
              END DO
           END IF
!!!reduced input end

           
!!!Calculate the position matrix elements
!!!Calculate the position matrix elements
!!!Calculate the position matrix elements
           DO ii=1,3
              posMatElem(ii,iv,ic) = position(ii,iv,ic)
!!!reduced input begin
              posMatElem(ii,ic,iv) = position(ii,ic,iv)
!!!reduced input end
           END DO !!ii
         END DO !!ic
     END DO !! iv
     
!!!spin=2
!!!spin=2
!!!spin=2
     IF (nSpinor==2) THEN
        DO iv = 1, nMax
           DO ic = iv, nMax     
              matTemp(1:6) = 0.d0
              READ(UNIT=14,FMT=*) (matTemp(l), l=1,6)
              spiMatElem(1,iv,ic) = matTemp(1) + (0.d0,1.d0)*matTemp(2)
              spiMatElem(2,iv,ic) = matTemp(3) + (0.d0,1.d0)*matTemp(4)
              spiMatElem(3,iv,ic) = matTemp(5) + (0.d0,1.d0)*matTemp(6)
              IF (ic.NE.iv) THEN
                 DO ii=1,3
                    spiMatElem(ii,ic,iv) = CONJG(spiMatElem(ii,iv,ic))
                 END DO
              END IF
              matTemp(1:6) = 0.d0
              
102           FORMAT(6E15.7)
              
           END DO ! ic
        END DO ! iv
     END IF !! spin matrix elements  
!!!end spin=2
!!!end spin=2
!!!end spin=2



     
!!!SET THE IMAGINARY PARTS OF THE DIAGONAL COMPONENTS TO ZERO BY HAND
     DO iv = 1, nMax
        momMatElem(1,iv,iv)= REAL(momMatElem(1,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(2,iv,iv)= REAL(momMatElem(2,iv,iv)) + 0.d0*(0.d0,1.d0)
        momMatElem(3,iv,iv)= REAL(momMatElem(3,iv,iv)) + 0.d0*(0.d0,1.d0)
     END DO

!!!Check hermiticity of position matrix elements
!!!Check hermiticity of position matrix elements
!!!Check hermiticity of position matrix elements
     !call calculaConmutadorMORE(ik) 
     !call calculaConmutadorLESS(ik)
     call ecuacion12sipe(ik)
!     call sumaRnl(ik)
     CALL checkHermiticity(ik)



     
!!! Calculate Delta(m,n)
!!! Calculate Delta(m,n)
!!! Calculate Delta(m,n)
     DO iv = 1, nMax
         DO ic = 1, nMax
            Delta(1,ic,iv) = momMatElem(1,ic,ic)-momMatElem(1,iv,iv)
            Delta(2,ic,iv) = momMatElem(2,ic,ic)-momMatElem(2,iv,iv)
            Delta(3,ic,iv) = momMatElem(3,ic,ic)-momMatElem(3,iv,iv)
         END DO
     END DO
     
     IF (oldStyleScissors) THEN
        band(1:nMax) = energys(ik,1:nMax)
     END IF
     
!!! below, according to PRB72,045223(2005) is correct
!!! Calculate the generalized derivative matrix elements
!!! Calculate the generalized derivative matrix elements
!!! Calculate the generalized derivative matrix elements
!!! Aqui va originalmente 
     DO iv = 1, nMax
        DO ic = 1, nMax
           DO ii=1,3
              DO iii=1,3
                 derMatElem(iii,ii,ic,iv) = genDeriv(iii,ii,ic,iv)
                 pderMatElem(iii,ii,ic,iv) = pgenDeriv(iii,ii,ic,iv)
              END DO
           END DO
        END DO
     END DO
     
!!! Now scissor the momentum matrix elements
!!! Now scissor the momentum matrix elements
!!! Now scissor the momentum matrix elements     
     DO iv = 1, nVal
        DO ic = nVal + 1, nMax
           scissorFactor = 1.d0 + scissor / (band(ic)-band(iv))
           DO ii=1,3
              momMatElem(ii,iv,ic) = momMatElem(ii,iv,ic)*scissorFactor
              momMatElem(ii,ic,iv) = momMatElem(ii,ic,iv)*scissorFactor              
           END DO
        END DO
     END DO
!!! Now use the scissored energy bands
!!! Now use the scissored energy bands
!!! Now use the scissored energy bands     
     band(1:nMax) = energys(ik,1:nMax)
!!! below, according to PRB72,045223(2005) is wrong, HOWEVER it satisfies gauge invariance
!!! for any value of the of the scissor's shift. Of course, we assume that we are applying 
!!! the scissors shift correctly to the the transverse susceptibility. Also, may be the
!!! tranverse susceptibility could be wrong as we do not include the scissors operator.
!!! Calculate the generalized derivative matrix elements
!!! Calculate the generalized derivative matrix elements
!!! Calculate the generalized derivative matrix elements
   if(1.eq.2)then
        DO iv = 1, nMax
           DO ic = 1, nMax
              DO ii=1,3
                 DO iii=1,3
                    derMatElem(iii,ii,ic,iv) = genDeriv(iii,ii,ic,iv)
                    pderMatElem(iii,ii,ic,iv) = pgenDeriv(iii,ii,ic,iv)
                 END DO
              END DO
           END DO
        END DO
     end if
     CALL calculateintegrands
     
  END DO !end do kpoints 
!!!end do kpoints 
!!!end do kpoints 
!!!end do kpoints 
  
  CALL closeOutputDataFiles
  CALL checkEndOfFileAndClose(11,pmn_data_filename)
  IF (nSpinor == 2) THEN
   CALL checkEndOfFileAndClose(14,smn_data_filename)
  end if
  
  IF (nSpinor == 2) THEN
     CLOSE(17)
  END IF
  CLOSE(18) 
  CALL deallocateArrays
  

  WRITE(56,*)"tolSHGt",tolSHGt
  close(67) !!! conmutador +
  close(68) !!! conmutador -


END PROGRAM set_input
!!!END OF PROGRAM
!!!END OF PROGRAM
!!!END OF PROGRAM

SUBROUTINE ecuacion12sipe(ik)
 USE ArraysMod, ONLY: momMatElem, nMax, posMatElem,nval
 USE ArraysMod, ONLY : derMatElem
 USE InputParametersMod, ONLY : nMaxCC
 implicit none
 INTEGER, intent(in) :: ik
 !! local variables
 integer :: in,il,aa,bb,cc,iv,ic
 INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
 COMPLEX(DPC) :: sigma,sigma1
 aa=3
 bb=3
 cc=3

 DO iv =1,nval
    DO ic=nval+1,nMaxCC
       sigma1 = derMatElem(2,1,iv,ic)-derMatElem(1,2,iv,ic)
       sigma = (0.d0, 0.d0)
       DO il = 1, nMaxCC
          sigma=sigma+(0.d0,1.d0)*(posMatElem(1,iv,il)*posMatElem(2,il,ic)-&
               posMatElem(2,iv,il)*posMatElem(1,il,ic))
       end do
      WRITE(68,'(3I5,4E16.4)')ik,iv,ic,REAL(sigma),AIMAG(sigma),REAL(sigma1),AIMAG(sigma1)
    end do
 end do

end SUBROUTINE ecuacion12sipe


!!! ==============================
!!! ==============================

SUBROUTINE sumaRnl(ik)
 USE ArraysMod, ONLY: momMatElem, nMax, posMatElem,nVal
  USE InputParametersMod, ONLY : nMaxCC
 !! USE ArraysMod, ONLY: MYmomMatElem, nMax, MYposMatElem
 implicit none
 INTEGER, intent(in) :: ik
 !! local variables
 integer :: in,il,aa,bb,cc,iv,ic
 INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
 COMPLEX(DPC) :: sigma
 aa=3
 bb=3
 cc=3
!!! begin code
    DO iv = 1, nVal
        DO ic = nVal+1, nMaxCC 
           sigma=(0.d0,0.d0)
           DO il = 1, nMaxCC
          !!a=1
          !!b=2
        
        sigma=sigma+(0.d0,1.d0)*(posMatElem(1,iv,il)*posMatElem(2,il,ic)-&
                                posMatElem(2,iv,il)*posMatElem(1,il,ic))
          end do
          WRITE(68,'(3I5,2E16.4)')ik,iv,il,REAL(sigma),AIMAG(sigma)
         end do
        end do 
end SUBROUTINE sumaRnl






SUBROUTINE calculaConmutadorMORE(ik)
 USE ArraysMod, ONLY: momMatElem, nMax, posMatElem
 !! USE ArraysMod, ONLY: MYmomMatElem, nMax, MYposMatElem
 implicit none
 INTEGER, intent(in) :: ik
 !! local variables
 integer :: in,il,aa,bb,cc
 INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
 COMPLEX(DPC) :: sigma
 aa=3
 bb=3
 cc=3
!!! begin code
  do in=1,nMax
    sigma=(0.d0,0.d0)
    do il=1,nMax
       if ( in.ne.il) then
          sigma=sigma+((momMatElem(bb,in,il)*posMatElem(aa,il,in))&
                      +(posMatElem(bb,in,il)*momMatElem(aa,il,in)))
       end if
    end do !! end do over l
    write(67,*)ik,in,real(sigma),AIMAG(sigma)
 end do  !! end do over n
end SUBROUTINE calculaConmutadorMORE

SUBROUTINE calculaConmutadorLESS(ik)
 USE ArraysMod, ONLY: momMatElem, nMax, posMatElem
 !! USE ArraysMod, ONLY: MYmomMatElem, nMax, MYposMatElem
 implicit none
 INTEGER, intent(in) :: ik
 !! local variables
 integer :: in,il,aa,bb,cc
 INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0)) ! double precision complex
 COMPLEX(DPC) :: sigma
 aa=3
 bb=3
 cc=3
!!! begin code
 !WRITE(*,*)"sub rutine calculaConmutador Punto k=",ik,nMax
 do in=1,nMax
    sigma=(0.d0,0.d0)
    do il=1,nMax
       if ( in.ne.il) then
          sigma=sigma+((momMatElem(bb,in,il)*posMatElem(aa,il,in))&
                      -(posMatElem(bb,in,il)*momMatElem(aa,il,in)))
       end if
    end do !! end do over l
     
    write(68,*)ik,in,real(sigma),AIMAG(sigma)
 end do  !! end do over n
end SUBROUTINE calculaConmutadorLESS



















!!!#############################
SUBROUTINE checkHermiticity(ik)
!!#############################
  USE DebugMod, ONLY : debug
  USE ConstantsMod, ONLY : DPC
  USE ArraysMod, ONLY: momMatElem, nMax, posMatElem
  IMPLICIT NONE
  INTEGER :: ik
  INTEGER :: iv, ic, ii
  COMPLEX(DPC) :: ctmpa(3), ctmpb(3)
  
!  IF (debug) WRITE(*,*) "Program Flow: entered checkHermiticity"
  
! check for reality
  DO iv=1,nMax
     ctmpa(1:3) = momMatElem(1:3,iv,iv)
     DO ii=1,3
        IF (IMAG(ctmpa(ii)).GT.3.d-5) THEN
!!! YES I KNOW 2d-5 IS VERY LARGE STILL
           WRITE(6,*) iv, ctmpa(ii)
           PAUSE
        END IF
     END DO
  END DO
!!! check for hermiticity
  DO iv=2, nMax-1
     DO ic=iv+1, nMax
        ctmpa(1:3) = momMatElem(1:3,iv,ic)
        ctmpb(1:3) = momMatElem(1:3,ic,iv)
        DO ii = 1, 3
           IF (ctmpa(ii).NE.CONJG(ctmpb(ii))) THEN
              WRITE(6,*) iv,ic,ik,ii,ctmpa(ii),ctmpb(ii)
              PAUSE 'pmn not hermitian'
105           FORMAT(4I5,4E17.7)
           END IF
        END DO
        ctmpa(1:3) = posMatElem(1:3,iv,ic)
        ctmpb(1:3) = posMatElem(1:3,ic,iv)
        DO ii = 1, 3
           IF (ctmpa(ii).NE.CONJG(ctmpb(ii))) THEN
              WRITE(6,*) iv,ic,ik,ii,ctmpa(ii),ctmpb(ii)
              PAUSE 'rmn not hermitian'
           END IF
        END DO
     END DO
  END DO
  
!!!WRITE(6,*) 'End check for kpoint', ik
!!!############################
END SUBROUTINE checkHermiticity
