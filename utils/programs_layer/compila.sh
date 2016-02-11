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
file='layer.f90'  
run='rlayer'
compila
#
file='operations.f90'
run='roperations'
compila
#
file='prom_layer.f90'
run='rprom_layer'
compila
#
file='slab.f90'
run='rslab'
compila
