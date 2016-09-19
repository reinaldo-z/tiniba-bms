#!/bin/bash
##
##PARENTS:
##7main.sh
   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color

       DIR=$PWD
         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`


##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
  declare -a NAMERES

    if [ $# -eq "0" ];then 
      printf "\t Stop rigth now ... Im children you can use me alone"
      exit 127
    fi 

      ii=0
      for file in $@; do
      let "ii=ii+1"
      NAMERES[$ii]=$file
      done 
printf "\n"
printf "\t${CYAN}=======+++Choices+++==========${NC}\n"
printf "\t${GREEN}1${NC}  ${BLU}${NAMERES[1]}${NC}  (${GREEN}linear bulk chi${NC})"
printf "\t                ${GREEN}24${NC} ${BLU}${NAMERES[24]}${NC}  (${GREEN}linear layered chi${NC})\n"
printf "\t${GREEN}21${NC} ${BLU}${NAMERES[21]}${NC}  (${GREEN}Length 1 omega${NC})"
printf "\t                ${GREEN}22${NC} ${BLU}${NAMERES[22]}${NC}  (${GREEN}Length 2 omega${NC})\n"
printf "\t${GREEN}64${NC} ${BLU}${NAMERES[64]}${NC} (${GREEN}transversal   1 omega${NC})"
printf "\t        ${GREEN}65${NC} ${BLU}${NAMERES[65]}${NC} (${GREEN}transversal  2 omega${NC})\n"
printf "\t${MAG}61${NC} ${BLU}${NAMERES[61]}${NC} (${MAG}transversal  1 omega WRONG )${NC}"
printf "\t${MAG}63${NC} ${BLU}${NAMERES[63]}${NC} (${MAG}transversal 2 omega WRONG)${NC}\n"
printf "\t${CYAN}==============================${NC}\n"
