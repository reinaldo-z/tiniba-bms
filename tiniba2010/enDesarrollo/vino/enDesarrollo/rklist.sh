#!/bin/bash
      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
  MAGENTA='\e[0;35m'
       NC='\e[0m' # No Color

##====== DEFINITIONS ===========
         WHERE="/home/$USER/wien2k"
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`


function StopMe {
      printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
      exit 127
       }


  if [ "$#" -ne 3 ];then
   printf "`basename $0`\n"
   StopMe
  fi 


   if [ ! -e symmetries/pvectors ];then
      printf "\t There isnt FILE: symmetries/pvectors \n"
      StopMe
   fi
   ###
   if [ ! -e symmetries/sym.d ];then
     printf "\t There isnt FILE: symmetries/sym.d \n"
     StopMe
   fi


     if [ ! -d $CASO ];then
       mkdir $CASO
     fi
      cd $CASO

       rm -f grid
       echo $1 $2 $3 > grid
       cp ../symmetries/pvectors .
       cp ../symmetries/sym.d .
       cp ../$CASO.struct .
 /home/jl/vino/ibz.xeon -wien2k -tetrahedra -cartesian -symmetries -reduced -mesh


    isThereFile kpoints.reciprocal
    NKPT=`wc kpoints.reciprocal | awk '{print $1}'`
     mv kpoints.reciprocal ../$CASO.klist_$NKPT
    isThereFile kpoints.cartesian
     mv kpoints.cartesian ../symmetries/$CASO.kcartesian_$NKPT
    isThereFile tetrahedra
     mv tetrahedra ../symmetries/tetrahedra_$NKPT
    isThereFile Symmetries.Cartesian
     mv Symmetries.Cartesian ../symmetries/Symmetries.Cartesian_$NKPT
     isThereFile kpoints.wien2k
     mv kpoints.wien2k ../$CASO.kpoints.wien2k_$NKPT
     printf "\n"


     printf "\t files generated\n"
     printf "\twien2k: ${MAGENTA}$CASO.kpoints.wien2k_$NKPT${NC}\n"
     printf "\tabinit: ${MAGENTA}$CASO.klist_$NKPT${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}$CASO.kcartesian_$NKPT${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}tetrahedra_$NKPT ${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}Symmetries.Cartesian_$NKPT ${NC}\n"
     printf "\tyou just generated Nk=${GREEN}$NKPT${NC} kpoints \n"
