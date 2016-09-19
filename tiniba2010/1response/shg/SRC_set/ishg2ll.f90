MODULE IntegrandSHG2Mod_Leitsman_eta_omega
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!##############################
  REAL(DP) FUNCTION SHG2_factor_Leitsman_eta_omega()
!!!##############################
    USE PhysicalConstantsMod
    USE ConstantsMod, ONLY : pi
    TYPE(physicalConstant) :: tmp1, tmp2, tmp3
    TYPE(physicalConstant) :: tmptmp
    TYPE(physicalConstant) :: volume
    REAL(DP) :: res
    
    volume = BohrRadius_cgs ** 3
    tmp1 = (electronCharge_cgs ** 3) / (hbar_cgs ** 2)
    tmp1 = tmp1 * (positionFactor_cgs ** 3)
    tmp1 = tmp1 / (frequency_cgs ** 2)
    tmp1 = tmp1 / volume
    res = makeDouble(tmp1)
    res = -res*pi 
    SHG2_factor_Leitsman_eta_omega = res
!!!#######################
  END FUNCTION SHG2_factor_Leitsman_eta_omega
!!!#######################
  
!!!#####################################
  INTEGER FUNCTION SHG2deltaFunctionFactor_Leitsman_eta_omega()
!!!#####################################
    SHG2deltaFunctionFactor_Leitsman_eta_omega = 2
!!!###############################
  END FUNCTION SHG2deltaFunctionFactor_Leitsman_eta_omega
!!!###############################
  
!!!#########################
  SUBROUTINE SHG2_Leitsman_eta_omega(i_spectra)
    !
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    USE PhysicalConstantsMod
    USE InputParametersMod, ONLY : tolSHGL


    IMPLICIT NONE

    INTEGER :: v, c, l
    INTEGER :: x, y, z
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(dpc) :: psym,dsym
    COMPLEX(dpc) :: ci
    REAL(dp) :: omegalv,omegacl,omegacv
    REAL(dp) :: T3(3,3,3),tmp

    ci=cmplx(0.,1.)

    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))

    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO x=1,3
             DO y=1,3
                DO z=1,3                   
!! two
                 dsym=(Delta(y,c,v)*posMatElem(z,c,v)+Delta(z,c,v)*posMatElem(y,c,v))/2.
                 tmp=tmp+16.*T3(x,y,z)*aimag(posMatElem(x,v,c)*dsym)/omegacv**2
                 
                   do l = 1,nMaxCC          
!! three
                      omegalv = band(l) - band(v) 
                      omegacl = band(c) - band(l)
              psym=(posMatElem(y,c,l)*posMatElem(z,l,v)+posMatElem(z,c,l)*posMatElem(y,l,v))/2.
                      tmp=tmp+4.*T3(x,y,z)*real(posMatElem(x,v,c)*psym)*(&
                       1./(omegalv-omegacl)-(omegalv-omegacl)/omegacv**2)
                    

                   end do

                END DO
             END DO
          END DO

          IF (c==nMaxCC) THEN
             ADV_opt = "YES"
          ELSE
             ADV_opt = "NO"
          END IF

          IF (c==nMaxCC) THEN
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
  END SUBROUTINE SHG2_Leitsman_eta_omega
!!!##################
  
!!!########################
END MODULE IntegrandSHG2Mod_Leitsman_eta_omega
!!!########################
