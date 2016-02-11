#!/bin/bash
##
FC='/opt/intel/compilers_and_libraries_2016.1.150/linux/bin/intel64/ifort'
OPTS='-O3 -axCORE-AVX2,-axSSE4.2'
function compila {
echo $FC -o$run $OPTS $file > compi
chmod +x compi
./compi
rm compi
}
#
file='smear2.f90'  
run='rsmear2'
compila
#
