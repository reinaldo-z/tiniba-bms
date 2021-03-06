#!/bin/bash
##2 Julio at 23:54 hrs.
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
NC='\e[0m' # No Color

##=========FUNCTIONS===============
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127
       }
 function CheckHost {
 ping -c 1 $1 >& /dev/null;
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
      WHERE="$HOME/abinit_shells/clustering/itaxeo"

    rm -f killme 
    if [ ! -e "$WHERE/ineedsplitWFSCF.sh" ];then
      printf "\tWhere is your FILE: ineedsplitWFSCF.sh \n"
      printf "\tthe path actual is: "
      printf "$WHERE\n"
      touch -f killme
      StopMe
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
        sleep .1
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
   #  TMP=`md5sum "$PWD/$DIRSCF/$WFSCFLOCAL"`
   #  echo $TMP>tmp
   #  MD5LOCAL=`awk '{print $1}' tmp`
   #  rm -f tmp  
##===============================================
 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    let "HHSU=$hh+1"
    REMOTESERVER=${MACHINESpmn[$hh]}
    ADONDECOPY=${WHEREWORKREMOTE[$hh]}
    ##---------------------------  
    if [[ "$REMOTESERVER" == "itanium"* ]]; then
         MAQUINA501=$REMOTESERVER
         SWITCHNAME="Using ethernet"
    fi
    #
    if [[ "$REMOTESERVER" == "node"* ]]; then
          if [ $ANFITRION == "master" ];then
           MAQUINA501=$REMOTESERVER"m"
           SWITCHNAME="Using myrinet"
          else
           MAQUINA501=$REMOTESERVER
           SWITCHNAME="No using myrinet"
          fi              
    fi
    #
    if [[ "$REMOTESERVER" == "quad"* ]]; then
        
        if [ $ANFITRION == "quad01" ];then
          #MAQUINA501=$REMOTESERVER"ib"
           MAQUINA501=$REMOTESERVER
          SWITCHNAME="NOT NOW infiniband"
        else
          MAQUINA501=$REMOTESERVER
          SWITCHNAME="No using infiniband"
        fi        
    fi 
    ##---------------------------
    #printf "$DIRSCF/$WFSCFLOCAL --> $MAQUINA501:$ADONDECOPY\n"
    TIMESTARTALL=`date`
    rcp $DIRSCF/$WFSCFLOCAL  $MAQUINA501:$ADONDECOPY/$WFSCFREMOTE
     TIMEENDALL=`date`
  #printf "\t--------------------------------------------------\n"
  #printf "\tFinished all at time: ${GREEN}$TIMEENDALL ${NC}\n"
  #printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      #printf "\t take:   $TMIN min. \n"
      #printf "\t take:   $TMIN1 Hrs. \n"
      #printf "\t--------------------------------------------------\n"
       printf "$DIRSCF/$WFSCFLOCAL --> $MAQUINA501:$ADONDECOPY  [$TMIN] [$TMIN1]\n"

#printf "\t I have find the end ..\n"


 done 
 #SALIDAeq=1
 # SALIDAneq=1
 #until [ "$SALIDAneq" -eq "$INTENTOS" ] || [ $SALIDAeq -eq 2 ];do
 # EXISTE=`rsh $REMOTESERVER 'test -e '$ADONDECOPY/$WFSCFREMOTE'; echo $?'`
 #   sleep .1
 #   if [ $EXISTE -eq 0 ] ;then ##existe
 #     rm -f tmp1
 #     TMP1=`rsh $REMOTESERVER 'md5sum '$ADONDECOPY/$WFSCFREMOTE''`
 #     echo $TMP1>>tmp1
 #     MD5REMOTE=`awk '{print $1}' tmp1`
 #     rm -f tmp1  
 #   fi 
 # if [ $EXISTE -ne 0 ] ;then ##no existe      
 #            if [ "$INEEDSPLIT" -eq 0 ];then
 #                $WHERE/ineedsplitWFSCF.sh
 #                let "INEEDSPLIT+=1"
 #                printf "\tSplitting the $DIRSCF/$WFSCFLOCAL..."
 #                printf "\ttake a while..!!\n"
 #            fi 
 #  rcp $DIRSCF/$WFSCFLOCAL.block* $MAQUINA501:$ADONDECOPY/
 #  rsh $MAQUINA501 "cd $ADONDECOPY; cat $WFSCFLOCAL.block* > $WFSCFREMOTE; rm -f $WFSCFLOCAL.block*"
 #      printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
 #      printf "  [${GREEN}copying${NC}] Attempt $SALIDAneq\n"
 #      printf "\t ${GREEN}$SWITCHNAME${NC}\n"
 #     #-------------
 #     rm -f tmp1
 #     TMP1=`rsh $REMOTESERVER 'md5sum '$ADONDECOPY/$WFSCFREMOTE''`
 #     echo $TMP1>>tmp1
 #     MD5REMOTE=`awk '{print $1}' tmp1`
 #     rm -f tmp1  
 #     #-------------
 # fi  ##no existe 
##################
 #     if [ "$MD5REMOTE" == "$MD5LOCAL" ];then
 #     SALIDAeq=2
 #     printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
 #     printf " [${GREEN}identical${NC}]\n"
 #     
 #     else
 #     ## I need to copy again but first erase
 #     printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
 #     printf " [${RED}NO Identical${NC}] $SALIDAneq \n" 
 #      let "INTE=INTENTOS-1"
 #      if [ $SALIDAneq -eq $INTE ];then
 #             printf "\t-----${RED}HOLD ON !!!!!${NC}-------\n"
 #             printf "after $SALIDAneq ATTEMPT "
 #             printf "Im not able to get the same copy, "
 #             printf "try to hand from:\n"
 #             printf "$PWD/$DIRSCF/$WFSCFLOCAL \n"
 #             printf "$MAQUINA502: $ADONDECOPY\n"
 #             printf "\t ${RED}Stoping right now ... ${NC}\n"
 #             read -p "any key to continue or Ctrl C to Kill me"
 #             # touch -f killme
 #             # exit 1
 #             fi
 #     let "SALIDAneq+=1"
 #     rsh $MAQUINA501 "cd $ADONDECOPY;rm -f $WFSCFREMOTE;rm -f $WFSCFLOCAL.block00;rm -f $WFSCFLOCAL.block01;rm -f $WFSCFLOCAL.block02;rm -f $WFSCFLOCAL.block03"  
 #     fi 
#done ##until  
#    sleep .2
#  done
  ##--------------------------
  TIMER=`date`
  printf "\t${CYAN}End to copy at time: $TIMER ${NC}\n"
 # rm -rf $PWD/$DIRSCF/$WFSCFLOCAL.block* #erase all children Local   
     
##StopMe
##nothing under here
