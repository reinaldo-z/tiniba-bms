#!/bin/bash
##
##
   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color
##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
           DIR=$PWD
         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`
    ##------------------
            
    SMEARxeon="$WHERE/smear.xeon"
    SMEARitan="$WHERE/smear.itan"
    SMEARquad="$WHERE/smear.quad"
           
 declare -a MACHINESRES
 declare -a MACHINESLATM
 declare -a TENSORXYZ
 declare -a T3XYZ
 declare -a T2XYZ
 declare -a BASICOPTIONS
 declare -a MAQ

##########################################
##########################################
function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stopping right now... ${NC} `basename $0`\n"
   exit 127
 else
   printf "\t${RED}Stopping right now... ${NC} `basename $0`\n"
   printf "\t$1\n\n"
   exit 127
 fi
    }
##########################################
##########################################
function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127
      else 
      printf "\t $1 [${GREEN}ok${NC}]\n"
      fi
      }
##########################################
##########################################
############## Begin Code ################
##########################################
########################################## 

    if [ "$#" -eq "0" ];then
    printf "\t${BLUE}==================${NC}\n"
    printf " \n"
    printf "\t Usage:\n\t$WHERE/${GREEN}`basename $0`${NC} [smearFactor(0.15)]\n"  
    exit 127
    else 
    FWHM=$1
    fi 
    ##echo $FWHM 
    if [ ! -d res ];then 
      mkdir res 
    fi 
#    NOT3XYZ=`echo ${#T3XYZ[@]}` 
#    NOT2XYZ=`echo ${#T2XYZ[@]}` 
 
    printf "\tTaken from: \n"
    printf "\t$WHERE  \n"

    isThereFile $SMEARxeon
    isThereFile $SMEARitan
    isThereFile $SMEARquad
      

       if [[ "$HOST" == "master" ]]; then
          RUNsmear=$SMEARxeon
         
       fi
       if [[ "$HOST" == "itanium01"* ]]; then
         RUNsmear=$SMEARitan
       fi

       if [[ "$HOST" == "quad01"* ]]; then
          RUNsmear=$SMEARquad
        fi
       # printf "\n"
        printf "\t${GREEN}$RUNsmear\n"


 #FILES="*kk*"
 FILES="*NOKK*"
      ii=0
      for file in $FILES; do
       let "ii=ii+1"
        if [ ! -e "$file" ];then       # Check if file exists
         printf  "\t there are no files with *kk* \n"
         printf  "\t Stoping Right now .......\n"
         exit 1
        fi
       GFILES[$ii]=$file
      done
      NOGFILES=`echo ${#GFILES[@]}`
      printf "\t${BLUE}==========================${NC}\n"

     # printf "\t${BLUE}==========================${NC}\n"
      for ((jj=1;jj<=($NOGFILES); jj++));do
          stringZ=${GFILES[$jj]}
          OUTPUT=`echo ${stringZ/NOKK/smNOKK}`
           #printf "\t[${GREEN}$jj${NC}] $stringZ   $OUTPUT\n"
           QUESAL=`basename $RUNsmear`
           QUESAF=`dirname $RUNsmear`
          printf " ${MAG}running:${NC}\n"
          printf " $QUESAF/${GREEN}$QUESAL${NC} 1 $stringZ $OUTPUT $FWHM \n"
         $RUNsmear 1 $stringZ $OUTPUT $FWHM > SMEAR_info_$jj

        if [ -e fromSmear ];then
         VALORSMEAR=`head -1 fromSmear`
         nueva1s=`echo ${VALORSMEAR}`
         FASME=`echo ${nueva1s/./-}` 
         printf "\t${MAG}====================${NC}\n"
         printf "\ttaking value from: fromSmear File\n" 
         printf "\tvalor de FHWM(smear):  $VALORSMEAR eV\n" 
         printf "\t${MAG}====================${NC}\n"
        else 
         nueva1s=`echo ${FHWM}`
         FASME=`echo ${nueva1s/./-}` 
        fi 
          SALIDAA=`echo ${OUTPUT/smNOKK/smNOKK_"$FASME"}`
        printf "\t${GREEN}OutPut${NC}:\n"         
        printf "\t[${GREEN}$jj${NC}] $stringZ  ${GREEN}$SALIDAA${NC}\n"
        mv $OUTPUT $SALIDAA

     done

###########
###########
###########

