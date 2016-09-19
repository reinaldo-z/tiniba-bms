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
SALIDA=shg1l_shg2l
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
##################333
##################
##################
NOSHG1L=`echo ${#SHG1L[@]}`
NOSHG2L=`echo ${#SHG2L[@]}`

 if [ $NOSHG1L -eq 0 ];then 
    printf "\tThere is not files with: $NAME1 \n"
    exit 127
 fi 
 if [ $NOSHG2L -eq 0 ];then 
    printf "\tThere is not files with: $NAME2 \n"
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
            if [ $APELLIDO1 == $APELLIDO2 ];then
                    NCOL1=`awk 'END{print NF}' $ARCHIVO1`
                    printf "$ARCHIVO1 [$NCOL1]\n"
                    NCOL2=`awk 'END{print NF}' $ARCHIVO2`
                    printf "$ARCHIVO2 [$NCOL2]\n"
                    ### 
                    rm -f tmp1 tmp2 tmp3 tmp4
                   if [ "$NCOL1" -ge "3" ];then 
                    awk '{print $1,$2,$3}' "$ARCHIVO1" >tmp1
                   else 
                    printf "\tArchivo: $ARCHIVO1\n\ttiene que tener al menos 3 columnas\n"
                    StopMe 
                   fi 
                   if [ "$NCOL2" -ge "3" ];then 
                   awk '{print $2,$3}' "$ARCHIVO2" > tmp2
                   else 
                   printf "\tArchivo: $ARCHIVO2\n\ttiene que tener al menos 3 columnas\n"
                    StopMe 
                   fi
                    OTA=$SALIDA$APELLIDO2
                     paste tmp1 tmp2 > $OTA
                   NCOL=`awk 'END{print NF}' $OTA`
                   printf "\t ==========================\n"
                   printf "${GREEN}Output${NC}: $OTA \n"                       
                   printf "       No. Columnas ${MAG}$NCOL${NC}\n" 
                  
                   
            fi 
      done 

done 
 rm -f tmp1 tmp2 
printf "\tI have found the end ... ${GREEN}ok${NC}\n" 
