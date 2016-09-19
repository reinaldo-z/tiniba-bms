#!/bin/bash
      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
      MAG='\e[0;35m'
       NC='\e[0m' # No Color

      WHERE=`dirname $0` ## great jl 
        WIEN2K="/home/bms/wien2k_04" 
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR` 
   SETUPABINIT=setUpAbinit_"$CASO".in
         CHECK="$CASO"_check"/$CASO.out"



if [ -e $SETUPABINIT ];then
   rm -f tmpX
    grep nband2 setUpAbinit_$CASO.in > tmpX
    Nmax=`head -1 tmpX | awk '{print $2}'`
   rm -f tmpX
  ECUTsetUp=`grep ecut $SETUPABINIT  |  awk '{print $2}'`
  ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
 
  if [ -e infoenergy2script ];then
       NBANDSwien=`awk '{print $1}' infoenergy2script`
       printf "\t     Total bands WIEN2K= $NBANDSwien\n"

      if [ "$NBANDSwien" != "$Nmax" ];then
       printf "\t${RED}=======================${NC}\n"
       printf "\t${RED}Warrning:(DO THIS PLEASE) ${NC}\n"
       printf "\t${RED}Warrning:(DO THIS PLEASE) ${NC}\n"
       printf "\t${RED}if not you not be able to"
       printf " calculate: responses_bms.sh ${NC}\n"
       printf "\t Modificate your : $SETUPABINIT \n"
       printf "\t put: \n"
       printf "\t nband2 = $NBANDSwien\n"
       printf "\t Actual is :nband2 = $Nmax \n"
       printf "\t${RED}=======================${NC}\n"
       else 
       printf "\t       Total bands WIEN2K= $NBANDSwien\n"
       printf "\t Total bands $SETUPABINIT= $Nmax\n"    
       printf "\t ${GREEN}OK${NC}\n"

      fi
   fi
fi 




