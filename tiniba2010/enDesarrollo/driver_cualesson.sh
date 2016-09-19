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
  SETUPABINIT=setUpAbinit_$CASO.in
  CUAL_ONE=$DONDEVIVO/one_node_cabellos.sh
  
     BASEABINIT="/home/prog/abinit"
     ABINIs_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinis.xeon"
     ABINIp_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinip.xeon"
     ABINIs_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinis.itan"
     ABINIp_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinip.itan"
     ABINIs_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinis.quad"
     ABINIp_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinip.quad"
      MPICH_XEON="/usr/local/mpich_gm_intel9/bin"
      MPICH_ITAN="/usr/local/mpich-itanium-intel9/bin"
      MPICH_QUAD="/home/mvapich-intel/bin/mpirun_rsh"
        

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
    let "HHSU=$hh+1"
       REMOTESERVER=${MACHINESpmn[$hh]}
       REMO=${REMOTE[$hh]}
       LOCA=${LOCAL[$hh]}
    printf "\t$REMOTESERVER : $LOCA   $REMO\n"
       sleep .1
  done 
