#!/bin/bash
## Agosto 14 2008 cabellos 
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 NC='\e[0m' # No Color
function StopMe {
      if [ -z "$1" ];then
        printf "\tI need a eigen file ...\n"
        ls eigen_*
        printf "\t${RED}Stoping right now... ${NC}\n"
        exit 127
      else
         printf "\t$1 \n"
         printf "\t${RED}Stoping right now... ${NC}\n"
         exit 127
      fi
       }

 BASEDIR=`dirname $PWD`
    CASO=`basename $PWD`
   CHECK="$CASO"_check"/$CASO.out" 
   WHERE=`dirname $0`
   

   if [ -z "$1" ];then
       printf "\tinput: eigen file, C-band, V-band, E, DeltaE\n"
       ls eigen_*
       printf "\t${RED}Stoping right now... ${NC}\n"
       exit 127
   fi 
  

   if [ ! -e "$1" ];then
       printf "\tThis eigen files no existe .... ...\n"
       ls eigen_*
       printf "\t${RED}Stoping right now... ${NC}\n"
       exit 127
   fi 




   if [ ! -e $CHECK ];then 
     StopMe "${RED}HOLD ON ${NC}No file: $CHECK"
   else 
     printf "\t$CHECK  [${GREEN}ok${NC}]\n"
   fi 
     
    #######
    #######
    rm -f tmpX
    grep nband2 setUpAbinit_$CASO.in > tmpX
    Nmax=`head -1 tmpX | awk '{print $2}'`
    rm -f tmpX

    rm -f tmpA tmpB tmpC tmpD
    grep -n 'occ ' $CHECK > tmpA
    iocc=`awk -F: '{print $1}' tmpA`
    grep -n 'prtvol' $CHECK > tmpB
    iprtvol=`awk -F: '{print $1}' tmpB`
    awk 'NR=='$iocc',NR=='$iprtvol'' $CHECK > tmpC
    grep -o 1.000 tmpC > tmpD

    Nvf=`wc tmpD | awk '{print $2}'`
    
      if [ $Nvf == '0' ];then
	grep -o 2.000 tmpC > tmpD
        Nvf=`wc tmpD | awk '{print $2}'`
      fi


    Nct=`expr $Nmax - $Nvf`
    



    rm -f tmpA tmpB tmpC tmpD
  
    printf "\t     Total bands = $Nmax\n"
    #printf "\t You modificate your file eigen_NKPT_ECUT-spin \n"
    printf "\t===================================\n"
    #printf "\t  Puntos K       = $1\n"
    printf "\t  valencia bands = $Nvf\n"
    printf "\tconduction bands = $Nct\n"
    echo $Nvf > fort.119

    #echo uno  $1 
    #echo dos $2 
    #echo tre $3 
    #echo cuatro $4 
    #echo cinco $5 
    #echo seis $6 

   # exit 127 

    #echo $WHERE/2vaca $1
    echo $2 > fort.169
    echo $3 >> fort.169
    echo $4 >> fort.169
    echo $5 >> fort.169
    echo $6 >> fort.169
    $WHERE/2vaca.gaas $1
    if [ $6 == '1' ]
	then
	caso=0
    fi
    mv salida.g fig_c$2_v$3_E$4_D$5_s$caso.g
 
