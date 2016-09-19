!!!####################
MODULE IntegrandSHG2Mod
!!!####################
  ! 
  ! Module contains two subroutines for the calculation of SHG2.
  ! First subroutine calculates the overall factor for SHG2.
  ! Second subroutine calculates the integrand of SHG2.
  !
  USE debugMod, ONLY : debug
  USE ConstantsMod, ONLY : DP, DPC
  IMPLICIT NONE
  
CONTAINS
  
!!!##############################
  REAL(DP) FUNCTION SHG2_factor()
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
    SHG2_factor = 2.*res*pi
    !######### 29 Nov. 2008 ##########
    !right now in pmV
    !##pag. 53 Nonlinear Optics Robert Boyd
    !K=4.189E-4*1E12
     SHG2_factor= SHG2_factor*4.189E-4*1E12
     SHG2_factor= SHG2_factor/2.
    !######### 29 Nov. 2008 ##########
!!!#######################
  END FUNCTION SHG2_factor
!!!#######################
  
!!!#####################################
  INTEGER FUNCTION SHG2deltaFunctionFactor()
!!!#####################################
    SHG2deltaFunctionFactor = 2
!!!###############################
  END FUNCTION SHG2deltaFunctionFactor
!!!###############################
  
!!!#########################
  SUBROUTINE SHG2(i_spectra)
!!!#########################
    !
    ! This computes the integrand of the imaginary part of
    ! the nonlinear response SHG2
    !
    !!USE InputParametersMod, ONLY : nVal, nMax, nSym, tol
    USE InputParametersMod, ONLY : nVal, nMax, nSym, tol,nMaxCC
    USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
    USE SpectrumParametersMod, ONLY : spectrum_info
    USE ArraysMod, ONLY: momMatElem, posMatElem, derMatElem, Delta, energy, band
    USE ArraysMod, ONLY: spiMatElem, magMatElem
    USE PhysicalConstantsMod
    USE InputParametersMod, ONLY : tolSHGL


    IMPLICIT NONE

    INTEGER :: v, c, l
    INTEGER :: da, db, dc
    INTEGER :: i_spectra
    CHARACTER(LEN=3) :: ADV_opt

    COMPLEX(dpc) :: sym1,sym2,sym3
    REAL(dp) :: omegacv, omegacl, omegalv,omegacllv
    REAL(dp) :: T3(3,3,3),tmp




    !! write(68,*)"tolSHGL",tolSHGL
    T3(1:3,1:3,1:3) = reshape( spectrum_info(i_spectra)%transformation_elements(1:27), (/3,3,3/))

    DO v = 1, nVal
       DO c = nVal+1, nMaxCC
          omegacv=band(c) - band(v)
          tmp = 0.d0
          DO da=1,3
             DO db=1,3
                DO dc=1,3
                   sym1=(derMatElem(db,dc,c,v)+derMatElem(dc,db,c,v))/2.
                   sym2=(posMatElem(db,c,v)*Delta(dc,c,v)+posMatElem(dc,c,v)*Delta(db,c,v))/2.
                   tmp=tmp+T3(da,db,dc)*(2.*aimag(posMatElem(da,v,c)*sym1)/omegacv-4.*aimag(posMatElem(da,v,c)*sym2)/omegacv**2)
                   DO l = 1, nMaxCC
                      if((l.ne.v).and.(l.ne.c))then
                         omegalv=band(l)-band(v)
                         omegacl=band(c)-band(l)
                         sym3=(posMatElem(db,c,l)*posMatElem(dc,l,v)+posMatElem(dc,c,l)*posMatElem(db,l,v))/2.
                         omegacllv=(omegacl-omegalv)
                          IF ((omegacllv.ge.0.d0).and.(omegacllv.le.tolSHGL)) omegacllv=tolSHGL
                          IF ((omegacllv.le.0.d0).and.(omegacllv.gt.(-tolSHGL))) omegacllv=-tolSHGL  
                         if (abs(omegacllv).gt.tolSHGL) then
                            tmp=tmp+2.*T3(da,db,dc)*real(posMatElem(da,v,c)*sym3)/(omegacllv)     
                         end if
                      end if
                   end DO
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
  END SUBROUTINE SHG2
!!!##################
  
!!!########################
END MODULE IntegrandSHG2Mod
!!!########################
