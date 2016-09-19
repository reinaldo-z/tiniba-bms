subroutine caso(cwd,cazo)
!! FUNCTION:
  !! find the caso by jl 
  !! PARENTS:
  !! CHILDREN
   implicit none
 !!input variables 
   character(len=255),intent(in) :: cwd  
 !!Output Variables
   character(len=255),intent(out) :: cazo  
 !!Local Variables
  integer :: ii1
 !! SOURCE
     ii1=index(cwd(1:255),'/',BACK = .TRUE.)
     cazo=(trim(cwd(ii1+1:255)))
end subroutine  caso
