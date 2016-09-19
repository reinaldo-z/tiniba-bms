!!!####################
MODULE IntegrandSHG1Mod_Leitsman_eta_omega
!!!####################
  ! 
  ! Module contains two subroutines for the calculation of
  ! the first part of the SHG tensor.
  ! First subroutine calculates the overall factor for SHG1.
  ! Second subroutine calculates the integrand of SHG1.
  ! 
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!##############################
  REAL(DP) FUNCTION SHG1_factor_Leitsman_eta_omega()
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
    SHG1_factor_Leitsman_eta_omega = res 
!!!#######################
  END FUNCTION SHG1_factor_Leitsman_eta_omega
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG1DeltaFunctionFactor_Leitsman_eta_omega()
!!!#########################################
    SHG1DeltaFunctionFactor_Leitsman_eta_omega = 1
!!!###################################
  END FUNCTION SHG1DeltaFunctionFactor_Leitsman_eta_omega
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1_Leitsman_eta_omega(i_spectra)
!!!#########################
    !!
    !! LENGHT LEITSMAN ETA+OMEGA  (1 \omega)
    !! 
    !!USE InputParametersMod, ONLY : nVal, nMax, nSym, tol
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    USE PhysicalConstantsMod
    USE InputParametersMod, ONLY : tolSHGL
    
    IMPLICIT NONE
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt
    INTEGER :: v, c, l
    COMPLEX(dpc) :: psym1,psym2,psym3,psym4,psym5,psym6,dsym
    COMPLEX(dpc) :: ci
    REAL(dp) :: omegalv,omegacl,omegacv,omegavl,omegalc
    REAL(dp) :: T3(3,3,3),tmp
    INTEGER :: da,db,dc

    ci=cmplx(0.,1.)

  T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    

            
    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.0d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                  !!two
                  dsym=(Delta(db,c,v)*posMatElem(dc,c,v)+Delta(dc,c,v)*posMatElem(db,c,v))/2.
                  tmp=tmp+8*T3(da,db,dc)*2*aimag(posMatElem(da,v,c)*dsym)/omegacv**2

                  do l = 1,nMaxCC
                  !! three
                  omegavl=band(v) - band(l)
                  omegalv=band(l) - band(v)
                  omegalc=band(l) - band(c)
                  omegacl=band(c) - band(l)
        psym1=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
        psym2=(posMatElem(db,l,c)*posMatElem(dc,c,v)+posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
        psym3=(posMatElem(db,l,c)*posMatElem(dc,c,v)+posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
        psym4=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
        psym5=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
        psym6=(posMatElem(db,l,c)*posMatElem(dc,c,v)+posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
        tmp=tmp+T3(da,db,dc)*(&
                           (-2*real(posMatElem(da,l,c)*psym1)/(omegavl-omegacv))+&
                           (-2*real(posMatElem(da,v,l)*psym2)/(omegacv-omegalc))+&
                           (omegalv*2*real(posMatElem(da,v,l)*psym3)/(omegacv**2))-&
                           (omegacl*2*real(posMatElem(da,l,c)*psym4)/(omegacv**2))+&
                           (omegavl*2*real(posMatElem(da,l,c)*psym5)/(2*omegacv**2))-&
                           (omegalc*2*real(posMatElem(da,v,l)*psym6)/(2*omegacv**2))&
                          ) 
       
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
  END SUBROUTINE SHG1_Leitsman_eta_omega
!!!##################
  
!!!########################
END MODULE IntegrandSHG1Mod_Leitsman_eta_omega
!!!########################
