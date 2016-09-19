#!/bin/bash
## CHILDREN:
## PARENT: 
## runBulk.sh
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 NC='\e[0m' # No Color
 
       if  [ $# -ne 2 ];then
          printf "\tUsage: \n"
          printf "\t `basename $0` \n"
          printf "\t THIS FILE IS SLAVE OF runBulk.sh\n"
          printf "\t need 2 input parameters\n"
          printf "\t maquina destino\n"
          printf "\t directorio destino\n"
          printf "\t check: runBulk.sh \n"
          exit 127
          touch killme
        fi

       
           HOSTNAME=`hostname`
        MAQUINAdest=$1
     DIRECTORIOdest=$2
               
              
               



       BASENAMEdest=`basename $DIRECTORIOdest`
       DELAY=1

    if [[ "$MAQUINAdest" == "quad"* ]]; then
         MAQUINA504=$MAQUINAdest
    fi 
    #
    if [[ "$MAQUINAdest" == "itanium"* ]]; then
         MAQUINA504=$MAQUINAdest       
    fi
    #
    if [[ "$MAQUINAdest" == "node"* ]]; then
         MAQUINA504=$MAQUINAdest      
    fi

    if [[ "$MAQUINAdest" == "master" ]]; then
         MAQUINA504=$MAQUINAdest      
    fi


    ##################################
    printf "${BLUE}=====================================${NC}\n"  
       
    if [ -e energy.d ] ;then ## eigen.d
     printf "$HOSTNAME:$PWD/eigen.d"
     printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/energy.d "
     printf "[${GREEN}copy${NC}] \n"
      rcp   energy.d $MAQUINA504:$DIRECTORIOdest/  
      sleep $DELAY 
    fi
    #else
    # printf "$HOSTNAME:$PWD/eigen.d"
    # printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/energy.d "
    # printf "[${BLUE}no exsist${NC}] \n"
    #fi
   
    #####


    if [ -e pmn.d ] ;then ## pmnhalf.d
     printf "$HOSTNAME:$PWD/pmn.d"
     printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/pmn.d "
     printf "[${GREEN}copy${NC}] \n"
      rcp  pmn.d $MAQUINA504:$DIRECTORIOdest/
      sleep $DELAY 
    fi
    #else
    # printf "$HOSTNAME:$PWD/pmnhalf.d"
    # printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/pmn.d "
    # printf "[${RED}No copy${NC}] \n"
    #fi



    #####


    if [ -e spinmn.d ] ;then ## spinmn.d
     printf "$HOSTNAME:$PWD/spinmn.d"
     printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/spinmn.d "
     printf "[${GREEN}copy${NC}] \n"
      rcp spinmn.d $MAQUINA504:$DIRECTORIOdest/
      sleep $DELAY 
    fi
  
  #   else
  #   printf "$HOSTNAME:$PWD/spinmn.d"
  #   printf "${GREEN} => ${NC}${BLUE}$BASENAMEdest${NC}/spinmn.d "
  #   printf "[${RED}No copy${NC}] \n"
  #  fi

    ##### 
       
