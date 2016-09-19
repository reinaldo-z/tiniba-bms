program conSetInput
 !! cabellos at 13 de octubre 2007 at 21:55 
 implicit none
  double precision :: entrada
  character(len=80) :: filein
  character(len=80) :: fileou
  integer   :: IArgC,ArgC
  logical :: filexist
 
  ArgC=IArgC()   !number of arguemnts
  if (ArgC.ne.1) then!!
   write(*,*)"Usage: conSetInput file1"
   write(*,*)"file1 ==> input "
   write(*,*)"ZAL ==> SALIDA "
   write(*,*)"just read a number in foramt 6.678808887990328E-001"
   write(*,*)"and write it in format : .067, for example"
   write(*,*)"file1 contains the number in format xxE-001 to be read"
   stop 
   call abort("Decision taken to exit ...stopping right now ")  
  end if 
  
  call GetArg(1,filein)
  call system ( "rm -f killme" )
 
inquire (file=(trim(filein)),exist=filexist)
 if (.NOT. filexist) then
   write(*,*)"There isnt FILE: ",trim(filein)
   write(*,*)"Stoping right now ..."
   call system ( "touch killme" )    
   stop 
 end if 
 
 !write(*,*)trim(filein)
 !write(*,*)trim(fileou)


OPEN(unit=12,FILE=trim(filein), STATUS="OLD", ACTION="READ")
 !write(*,*)"here enter "
 entrada=0.0
 read(12,*)entrada
 
 write(*,*)"entrada form FILE:  ",trim(filein)
 write(*,*)entrada
 
       call system ("rm -f ZAL")
       OPEN(unit=14,FILE='ZAL', STATUS="UNKNOWN", ACTION="write")
        write(14,'(2f6.3)')entrada 
        write(*,*)"salida in FILE: ZAL"
        write(*,'(2f6.3)')entrada
 close(12)  
 close(12)
end program conSetInput
