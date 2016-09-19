!!!#################
MODULE TetrahedraMod
!!!#################
  USE ConstantsMod, ONLY : DP
  IMPLICIT NONE
  
  LOGICAL,  ALLOCATABLE :: includeTetrahedron(:) ! choose which tetrahedron to use
  INTEGER,  ALLOCATABLE :: tetCorner(:,:)        ! tetrahedron corner indices
  REAL(DP), ALLOCATABLE :: tetrahedronVolume(:)  ! relative volume of each tetrahed
  
CONTAINS
  
!!!##############################
  SUBROUTINE Load_Tetrahedra_Data
!!!##############################
!!! Reads tetrahedra indices and tetrahedra volumes
    USE ConstantsMod, ONLY : DP
    USE ConstantsMod, ONLY : PI
    USE InputParametersMod, ONLY :  nTetra
    USE InputParametersMod, ONLY :  tet_list_filename
    USE InputParametersFileMod, ONLY : nTetra_set
    IMPLICIT NONE
    INTEGER :: file_nTetra
    INTEGER :: iTetra
    INTEGER :: totalReducibleTetrahedra
    REAL(DP) :: totalVolume
    REAL(DP), ALLOCATABLE :: tetrahedronWeight(:)
    
    WRITE(*,'(A10,A80)') 'opening: ', tet_list_filename
    OPEN (1,FILE = tet_list_filename,FORM = 'formatted',STATUS = 'old')
    READ (1,*) file_nTetra
    
    IF (nTetra_set) THEN
       IF (file_nTetra.NE.nTetra) THEN
          WRITE(6,*) ' '
          WRITE(6,*) 'Inconsistency of first line of', &
               tet_list_filename, 'with internal value for nTetra'
          WRITE(6,*) 'First line of', tet_list_filename, ' is ', file_nTetra
          WRITE(6,*) 'Internal value of nTetra is ', nTetra
          WRITE(6,*) 'STOPPING'
          WRITE(6,*) ' '
       END IF
    ELSE
       WRITE(*,*) "Setting nTetra from tetrahedra file"
       nTetra = file_nTetra
    END IF
    
    ALLOCATE( tetCorner(nTetra,4) )
    ALLOCATE( tetrahedronVolume(nTetra) )
    ALLOCATE( tetrahedronWeight(nTetra) )
    
    ! initialize arrays
    tetCorner(1:nTetra,1:4) = 0
    tetrahedronVolume(1:nTetra) = 0.d0
    tetrahedronWeight(1:nTetra) = 0.d0
    
    DO iTetra = 1, nTetra
       ! File has the real volume of the tetrahedron, in atomic units, not
       ! the relative volume
       READ(1,*)  tetCorner(iTetra,1:4), tetrahedronWeight(iTetra), tetrahedronVolume(iTetra)
       tetrahedronVolume(iTetra) = tetrahedronWeight(iTetra) * &
            tetrahedronVolume(iTetra)/(8.d0*PI**3)
    END DO
1001 FORMAT(4I6,E18.8)
    CLOSE(1)
    
    totalVolume = SUM(tetrahedronVolume(1:nTetra))
    WRITE(6,*) 'Tetrahedra volumes add to ', totalVolume*(8.d0*PI**3)
    
    totalReducibleTetrahedra = SUM(tetrahedronWeight(1:nTetra))
    WRITE(*,*) 'Total number of reducible tetrahedra ', totalReducibleTetrahedra
    
    DEALLOCATE( tetrahedronWeight )
    
    WRITE(6,*) 'Load_Tetrahedra_Data DONE'
!!!##################################
  END SUBROUTINE Load_Tetrahedra_Data
!!!##################################
  
!!!##########################
  SUBROUTINE Which_Tetrahedra
!!!##########################
!!! determine which tetrahedra to include in the calculation
    USE InputParametersMod, ONLY : nTetra
    IMPLICIT NONE
    INTEGER :: iTetra
    
    ALLOCATE(includeTetrahedron(nTetra))
    
    includeTetrahedron(1:nTetra) = .FALSE.
    
    DO iTetra=1,nTetra
       includeTetrahedron(iTetra) = .TRUE.
    END DO
    
    WRITE(6,*) 'Which_Tetrahedra DONE'
!!!##############################
  END SUBROUTINE Which_Tetrahedra
!!!##############################
  
!!!#####################
END MODULE TetrahedraMod
!!!#####################
