PROGRAM escala
!!!
!!! Takes any file with a given number of columns
!!! and rescale every column by a fixed number
!!!
    IMPLICIT NONE
    INTEGER :: i,j
    INTEGER :: w,a,nc
    DOUBLE PRECISION :: r,f
    DOUBLE PRECISION, allocatable :: x(:)

    read(*,*)w,a,f !number of frequencies, second value from 'wc', scaling factor
    nc=a/w !number of columns
    r=mod(a,w) !if mod is different from 0, something is wrong, thus stop
    if ( r .ne. 0.0 ) stop 'escala.f90@WARNING:not a integer number of columns'
    allocate (x(nc))
    write(*,*)'       escala.f90: ',nc,' columns'
    do i=1,w
       read(1,*) (x(j), j = 1, nc )
       write(2,69)x(1),( f*x(j), j = 2, nc )
    end do
69  format(100e14.6)

  END PROGRAM escala


    

