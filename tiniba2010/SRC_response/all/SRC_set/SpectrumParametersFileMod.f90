!!!#############################
MODULE SpectrumParametersFileMod
!!!#############################
  
  USE SpectrumParametersMod, ONLY : spectrumFile
  USE SpectrumParametersMod, ONLY : number_of_spectra_to_calculate
  USE SpectrumParametersMod, ONLY : spectrum_info
  
CONTAINS
  
!!!############################
  SUBROUTINE parseSpectrumFile
!!!############################
    
    IMPLICIT NONE
    INTEGER :: i, dims, length
    INTEGER :: istat, iostat
    INTEGER, ALLOCATABLE :: tmpIntArr(:)
    
    WRITE(*,*) "================================="
    WRITE(*,*) "subroutine  parseSpectrumFile()  "
    WRITE(*,*) "================================="  
    WRITE(*,*) "                           Opening = ",trim(spectrumFile)
    
    OPEN(UNIT=1, FILE=spectrumFile, FORM='FORMATTED', STATUS='OLD', IOSTAT=istat)
    IF (istat.NE.0) THEN
       WRITE(6,*) 'Error opening file', spectrumFile
       WRITE(6,*) 'Stopping'
       STOP
    END IF
    
    READ(1,*) number_of_spectra_to_calculate
    WRITE(*,*) "    Number of spectra to calculate = ",number_of_spectra_to_calculate
    
    ALLOCATE (spectrum_info(number_of_spectra_to_calculate), STAT=istat)
    IF (istat.NE.0) THEN
       ! Could not allocate
       WRITE(6,*) "Could not allocate spectrum_info)"
       WRITE(6,*) "Tried to allocate size of ", number_of_spectra_to_calculate
       WRITE(6,*) "Stopping"
       STOP
    END IF
    
    DO i=1, number_of_spectra_to_calculate
       READ(1,*) &
            spectrum_info(i)%spectrum_type,            &
            spectrum_info(i)%integrand_filename,       &
            spectrum_info(i)%integrand_filename_unit,  &
            spectrum_info(i)%compute_integrand   
       WRITE(6,*) "               For spectrum number = ",i
       WRITE(6,*) "                 Spectrum type is  = ",spectrum_info(i)%spectrum_type
       WRITE(6,*) "              Spectrum filename is = ",trim(spectrum_info(i)%integrand_filename)
       WRITE(6,*) "         Spectrum filename unit is = ",spectrum_info(i)%integrand_filename_unit
       WRITE(6,*) "Whether integrand will be computed = ",spectrum_info(i)%compute_integrand
       !WRITE(6,*) ' '
       
      
        SELECT CASE(spectrum_info(i)%spectrum_type)
        CASE(1)
          WRITE(6,*) 'imaginary part of Chi1'
          dims = 2
          length = 9
       CASE(21,22)
          WRITE(6,*) "Second-harmonic generation: Length Gauge"
          dims = 3
          length = 27
       CASE(26)
          WRITE(6,*) "Second-harmonic generation: Transversal Gauge 1 Omega"
          dims = 3
          length = 27
       CASE(27)
          WRITE(6,*) "Second-harmonic generation: Transversal Gauge 2 Omega"
          dims = 3
          length = 27
       CASE(60)
          WRITE(6,*) "SHG (Leitsman three): Transversal Gauge 1 Omega"
          dims = 3
          length = 27
       CASE(61)
          WRITE(6,*) "SHG (ARTICULO ): Transversal Gauge 1 Omega"
          dims = 3
          length = 27
       CASE(62)
          WRITE(6,*) "SHG (Leitsman three): Transversal Gauge 2 Omega"
          dims = 3
          length = 27
       CASE(63)
          WRITE(6,*) "SHG (ARTICULO): Transversal Gauge 2 Omega"
          dims = 3
          length = 27
       CASE(64)
          WRITE(6,*) "SHG (ARTICULO+ALGEBRA): Transversal Gauge 1 Omega"
          dims = 3
          length = 27
       CASE(65)
          WRITE(6,*) "SHG (ARTICULO+ALGEBRA): Transversal Gauge 2 Omega"
          dims = 3
          length = 27
       CASE(80)
          WRITE(6,*) "SHG 1 Leitsman A1 eta + omega"
          dims = 3
          length = 27
       CASE(81)
          WRITE(6,*) "SHG 2 Leitsman A1 eta + omega"
          dims = 3
          length = 27
CASE DEFAULT
          WRITE(6,*) "Error in input file: SpectrumParametersFileMod.f90"
          WRITE(6,*) "Spectrum_type ", spectrum_info(i)%spectrum_type," unknown"
          WRITE(6,*) "Stopping"
          STOP
       END SELECT
       
       ALLOCATE(tmpIntArr(dims), STAT=istat)
       IF (istat.NE.0) THEN
          ! Could not allocate
          WRITE(6,*) "Could not allocate tmpIntArr"
          WRITE(6,*) "Tried to allocate size of ", dims
          WRITE(6,*) "Stopping"
          STOP
       END IF
       
       READ(1,*) tmpIntArr(1:dims)
       IF ((tmpIntArr(1).GE.1).AND.(tmpIntArr(1).LE.3)) THEN
          ALLOCATE(spectrum_info(i)%spectrum_tensor_component(dims), STAT=istat)
          IF (istat.NE.0) THEN
             ! Could not allocate
             WRITE(6,*) "Could not allocate spectrum_info(", i, ")%spectrum_tensor_component"
             WRITE(6,*) "Tried to allocate size of ", dims
             WRITE(6,*) "Stopping"
             STOP
          END IF
          spectrum_info(i)%spectrum_tensor_component(1:dims) = tmpIntArr(1:3)
         ! WRITE(6,*) 'components are ', spectrum_info(i)%spectrum_tensor_component(1:dims)
          WRITE(*,*) "    components are = ",spectrum_info(i)%spectrum_tensor_component(1:dims)


       ELSE
          STOP 'Error in input file: spectrum_tensor_components not equal to 1, 2, or 3'
       END IF
       
       DEALLOCATE(tmpIntArr, STAT=istat)
       IF (istat.NE.0) THEN
          WRITE(6,*) "Could not deallocate tmpIntArr"
          WRITE(6,*) "Stopping"
          STOP
       END IF
       
       ALLOCATE(spectrum_info(i)%transformation_elements(length), STAT=istat)
       IF (istat.NE.0) THEN
          WRITE(6,*) "Could not allocate spectrum_info_transformation_elements"
          WRITE(6,*) "Stopping"
          STOP
       END IF
       
    END DO
    
    CLOSE(1)
    
    ! SHOULD ADD CHECKS ON THE DATA HERE
    ! 1) THAT THE SPECTRUM TYPE EXISTS
    ! 2) THAT THERE ARE NOT TOO MANY OR NOT ENOUGH COMPONENTS ENTERED
    
!!!*******************************
  END SUBROUTINE parseSpectrumFile
!!!*******************************

!!!*********************************
END MODULE SpectrumParametersFileMod
!!!*********************************
