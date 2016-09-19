#!/bin/bash
##FUNCTION: DON GET CONFUSED WITH ARE YOU PASTE  
##CHILDREN:
##LAST UPDATE: Octuber 2007 11 at 11:25 by JL
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
MAG='\e[0;35m'
NC='\e[0m' # No Color
### <><><><><><><><><><><><><><><><><><>
### <><><><><><><><><><><><><><><><><><>
### <><><><><><><><><><><><><><><><><><>
NAME1=shg1_la
NAME2=shg2_la
NAME3=shg1_ta
NAME4=shg2_ta
SALIDA=shg1l_shg2l_shg1t_shg2t
#SALIDA=perro
### <><><><><><><><><><><><><><><><><><>
### <><><><><><><><><><><><><><><><><><>
### <><><><><><><><><><><><><><><><><><>


function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   exit 127
 else
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   printf "\t$1\n\n"
   exit 127
 fi
}

function howto {
    printf "\tUsage:\n"
    printf "\t example:\n"
    printf "\t`dirname $0`/${GREEN}`basename $0`${NC}\n"
    StopMe 
 }
####################
####################
####################
   if [ "$#" -gt 0 ];then
    howto        
   fi
###### 
######
     ii=0
     FILES="$NAME1*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
               let "ii=ii+1"
                #echo $file 
               SHG1L[$ii]=$file
             fi
           fi
         fi
       fi  
       
      done
    #######
     ii=0
     FILES="$NAME2*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
                #echo $file
                let "ii=ii+1" 
                SHG2L[$ii]=$file           
            fi
           fi
         fi
       fi  
      done
    #######
        ii=0
     FILES="$NAME3*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
               #echo $file
               let "ii=ii+1" 
               SHG1T[$ii]=$file
            fi
           fi
         fi
       fi  
      done
   #######
    ii=0
     FILES="$NAME4*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
                 # echo $file
                  let "ii=ii+1" 
                   SHG2T[$ii]=$file
            fi
           fi
         fi
       fi  
      done
##################333
##################
##################
NOSHG1L=`echo ${#SHG1L[@]}`
NOSHG2L=`echo ${#SHG2L[@]}`
NOSHG1T=`echo ${#SHG1T[@]}`
NOSHG2T=`echo ${#SHG2T[@]}`


 if [ $NOSHG1L -eq 0 ];then 
    printf "\tThere is not files with: $NAME1 \n"
    exit 127
 fi 
 if [ $NOSHG2L -eq 0 ];then 
    printf "\tThere is not files with: $NAME2 \n"
    exit 127
 fi 
 if [ $NOSHG1T -eq 0 ];then 
    printf "\tThere is not files with: $NAME3 \n"
    exit 127
 fi 
 if [ $NOSHG2T -eq 0 ];then 
    printf "\tThere is not files with: $NAME1 \n"
    exit 127
 fi 

################
################
################
for ((hh=1;hh<=($NOSHG1L); hh++));do
     ARCHIVO1=${SHG1L[$hh]}
     APELLIDO1=`echo ${ARCHIVO1##*"$NAME1"}`
       for ((jj=1;jj<=($NOSHG2L); jj++));do
        ARCHIVO2=${SHG2L[$jj]}
        APELLIDO2=`echo ${ARCHIVO2##*"$NAME2"}`
           for ((ii=1;ii<=($NOSHG1T); ii++));do              
               ARCHIVO3=${SHG1T[$ii]}
               APELLIDO3=`echo ${ARCHIVO3##*"$NAME3"}`
                for ((zz=1;zz<=($NOSHG2T); zz++));do
                  ARCHIVO4=${SHG2T[$zz]}
                  APELLIDO4=`echo ${ARCHIVO4##*"$NAME4"}`
                  if [ $APELLIDO1 == $APELLIDO2 ];then
                  if [ $APELLIDO2 == $APELLIDO3 ];then
                  if [ $APELLIDO3 == $APELLIDO4 ];then
                    printf "\t${GREEN} ==========================${NC}\n" 
                    printf "$ARCHIVO1\n"
                    printf "$ARCHIVO2\n"
                    printf "$ARCHIVO3\n"
                    printf "$ARCHIVO4\n"
		    printf "\t${GREEN} ==========================${NC}\n"
                    printf "\t press any key to continue ...\n"
                    read -p "" 
                   
                   
                   
                  fi 
                  fi 
                  fi 

                 done 
           done 
           
      done 

done 
printf "\tI have found the end ... ${GREEN}ok${NC}\n" 
