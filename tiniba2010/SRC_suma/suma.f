      read(*,*)a1,a2,a3
      slab=abs(a1-a2)
      vac= abs(slab-a3)
      write(*,*)'slab size= ',slab,'vacuum size= ',vac
      end
