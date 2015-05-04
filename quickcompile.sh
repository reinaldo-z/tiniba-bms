#!/bin/bash

printf "Compiling matrix elements.\n"
cd $TINIBA/matrix_elements/ver4.0
    ./compilerRPMNS.sh hexa
printf "Done.\n"
printf "Compiling latm/SRC_1setinput.\n"
cd $TINIBA/latm/SRC_1setinput
    ./compiler_all.sh
printf "Done.\n"
printf "Compiling latm/SRC_2latm.\n"
cd $TINIBA/latm/SRC_2latm
    ./compiler_all.sh
printf "Done.\n"
