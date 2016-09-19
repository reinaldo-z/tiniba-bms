#!/bin/bash
## PARENTS:
## run.sh 
## CHILDREN: arrangeMachines.pl
## LAST MODIFICATION : Febrero 22 2010 by cabellos jl


 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 MAG='\e[0;35m'
 NC='\e[0m' # No Color

 declare -a MACHINESpmn
 

            WHERE=`dirname $0`
       NAMESCRIPT=`basename $0`  
             CASO=`basename $PWD`
            ERROR="killme"

##<><><><><><><><><><><><><><> 
##<><><><> FUNCTIONS<><><><><> 
##<><><><><><><><><><><><><><>

 function StopMe {
   if [ -z "$1" ];then 
      printf "\n"
      printf "\t${RED}Stoping right now... ${NC} $NAMESCRIPT\n"
      printf "\n"
      exit 127   
 
   else 
      printf "\n"
      printf "\t${RED}Stoping right now... ${NC} $NAMESCRIPT\n" 
      printf "\t$1\n"
      printf "\n"
      exit 127    
   fi 
       }

##<><><><><><><><>
##<><><><><><><><>
##<><><><><><><><>

function IsThereFile {
   if [ ! -e $1 ];then 
      rm -f $ERROR
      printf "\n"
      printf "\t${RED}Stoping right now... ${NC} $NAMESCRIPT\n"
      printf "\t${RED}there isnt FILE:${NC}\n\t$1\n" 
      printf "\n"
      touch $ERROR
      echo `date` > $ERROR  
      echo "Stoping right now... `basename $0`" >> $ERROR
      echo "there isnt FILE: $1" >> $ERROR
      exit 127  
   fi 
}


##====== DEFINITIONS ========== 
      declare -a MACHINESpmn
       IsThereFile "$WHERE/arrangeMachines.pl"
       IsThereFile ".machines_pmn"
       rm -f killme 
       
      
 

##======SOURCE ==============

     if [ $# -eq 4 ]; then
        SETKPT=`echo $1 | tr A-Z a-z` #to lowercase.
        NKPT=$2
        WEIGHT=$3
        WEIGHTQUAD=$4
        if [ "$SETKPT" != "setkp" ];then
          printf "\tHold on !\n"
           printf "\t${BLUE}$SETKPT${NC} has to be "
           printf "${CYAN}setkpt${NC}\n"
            printf "\t${RED}stoping right now ...${NC}\n"
             touch -f killme
             exit 1
        fi
         
        printf "\t${MAG}Running : ${NC}$WHERE/${GREEN}$NAMESCRIPT${NC} "
        printf "$SETKPT $NKPT $WEIGHT $WEIGHTQUAD \n"
      
        if [ ! -e .machines_pmn ];then
         printf "\t ${RED}There is not .machines_pmn, make one${NC}\n"
         touch -f killme
          StopMe
        else
         MACHINESpmn=(`cat .machines_pmn`)
         NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
         printf "\t .machines_pmn .........[${GREEN}ok${NC}]\n"
        fi
        ##
        FILEKLIST=$CASO.klist_"$NKPT"  
        #IsThereFile "$FILEKLIST"
          if [  -e $FILEKLIST ];then
            DESITION=1
            READAGAINWEIGHT=0
            
            printf "\t  $FILEKLIST....[${GREEN}ok${NC}]\n"
            printf "\tThe optimization for new weigths is= "
               printf "ITANIUM=${BLUE}$WEIGHT${NC} and "
               printf "QUAD=${BLUE}$WEIGHTQUAD${NC}\n"
     
  # while [ "$DESITION" -eq "1" ];do
     while [ "$DESITION" == "1" ];do
            let "READAGAINWEIGHT+=1"
            echo $WEIGHT > pesoITAN
            echo $WEIGHTQUAD > pesoQUAD
         if [ $READAGAINWEIGHT -gt 1 ];then
               printf "\tthe new weight ITANIUM is :  "
               read WEIGHT
               printf "\tthe new weight QUAD is :  "
               read WEIGHTQUAD
               printf "\tThe optimization for new weigths is= \n"
               printf "\tITANIUM=${BLUE}$WEIGHT${NC} \n"
               printf "\tQUAD   =${BLUE}$WEIGHTQUAD${NC}\n"
               
         fi  
  $WHERE/arrangeMachines.pl "$FILEKLIST" "$NOMACHINESpmn" "$WEIGHT" "$WEIGHTQUAD"
         printf "\t${GREEN}1${NC}=Choose another weight\n\t${GREEN}2${NC}=Exit to run \n "
         read DESITION
         if [ -z DESITION ];then
           DESITION=1000
         fi

         
  done 
         else
           printf "\t your file "
                   printf "${CYAN}$FILEKLIST${NC} "
                    printf "doesnt exist ...\n"
                     find  -name '*.klist*'
              touch -f killme
                StopMe
         fi 
    else
     printf "\tUsage:\n\t "$(basename "$0")" "
     printf " [${GREEN}setkp${NC}],"
     printf " [gaas.klist_${GREEN}?${NC}],"
     printf " [${GREEN}(xeon/itanium)${NC}] "
     printf " [${GREEN}(xeon/quad)${NC}] \n"
     #find  -name '*.klist*'
     FILES="*.klist*"
      ii=0
      for file in $FILES; do
       let "ii=ii+1"
        #if [ ! -e "$file" ];then       # Check if file exists
        # printf  "\t there are no files with *.g \n"
        # printf  "\t Stoping Right now .......\n"
        # exit 1
        #fi
       printf "\t - $file \n"
      done
      printf "\n"
      printf "\t ${MAG}=====================================${NC}\n"
      printf "\n"
      FILES="*.klist*"
      ii=0
      for file in $FILES; do
       let "ii=ii+1"
        #if [ ! -e "$file" ];then       # Check if file exists
        # printf  "\t there are no files with *.g \n"
        # printf  "\t Stoping Right now .......\n"
        # exit 1
        #fi
    NKK=`echo $file | tr '_' ' ' | awk '{print $2}'`   

  printf "\t`dirname $0`/${GREEN}`basename $0`${NC} setkp $NKK 2 4\n"
      done
printf "\n"
    ## LAST MODIFICATION OCTUBER 4 2007 AT 23:25 cabellos 
    ## LAST MODIFICATION Febrero 22 2010 AT 17:51 cabellos 

    fi ## main       
             
   
