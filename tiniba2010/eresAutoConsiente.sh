#!/bin/bash
## CHILDREN:
## checkPSPabinit.pl
## 
## INPUTS: 
## $1=[SERIAL O PARALELO] $2=ABINIp_xx

## SCF ITANIUM 
## CABELLOS LAST MODIFICATION 7 Marzo 2009
## CABELLOS LAST MODIFICATION 27 Marzo 2009

 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 MAG='\e[0;35m'
 NC='\e[0m' # No Color

   rm -rf killme
      

##==============================
        WHERE=`dirname $0`
        #printf "\t${MAG}Running: ${NC} $WHERE/`basename $0` $1 \n"
      BASEDIR=`dirname $PWD`
         CASO=`basename $PWD`
       PARENT=`basename $BASEDIR`
       DIRSCF=$CASO'_scf'
  ABINITfiles=$CASO'.files'
     ABINITin=$CASO'.in'
   WFSCFLOCAL=$CASO'o_DS1_WFK'
  WFSCFREMOTE=$CASO'i_DS1_WFK'
   WF2DATASET=$CASO'o_DS2_WFK'
CUANTOSEGUNDOS="1"          
    WORKZPACE="workspace"   
      FILEscf="$DIRSCF/.machines_scf"
      ABfiles="$DIRSCF/$ABINITfiles"
         ABin="$DIRSCF/$ABINITin"
    ANFITRION=`hostname`
##==============================
   ABINIs_ITAN="/home/prog/abinit/ABINITv4.6.5_ITAN/abinis"
   ABINIp_ITAN="/home/prog/abinit/ABINITv4.6.5_ITAN/abinip"
       MPICH_ITAN="/usr/local/mpich-itanium-intel9/bin"
##==============================
       declare -a MACHINESscf
##====== FUNCTIONS ============= 
 function StopMe {
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127    
       }
 function IsThereError {
     if [ -e killme ]; then
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127
     fi
    }
 function Duerme {
      if [ "$1" -gt 0 ];then
       printf "\t${BLU}Sleeping:${NC} $1 seconds\n"
       sleep $1
      fi 
       }
 function Line {
      printf "\t${BLUE}=============================${NC}\n"
       }
 function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127 
      fi
      }    
##====== BEGIN CODE =========== 
     if  [ $# -ne 1 ];then
         printf "\tUsage: \n"
         printf "\t `basename $0` [Option1]\n"
         printf "\t [Option1]= 2=paralelo 1=serial\n"
         StopMe
     fi
     ## 
     PARALELO=$1
     if [ "$PARALELO" != 1 ];then
        if [ "$PARALELO" != 2 ];then
          printf "\t [Option1] has to be 1=serial 2=paralelo\n"
          StopMe
        fi
     fi  
     ##=================================================
###########################
########################### PARALELO
###########################
     
     if [ $PARALELO -eq 2 ];then ##run in parallel
          rm -f tmpQ1
          sed '/^ *$/d' .machines_scf > tmpQ1
          mv tmpQ1 .machines_scf
           MACHINESscf=(`cat .machines_scf`)
          NOMACHINESscf=`echo ${#MACHINESscf[@]}`
          rm -f tmpQ1
        ##
        if [[ "${MACHINESscf[0]}" == "itanium"* ]]; then
          $WHERE/SCFitan.sh 2
        fi   
        if [[ "${MACHINESscf[0]}" == "node"* ]]; then
          $WHERE/SCFxeon.sh 2
        fi   
        if [[ "${MACHINESscf[0]}" == "quad"* ]]; then
          printf "\t No yet ...cabellos \n"
        fi   
       fi ## end PARALELO
###########################
########################### SERIAL 
###########################
     if [ $PARALELO -eq 1 ];then ##run in SERIAL 
     Line
     printf "\tSerial no yet implemeted... \n"
     printf "\tImplement in line=192 `basename $0`  Atte: cabellos\n"
     StopMe
     fi
