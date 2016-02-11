#!/bin/bash 
## FUNCTION:
## Compila 
RED='\e[0;31m'
BLUE='\e[0;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color 
###
dir=$PWD
exec=rpmns
#####
function mueve {
 if [ -e $exec ]; then
	 mv $exec ../.
     else
	 printf "\t${RED}Nothing got compiled: check for errors ${NC} \n"
	 exit 1
     fi
}
###
 if [ "$#" -eq 0 ]
   then 
  printf "\n"
  printf "\tUsage: compilerRPMNS.sh medusa\n\n"
  printf "\tcompiles for ${CYAN}fat, hexa and quad${NC}\n" 
  printf " \n"
  exit 1 
 fi 

  if [ ! -e Makefile ];then 
  printf "\tThere is not FILE: Makefile ....\n"
  printf "\t${RED}Stoping right now ...${NC}\n" 
  exit 1
  fi 

  if [ $1 == 'medusa' ];then 
      printf "\t${GREEN}compiling for fat, hexa and quad ${NC}  \n"
      make clean >> /dev/null
      make 
      make clean >> /dev/null
      mueve $1
      printf " \n"
  fi

#      ssh  hexa2 "cd $dir; make"
