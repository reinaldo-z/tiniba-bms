#!/bin/bash
## cabellos 
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color




 BASEDIR=`dirname $PWD`
 CASO=`basename $PWD`
  SETUPABINIT=setUpAbinit_"$CASO".in
 SETUPABINITp=.setUpAbinit_"$CASO".in
  COORDINATES="$CASO".xyz
 COORDINATESp=."$CASO".xyz
DIRSCF=$CASO'_scf'

 ###########################################3
        if [  -e "$SETUPABINITp" ];then
        cmp $SETUPABINIT $SETUPABINITp &> /dev/null
         if [ $? -eq  0 ];then
         printf "\t  ${CYAN}running the same case${NC}........."
         printf " [${GREEN}ok${NC}]\n"
         else
          printf "\t${RED}=========================${NC}\n"
          printf "\t ${RED}Hold on ...${RED}"
          printf "${CYAN}You changed something in your:${NC}"
          printf " $SETUPABINIT \n"
          printf "${GREEN}NEW VALUE${NC}                    "
          printf "                              "
          printf "   ${GREEN}OLD VALUE${NC}\n"
          diff --suppress-common-lines -w -y  $SETUPABINIT $SETUPABINITp
          printf "\t 30 seconds to ${RED}STOP${NC} for kill me \n"
          printf "\t if not Im going to continue... \n"
          sleep 30
          rm -rf $DIRSCF
          printf "\t${GREEN}FORCING to run SCF ${NC}...."
          printf " [${GREEN}ok${NC}]\n"
         fi
       fi
 ######################################

