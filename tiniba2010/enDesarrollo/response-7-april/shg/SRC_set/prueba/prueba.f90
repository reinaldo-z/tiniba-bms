program prueba 
implicit none 
integer :: i
double precision :: a,tol
tol=.30 
do i=-10,10
a=.1d0*i
if ((a.ge.0.d0).and.(a.lt.tol)) a=tol
if ((a.le.0.d0).and.(a.gt.(-tol))) a=-tol
!if ((a.le.0.d0).and.(a.lt.tol)) a=tol
 !IF ((omegacvlv.gt.0.d0).and.(omegacvlv.le.tolSHGt)) omegacvlv=omegacvlv+tolSHGt
write(*,*)a 
end do 

end program prueba 
