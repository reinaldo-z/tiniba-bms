#!/bin/bash
##FUNCTION:
##check all files need for run abinit in medusa 
##INPUT: 
##inputs:  1=Display, 0=just display files not found, 1=default
##PARENTS:
##runBulk.sh
##CHILDREN:
##none
##LAST MODIFICATION:
##05/Abril/2010 at 15:54 by cabellos
## Cabellos 07 Junio 2010 by Cabellos JL

RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
MAGENTA='\e[0;35m'
    MAG='\e[0;35m'
NC='\e[0m' # No Color
##----------------------------
function StopMe {
      printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
      touch killme
      exit 127
 }


 DIR=$PWD
 USER=$USER
 BASEDIR=`dirname $PWD`
 CASO=`basename $PWD`
 PARENT=`basename $BASEDIR`
 SETUPABINIT=setUpAbinit_"$CASO".in
 SETUPABINITp=.setUpAbinit_"$CASO".in
 COORDINATES="$CASO".xyz
 COORDINATESp=."$CASO".xyz
 CASOCHECK="$CASO"_check
 DIRSCF=$CASO'_scf'
 DISPLAY=1
  
  rm -rf killme #MAKE SURE THAT NOT killme FILE EXIST
  function StopMe {
      printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
      touch killme
      exit 127
  }
  
   if [ -z $1 ]; then
    DISPLAY=1
   else
    DISPLAY=$1 
   fi 
   printf "\n"
   printf "\t${MAG}Running: ${NC}`dirname $0`/`basename $0`\n"
 ##===check IF pesoITAN file exist=====================!!!
   printf "\t  ${BLU}$USER${NC} let me check your files\n"   
   printf "\n"
     if [ ! -e pesoQUAD ];then
     printf "\t ${RED}There is not file 'pesoQUAD' ${NC}\n"
      printf "\t you must run first with the option 'setkp'  \n"
       StopMe
     fi 
 ##===check IF pesoITAN file exist=====================!!!
    if [ ! -e pesoITAN ];then
	printf "\t ${RED}There is not file 'pesoITAN' ${NC}\n"
      printf "\t you must run first with the option 'setkp'  \n"
       StopMe
    fi 
 ##===CHECK IF .machines file exist==================== !!
  if [ ! -e .machines_pmn ];then
        printf "\t ${RED}There is not .machines_pmn, make one${NC}\n"    
        StopMe
  else 
        if [ $DISPLAY == 1 ];then
         printf "\t .machines_pmn .........[${GREEN}ok${NC}]\n" 
        fi
   
  fi    
  
  ##--------------------------------
  if [ ! -e .machines_scf ];then
        printf "\t ${RED}There is not .machines_scf, make one${NC}\n"
        StopMe
  else 
        if [ $DISPLAY == 1 ];then
         printf "\t .machines_scf..........[${GREEN}ok${NC}]\n" 
        fi
  fi
  
  ##--------------------------------
  if [ ! -e .machines_latm ];then
        printf "\t ${RED}There is not .machines_latm, make one${NC}\n"
        StopMe
  else 
       if [ $DISPLAY == 1 ];then
        printf "\t .machines_latm.........[${GREEN}ok${NC}]\n" 
       fi
  fi
  ##--------------------------------
  if [ ! -e .machines_res ];then
        printf "\t ${RED}There is not .machines_res, make one${NC}\n"
        touch -f killme
  else 
       if [ $DISPLAY == 1 ];then
        printf "\t .machines_res..........[${GREEN}ok${NC}]\n"
       fi
  fi
  ##----------CHECK FOR COORDINATES.xyz
  if [ ! -e "$COORDINATES" ];then
        printf "\t ${RED}There is not $COORDINATES , HACER UNO ${NC}\n"
        touch -f killme
  else 
       if [ $DISPLAY == 1 ];then
        printf "\t  $COORDINATES..............[${GREEN}ok${NC}]\n" 
       fi
  fi

  ##----------CHECK FOR setUpAbinit
  if [ ! -e "$SETUPABINIT" ];then
        printf "\t ${RED}There is not $SETUPABINIT, make one ${NC}\n"
        StopMe
  else 
     ECUTsetUp=`grep ecut $SETUPABINIT  |  awk '{print $2}'`
     ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
       if [ $DISPLAY == 1 ];then
        printf "\t============================================\n"
        printf "\t                             $SETUPABINIT..........[${GREEN}ok${NC}]\n" 
        printf "\t Ecut=${GREEN}$ECUTsetUp${NC}               From: $SETUPABINIT\n"
        printf "\t Spin=${GREEN}$ESPINsetUp${NC}                From: $SETUPABINIT\n"
       fi
  fi
   ##----------$CASO.check 
   if [ ! -d "$CASOCHECK" ];then
        printf "\t ${RED}You have to run first:${NC}"
        printf "\t ${GREEN}abinit_check.sh  ${NC}\n"
        printf "\t ${RED}there isnt dir : ${NC}${BLUE}$CASOCHECK ${NC}\n"
        StopMe
  else 
       if [ $DISPLAY == 1 ];then
        printf "\t============================================\n"
        printf "\t                             ${BLUE}$CASOCHECK${NC}.............."
        printf "[${GREEN}ok${NC}]\n" 
       fi
  fi
 ##################
       if [ ! -e "$CASOCHECK/$CASO.out" ]; then
          printf "\t ${RED}there isnt file :"
          printf " ${NC}${BLUE}$CASOCHECK${NC}/$CASO.out\n"
          StopMe
       else 
       ECUTcheckOut=`grep ecut $CASOCHECK/$CASO.out  |  awk '{print $2}'` 
      
          if [ $DISPLAY == 1 ];then
           #printf "\t  ${BLUE}$CASOCHECK${NC}/$CASO.out.............."
           #printf " [${GREEN}ok${NC}]\n" 
           printf "\t Ecut=${GREEN}$ECUTcheckOut${NC}   From: ${BLUE}$CASOCHECK${NC}/$CASO.out\n"   
           
          fi

       fi 


  
  ######################### log 
  if [  -e "$CASOCHECK/log" ]; then
  ECUTcheckLog=`grep ecut $CASOCHECK/log  |  awk '{print $4}'`
  printf "\t Ecut=${GREEN}$ECUTcheckLog${NC}     From: ${BLUE}$CASOCHECK${NC}/log \n"   
  fi 
  ######## .in 
  if [  -e "$CASOCHECK/$CASO.in" ]; then
  ECUTcheckCasoIn=`grep ecut $CASOCHECK/$CASO.in  |  awk '{print $2}'` 
  printf "\t Ecut=${GREEN}$ECUTcheckCasoIn${NC}               From: ${BLUE}$CASOCHECK${NC}/$CASO.in \n"   
  ## printf "\t============================================\n"
  printf "\t${MAGENTA}-------------------------${NC}\n" 
  fi 
############################################################
#####################################################spin
####################################################
 if [ -e "$CASOCHECK/$CASO.out" ]; then
 ESPINcheckOut=`grep nspinor $CASOCHECK/$CASO.out | awk -F= '{print $4}' | awk '{print $1}'`
 printf "\t Spin=${GREEN}$ESPINcheckOut${NC}                From: ${BLUE}$CASOCHECK${NC}/$CASO.out\n"   
fi
#########
 ######################### log 
  if [  -e "$CASOCHECK/log" ]; then
  ESPINcheckLog=`grep nspinor $CASOCHECK/log | awk -F= '{print $4}' | awk '{print $1}'`
 printf "\t Spin=${GREEN}$ESPINcheckLog${NC}                From: ${BLUE}$CASOCHECK${NC}/log \n"   
  fi 
 
  ######## .in 
  if [  -e "$CASOCHECK/$CASO.in" ]; then
  ESPINcheckCasoIn=`grep nspinor $CASOCHECK/$CASO.in | awk '{print $2}'`
  printf "\t Spin=${GREEN}$ESPINcheckCasoIn${NC}                From: ${BLUE}$CASOCHECK${NC}/$CASO.in \n"   
   printf "\t============================================\n"
  fi 



  ###
  ############################
  ############################dirscf 
  ############################
  ############################
  if [ -d "$DIRSCF" ];then
           printf "\t                             ${BLUE}$DIRSCF${NC}"
           printf "................[${GREEN}ok${NC},exist] \n"
  fi 
  ################
  #################

  if [ -e "$DIRSCF/log" ];then     
   ECUTscfLog=`grep best $DIRSCF/log | awk '{print $4}'` 
   printf "\t Ecut=${GREEN}$ECUTscfLog${NC}     From: ${BLUE}$DIRSCF${NC}/log\n"
   printf "\t ${MAGENTA}Do this${NC}: ${GREEN}grep ecut $DIRSCF/log${NC} \n" 
     if [ -e "$DIRSCF/$CASO.out" ];then     
   printf "\t ${MAGENTA}Do this${NC}: ${GREEN}grep ecut $DIRSCF/$CASO.out${NC}\n" 
     fi
  fi
  #####
  if [  -e "$DIRSCF/$CASO.in" ]; then
  ECUTscfCasoIn=`grep ecut $CASOCHECK/$CASO.in  |  awk '{print $2}'` 
  printf "\t Ecut=${GREEN}$ECUTscfCasoIn${NC}               From: ${BLUE}$CASOCHECK${NC}/$CASO.in \n"   
   #printf "\t============================================\n"
   printf "\t${MAGENTA}-------------------------${NC}\n" 
  fi
#####################################SPIN 
#####################################SPIN 
#####################################SPIN 
#####################################SPIN 
#####################################SPIN 


  if [ -e "$DIRSCF/log" ];then     
   ESPINscfLog=`grep nspinor $DIRSCF/log | awk -F= '{print $4}' | awk '{print $1}'`
   printf "\t Spin=${GREEN}$ESPINscfLog${NC}                From: ${BLUE}$DIRSCF${NC}/log\n"
  fi
  ####
  if [  -e "$DIRSCF/$CASO.in" ]; then
  ESPINscfCasoIn=`grep nspinor $CASOCHECK/$CASO.in | awk '{print $2}'`
 printf "\t Spin=${GREEN}$ESPINscfCasoIn${NC}                From: ${BLUE}$CASOCHECK${NC}/$CASO.in \n"   
   printf "\t============================================\n"
  fi

####################################3
#####################################333
#echo $ECUTcheckCasoIn
#echo $ECUTsetUp

if [  "$ECUTsetUp" != "$ECUTcheckCasoIn" ];then
printf "\t${MAGENTA}-------------------------${NC}\n" 
#printf "\t${MAGENTA}=========================${NC}\n" 
#
 printf "\tYou change: ecut=${RED}$ECUTsetUp ${NC}  : $SETUPABINIT\n"
 printf "\tYou change: ecut=${RED}$ECUTcheckCasoIn ${NC}  : ${BLUE}$CASOCHECK${NC}/$CASO.in \n"
  printf "\tHere realy doesnt matter the change because:${BLUE}$CASOCHECK${NC}/$CASO.in   \n"
  printf "\tis just for to get the symmetries...go go\n"
printf "\t${MAGENTA}-------------------------${NC}\n" 
fi 

if [ ! -z $ECUTscfCasoIn ];then

if [ "$ECUTsetUp" -ne "$ECUTscfCasoIn" ];then
printf "\t${MAGENTA}-------------------------${NC}\n" 
#printf "\t${MAGENTA}=========================${NC}\n" 
 
printf "\tYou change: ecut=${RED}$ECUTsetUp ${NC}  : $SETUPABINIT\n"
 printf "\tYou change: ecut=${RED}$ECUTscfCasoIn ${NC}  : ${BLUE}$DIRSCF${NC}/$CASO.in \n"
  printf "\t${MAGENTA}Forcing to run SCF${NC}: \n"
  printf "\tErasing : ${BLUE}$DIRSCF${NC}/runSCF\n"
 #rm -f $DIRSCF/runSCF
printf "\t${MAGENTA}-------------------------${NC}\n"
else 
 printf "\tEcut=$ECUTsetUp :$SETUPABINIT [${GREEN}ok${NC}]\n"
 printf "\tEcut=$ECUTscfCasoIn :${BLUE}$DIRSCF${NC}/$CASO.in     [${GREEN}ok${NC}]\n" 
 
fi 

fi ##z
#######################################3
#######################################3
#######################################3SPIN
#######################################3
#######################################3

if [ ! -z $ESPINscfCasoIn ];then

if [ "$ESPINsetUp" -ne "$ESPINscfCasoIn" ];then
printf "\t${MAGENTA}-------------------------${NC}\n" 
#printf "\t${MAGENTA}=========================${NC}\n" 
 
 printf "\tYou change: Spin=$ESPINsetUp   : $SETUPABINIT\n"
 printf "\tYou change: Spin=$ESPINscfCasoIn   : ${BLUE}$DIRSCF${NC}/$CASO.in \n"
  printf "\t${MAGENTA}Forcing to run SCF${NC}: \n"
  printf "\tErasing : ${BLUE}$DIRSCF${NC}/runSCF\n"
  rm -f $DIRSCF/runSCF
printf "\t${MAGENTA}-------------------------${NC}\n" 
 else 
 printf "\tSpin=$ESPINsetUp :$SETUPABINIT [${GREEN}ok${NC}]\n"
 printf "\tSpin=$ESPINscfCasoIn :${BLUE}$DIRSCF${NC}/$CASO.in     [${GREEN}ok${NC}]\n"
fi 

fi ## z
  if [  -e "$SETUPABINITp" ];then  
        cmp $SETUPABINIT $SETUPABINITp &> /dev/null
         if [ $? -eq  0 ];then 
         printf "\t${CYAN}Running the same case${NC}........."
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
          printf "\n"
          printf "\t${GREEN}FORCE  to run SCF ${NC}...."
          printf " [${GREEN}ok${NC}]\n" 
          printf "\tErasing : ${BLUE}$DIRSCF${NC}/runSCF\n"
          
          printf "\t 20 seconds to ${RED}STOP${NC} for kill me \n"
          printf "\t if not Im going to continue... \n"
          sleep 20
          rm -f $DIRSCF/runSCF
         fi
       fi
       ######################################
        if [  -e "$COORDINATESp" ];then
         cmp $COORDINATES  $COORDINATESp &> /dev/null
          if [ $? -eq  0 ];then 
            printf "\tthe same coordinates ....."
            printf " [${GREEN}ok${NC}]\n" 
         else
         diff --suppress-common-lines -w -y $COORDINATES  $COORDINATESp
          printf "\t ${RED}Hold on ...${RED}"
          printf "${CYAN}You changed something in your:${NC}"
          printf " $COORDINATES \n"
          #StopMe    
          fi
        fi 
 
