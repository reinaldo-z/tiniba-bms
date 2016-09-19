#!/bin/bash
## FUNCTION: 
## FOR BULK CALCULATIONS 
## master program 
## CHILDREN:
## LAST MODIFICATION 
## Lunes 1 de Marzo de 2010 by JL Cabellos
    RED='\e[0;31m'
   BLUE='\e[0;34m'
    BLU='\e[1;34m'
   CYAN='\e[0;36m'
  GREEN='\e[0;32m'
    GRE='\e[1;32m'
 YELLOW='\e[1;33m'
    MAG='\e[0;35m'
     NC='\e[0m' # No Color


           WHERE=`dirname $0`
      NAMESCRIPT=`basename $0`

      BASEABINIT="/home/prog/abinit"
         BASEDIR=`dirname $PWD`
            CASO=`basename $PWD`
          PARENT=`basename $BASEDIR`
          DIRSCF=$CASO'_scf'
        DIRCHECK=$CASO'_check'
     SETUPABINIT=setUpAbinit_"$CASO".in
      WFSCFLOCAL=$CASO'o_DS1_WFK'
     WFSCFREMOTE=$CASO'i_DS1_WFK'
      WF2DATASET=$CASO'o_DS2_WFK'
  CUANTOSEGUNDOS="1"          
       WORKZPACE="workspace"
            HOST=`hostname`   
           INDEX=1
printf "\n"
printf "\tto RUN ${GREEN}ABINIT${NC} ==> $WHERE/${GREEN}runBulk.sh${NC}\n"
printf "\tto RUN ${GREEN}WIEN2K${NC} ==> $WHERE/${BLUE}wien2k${NC}/${GREEN}wien2k.sh${NC} (only in XEON 32 bits)\n"
printf "\tUtilities\n"
printf "\t$WHERE/${BLUE}utils${NC}/${GREEN}createRemoteDir.sh${NC}\n"
printf "\t$WHERE/${BLUE}utils${NC}/${GREEN}checkMountQuads.sh${NC}\n"
printf "\t$WHERE/${BLUE}utils${NC}/${GREEN}limpiaSetUpAbinit.pl${NC}\n"
printf "\n"
