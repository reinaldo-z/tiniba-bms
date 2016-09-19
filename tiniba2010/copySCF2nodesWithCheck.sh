#!/bin/bash
##2 Julio at 23:54 hrs. cabellos 
##29 SEPTIEMBRE 2007 AT 21:03 cabellos 
##FUNCTION:
##copy SCF to dir in .machines_pmn 
##CHILDREN:
##ineedsplitWFSCF.sh
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
MAG='\e[0;35m'
NC='\e[0m' # No Color

##=========FUNCTIONS===============
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127
       }
##================================= 
 declare -a MACHINESpmn
 declare -a WHEREWORKREMOTE
 declare -a WHEREWORKLOCAL

        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace" 
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'
     DIRSCF=$CASO'_scf'
   INTENTOS=6
 INEEDSPLIT=0
  FILE2COPY=$1
  ANFITRION=`hostname`
#      WHERE="/homeib/jl/tinibaQUAD"

    rm -f killme
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${MAG}Running :${NC}`dirname $0`/`basename $0`\n" 
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
##################################################
####========WHERE WORK ===========================
##################################################
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        CAZO=$CASO"_"$kk
        WHEREWORKREMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         WHEREWORKLOCAL[$hh]="$PWD/$CAZO"
   done
##################################################
####========REMOTE DIRECTORIOS====================
##################################################
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${CYAN}Checking${NC} REMOTE directories \n"
     for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        REMOTESERVER=${MACHINESpmn[$hh]}
        DIRQ=${WHEREWORKREMOTE[$hh]}
        BASE=`dirname $DIRQ`
        DIRE=`basename $DIRQ`
        printf "\t[$REMOTESERVER]:$BASE/${BLUE}$DIRE${NC}"          
        EXISTE=`rsh $REMOTESERVER 'test -d '$DIRQ'; echo $?'`
         if [ $EXISTE -eq 0 ] ;then
          printf " [${GREEN}exist${NC}]\n"
         else
          printf " [${GREEN}making${NC}]\n"
          rsh $REMOTESERVER "mkdir -p $DIRQ"
         fi
        sleep .15
      done
   printf "\t${BLUE}========================${NC}\n"
##################################################
####======== CHEKING SCF  ========================
##################################################
##===CHECK IF SCF DIR EXIST down======================
  if [ -d "$DIRSCF" ];then
   printf "\t${BLUE}$DIRSCF${NC}  "
   printf "...................[${GREEN}ok${NC},exist] \n"
    if [ -e "$DIRSCF/$WFSCFLOCAL" ];then
     printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL  "
     printf ".................[${GREEN}ok${NC},exist] \n"
     if [ -e "$DIRSCF/log" ];then
       printf "\tBegin to check WF SCF...\n"
         WARRNINGS=`awk '/Delivered/ { print }' $PWD/$DIRSCF/log`
         CALCULATION=`awk '/Calculation/ { print }' $PWD/$DIRSCF/log`
          if [ -z "$CALCULATION" ];then
           printf "\t           ${RED}BUT IS WRONG ${NC}\n"
           printf "\tIt seems that your scf ABINIT did not run properly\n"
           printf "\tlook for error messages in:\n "
           printf "\t$PWD/${BLUE}$DIRSCF${NC}/log \n"
           #printf "\t ${RED}Stoping right now ... ${NC}\n"
           touch killme
           exit 1
          else
           printf "\t${BLUE}$DIRSCF${NC}/log "
           printf ".................[${GREEN}ok${NC},exist] \n"
           printf "\t$WARRNINGS \n"
           printf "\t$CALCULATION\n"
           printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL "
           printf "....... [${GREEN}ok${NC}]\n"
          fi #end CALCULATION
        else #log
        printf "\t$DIRSCF/log doesnt exist \n"
        printf "\t${RED}Stoping right now ... ${NC}\n"
        touch -f killme
        #read -p "Ctrl C to Kill me ..."
        exit 1
        fi # end log
      else # "$DIRSCF/$WFSCFLOCAL"
        printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL doesnt exist...\n"
        printf "\t CAUSE: ABINIT didn't run SCF...  "
        #printf "\t${RED}Stoping right now ... ${NC}\n"
        #read -p "Ctrl C to Kill me ..."
        touch -f killme
        exit 1
      fi # "$DIRSCF/$WFSCFLOCAL"
   else
   printf "\t ${RED}There isn't DIRECTORY ${NC}${BLUE}$DIRSCF${NC} in :\n"
   printf "\t $DIR/ \n"
   printf "\t CAUSE: ABINIT didn't run SCF...  "
   printf "${RED}Stoping right now ... ${NC}\n"
   touch -f killme
   #read -p "Ctrl C to Kill me ..."
   exit 1
  fi
  ##===CHECK IF SCF DIR EXIST up======================
##################################################
####========COPYING FILE ========================
##################################################
  TIMER=`date`
  rm -f killme
  rm -f tmp
   printf "\t${CYAN}=================================${NC}\n"
    printf "\t${CYAN}Start to copy at time: $TIMER ${NC}\n" 

  CUANTO=`du -h  $DIRSCF/$WFSCFLOCAL | awk '{print $1}'`  
##===============================================
 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    let "HHSU=$hh+1"
    REMOTESERVER=${MACHINESpmn[$hh]}
    ADONDECOPY=${WHEREWORKREMOTE[$hh]}
    ##---------------------------  
    if [[ "$REMOTESERVER" == "itanium"* ]]; then
         MAQUINA501=$REMOTESERVER
         SWITCHNAME="ethernet"
    fi
    #
    if [[ "$REMOTESERVER" == "node"* ]]; then
          if [ $ANFITRION == "master" ];then
           MAQUINA501=$REMOTESERVER"m"
           SWITCHNAME="myrinet"
          else
           MAQUINA501=$REMOTESERVER
           SWITCHNAME="No myrinet"
          fi              
    fi
    #
    if [[ "$REMOTESERVER" == "quad"* ]]; then
        
        if [ $ANFITRION == "quad01" ];then
          #MAQUINA501=$REMOTESERVER"ib"
          MAQUINA501=$REMOTESERVER
          SWITCHNAME="not now ....Infini"
        else
          MAQUINA501=$REMOTESERVER
          SWITCHNAME="No Infini"
        fi        
    fi 
    ##---------------------------
    rcp $DIRSCF/$WFSCFLOCAL $MAQUINA501:$ADONDECOPY/$WFSCFREMOTE
    printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
    printf "  [${GREEN}copy${NC}] "
    printf "[${GREEN}$SWITCHNAME${NC}] [$CUANTO]\n"
    sleep .1
  done
  ##--------------------------
  TIMER=`date`
  printf "\t${CYAN}End to copy at time: $TIMER ${NC}\n"

     
##StopMe
##nothing under here
