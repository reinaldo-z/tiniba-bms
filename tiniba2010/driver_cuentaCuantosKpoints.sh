#!/bin/bash
##
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
##copiaCASOin.sh
##copiaSTANDAR.sh
## 
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
   if  [ $# -lt 1 ];then
         printf "\tUsage: \n"
         printf "\t ${GREEN}`basename $0`${NC} [Option1]\n"
         printf "\t [Option1]= 2=paralelo 1=serial\n"
         printf "\t 1 = in local  dir\n"
         printf "\t 2 = in remote dir\n"
         exit 0
  fi



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
  ###
  ###
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
###################################################
###################################################
 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    let "kk=$hh+1"
       CAZO=$CASO"_"$kk
       LOCA=${LOCAL[$hh]}
       REMO=${REMOTE[$hh]}
       REMOTESERVER=${MACHINESpmn[$hh]}
        if [ "$1" == "1" ];then
          if [ -e $CAZO/$CASO.in ];then 
          CUA=`grep nkpt2  $CAZO/$CASO.in | awk '{print $2}'`
          printf "\t$REMOTESERVER --->${BLUE}$CAZO${NC}/$CASO.in [$CUA Kpoints] \n"
          else
          printf "\t$no file:  ${BLUE}$CAZO${NC}/$CASO.in \n" 
          fi
        fi    
 done 
  exit 0 
