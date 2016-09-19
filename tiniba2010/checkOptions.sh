#!/bin/bash
##FUNCTION: just acept 3 parmeteres the combination are :
##          0 1 1
##          0 2 1
##          3 0 1
##          3 1 1
##          El tercer parametro es display or not display 
##          any other combinacion display a WARNING 
##          and produce a killme file
##OUTPUT  : FILE: killme if is no the combination
##          Nothing if is correct combination  
##CHILDREN: None
##PARENTS :
##LAST MODIFICATION: FRIDAY MAY 4 2007 at 21:14 By jl
##LAST MODIFICATION: STURDAY SEPTEMBER 29 2007 at 19:17 By jl
                      
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color      
#-------



rm -f killme
OPT1=$1
OPT2=$2
     
   if [ -z $3 ]; then
    DISPLAY=1
   else
    DISPLAY=$3
   fi
#-------
if [ "$OPT1" == "1" ] && [ -z "$OPT2" ];then 
   if [ $DISPLAY == "1" ];then 
     printf "\t${GREEN}Option${NC} 1\n"
   fi
   exit 1
fi 


if [ "$OPT1" == "0" ] && [ "$OPT2" == "1" ];then 
  if [ $DISPLAY == "1" ];then 
  printf "\t${GREEN}Option${NC} 0 1\n"
  fi
   exit 1
    else
      if [ "$OPT1" == "0" ] && [ "$OPT2" == "2" ];then
       if [ $DISPLAY == "1" ];then
       printf "\t${GREEN}Option${NC} 0 2\n"
       fi
        exit 1
         else
          if [ "$OPT1" == "3" ] && [ "$OPT2" == "0" ];then
           if [ $DISPLAY == "1" ];then
           printf "\t${GREEN}Option${NC} 3 0\n"
           fi
            exit 1
            else
             if [ "$OPT1" == "3" ] && [ "$OPT2" == "1" ];then
              if [ $DISPLAY == "1" ];then
              printf "\t${GREEN}Option${NC} 3 1\n"
              fi
               exit 1
             else
              printf "\t${RED}WARNINIG${NC}: this not a valid option: "
               printf "$OPT1 $OPT2\n" 
                touch killme
                 exit 1        
             fi 
          fi 
      fi 
fi 
##nothing under here 
