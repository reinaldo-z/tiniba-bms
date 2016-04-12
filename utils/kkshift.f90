PROGRAM kkshift
!!!
!!! Takes any file with 2 columns
!!! and shifts column 1 by a fixed number
!!!
    IMPLICIT NONE
    INTEGER :: i,j
    INTEGER :: w
    DOUBLE PRECISION :: delta
    DOUBLE PRECISION :: x(2)

    read(*,*)w,delta !number of frequencies, shift value
    do i=1,w
       read(1,*) (x(j), j = 1, 2 )
       write(2,*)delta + x(1),x(2)
    end do
!69  format(100e14.6)

  END PROGRAM kkshift


    

