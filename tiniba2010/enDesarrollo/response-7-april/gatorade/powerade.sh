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

 BASEDIR=`dirname $PWD`
    CASO=`basename $PWD`
   CHECK="$CASO"_check"/$CASO.out" 
   WHERE=`dirname $0`
   

   if [ -z "$1" ];then
       printf "\t${GREEN}`basename $0`${NC} [eigenFile], [C-band], [V-band], [E], [DeltaE]\n"
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
    printf "\t  valencia bands = 1-$Nvf ($Nvf  Highest Valence)\n"
    printf "\tconduction bands = 1-$Nct (  1   Lowest Conduction)\n"
    printf "\t$WHERE/${GREEN}lemonade${NC} [eigenFile]\n"
      ls eigen_*
       printf "\t${RED}Stoping right now... ${NC}\n"
       exit 127
   fi 
  
    ################################
    ################################
    ################################
    ################################
    ################################
    ################################
    ################################

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
    printf "\t  valencia bands = $Nvf\n"
    printf "\tconduction bands = $Nct\n"
    echo $Nvf > fort.119
     
    echo $2 > fort.169
    echo $3 >> fort.169
    echo $4 >> fort.169
    echo $5 >> fort.169
   #  rm -f salida.g 
   # $WHERE/2vaca $1
    

    NAME="fig_c$2_v$3_E$4_D$5.g"
    if [ -e salida.g ];then 
    mv salida.g $NAME
    printf "\t Output: ${GREEN}$NAME ${NC}\n" 
    fi 


    
