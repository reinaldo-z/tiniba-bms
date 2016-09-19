#!/bin/bash
#FUNCTION:
#PRINT WHAT OPIION IS AND CHECK IF IS OTHER THEN STOP
#INPUT 1 COULD BE =0,1,2,3,4
#INPUT 2 COULD BE =0,1,2,3, not other
#22/JANUARY/2007 at 17:55 by jl

#BEGIN MENU
RED='\e[0;31m'
REDD='\e[1;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color
if  [ -z $2 ] && [ $1 -eq "1" ] ;then 
     printf "        ${BLUE}1${NC} Layered calculation\n"
 exit 127
fi 
      

if  [ ! -z $1 ] && ([ $1 -eq "0" ] || [ $1 -eq "1" ] || [ $1 -eq "2" ] || [ $1 -eq "3" ] || [ $1 -eq "4" ]) ;then 

  if [ $1 -eq "0" ] && [ $2 -eq "1" ];then
   printf "        ${BLUE}0 1${NC} ONLY calculates energies for band structure (so is faster)\n"
  fi  
  if [ $1 -eq "0" ] && [ $2 -eq "2" ];then
 printf "        ${BLUE}0 2${NC} NORMAL optics calculation, calculates both energies and pmn \n"
  fi
   if [ $1 -eq "0" ] && [ $2 -eq "3" ];then
    printf "        ${BLUE}0 3${NC} ONLY calculates rho(z) ${REDD}***choose set of k-points in${NC}${BLUE} $CASO.klist_rho***${NC}"
     printf "                ${REED}generate one with:${NC}$HOME/abinit_shells/utils/${BLUE}zmesh.sh${NC}\n"
     exit 1
   fi 

   if [ $1 -eq "3" ] && [ $2 -eq "0" ];then
    printf "        ${BLUE}3 0${NC} SPIN MATRIX elements only!\n"
     exit 1
   fi

   if [ $1 -eq "3" ] && [ $2 -eq "1" ];then
    printf "        ${BLUE}3 1${NC} BULK: optics and spin density/current calculation\n"
     exit 1
   fi

 ##SECOND EMPTY 
  if [ -z $2 ] || [ $2 -eq "0" ] || [ $2 -eq "1" ] || [ $2 -eq "2" ] || [ $2 -eq "3" ];then
   if [ $1 -eq "1" ];then
    printf "        ${BLUE}1${NC}   LAYERED OPTICS calculation (${REDD}N_Layer>0 or half-slab${NC})\n            (${CYAN}rho(z) not recomended=>${red}rho=2${NC})\n"
     exit 1
   fi
   if [ $1 -eq "2" ];then
    printf "        ${BLUE}2${NC}   MICROSCOPIC density and current calculation ${REDD}NOT IMPLEMENTED YET${NC}\n"
     exit 1
   fi
   if [ $1 -eq "4" ];then
    printf "        ${BLUE}4 ${NC}  Smm ONLY for n-dot and LAYERED calculation: included in ${BLUE}1${NC}\n"
    exit 1
   fi
  else
   printf "\t $2 has to be: 0, 1, 2 or 3, not any other number...\n"  
   touch -f killme
 exit 1
  
  fi

 else 
  printf "\t $1 has to be: 0, 1, 2, 3 or 4 not any other number... \n"  
  touch -f killme
 exit 1
fi

