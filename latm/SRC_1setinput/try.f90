program try
  LOGICAL :: spinCalculation
  CHARACTER(LEN=80) ::  smn_data_filename
  read(*,*)  smn_data_filename
  INQUIRE(FILE=smn_data_filename, EXIST=spinCalculation)
  if (spinCalculation) then
     write(*,*)smn_data_filename,' existe'
  else
     write(*,*)smn_data_filename,' no existe'
  end if
end program try
