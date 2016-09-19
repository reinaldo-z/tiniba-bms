!!!####################
MODULE IntegrandSHG1Mod
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
  REAL(DP) FUNCTION SHG1_factor()
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
    SHG1_factor = 2.*res*pi 
    !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG1_factor= SHG1_factor*4.189E-4*1E12
     SHG1_factor= SHG1_factor/2.
    !######### 29 Nov. 2008 ##########

!!!#######################
  END FUNCTION SHG1_factor
!!!#######################
  
!!!#########################################
  INTEGER FUNCTION SHG1DeltaFunctionFactor()
!!!#########################################
    SHG1DeltaFunctionFactor = 1
!!!###################################
  END FUNCTION SHG1DeltaFunctionFactor
!!!###################################
  
!!!#########################
  SUBROUTINE SHG1(i_spectra)
!!!#########################
    !!
    !! 21 Length Gauge (1 \omega)
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

    INTEGER :: v,c,l
    INTEGER :: da,db,dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(DPC) :: sym1,sym2,sym3,sym4,sym5
    REAL(DP) :: omegacv,omegalc,omegavl,omegacvlc,omegavlcv
    REAL(DP) :: T3(3,3,3),tmp



    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))    


    DO v = 1,nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp =0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   sym1=(derMatElem(da,dc,v,c)*posMatElem(db,c,v)+derMatElem(da,db,v,c)*posMatElem(dc,c,v))/2.
                   sym2=(posMatElem(db,c,v)*Delta(dc,c,v)+posMatElem(dc,c,v)*Delta(db,c,v))/2.
                   sym3=(derMatElem(db,da,v,c)*posMatElem(dc,c,v)+derMatElem(dc,da,v,c)*posMatElem(db,c,v))/2.
                   tmp=tmp+T3(da,db,dc)*(aimag(sym1)/omegacv+aimag(posMatElem(da,v,c)*sym2)/omegacv**2-aimag(sym3)/(2.*omegacv))
                   do l=1,nMaxCC
                      if((l.ne.c).and.(l.ne.v)) then
                         omegalc=band(l) - band(c)
                         omegavl=band(v) - band(l)
                         omegacvlc=(omegacv-omegalc)
                        IF ((omegacvlc.ge.0.d0).and.(omegacvlc.le.tolSHGL)) omegacvlc=omegacvlc+tolSHGL
                        IF ((omegacvlc.le.0.d0).and.(omegacvlc.gt.(-tolSHGL))) omegacvlc=omegacvlc-tolSHGL
                         omegavlcv=(omegavl-omegacv)      
                        IF ((omegavlcv.ge.0.d0).and.(omegavlcv.le.tolSHGL))    omegavlcv=omegavlcv+tolSHGL
                        IF ((omegavlcv.lt.0.d0).and.(omegavlcv.gt.(-tolSHGL))) omegavlcv=omegavlcv-tolSHGL
                         sym4=(posMatElem(db,l,c)*posMatElem(dc,c,v)+posMatElem(dc,l,c)*posMatElem(db,c,v))/2.
                         sym5=(posMatElem(db,c,v)*posMatElem(dc,v,l)+posMatElem(dc,c,v)*posMatElem(db,v,l))/2.
       tmp=tmp+T3(da,db,dc)*(real(posMatElem(da,v,l)*sym4)/(omegacvlc)+real(posMatElem(da,l,c)*sym5)/(omegavlcv))
       !  if ((abs(omegacvlc)).gt.tolSHGL)then 
       !  tmp=tmp+T3(da,db,dc)*(real(posMatElem(da,v,l)*sym4)/(omegacvlc))
       !  end if 
       !  if ((abs(omegavlcv)).gt.tolSHGL)then 
       !  tmp=tmp+T3(da,db,dc)*(real(posMatElem(da,l,c)*sym5)/(omegavlcv))
       !  end if 
                      end if
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
END SUBROUTINE SHG1
!!!##################
  
!!!########################
END MODULE IntegrandSHG1Mod
!!!########################
