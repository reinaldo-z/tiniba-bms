!################
MODULE integrands
!################
  USE constants, ONLY : DP, DPC, pi
  USE inparams, ONLY : nVal, nMax, nSym
  USE inparams, ONLY : tol
  USE inparams, ONLY : acellz
  USE inparams, ONLY : crystal_class
  USE inparams, ONLY : number_of_spectra_to_calculate,static
  USE inparams, ONLY : spectrum_info
  USE arrays, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
  USE arrays, ONLY: calMomMatElem
  USE arrays, ONLY: spiMatElem
  USE arrays, ONLY: calDelta
  !#BMSVer3.0d
  USE arrays, ONLY: calVsig,gdcalVsig,gdVsig
  !#BMSVer3.0u
!  USE arrays, ONLY: genderiv
  USE arrays, ONLY: curMatElem
  USE arrays, ONLY: calrho
!!!--------------------------------June  2008
  USE arrays, ONLY: calPosMatElem
!!!--------------------------------Feb 2013
  USE arrays, ONLY: GenDerCalPosition
!!!--------------------------------03 Marzo 2009
  USE arrays, ONLY: kMax
  
  IMPLICIT NONE
  
  ! TYPE spectrum
  !    CHARACTER(LEN=60) :: integrand_filename
  !    INTEGER :: integrand_filename_unit
  !    INTEGER :: spectrum_type

  !!  1 : chi1                (W)       
  !!  2 : Lambda       
  !!  3 : eta2        
  !!  4 : S
  !!  5 : C 
  !!  6 : Ctilde
  !!  7 : E
  !!  8 : Etilde
  !!  9 : staticChi1 
  !! 10 : staticS 
  !! 11 : staticC
  !! 12 : staticCtilde
  !! 13 : staticE    
  !! 14 : staticEtilde 
  !! 15 : staticChi2i  
  !! 16 : staticChi2e
  !! 17 : zeta_spin_bulk      (W)       
  !! 18 : zeta_spin_layered  
  !! 19 : xi2          
  !! 20 : eta3
  !! 21 : SHG1L-Longitudinal gauge       
  !! 22 : SHG2L-Longitudinal gauge
  !! 42 : SHG1V-Velocity gauge
  !! 43 : SHG2V-Velocity gauge
  !! 44 : SHG1C-Layer-Longitudinal gauge
  !! 45 : SHG2C-Layer-Longitudinal gauge
  !! 23 : LEO          
  !! 24 : calChi1  (layered)  (W)
  !! 25 : caleta2  (layered)  (W)
  !! 26 : n-dot-ccp (layered)
  !! 27 : n-dot-vv (layered)
  !! 28 :
  !! 29 : calZeta1 (layered)  (W)
  !! 39 :
  !! 40 : zeta_cabellos       (W)
  !! 41 : zeta_bulk            (W)
  !!#BMSd feb/09/16
  !! 46 : sigma    (bulk)
  !! 47 : calsigma (layered)
  !!#BMSu feb/09/16
  !!#BMSd sep/09/16
  !! 48 : mu    (bulk)
  !! 49 : calmu (layered)
  !!#BMSu sep/09/16
  !    LOGICAL :: compute_integrand
  !    INTEGER, POINTER :: spectrum_tensor_component(:)
  !    REAL(DP), POINTER :: transformation_elements(:)
  ! END TYPE spectrum
  INTEGER :: iv, ic,iq,ip
  INTEGER :: ix, iy, iz, iw
  INTEGER :: i_spectra
  !! spin indices&variable=above + below (feb.16.2009)
  INTEGER :: icp

CONTAINS
!!!#############################
  SUBROUTINE calculateintegrands
!!!###########################
    IMPLICIT NONE
    
    CHARACTER(LEN=3) :: ADV_opt
    REAL(DP) :: omegamp, omeganp, omegapn
    integer :: comova
    !--------------------------------------------------------------------------
    DO i_spectra = 1, number_of_spectra_to_calculate
       IF (spectrum_info(i_spectra)%compute_integrand) THEN
!          WRITE(*,*) "integrands.f90: Spectrum type", spectrum_info(i_spectra)%spectrum_type
          SELECT CASE(spectrum_info(i_spectra)%spectrum_type)
          CASE(1) ! linear response
             CALL ImChi1
          CASE(2)
             CALL ImLambda
          CASE(3)
             CALL eta2
          CASE(4)
             CALL ImS
          CASE(5)
             CALL ImC
          CASE(6)
             CALL ImCtilde
          CASE(7)
             CALL ImE
          CASE(8)
             CALL ImEtilde
          CASE(9)
!!!                 CALL staticChi1
          CASE(10)
!!!                 CALL staticS
          CASE(11)
!!!                 CALL staticC
          CASE(12)
!!!                 CALl staticCtilde
          CASE(13)
!!!                 CALL staticE
          CASE(14)
!!!                 CALL staticEtilde
          CASE(15)
!!!                 CALL staticChi2i
          CASE(16)
!!!                 CALL staticChi2e
          CASE(17)
             CALL zeta_fred
          CASE(18)
             CALL zeta_layered_bms
!!!BW!
          CASE(19)
             CALL xi2
          CASE(20)
             CALL eta3
!!!BMS feb/6/2013
!!!Longitudinal gauge
          CASE(21)
             CALL shg1L
          CASE(22)
             CALL shg2L
!!!Velocity gauge
          CASE(42)
             CALL shg1V
          CASE(43)
             CALL shg2V
!!!Layer-Longitudinal gauge
          CASE(44)
             CALL shg1C
          CASE(45)
             CALL shg2C
!!!
          CASE(23)
             CALL LEO
          CASE(24)
             CALL calImChi1
          CASE(25)
             CALL caleta2
          CASE(26)
             CALL ndotccp
          CASE(27)
             CALL ndotvv
!!!!!!!!!!! right now we add new response to 17 Febrero 2009  jl !!!!!
          CASE(28)
             CALL zeta_fred
!!!!!!!!!!! right now we add new response to 23 Febrero 2009  jl !!!!!
          CASE(29)
              call zeta_layered_bms
              !if ( comova.eq.1 ) then
              ! write(*,*)"Haciendo FILE: zeta_layered_bms veces ", comova
              ! call system("touch zeta_layered_bms") 
              !end if 
!!!!!!!!!!! right now we add new response to 20 Febrero 2009  jl !!!!!
          CASE(39) 
             CALL ImChi1_cabellos
          CASE(40)
             CALL zeta_cabellos
          CASE(41)
             CALL zeta_bulk  !!! esta como en las notas y usamos esta  
                             !!! para el calculo de spin bulk 
             !!#BMSd feb/09/16
             !! Bulk Shift current
          CASE(46)
             CALL sigma
             !! Layer Shift current
!!          CASE(47)
!!             CALL calsigma
             !!#BMSu feb/09/16
!!!
             !!#BMSd sep/09/16
             !! Bulk spin injection current
          CASE(48)
             CALL mu
             !! layer spin injection current
!!          CASE(49)
!!             CALL calmu
             !!#BMSu sep/09/16
             !!#BMSd sep/13/16
             !! Bulk electric current 
          CASE(32)
             CALL eta_ec
             !! layer electric current 
!!          CASE(33)
!!             CALL calmu
             !!#BMSu sep/13/16
          CASE DEFAULT
             STOP 'Error in calculateIntegrands: spectrum_type not available'
          END SELECT
       END IF
    END DO
    
  END SUBROUTINE calculateintegrands
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!! below is $\zeta^{\ell,abc}_{\mathrm{i}}$
!!!! of Eq. \ref{zetaabci} (i.e. Eq. 11)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  SUBROUTINE zeta_layered_bms!_buena_31_agosto_2009
    IMPLICIT NONE
    REAL(DP) :: PT3(3,3,3)
    REAL(DP) :: tmp,tmp1
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
          DO icp = nVal+1, nMax
             IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         tmp1=0.d0!
!!!
!!! with coherences
!!!
                         tmp1= PT3(ix,iy,iz) &
                              *aimag(spiMatElem(ix,icp,ic)*posMatElem(iy,iv,icp)*posMatElem(iz,ic,iv)&
                              + spiMatElem(ix,ic,icp)*posMatElem(iy,iv,ic)*posMatElem(iz,icp,iv) )
!!!
!!! without coherences (any term is qualitatively the same)
!!! comment DO icp + IF (DABS(... + END IF !(DABS(... + END DO !icp
!!!                         tmp1= PT3(ix,iy,iz) &
!!!                              *aimag(spiMatElem(ix,ic,ic)*posMatElem(iy,iv,ic)*posMatElem(iz,ic,iv))
!!!
                         tmp = tmp + tmp1
!!!
                      END DO !iz
                   END DO !iy
                END DO !ix
             END IF !(DABS(...
          END DO !icp
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_layered_bms!_buena_31_agosto_2009
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!! below is $\zeta^{\ell,abc}_{\mathrm{i}}$
!!!! of Eq. \ref{zetaabci} (i.e. Eq. 11)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  SUBROUTINE zeta_layered_bms_coherences
    IMPLICIT NONE
    REAL(DP) :: PT3(3,3,3)
    REAL(DP) :: tmp,tmp1
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
         !DO icp = nVal+1, nMax
             !IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         tmp1=0.d0
                         tmp1= PT3(ix,iy,iz) &
                              !!*aimag(  spiMatElem(ix,icp,ic)*calposMatElem(iy,ic,iv)*posMatElem(iz,iv,icp) &
                              !!       + spiMatElem(ix,ic,icp)*calposMatElem(iy,icp,iv)*posMatElem(iz,iv,ic) )
                              !! modificada el 26 Mayo 2009 acorde la version V11.pdf (ecuacion zetaabci) jl
                              !! right now you can not have a icp index icp=ic
                              *aimag(  spiMatElem(ix,ic,ic)*calposMatElem(iy,iv,ic)*posMatElem(iz,ic,iv) &
                                     !+ spiMatElem(ix,ic,icp)*calposMatElem(iy,iv,ic)*posMatElem(iz,icp,iv)
                                      )
                                
                         tmp = tmp + tmp1
                      END DO
                   END DO
                END DO
             !END IF
          !END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_layered_bms_coherences



!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><> Martes 20 Febrero 2009 <><><><><><><><><><><><>
!!! <><><><><><><><> responses #  <><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  SUBROUTINE zeta_cabellos 
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *   posMatElem(iy,iv,ic)*posMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *   posMatElem(iy,iv,ip)*posMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_cabellos 
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><> Martes 17 Febrero 2009 <><><><><><><><><><><><>
!!! <><><><><><><><> responses # 28 <><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  SUBROUTINE zeta_fred 
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *   posMatElem(iy,iv,ic)*posMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *   posMatElem(iy,iv,ip)*posMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_fred
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><> Martes 17 Febrero 2009 <><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  SUBROUTINE ImChi1
    ! This computes the integrand of the imaginary part of
    ! the linear response Chi1
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    !REAL(DP) :: omegamn,omeganm
    REAL(DP) :: omegacv
    REAL(DP) :: fsc,Delta
    REAL(DP) :: T2(3,3)
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )

!!! oct 2, 2010. below is not longer needed
!!! since the scissors shift is implemented correctly, i.e.
!!! the momentum matrix elements are read properly renormalized
!!! according to Cabellos et al., PRB {\bf 80}, 155205-1-13 (2009)
!!! within the velocity-gauge.
!!! The position matrix elements, accordimg to Nastos PRB 72, 045223 (2005),
!!! are calculated at the LDA lavel since that is the way iy should be for the
!!! sicssors hamiltonian within the length-gauge.
!!! Finally, the eigen-energies are also read properly scissor shifted and they work 
!!! the same for both gauges.
!!!
!!! reads the scissors correction Delta    
!!!    read(69,*)Delta
!!!    close(69)
!!!    write(*,*)'Delta=',Delta
!!!    stop

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
!!!          omegamn = band(iv) - band(ic)
!!!          omeganm = band(ic) - band(iv)
          omegacv = band(ic) - band(iv) !for w=0 response
!!!          fsc=1.
!!!          IF (DABS(omeganm).LT.tol) THEN
!!!             ! NOTE: the position operator matrix elements are set to
!!!             ! zero at functions.f90, se we don't do anything here
!!!             ! Set matrix element to zero, 
!!!             ! which is equivalent to take
!!!             fsc=0.
!!!             IF (iv.EQ.nVal.AND.ic.EQ.nVal+1) THEN
!!!                write(6,*)'############################'
!!!                write(6,*)'integrands.f90@ImChi1: Hold on! The tol value is bigger than the gap'
!!!                WRITE(6,*)'matrix elements set to zero'
!!!                !             STOP
!!!             END IF
!!!          end IF
!!!
          DO ix=1,3
             DO iy=1,3
                ! written in terms of the position matrix elements => length-gauge
                !vs omega
                if(static.eq.1) then
                   ctmp = ctmp + T2(ix,iy)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,ic)
                   ! written in terms of the momentum matrix elements => velocity-gauge (uncomment omega... above)
                   ! ctmp = ctmp - fsc*T2(ix,iy)*momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)/(omegamn*omeganm)
                end if
                ! w=0 (static-value) length-gauge
                if(static.eq.0) then
                   ! PF[\chi(0;0)]=(1/PI)PF[Im[\chi(-w;w)]] where PF=prefactor
                   ctmp = ctmp + (2.d0/PI)*T2(ix,iy)*posMatElem(ix,iv,ic)*posMatElem(iy,ic,iv)/omegacv
                end if
             END DO
          END DO
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
!!$    if(ik.eq.0) then
!!$       if(static.eq.0) then
!!$          WRITE(*,*)'@integrands.f90 static unit:',spectrum_info(i_spectra)%integrand_filename_unit
!!$       end if
!!$       if(static.eq.1) then
!!$          WRITE(*,*)'@integrands.f90 vs w unit:',spectrum_info(i_spectra)%integrand_filename_unit
!!$       end if
!!$    end if
  
     END SUBROUTINE ImChi1
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><> Viernes 20 Febrero 2009 <><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  SUBROUTINE ImChi1_cabellos
    ! This computes the integrand of the imaginary part of
    ! the linear response Chi1
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: omegamn,omeganm,fsc,Delta
    REAL(DP) :: T2(3,3)
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
    
    read(69,*)Delta
    close(69)
    !    write(*,*)'Delta=',Delta
    !    stop
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          omegamn = band(iv) - band(ic)
          omeganm = band(ic) - band(iv)
          fsc = (omeganm/(omeganm-Delta))**2
          IF (DABS(omeganm).LT.tol) THEN
             ! NOTE: the position operator matrix elements are set to
             ! zero at functions.f90, se we don't do anything here
             ! Set matrix element to zero, 
             ! which is equivalent to take
             fsc=0.
             IF (iv.EQ.nVal.AND.ic.EQ.nVal+1) THEN
                write(6,*)'############################'
                write(6,*)'integrands.f90@ImChi1: Hold on! The tol value is bigger than the gap'
                WRITE(6,*)'matrix elements set to zero'
                !             STOP
             END IF
          end IF
!!!
          DO ix=1,3
             DO iy=1,3
                ! written in terms of the position matrix elements
                !                ctmp = ctmp + T2(ix,iy)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,ic)
                ! written in terms of the momentum matrix elements
       ctmp = ctmp - fsc*T2(ix,iy)*momMatElem(ix,ic,iv)*momMatElem(iy,iv,ic)/(omegamn*omeganm)
             END DO
          END DO
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
  END SUBROUTINE ImChi1_cabellos
!!!!<><><><><><><><><><><><><><><><><><><><><><>>



  SUBROUTINE calImChi1

    !
    !! This computes the integrand of the imaginary part of
    !! the linear response Chi1
    !! for a layer-by-layer analysis
    !! 1 dic 2008 cabellos 
    !! esta utiliza el prefactor de chi1: Chi1_factor
    !! en inparams.f90 
    !! chi1 factor de acuerdo con paper's sipe es: 
    !!  
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp1
    REAL(DP) :: omegamn
    REAL(DP) :: T2(3,3)
    REAL(DP) :: omegacv
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          
          omegamn = band(iv) - band(ic)
          omegacv = band(ic) - band(iv) !for w=0 response
          
          DO ix=1,3
             DO iy=1,3
                !vs omega
                if(static.eq.1) then
                   ctmp1 = posMatElem(ix,ic,iv)*calMomMatElem(iy,iv,ic)/(0.d0,1.d0)/omegamn
                   ctmp = ctmp + T2(ix,iy)*ctmp1
                end if
                ! w=0 (static-value) length-gauge
                if(static.eq.0) then
                   ! PF[\chi(0;0)]=(1/PI)PF[Im[\chi(-w;w)]] where PF=prefactor
                   ctmp1 = posMatElem(ix,ic,iv)*calMomMatElem(iy,iv,ic)/(0.d0,1.d0)/omegamn
                   ctmp = ctmp + (2.d0/PI)*T2(ix,iy)*ctmp1/omegacv
                end if
             END DO
          END DO

          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
    

  END SUBROUTINE calImChi1
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! this subroutine works fine as well as ndotvv
!!! however there is no response that needs it YET!
!!$  SUBROUTINE ndotcc
!!$!!! This computes the integrand of $\xi^{ab}(\ell,omega)$
!!$!!! for the carrier injection rate $\dot n$
!!$!!! for a layer-by-layer analysis
!!$    IMPLICIT NONE
!!$    COMPLEX(DPC) :: ctmp, ctmp1,ctmp2
!!$    REAL(DP) :: T2(3,3)
!!$    
!!$    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
!!$    
!!$    DO iv = 1, nVal
!!$       DO ic = nVal+1, nMax
!!$          ctmp = (0.d0, 0.d0)
!!$          DO ix=1,3
!!$             DO iy=1,3
!!$                ctmp2  = calrho(ic)
!!$                ctmp1  = ctmp2*posMatElem(ix,iv,ic)*posMatElem(iy,ic,iv)
!!$                ctmp   = ctmp + T2(ix,iy)*ctmp1
!!$             END DO
!!$          END DO
!!$          IF (ic==nMax) THEN
!!$             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
!!$                  FMT=104,ADVANCE="YES") REAL(ctmp)
!!$          ELSE
!!$             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
!!$                  FMT=104,ADVANCE="NO") REAL(ctmp)
!!$          END IF
!!$       END DO
!!$    END DO
!!$104 FORMAT(E15.7)
!!$ END SUBROUTINE ndotcc
  SUBROUTINE ndotccp
!!! This computes the integrand of $\xi^{ab}(\ell,omega)$
!!! for the carrier injection rate $\dot n$
!!! for a layer-by-layer analysis using rho_cc' matrix elements
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: T2(3,3)
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO icp = nVal+1, nMax
             IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
!!!
!!! with coherences
!!!
                      ctmp1  = calrho(icp,ic)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,icp)&
                           + calrho(ic,icp)*posMatElem(ix,icp,iv)*posMatElem(iy,iv,ic)
!!!
!!! without coherences (either term is qualitatively the same)
!!! comment DO icp + IF (DABS(... + END IF !(DABS(... + END DO !icp
!!!                   ctmp1  = calrho(ic,ic)*posMatElem(ix,ic,iv)*posMatElem(iy,iv,ic)
!!!
                      ctmp   = ctmp + T2(ix,iy)*ctmp1
!!!
                   END DO !iy
                END DO !ix
             END IF !(DABS(...
          END DO !icp
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp/2.)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp/2.)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
  END SUBROUTINE ndotccp
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  SUBROUTINE ndotvv

    ! This computes the integrand of $\xi^{ab}(\ell,omega)$
    ! for the carrier injection rate $\dot n$
    ! for a layer-by-layer analysis

    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp1,ctmp2
    REAL(DP) :: omegamn
    REAL(DP) :: T2(3,3)
    
    T2(1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:9), (/3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iy=1,3
!                ctmp2  = calrho(iv)
                ctmp1  = ctmp2*posMatElem(ix,iv,ic)*posMatElem(iy,ic,iv)
                ctmp   = ctmp + T2(ix,iy)*ctmp1
             END DO
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
  END SUBROUTINE ndotvv
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!!##################
  SUBROUTINE ImLambda
!!!##################
    IMPLICIT NONE
    ! 
    ! THIS IS NOW MODIFIED TO BE THE LAMBDA FROM Nastos, Adolph and Sipe
    ! It is not the Lambda in Sipe's notes.  It differs from it by a factor
    ! of i.
    ! 
    ! The shift current tensor is just LambdaABC+LambdaACB now.
    !  
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: omegamn
    REAL(DP) :: T3(3,3,3)
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          omegamn=band(ic) - band(iv)
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   ctmp = ctmp +                                       &
                        T3(ix,iy,iz)*derMatElem(iz,ix,iv,ic)*posMatElem(iy,ic,iv)
                END DO
             END DO
          END DO
          
          ctmp = -(0.d0,1.d0)*ctmp/2.d0
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!######################
  END SUBROUTINE ImLambda
!!!######################
  
!!!#################
  SUBROUTINE eta2
!!!#################
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: T3(3,3,3)
    
    T3(1:3,1:3,1:3) = reshape(spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   ctmp = ctmp                                     & 
                        +                                          &
                        T3(ix,iy,iz) *                             & 
                        Delta(ix,ic,iv) *                          &
                        (posMatElem(iz,ic,iv)*posMatelem(iy,iv,ic) &  
                        -posMatElem(iy,ic,iv)*posMatelem(iz,iv,ic))
                END DO
             END DO
          END DO
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") AIMAG(ctmp)
             write(68,92)iv,ic,ctmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO") AIMAG(ctmp)
             write(68,92)iv,ic,ctmp
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
92  format(2i5,6e14.5)     
79  format(5i5,76e14.5)    
!!!#####################
  END SUBROUTINE eta2
!!!#####################

!!!#################
  SUBROUTINE caleta2
!!!################# 
    IMPLICIT NONE
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: tmp
    T3(1:3,1:3,1:3) = reshape(spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
!!!!!!!!!!!!!!!!!
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   if (iv.ne.ic)then 
                      tmp = tmp +  T3(ix,iy,iz)* &
                           ! #BMSVer3.0d, used to confirm that both methods agree
                           !However curMatElem is much faster as it does not
                           !requier C^\ell_{nm}
                           ( real(calVsig(ix,ic,ic))-real(calVsig(ix,iv,iv)) )* & 
                           !#BMSVer3.0u
                           !( curMatElem(ix,ic)-curMatElem(ix,iv) )* & 
                           aimag( PosMatElem(iy,ic,iv)*PosMatElem(iz,iv,ic) )
                   end if

                END DO
             END DO
          END DO

          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES")tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO")tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
92  format(2i5,6e14.5)     
    
!!!#####################
  END SUBROUTINE caleta2
!!!#####################

!!!#############
  SUBROUTINE ImS
!!!#############
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: omegamn
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          omegamn=band(ic) - band(iv)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   ctmp = ctmp +                                  &
                        T3(ix,iy,iz)*derMatElem(iy,iz,ic,iv)*posMatElem(ix,iv,ic)
                END DO
             END DO
          END DO
          ctmp = ctmp/(2.d0*omegamn)
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") -1.d0*IMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO") -1.d0*IMAG(ctmp)
          END IF
          !The formula for S has an i in front. This i times
          !the i from the IMAG part gives a minus sign
       END DO
    END DO
!!!#################
  END SUBROUTINE ImS
!!!#################
  
!!!#############
  SUBROUTINE ImC
!!!#############
!    USE functions, ONLY : CfunctionTMP
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp2, ctmp3
    REAL(DP) :: omegamp, omeganp
    REAL(DP) :: T3(3,3,3)
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iz=1,3
                ctmp2 = (0.d0, 0.d0)
                DO ip = 1, nMax
                   omegamp = band(ic) - band(ip)
                   IF (DABS(omegamp).GT.tol) THEN
                      ctmp2 = ctmp2 + posMatElem(ix,ic,ip)*posMatElem(iz,ip,iv)/omegamp
                   END IF
                   omeganp = band(iv) - band(ip)
                   IF (DABS(omeganp).GT.tol) THEN
                      ctmp2 = ctmp2 + posMatElem(iz,ic,ip)*posMatElem(ix,ip,iv)/omeganp
                   END IF
                END DO
                ctmp3 = (0.d0, 0.d0)
                DO iy=1,3
                   ctmp3 = ctmp3 +  T3(ix,iy,iz)*posMatElem(iy,iv,ic)
                END DO
                ctmp = ctmp +  ctmp3*ctmp2
                ctmp2 = (0.d0, 0.d0)
                ctmp3 = (0.d0, 0.d0)
             END DO
          END DO
          
          ctmp = -ctmp/4.d0
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO")  REAL(ctmp)
          END IF
       END DO
    END DO
!!!#################
  END SUBROUTINE ImC
!!!#################
  
!!!##################
  SUBROUTINE ImCtilde
!!!##################
!    USE functions, ONLY : rmprpnomp
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp2, ctmp3
    REAL(DP) :: omegamn, omegamp, omeganp
    REAL(DP) :: T3(3,3,3)
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          omegamn = band(ic) - band(iv)
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iz=1,3
                ctmp2 = (0.d0, 0.d0)
                DO ip = 1, nMax
                   omegamp = band(ic) - band(ip)
                   IF (DABS(omegamp).GT.tol) THEN
                      ctmp2 = ctmp2 + posMatElem(ix,ic,ip)*posMatElem(iz,ip,iv)/omegamp**2
                   END IF
                   omeganp = band(iv) - band(ip)
                   IF (DABS(omeganp).GT.tol) THEN
                      ctmp2 = ctmp2 - posMatElem(iz,ic,ip)*posMatElem(ix,ip,iv)/omeganp**2
                   END IF
                END DO
                ctmp3 = (0.d0, 0.d0)
                DO iy=1,3
                   ctmp3 = ctmp3 +  T3(ix,iy,iz)*posMatElem(iy,iv,ic)
                END DO
                ctmp = ctmp +  ctmp3*ctmp2
                ctmp2 = (0.d0, 0.d0)
                ctmp3 = (0.d0, 0.d0)
             END DO
          END DO
          
          ctmp = -ctmp/4.d0*omegamn
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO")  REAL(ctmp)
          END IF
       END DO
    END DO
!!!######################
  END SUBROUTINE ImCtilde
!!!######################
  
!!!#############
  SUBROUTINE ImE
!!!#############
    USE functions, ONLY : rmprpnomp
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: omegamn
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          omegamn=band(ic) - band(iv)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   ctmp = ctmp +                                 &
                        T3(ix,iy,iz) * posMatElem(ix,iv,ic)*     &
                        rmprpnomp(0,0,iy,iz,ic,iv,0)
                END DO
             END DO
          END DO
          ctmp = ctmp/(4.d0*omegamn)
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
!!!#################
  END SUBROUTINE ImE
!!!#################
  
!!!##################
  SUBROUTINE ImEtilde
!!!##################
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp2
    REAL(DP) :: T3(3,3,3)
    REAL(DP) :: omegamn, omegamp, omegapn
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          omegamn=band(ic) - band(iv)
          DO iy=1,3
             DO iz=1,3    
                ctmp2 = (0.d0, 0.d0)
                DO ip=1, nMax
                   omegamp = band(ic)-band(ip)
                   omegapn = band(ip)-band(iv)
                   ctmp2 = ctmp2                                             &
                        +  omegamp*posMatElem(iy,ic,ip)*posmatelem(iz,ip,iv) &
                        -  omegapn*posMatElem(iz,ic,ip)*posmatelem(iy,ip,iv)
                END DO
                DO ix=1,3
                   ctmp = ctmp + T3(ix,iy,iz)*posMatElem(ix,iv,ic)*ctmp2
                END DO
             END DO
          END DO
          
          ctmp = ctmp/(4.d0*omegamn**2)
          
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT="(E15.7)",ADVANCE="NO") REAL(ctmp)
          END IF
          
       END DO
    END DO
    
!!!######################
  END SUBROUTINE ImEtilde
!!!######################
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!! ESTA ZETA calcula zeta con (DOS DOS) rpmns caligraphics 
!!!! y usa   response_BMS_7_Agosto_2008.sh
!  SUBROUTINE zeta_layered 
!    IMPLICIT NONE
!    REAL(DP) :: PT3(3,3,3)
!    REAL(DP) :: tmp,tmp1
!    
!    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
!
!   DO iv = 1, nVal
!       DO ic = nVal+1, nMax
!          tmp = 0.d0
!         DO icp = nVal+1, nMax
!             IF (DABS(band(icp)-band(ic)).LT.tol) THEN
!                DO ix=1,3
!                   DO iy=1,3
!                      DO iz=1,3
!                         tmp1=0.d0
!                         tmp1= PT3(ix,iy,iz) &
!                              *aimag( spiMatElem(ix,ic,icp) &
!                                  *posMatElem(iy,icp,iv)*calposMatElem(iz,iv,ic) &
!                                 +spiMatElem(ix,icp,ic) &
!                                  *posMatElem(iy,ic,iv)*calposMatElem(iz,iv,icp) )
!                         tmp = tmp + tmp1
!                      END DO
!                   END DO
!                END DO
!             END IF
!          END DO
!          IF (ic==nMax) THEN
!             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
!                  FMT=104,ADVANCE="YES") tmp
!          ELSE
!             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
!                  FMT=104,ADVANCE="NO") tmp
!          END IF
          
!       END DO !!
!    END DO !!
!104 FORMAT(E15.7)
!  END SUBROUTINE zeta_layered
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><> 18 OCTUBRE 2008 <><><><><><><><><><><><><><><><><><> 
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!! ESTA ZETA calcula zeta con (UNA UNA) rpmns caligraphics 
!!!! y usa   response_BMS_7_Agosto_2008.sh
  SUBROUTINE zeta_UNA_R 
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *  calposMatElem(iy,iv,ic)*posMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *  calposMatElem(iy,iv,ip)*posMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_UNA_R
!!! <><><><><><><<<<<<<<< 01 MARZO 2009 <><>><><>
!!! <><><><><><><<<<<<<<< 01 MARZO 2009 <><>><><>
!!! <><><><><><><<<<<<<<< 01 MARZO 2009 <><>><><>
!!! <><><><><><><<<<<<<<< 01 MARZO 2009 <><>><><>
  SUBROUTINE zeta_DOS_R 
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *  calposMatElem(iy,iv,ic)*calposMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *  calposMatElem(iy,iv,ip)*calposMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_DOS_R
!!!!!!!!!!!!!!!!!!!!!!!!! 01 MARZO 2009 !!!!!!!!!!!!!!!!!!!!!!!!
  SUBROUTINE zeta_NINGUNA_R 
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *  posMatElem(iy,iv,ic)*posMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *  posMatElem(iy,iv,ip)*posMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_NINGUNA_R
!!!!!!!!!!!!!!!!!!!!!!!!! 01 MARZO 2009 !!!!!!!!!!!!!!!!!!!!!!!!




!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><> this zeta is good   <><><><><><><><><><><><><<><><><><>
!!! <><> 23 septiembre 2008 <><><><><><><><><><><><><><><><><><> 
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! hi simpre prueba esta zeta con el GaAs.
  SUBROUTINE zeta_good
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp,ctmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    !write(29,*)"tol=",tol

    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ip=ic
          ctmp = (0.d0, 0.d0)
         DO ip = nVal+1, nMax
             IF (DABS(band(ip)-band(ic)).LT.tol) THEN
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         ctmp1=(0.d0,0.d0)
                         ctmp1= PT3(ix,iy,iz) &
                              * ( spiMatElem(ix,ic,ip) &
                              *   posMatElem(iy,iv,ic)*posMatElem(iz,ip,iv) &
                              +   spiMatElem(ix,ip,ic) &
                              *   posMatElem(iy,iv,ip)*posMatElem(iz,ic,iv) )
                            ctmp1 = ctmp1*0.50d0*(band(ip)-band(iv))/(band(ic)-band(iv))
                         ctmp = ctmp + ctmp1
                      END DO
                   END DO
                END DO
             END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") DIMAG(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") DIMAG(ctmp)
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_good
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!!  below zeta is according to 
!!!  Eq. 2 of Cabellos et al, PRB 80, 245204 (2009) 
  SUBROUTINE zeta_bulk!_BUENA_RESPALDO_11_AGOSTO_2009
    IMPLICIT NONE
    REAL(DP) :: tmp,tmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
         DO icp = nVal+1, nMax
             IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                 DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         tmp1=0.d0
                         tmp1= PT3(ix,iy,iz) &
                              * aimag(spiMatElem(ix,icp,ic) &
                                      *posMatElem(iy,iv,icp)*posMatElem(iz,ic,iv) &
                                    + spiMatElem(ix,ic,icp) &
                                      *posMatElem(iy,iv,ic)*posMatElem(iz,icp,iv) )
                         tmp = tmp + tmp1
                      END DO
                   END DO
                END DO
               END IF
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_bulk!_BUENA_RESPALDO_11_AGOSTO_2009
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! 
  SUBROUTINE zeta_bulk_integrando  
  !!! solo para caclualar el integrando INTEGRANDO del paper de temok 
    IMPLICIT NONE
    REAL(DP) :: tmp,tmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
         DO icp = nVal+1, nMax
             IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                 DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         tmp1=0.d0
                         tmp1= PT3(ix,iy,iz) &
                              !!* aimag(  spiMatElem(ix,icp,ic)* posMatElem(iy,ic,iv)*posMatElem(iz,iv,icp) &
                              !!        + spiMatElem(ix,ic,icp)*posMatElem(iy,icp,iv)*posMatElem(iz,iv,ic) )
                              !! modificted en 26 Mayo 2009 acording to paper v11 ec. (zetaabci)
                              !! the modification was chnging the index vc icp .. check the two above lines jl
                              * aimag(  spiMatElem(ix,icp,ic)*posMatElem(iy,iv,icp)*posMatElem(iz,ic,iv) &
                                       + spiMatElem(ix,ic,icp)*posMatElem(iy,iv,ic)*posMatElem(iz,icp,iv))
                         tmp = tmp + tmp1
                      END DO
                   END DO
                END DO
               END IF
          END DO
          if (iv.eq.nVal)then  !!! esto solo para calcualra el integrando de la ultima banda valcencia  
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
         end if 
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_bulk_integrando




!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!!  below zeta is according to 
!!! $\zeta^{B,abc}_{\mathrm{i}}=\zeta^{B,abc}/2$ given in A4 of
!!!   Cabellos et al manuscript
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! hi simpre prueba esta zeta con el GaAs.
!!! con coherences 


!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
!!! 06 AGOSTO 2009 
!!! sin coherences 
 SUBROUTINE zeta_bulk_coh
    IMPLICIT NONE
    REAL(DP) :: tmp,tmp1
    REAL(DP) :: PT3(3,3,3)
    
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          tmp = 0.d0
         !DO icp = nVal+1, nMax
            !! IF (DABS(band(icp)-band(ic)).LT.tol) THEN
                 DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         tmp1=0.d0
                         tmp1= PT3(ix,iy,iz) &
                              !!* aimag(  spiMatElem(ix,icp,ic)* posMatElem(iy,ic,iv)*posMatElem(iz,iv,icp) &
                              !!        + spiMatElem(ix,ic,icp)*posMatElem(iy,icp,iv)*posMatElem(iz,iv,ic) )
                              !! modificted en 26 Mayo 2009 acording to paper v11 ec. (zetaabci)
                              !! the modification was chnging the index vc icp .. check the two above lines jl
                              * aimag(  spiMatElem(ix,ic,ic)*posMatElem(iy,iv,ic)*posMatElem(iz,ic,iv) &
                                       !!+ spiMatElem(ix,ic,icp)*posMatElem(iy,iv,ic)*posMatElem(iz,icp,iv) &
                                     )
                         tmp = tmp + tmp1
                      END DO
                   END DO
                END DO
              !! END IF
         ! END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO !!
    END DO !!
104 FORMAT(E15.7)
  END SUBROUTINE zeta_bulk_coh



!!!#############
  SUBROUTINE xi2
!!!#############
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp
    COMPLEX(DPC) :: vxy, vzw
    REAL(DP) :: T4(3,3,3,3)
    REAL(DP) :: omegabarcv, omegacv

    T4(1:3,1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:81), (/3,3,3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          omegabarcv = (band(ic) + band(iv))/2.0d0
          omegacv = band(ic) - band(iv)
          DO ip = 1, nMax
             DO iq = 1, nMax
                DO ix=1,3
                   DO iy=1,3
                      DO iz=1,3
                         DO iw=1,3
                            vxy = (momMatElem(ix,iv,iq)*momMatElem(iy,iq,ic)                 &
                                   + momMatElem(iy,iv,iq)*momMatElem(ix,iq,ic))/2.0d0
                            vzw = (momMatElem(iz,ic,ip)*momMatElem(iw,ip,iv)                 &
                                   + momMatElem(iw,ic,ip)*momMatElem(iz,ip,iv))/2.0d0
                            
                            ctmp = ctmp + T4(ix,iy,iz,iw)*vxy*vzw                            &
                                   /((omegabarcv-band(iq))*(omegabarcv-band(ip))             &
                                    *(omegacv)**4)
                         END DO
                      END DO
                   END DO
                END DO
             END DO
          END DO
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
!!!#################
  END SUBROUTINE xi2
!!!#################
  
  
!!!##############
  SUBROUTINE eta3
!!!##############
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp, ctmp2
    COMPLEX(DPC) :: vyz
    REAL(DP) :: T4(3,3,3,3)
    REAL(DP) :: omegabarcv, omegacv
    
    T4(1:3,1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:81), (/3,3,3,3/) )
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          ctmp = (0.d0,0.d0)
          omegabarcv = (band(ic) + band(iv))/2.0d0
          omegacv = band(ic) - band(iv)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
                   DO iw=1,3
                      vyz = (0.d0, 0.d0)
                      DO ip = 1, nMax
                         ctmp2 = (0.d0, 0.d0)
                         ctmp2 = (momMatElem(iy,iv,ip)*momMatElem(iz,ip,ic)         &
                              + momMatElem(iz,iv,ip)*momMatElem(iy,ip,ic))/2.0d0
                         vyz = vyz + ctmp2/(band(ip)-omegabarcv)
                      END DO
!! BMS 20/01/05
!! only electrons
!                     ctmp = ctmp + T4(ix,iy,iz,iw)*                         &
!                          (momMatElem(ix,ic,ic)*vyz*momMatElem(iw,ic,iv))
!! only holes
!                     ctmp = ctmp + T4(ix,iy,iz,iw)*                         &
!                          (-momMatElem(ix,iv,iv)*vyz*momMatElem(iw,ic,iv))
!! electrons and holes
                      ctmp = ctmp + T4(ix,iy,iz,iw)*                         &
                     ((momMatElem(ix,ic,ic)-momMatElem(ix,iv,iv))*vyz*momMatElem(iw,ic,iv))
                   END DO
                END DO
             END DO
          END DO
!! BMS 24/01/05
          ctmp = 8.d0*ctmp/(omegacv)**3
          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO")  REAL(ctmp)
          END IF
       END DO
    END DO
104 FORMAT(E15.7)
!!!##################
  END SUBROUTINE eta3
!!!##################

!!! BW End!
  
!!!############
  SUBROUTINE mu
!!!############
!!!Spin injection current
!!!The formulas are in /Users/bms/research/spin-current/notes/mu.tex
!!!############
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp ! acumulator
    REAL(DP) :: omegamn ! \omega_m-\omega_n
    COMPLEX(DPC) :: Kab ! K^{ab}=v^a\gs^a
    REAL(DP) :: PT4(3,3,3,3) ! rank-4 Symmetry matrices
    INTEGER :: v,c,cp,l ! band indices
    INTEGER :: ia,ib,ic,id ! Cartesian Indices
    PT4(1:3,1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:81), (/3,3,3,3/) )

    DO v = 1, nVal
       DO c = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO cp = nVal+1, nMax
             IF (DABS(band(cp)-band(c)).LT.tol) THEN !Only quasi degenerate conduction bands
                Kab = (0.d0, 0.d0)
                DO ia=1,3 !Cartesian index for Kab
                   DO ib=1,3 !Cartesian index for Kab
                      DO l = 1, nMax ! Eq. {11.e}
                         Kab = Kab + calVsig(ia,cp,l)*spiMatElem(ib,l,c) 
                      END DO
                      DO ic=1,3 !Cartesian index for internal part of {10.e}  
                         DO id=1,3 !Cartesian index for internal part of {10.e}  
                            ctmp = ctmp + PT4(ia,ib,ic,id)*Kab &
                                 *(posMatElem(ic,v,cp)*posMatElem(id,c,v)  & 
                                 +posMatElem(id,v,cp)*posMatElem(ic,c,v)) ! ic<->id
                         END DO !DO id=1,3
                      END DO !DO ic=1,3
                   END DO !DO ib=1,3
                END DO !DO ia=1,3
             END IF !Only quasi degenerate conduction bands
          END DO !DO cp = nVal+1, nMax
!!!          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") real(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") real(ctmp)
          END IF
 !!         
       END DO !DO c = nVal+1, nMax
    END DO !DO v = 1, nVal
104 FORMAT(E15.7)
    
!!!################
  END SUBROUTINE mu
!!!################

!!!############
  SUBROUTINE eta_ec
!!!############
!!!electric current
!!!The formulas are in /Users/bms/research/spin-current/notes/mu.tex
!!!############
    IMPLICIT NONE
    COMPLEX(DPC) :: ctmp ! acumulator
    REAL(DP) :: omegamn ! \omega_m-\omega_n
    COMPLEX(DPC) :: Kab ! K^{ab}=v^a\gs^a
    REAL(DP) :: PT3(3,3,3) ! rank-3 Symmetry matrices
    INTEGER :: v,c,cp ! band indices
    INTEGER :: ia,ib,ic ! Cartesian Indices
    PT3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/) )

    DO v = 1, nVal
       DO c = nVal+1, nMax
          ctmp = (0.d0, 0.d0)
          DO cp = nVal+1, nMax
             IF (DABS(band(cp)-band(c)).LT.tol) THEN !Only quasi degenerate conduction bands
                DO ia=1,3 !Cartesian index for v^a
                   DO ib=1,3 !Cartesian index for r^b
                      DO ic=1,3 !Cartesian index for r^c
                         ctmp = ctmp + PT3(ia,ib,ic) &
                              *(calVsig(ia,c,cp)*posMatElem(ib,v,c)*posMatElem(ic,cp,v)  & 
                              + calVsig(ia,cp,c)*posMatElem(ib,v,cp)*posMatElem(ic,c,v))
                      END DO !DO ic=1,3
                   END DO !DO ib=1,3
                END DO !DO ia=1,3
             END IF !Only quasi degenerate conduction bands
          END DO !DO cp = nVal+1, nMax
!!!          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") aimag(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") aimag(ctmp)
          END IF
 !!         
       END DO !DO c = nVal+1, nMax
    END DO !DO v = 1, nVal
104 FORMAT(E15.7)
    
!!!################
  END SUBROUTINE eta_ec
!!!################
  
!!!##################
  SUBROUTINE shg1V
!!!##################
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 1-omega term
!!! using the velocity-gauge correctly scissored according to
!!! Cabellos et al., PRB {\bf 80}, 155205-1-13 (2009).
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c,l
    INTEGER :: da, db, dc
    COMPLEX(DPC) :: psym1,psym2
    REAL(DP) :: omegacv,omegalv,omegacl
    REAL(DP) :: omegaclcv,omegalvcv
    REAL(DP) :: T3(3,3,3),tmp
    REAL(DP) :: tolSHGt
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg1V: Velocity gauge'
!    write(*,*)'*********'

!!! the following tolerance seems to be irrelevant
    tolSHGt=3.0d-02
!!!
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   do l=1,nMax
                      if((l.ne.v).and.(l.ne.c))then
                         omegacl=band(c)-band(l)
                         omegalv=band(l)-band(v)
                         omegalvcv=(omegalv-2.*omegacv)
                         IF ((omegalvcv.ge.0.d0).and.(omegalvcv.le.tolSHGt))    omegalvcv=omegalvcv+tolSHGt
                         IF ((omegalvcv.le.0.d0).and.(omegalvcv.ge.(-tolSHGt))) omegalvcv=omegalvcv-tolSHGt
                         
                         omegaclcv=(omegacl-2.*omegacv)
                         IF ((omegaclcv.ge.0.d0).and.(omegaclcv.le.tolSHGt))    omegaclcv=omegaclcv+tolSHGt
                         IF ((omegaclcv.le.0.d0).and.(omegaclcv.ge.(-tolSHGt))) omegaclcv=omegaclcv-tolSHGt
                         
                         psym1=(momMatElem(db,c,v)*momMatElem(dc,v,l)+momMatElem(dc,c,v)*momMatElem(db,v,l))/2.
                         psym2=(momMatElem(db,l,c)*momMatElem(dc,c,v)+momMatElem(dc,l,c)*momMatElem(db,c,v))/2.
                         tmp=tmp+(T3(da,db,dc)/omegacv**3)*(aimag(momMatElem(da,l,c)*psym1)/(omegaclcv) -aimag(momMatElem(da,v,l)*psym2)/(omegalvcv)) 
                      end if
                   end do

!!! these terms come from the scissors operator in the velocity-gauge
                   psym1=-(conjg(efe(c,v,da,db))*momMatElem(dc,c,v)&
                        +conjg(efe(c,v,da,dc))*momMatElem(db,c,v))/2.
                   tmp=tmp-T3(da,db,dc)*real(psym1)/omegacv**3
!!!
                END DO
             END DO
          END DO
          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!##################
  END SUBROUTINE shg1V
!!!##################

!!!##############
  SUBROUTINE shg2V
!!!##############
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 2-omega term
!!! using the velocity-gauge correctly scissored according to
!!! Cabellos et al., PRB {\bf 80}, 155205-1-13 (2009).
!!!
    IMPLICIT NONE

    INTEGER :: v,c,cp,vp
    INTEGER :: da, db,  dc

    COMPLEX(DPC) :: psym
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacvcpv,omegacvcvp
    REAL(DP) :: T3(3,3,3),tmp
    REAL(DP) :: tolSHGt
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg2V: Velocity gauge'
!    write(*,*)'*********'

!!! the following tolerance seems to be irrelevant
    tolSHGt=3.d-02
!!!
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!!! virtual-electron
                   do cp=nVal+1,nMax
                      if((cp.ne.v).and.(cp.ne.c))then
                         omegacpv=band(cp) - band(v)
                         omegacvcpv=(omegacv-2.*omegacpv)
                         IF ((omegacvcpv.ge.0.d0).and.(omegacvcpv.le.tolSHGt))    omegacvcpv=omegacvcpv+tolSHGt
                         IF ((omegacvcpv.le.0.d0).and.(omegacvcpv.gt.(-tolSHGt))) omegacvcpv=omegacvcpv-tolSHGt

                         psym= (momMatElem(db,c,cp) * momMatElem(dc,cp,v) + momMatElem(dc,c,cp) * momMatElem(db,cp,v))/2.
                         tmp=tmp+16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcpv))
                      end if
                   end do
!!!  virtual-hole 
                   do vp=1,nVal
                      if((vp.ne.v).and.(vp.ne.c))then
                         omegacvp=band(c) - band(vp)
                         omegacvcvp=(omegacv-2.*omegacvp)
                         IF ((omegacvcvp.ge.0.d0).and.(omegacvcvp.le.tolSHGt))    omegacvcvp=omegacvcvp+tolSHGt
                         IF ((omegacvcvp.le.0.d0).and.(omegacvcvp.gt.(-tolSHGt))) omegacvcvp=omegacvcvp-tolSHGt
                         psym= (momMatElem(db,c,vp)*momMatElem(dc,vp,v) + momMatElem(dc,c,vp)*momMatElem(db,vp,v))/2.
                         tmp=tmp-16.*T3(da,db,dc)*aimag(momMatElem(da,v,c)*psym)/(omegacv)**3*(1/(omegacvcvp))
                      end if
                   end do
!!! these terms come from the scissors operator in the velocity-gauge
                   psym=(efe(c,v,db,dc)+efe(c,v,dc,db))/2.
!!!
                   tmp=tmp-4.*T3(da,db,dc)*real(momMatElem(da,v,c)*psym)/omegacv**3
                END DO
             END DO
          END DO

          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)


!!!######################
  END SUBROUTINE shg2V
!!!######################
  
!!!##################
  SUBROUTINE shg1L
!!!##################
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 1-omega term
!!! using the length-gauge correctly scissored according to
!!! /Users/bms/research/austin/shg/shg-notes/shg-layer-nonlocal.tex
!!! \ref{imchiew,imchiwf}, i.e. Eq. (I34,I36)
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c,l
    INTEGER :: da, db, dc
    COMPLEX(DPC) :: psym0,psym1,psym2,primero,segundo
    REAL(DP) :: omegacv,omegalv,omegacl
    REAL(DP) :: omegacvcl,omegacvlv
    REAL(DP) :: T3(3,3,3),tmp,tol
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg1L: Length gauge'
!    write(*,*)'*********'

!!!
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    tol = 0.03   ! agrege
    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!! this is for interband 1w contributions
                   do l=1,nMax
                      if((l.ne.v).and.(l.ne.c))then
                         omegacl=band(c)-band(l)
                         omegacvcl=(2.*omegacv-omegacl)
                         IF ((omegacvcl.ge.0.d0).and.(omegacvcl.le.tol))    omegacvcl=omegacvcl+tol ! agrege
                         IF ((omegacvcl.le.0.d0).and.(omegacvcl.ge.(-tol))) omegacvcl=omegacvcl-tol ! agrege
                         omegalv=band(l)-band(v)
                         omegacvlv=(2.*omegacv-omegalv)
                         IF ((omegacvlv.ge.0.d0).and.(omegacvlv.le.tol))    omegacvlv=omegacvlv+tol   !agrege
                         IF ((omegacvlv.le.0.d0).and.(omegacvlv.ge.(-tol))) omegacvlv=omegacvlv-tol    !agrege
                         !vs omega
                         if(static.eq.1) then
                            psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                            psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                            tmp=tmp+T3(da,db,dc)*( real(-omegacl*posMatElem(da,l,c)*psym1)/(omegacv*omegacvcl) &
                                 -real(-omegalv*posMatElem(da,v,l)*psym2)/(omegacv*omegacvlv)) 
                         end if
                         !omega=0
                         if(static.eq.0) then
                            ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                            ! according to Anderson et al. PRB  91, 075302 (2015)
                            if (1.eq.1) then 
                               psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                               psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                               tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**2)*(&
                                     aimag(momMatElem(da,l,c)*psym1)/omegacvcl&
                                    -aimag(momMatElem(da,v,l)*psym2)/omegacvlv)
                            end if
                         end if
                      end if
                   end do
!!! this is for intraband 1w contributions
                   !vs omega
                   if(static.eq.1) then
                      psym1=( posMatElem(db,c,v)*derMatElem(da,dc,v,c) &
                           +posMatElem(dc,c,v)*derMatElem(da,db,v,c) )/2.
                      psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                           +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                      tmp=tmp+(T3(da,db,dc)/omegacv)*(aimag(psym1)+2.*aimag(posMatElem(da,v,c)*psym2)/omegacv)
                   end if
                   !omega=0
                   if(static.eq.0) then
                      ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                      ! according to Anderson et al. PRB  91, 075302 (2015)
                      psym0=( posMatElem(db,c,v)*gdVsig(da,dc,v,c) &
                           +posMatElem(dc,c,v)*gdVsig(da,db,v,c) )/2.
                      psym1=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                      psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                           +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                      tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**3)&
                           *(real(psym0 + momMatElem(da,v,c)*(4.*psym1 - 7.*psym2/omegacv)))
                   end if
!!!
                END DO
             END DO
          END DO
          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!##################
  END SUBROUTINE shg1L
!!!##################

!!!##################
  SUBROUTINE shg1Lrashkeev
!!!##################
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 1-omega term
!!! using the length-gauge correctly scissored according to
!!! /Users/bms/research/austin/shg/shg-notes/shg-layer-nonlocal.tex
!!! \ref{imchiew,imchiwf}, i.e. Eq. (I34,I36)
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c,l,vp,cp
    INTEGER :: da, db, dc
    COMPLEX(DPC) :: psym0,psym1,psym2,primero,segundo
    REAL(DP) :: omegacv,omegalv,omegacl
    REAL(DP) :: omegacvcl,omegacvlv
    REAL(DP) :: omegacvp,omegacpv
    REAL(DP) :: calF1,calF2,calF3
    REAL(DP) :: T3(3,3,3),tmp,tol
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg1L: Length gauge'
!    write(*,*)'*********'

!!!
!    write(*,*)'shg1L@integrands.f90: static=',static
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    tol = 0.03   ! agrege
    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!! this is for interband 1w contributions
                   !vs omega
                   if(static.eq.1) then
                      do l=1,nMax
                         if((l.ne.v).and.(l.ne.c))then
                            omegacl=band(c)-band(l)
                            omegacvcl=(2.*omegacv-omegacl)
                            IF ((omegacvcl.ge.0.d0).and.(omegacvcl.le.tol))    omegacvcl=omegacvcl+tol ! agrege
                            IF ((omegacvcl.le.0.d0).and.(omegacvcl.ge.(-tol))) omegacvcl=omegacvcl-tol ! agrege
                            omegalv=band(l)-band(v)
                            omegacvlv=(2.*omegacv-omegalv)
                            IF ((omegacvlv.ge.0.d0).and.(omegacvlv.le.tol))    omegacvlv=omegacvlv+tol   !agrege
                            IF ((omegacvlv.le.0.d0).and.(omegacvlv.ge.(-tol))) omegacvlv=omegacvlv-tol    !agrege
                            !vs omega
                            if(static.eq.1) then
                               psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                               psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                               tmp=tmp+T3(da,db,dc)*( real(-omegacl*posMatElem(da,l,c)*psym1)/(omegacv*omegacvcl) &
                                    -real(-omegalv*posMatElem(da,v,l)*psym2)/(omegacv*omegacvlv)) 
                            end if
                            !omega=0
                            if(static.eq.0) then
                               ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                               ! according to Anderson et al. PRB  91, 075302 (2015)
                               if (1.eq.2) then 
                                  psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                                  psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                                  tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**2)*(aimag(momMatElem(da,v,l)*psym2)/omegacvlv&
                                       -aimag(momMatElem(da,l,c)*psym1)/omegacvcl)
                               end if
                            end if
                         end if
                      end do
                   end if !static=1
                   !omega=0
                   if(static.eq.0) then
                      ! according to Rashkeev et al. PRB  57, 3905 (1998)
                      ! and /Users/bms/research/paris/shg/length/static/manuscript.tex eq.{rn5nn}
                      ! sum_v'
                      DO vp = 1, nVal
                         if(vp.ne.v)then
                            l=vp
                            omegacvp=band(c) - band(l)
                            !calF1
                            psym0=(posMatElem(db,c,v)*posMatElem(dc,v,l)&
                                  +posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                            psym1=(posMatElem(db,v,c)*posMatElem(dc,c,l)&
                                  +posMatElem(dc,v,c)*posMatElem(db,c,l))/2.
                            calF1=real(posMatElem(da,l,c)*psym0+posMatElem(da,l,v)*psym1)
                            !calF2
                            psym0=(posMatElem(db,l,c)*posMatElem(dc,c,v)&
                                  +posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
                            psym1=(posMatElem(db,l,v)*posMatElem(dc,v,c)&
                                  +posMatElem(dc,l,v)*posMatElem(db,v,c))/2.
                            calF2=real(posMatElem(da,v,l)*psym0+posMatElem(da,c,l)*psym1)
                            !calF3
                            psym0=(posMatElem(db,v,l)*posMatElem(dc,l,c)&
                                  +posMatElem(dc,v,l)*posMatElem(db,l,c))/2.
                            psym1=(posMatElem(db,c,l)*posMatElem(dc,l,v)&
                                  +posMatElem(dc,c,l)*posMatElem(db,l,v))/2.
                            calF3=real(posMatElem(da,c,v)*psym0+posMatElem(da,v,c)*psym1)
                            tmp=tmp-(2./PI)*(T3(da,db,dc)/(omegacvp*omegacv))*(calF1+calF2+calF3)
                         end if
                      end DO
                      !!! sum_c'
                      DO cp = nVal+1, nMax
                         if(cp.ne.c)then
                            l=cp
                            omegacpv=band(l) - band(v)
                            !calF1
                            psym0=(posMatElem(db,c,v)*posMatElem(dc,v,l)&
                                  +posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                            psym1=(posMatElem(db,v,c)*posMatElem(dc,c,l)&
                                  +posMatElem(dc,v,c)*posMatElem(db,c,l))/2.
                            calF1=real(posMatElem(da,l,c)*psym0+posMatElem(da,l,v)*psym1)
                            !calF2
                            psym0=(posMatElem(db,l,c)*posMatElem(dc,c,v)&
                                  +posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
                            psym1=(posMatElem(db,l,v)*posMatElem(dc,v,c)&
                                  +posMatElem(dc,l,v)*posMatElem(db,v,c))/2.
                            calF2=real(posMatElem(da,v,l)*psym0+posMatElem(da,c,l)*psym1)
                            !calF3
                            psym0=(posMatElem(db,v,l)*posMatElem(dc,l,c)&
                                  +posMatElem(dc,v,l)*posMatElem(db,l,c))/2.
                            psym1=(posMatElem(db,c,l)*posMatElem(dc,l,v)&
                                  +posMatElem(dc,c,l)*posMatElem(db,l,v))/2.
                            calF3=real(posMatElem(da,c,v)*psym0+posMatElem(da,v,c)*psym1)
                            tmp=tmp+(2./PI)*(T3(da,db,dc)/(omegacpv*omegacv))*(calF1+calF2+calF3)
                         end if
                      end DO
                   end if !static=0
!!! this is for intraband 1w contributions
                   !vs omega
                   if(static.eq.1) then
                      psym1=( posMatElem(db,c,v)*derMatElem(da,dc,v,c) &
                           +posMatElem(dc,c,v)*derMatElem(da,db,v,c) )/2.
                      psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                           +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                      tmp=tmp+(T3(da,db,dc)/omegacv)*(aimag(psym1)+2.*aimag(posMatElem(da,v,c)*psym2)/omegacv)
                   end if
                   !omega=0
                   if(static.eq.0) then
                      ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                      ! according to Anderson et al. PRB  91, 075302 (2015)
                      if (1.eq.2) then 
                         psym0=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                         psym1=( posMatElem(db,c,v)*gdVsig(da,dc,v,c) &
                              +posMatElem(dc,c,v)*gdVsig(da,db,v,c) )/2.
                         psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                              +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                         tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**3)&
                              *(real(psym1 + momMatElem(da,v,c)*(4.*psym0 - 7.*psym2/omegacv)))
                      end if
                      ! according to Rashkeev et al. PRB  57, 3905 (1998)
                      ! and /Users/bms/research/paris/shg/length/static/manuscript.tex eq.{i.1}
                      if (1.eq.1) then
                         psym0=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                         psym1=(derMatElem(da,db,v,c)+derMatElem(db,da,v,c))/2.
                         psym2=(derMatElem(dc,da,v,c)+derMatElem(da,dc,v,c))/2.
                         tmp=tmp+(1./PI)*(T3(da,db,dc)/omegacv**2)&
                              *(aimag(posMatElem(da,v,c)*psym0+posMatElem(dc,c,v)*psym1&
                              +posMatElem(db,c,v)*psym2))
                      end if
                   end if
!!!
                END DO
             END DO
          END DO
          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!##################
  END SUBROUTINE shg1Lrashkeev
!!!##################

!!!##############
  SUBROUTINE shg2L
!!!##############
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 2-omega term
!!! using the length-gauge correctly scissored according to
!!! /Users/bms/research/austin/shg/shg-notes/shg-layer-nonlocal.tex
!!! \ref{imchie2w,imchi2wf}, i.e. Eq. (I38,I40)
!!!

    IMPLICIT NONE

    INTEGER :: v,c,cp,vp
    INTEGER :: da, db,  dc

    COMPLEX(DPC) :: psym,psym1,primero,segundo
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacpvcv,omegacvpcv
    REAL(DP) :: T3(3,3,3),tmp,tol
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg2L: Length gauge'
!    write(*,*)'*********'

!!!
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    tol = 0.03     ! agrege
    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!! this is for interband 2w contributions
!!!  virtual-hole 
                   do vp=1,nVal
                      if((vp.ne.v).and.(vp.ne.c))then
                         omegacvp=band(c) - band(vp)
                         omegacvpcv=(2.*omegacvp-omegacv)
                         IF ((omegacvpcv.ge.0.d0).and.(omegacvpcv.le.tol))    omegacvpcv=omegacvpcv+tol ! agrege
                         IF ((omegacvpcv.le.0.d0).and.(omegacvpcv.ge.(-tol))) omegacvpcv=omegacvpcv-tol ! agrege
                         psym=(posMatElem(db,c,vp)*posMatElem(dc,vp,v)+posMatElem(dc,c,vp)*posMatElem(db,vp,v))/2.
                         tmp=tmp+4.*T3(da,db,dc)*real(posMatElem(da,v,c)*psym)/omegacvpcv
                      end if
                   end do
!!!! virtual-electron
                   do cp=nVal+1,nMax
                      if((cp.ne.v).and.(cp.ne.c))then
                         omegacpv=band(cp) - band(v)
                         omegacpvcv=(2.*omegacpv-omegacv)
                         IF ((omegacpvcv.ge.0.d0).and.(omegacpvcv.le.tol))    omegacpvcv=omegacpvcv+tol  ! agrege
                         IF ((omegacpvcv.le.0.d0).and.(omegacpvcv.ge.(-tol))) omegacpvcv=omegacpvcv-tol  ! agrege
                         psym=(posMatElem(db,c,cp)*posMatElem(dc,cp,v)+posMatElem(dc,c,cp)*posMatElem(db,cp,v))/2.
                         tmp=tmp-4.*T3(da,db,dc)*real(posMatElem(da,v,c)*psym)/omegacpvcv                          
                      end if
                   end do
!!! this is for intraband 2w contributions 
                   psym=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                   psym1=(posMatElem(db,c,v)*delta(dc,c,v)+posMatElem(dc,c,v)*delta(db,c,v))/2.
                   tmp=tmp+4.*(T3(da,db,dc)/omegacv)&
                        *(aimag(posMatElem(da,v,c)*psym) &
                        -2.*aimag(posMatElem(da,v,c)*psym1)/omegacv)
                END DO
             END DO
          END DO

          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)

!!!######################
  END SUBROUTINE shg2L
!!!######################

!!!#BMSVer3.0d 
!!!##################
  SUBROUTINE shg1C
!!!##################
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 1-omega term
!!! using the length-gauge correctly scissored according to
!!! shg-layer-nonlocal.tex Eqs. calvimchiewn and calvimchiwn
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c,l
    INTEGER :: da, db, dc
    COMPLEX(DPC) :: psym0,psym1,psym2,primero,segundo
    REAL(DP) :: omegacv,omegalv,omegacl
    REAL(DP) :: omegacvcl,omegacvlv
    REAL(DP) :: T3(3,3,3),tmp,tol
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg1C: Layer-Length gauge'
!    write(*,*)'*********'

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    tol = 0.03  !agrege

    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!! this is for interband 1w contributions Eq. (28a) Anderson et al. PRB 91, 075302 (2015)
                   do l=1,nMax
                      if((l.ne.v).and.(l.ne.c))then
                         omegacl=band(c)-band(l)
                         omegacvcl=(2.*omegacv-omegacl)
                         IF ((omegacvcl.ge.0.d0).and.(omegacvcl.le.tol))    omegacvcl=omegacvcl+tol ! agrege
                         IF ((omegacvcl.le.0.d0).and.(omegacvcl.ge.(-tol))) omegacvcl=omegacvcl-tol ! agrege
                         omegalv=band(l)-band(v)
                         omegacvlv=(2.*omegacv-omegalv)
                         IF ((omegacvlv.ge.0.d0).and.(omegacvlv.le.tol))    omegacvlv=omegacvlv+tol ! agrege
                         IF ((omegacvlv.le.0.d0).and.(omegacvlv.ge.(-tol))) omegacvlv=omegacvlv-tol ! agrege
                         !vs omega
                         if(static.eq.1) then
                            psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                            psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                            tmp=tmp+T3(da,db,dc)*( aimag(calVsig(da,l,c)*psym1)/(omegacv*omegacvcl) &
                              -aimag(calVsig(da,v,l)*psym2)/(omegacv*omegacvlv)) 
                         end if
                         !omega=0
                         if(static.eq.0) then
                            ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                            psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
                            psym2=(posMatElem(dc,l,c)*posMatElem(db,c,v)+posMatElem(db,l,c)*posMatElem(dc,c,v))/2.
                            tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**2)*(aimag(calVsig(da,v,l)*psym2)/omegacvlv&
                                 -aimag(calVsig(da,l,c)*psym1)/omegacvcl)
                         end if
                      end if
                   end do
!!! this is for intraband 1w contributions Eq. (28b) Anderson et al. PRB 91, 075302 (2015)
                   !vs omega
                   if(static.eq.1) then
                      psym1=( posMatElem(db,c,v)*gdcalVsig(da,dc,v,c) &
                           +posMatElem(dc,c,v)*gdcalVsig(da,db,v,c) )/2.
                      psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                           +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                      tmp=tmp+(T3(da,db,dc)/omegacv**2)&
                           *( real(psym1)&
                           +real(calVsig(da,v,c)*psym2)/omegacv)
                   end if
                   !omega=0
                   if(static.eq.0) then
                      ! PF[\chi(0;0,0)]=(1/PI)PF[Im[\chi(-w;w,w)]] where PF=prefactor
                      psym0=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                      psym1=( posMatElem(db,c,v)*gdcalVsig(da,dc,v,c) &
                           +posMatElem(dc,c,v)*gdcalVsig(da,db,v,c) )/2.
                      psym2=( posMatElem(db,c,v)*delta(dc,c,v) &
                           +posMatElem(dc,c,v)*delta(db,c,v) )/2.
                      tmp=tmp+(2./PI)*(T3(da,db,dc)/omegacv**3)&
                           *(real(psym1 + calVsig(da,v,c)*(4.*psym0 - 7.*psym2/omegacv)))
                   end if
!!!
                END DO
             END DO
          END DO

          !!! This calculatues the necessary scaling factor for normalizing layered SHG spectra.
          !!! Units are in (\times 10^6 pm^2/V). The 52.9177249 factor is the conversion from Bohr to pm.
          !!! We divide by 1.e6 to get the correct scale.
          !!! See /Users/bms/research/austin/shg/shg-notes/shg-layer-nonlocal.tex
          tmp=(acellz*52.9177249*1/1.e6)*tmp
          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!##################
  END SUBROUTINE shg1C
!!!##################
!!!##############
  SUBROUTINE shg2C
!!!##############
!!!
!!! This computes the integrand of the imaginary part of
!!! the nonlinear response tensor for the 2-omega term
!!! using the length-gauge correctly scissored according to
!!! shg-layer.tex Eqs. calvimchie2wn and calvimchi2wn
!!! 

    IMPLICIT NONE

    INTEGER :: v,c,cp,vp
    INTEGER :: da, db,  dc

    COMPLEX(DPC) :: psym,psym1
    REAL(DP) :: omegacv,omegacpv,omegacvp,omegacpvcv,omegacvpcv
    REAL(DP) :: T3(3,3,3),tmp,tol
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90-shg2C: Layer-Length gauge'
!    write(*,*)'*********'

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    tol = 0.03 ! agrege

    DO v = 1, nVal
       DO c = nVal+1, nMax
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
!!! this is for interband 2w contributions Eq. (28c) Anderson et al. PRB 91, 075302 (2015)
!!!  virtual-hole 
                   do vp=1,nVal
                      if((vp.ne.v).and.(vp.ne.c))then
                         omegacvp=band(c) - band(vp)
                         omegacvpcv=(2.*omegacvp-omegacv)
                         IF ((omegacvpcv.ge.0.d0).and.(omegacvpcv.le.tol))    omegacvpcv=omegacvpcv+tol ! agrege
                         IF ((omegacvpcv.le.0.d0).and.(omegacvpcv.ge.(-tol))) omegacvpcv=omegacvpcv-tol ! agrege 
                        psym=(posMatElem(db,c,vp)*posMatElem(dc,vp,v)+posMatElem(dc,c,vp)*posMatElem(db,vp,v))/2.
                         tmp=tmp-4.*T3(da,db,dc)*aimag(calVsig(da,v,c)*psym)&
                              /(omegacv*omegacvpcv)
                      end if
                   end do
!!!! virtual-electron
                   do cp=nVal+1,nMax
                      if((cp.ne.v).and.(cp.ne.c))then
                         omegacpv=band(cp) - band(v)
                         omegacpvcv=(2.*omegacpv-omegacv)
                         IF ((omegacpvcv.ge.0.d0).and.(omegacpvcv.le.tol))    omegacpvcv=omegacpvcv+tol ! agrege
                         IF ((omegacpvcv.le.0.d0).and.(omegacpvcv.ge.(-tol))) omegacpvcv=omegacpvcv-tol ! agrege
                         psym=(posMatElem(db,c,cp)*posMatElem(dc,cp,v)+posMatElem(dc,c,cp)*posMatElem(db,cp,v))/2.
                         tmp=tmp+4.*T3(da,db,dc)*aimag(calVsig(da,v,c)*psym)&
                              /(omegacv*omegacpvcv)
                      end if
                   end do
!!! this is for intraband 2w contributions Eq. (28d) Anderson et al. PRB 91, 075302 (2015)
                   psym=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                   psym1=(posMatElem(db,c,v)*delta(dc,c,v)+posMatElem(dc,c,v)*delta(db,c,v))/2.
                   tmp=tmp+4.*(T3(da,db,dc)/omegacv**2)&
                        *(real(calVsig(da,v,c)*psym) &
                        -2.*real(calVsig(da,v,c)*psym1)/omegacv)
                END DO
             END DO
          END DO

          !!! This calculatues the necessary scaling factor for normalizing layered SHG spectra.
          !!! Units are in (\times 10^6 pm^2/V). The 52.9177249 factor is the conversion from Bohr to pm.
          !!! We divide by 1.e6 to get the correct scale.
          !!! See /Users/bms/research/austin/shg/shg-notes/shg-layer-nonlocal.tex
          tmp=(acellz*52.9177249*1/1.e6)*tmp

          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF

       END DO
    END DO
104 FORMAT(E15.7)

!!!######################
  END SUBROUTINE shg2C
!!!######################
!!!#BMSVer3.0u
!!!#BMSVer3.1u
!!!##################
  SUBROUTINE sigma
!!!##################
!!!
!!! This computes the integrand of 
!!! the nonlinear response tensor for the shift-current
!!! \sigma^{abc}_2
!!! according to the notes of BMS
!!! that come from the notes of Benjamin M. Fregoso
!!! which correct Eq. (57) of
!!! J. E. Sipe and A. I. Shkrebtii, Phys. Rev. B 61, 5337 (2000).
!!!
    IMPLICIT NONE
    
    INTEGER :: v,c
    INTEGER :: da, db, dc
    REAL(DP) :: T3(3,3,3),tmp
!    write(*,*)'*********'
!    write(*,*)'@intergands.f90:sigma'
!    write(*,*)'*********'

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

    DO v = 1, nVal
       DO c = nVal+1, nMax
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   tmp=tmp+T3(da,db,dc)*aimag(posMatElem(db,c,v)*derMatElem(dc,da,v,c) &
                   - posMatElem(dc,v,c)*derMatElem(db,da,c,v))
                END DO
             END DO
          END DO
          
          IF (c==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") tmp
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") tmp
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
    
!!!##################
  END SUBROUTINE sigma
!!!##################

!!!#BMSVer3.1d
!!!##################
    COMPLEX FUNCTION efe(c,v,i,j)
!!!##################
    implicit none
    REAL(DP) :: scissors
    COMPLEX(DPC) :: ci
    integer :: c,v,i,j,vp,cp
    ci=cmplx(0.d0,1.d0)
!!! reads the scissors correction Delta    
    read(69,*)scissors
    close(69)
    efe=cmplx(0.d0,0.d0)
    do vp=1,nVal
       if (vp.ne.v) then
          efe=efe+posMatElem(j,c,vp)*posMatElem(i,vp,v)
       end if
    end do
    do cp=nVal+1,nMax
       if (cp.ne.c) then
          efe=efe-posMatElem(i,c,cp)*posMatElem(j,cp,v)
       end if
    end do
    efe=-scissors*(ci*efe+derMatElem(j,i,c,v)) 
!!!##################
  end FUNCTION efe
!!!##################

!!!##################
  SUBROUTINE Leo
!!!##################
    IMPLICIT NONE
    !
    ! One part of the second-harmonic tensor
    !  
    COMPLEX(DPC) :: ctmp
    REAL(DP) :: omegamn
    REAL(DP) :: T3(3,3,3)
    
    STOP 'LEO is not implemented.  In fact, you should not reach this message'
    
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    
    
    DO iv = 1, nVal
       DO ic = nVal+1, nMax
          omegamn=band(ic) - band(iv)
          ctmp = (0.d0, 0.d0)
          DO ix=1,3
             DO iy=1,3
                DO iz=1,3
!                   ctmp = ctmp +                                       &
!                        T3(ix,iy,iz)*derMatElem(iz,ix,iv,ic)*posMatElem(iy,ic,iv)
                   ctmp = (0.d0, 0.d0)
                END DO
             END DO
          END DO
          
!          ctmp = -(0.d0,1.d0)*ctmp/2.d0
          

          IF (ic==nMax) THEN
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="YES") REAL(ctmp)
          ELSE
             WRITE(UNIT=spectrum_info(i_spectra)%integrand_filename_unit, &
                  FMT=104,ADVANCE="NO") REAL(ctmp)
          END IF
          
       END DO
    END DO
104 FORMAT(E15.7)
!!!######################
  END SUBROUTINE Leo
!!!######################
  
!!!####################  
END MODULE integrands
!####################
