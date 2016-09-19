#!/bin/bash
## LAST MODIFICATION : Febrero 23 2010 by JL Cabellos
GREEN='\e[0;32m'
green='\e[1;32m'
YELLOW='\e[1;33m'
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color

        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace"
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'  
     DIRSCF=$CASO'_scf'
  DONDEVIVO=`dirname $0`     
      
     
##====== FUNCTIONS ============ 
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127    
       }
############################################## cabellos ####################
############################################## cabellos ####################
############################################## cabellos ####################
##===CHECK IF .machines file exist==================== !!
  if [ ! -e .machines_pmn ]
      then
        printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        StopMe
  else
     MACHINESpmn=(`cat .machines_pmn`)
     NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
  fi
###################################################
###################################################
##################################################
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        CAZO=$CASO"_"$kk
         REMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         LOCAL[$hh]="$CAZO"
   done
###################################################
###################################################
  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
  #for ((hh=0;hh<=(1); hh++));do
    let "HHSU=$hh+1"
       REMOTESERVER=${MACHINESpmn[$hh]}
       REMO=${REMOTE[$hh]}
       LOCA=${LOCAL[$hh]}
          QUECORRES="abinis_$HHSU.sh"
          CASI=`basename $REMO`
        CAMINO=`dirname $REMO` 
   # printf "\t$REMOTESERVER : $CAMINO/${BLUE}$CASI${NC}/$QUECORRES \n"
    rsh $REMOTESERVER "cd $REMO;./$QUECORRES" &
    sleep 1
  done 
exit 0
