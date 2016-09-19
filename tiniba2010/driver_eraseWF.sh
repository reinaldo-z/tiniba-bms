#!/bin/bash
##LAST MODIFICATION : 
##                   Febrero 24 2010 by cabellos a las 10:35 
##FUNCTION          : 
##                   check if abinis finished  
##CHILDREN          : 
##                   none 
##REPORTING BUGS    :
##                   Report bugs to <sollebac@gmail.com>.
##
## AUTHOR           :
##                   Written by JL Cabellos
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

declare -a MACHINESpmn
 declare -a WHEREWORKREMOTE
 declare -a WHEREWORKLOCAL

    rm -f killme 
        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace" 
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'
      perro=$CASO'o_DS2_WFK'
     DIRSCF=$CASO'_scf'
   INTENTOS=6
 INEEDSPLIT=0
  FILE2COPY=$1
  ANFITRION=`hostname`
      WHERE="$HOME/abinit_shells/clustering/itaxeo"
   NOBLOCKS=4
     MEMPWD=$PWD
      PUTA=$CASO".out*"
      PUTA1=$CASO".in"

##=========FUNCTIONS===============
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127
       }

  if [ ! -e .machines_pmn ]
      then
        printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        StopMe
  else
     MACHINESpmn=(`cat .machines_pmn`)
     NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
  fi
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        CAZO=$CASO"_"$kk
        WHEREWORKREMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         WHEREWORKLOCAL[$hh]="$PWD/$CAZO"
   done
         for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        REMOTESERVER=${MACHINESpmn[$hh]}
                DIRQ="${WHEREWORKREMOTE[$hh]}"
               BASE=`dirname $DIRQ`
               DIRE=`basename $DIRQ`
           printf " [$REMOTESERVER]:$BASE/${BLUE}$DIRE${NC}/log"    
         EXISTEa=`rsh $REMOTESERVER 'test -e '$DIRQ/abineta'; echo $?'`          
           if [ $EXISTEa -eq 0 ] ;then
              printf " [${GREEN}abinis${NC}] [${GREEN}Finish${NC}] "
               EXISTE=`rsh $REMOTESERVER 'test -e '$DIRQ/log'; echo $?'`
                 if [ $EXISTE -eq 0 ] ;then
                 #printf " [${GREEN}abinis${NC}] "
                 #WARRNINGS=`rsh $REMOTESERVER "cd $DIRQ;awk '/Delivered/ { print }' log"`
               CALC=`rsh $REMOTESERVER "cd $DIRQ;awk '/Calculation/ { print }' log"`
                   if [ -z "$CALC" ];then 
                   printf "[${RED} ERROR${NC}]\n" 
                  else
                    printf [${GREEN}"$CALC${NC}]\n" 
                  fi  
             else
           printf " [${GREEN}abinis${NC}] "
           printf "[${RED} ERROR${NC}]\n" 
           fi
           else 
              printf " [${GREEN}abinis${NC}] [${RED}NO FINISH${NC}] \n"  
              
           fi      
            printf "\t$PUTA\n"
            #rsh $REMOTESERVER "cd $DIRQ; rm $perro; rm $PUTA;rm $PUTA1"
            rsh $REMOTESERVER "cd $DIRQ; rm rpmnEND; rm $PUTA;rm abineta; rm log"

           #EXISTE=`rsh $REMOTESERVER 'test -e '$DIRQ/log'; echo $?'`
           # if [ $EXISTE -eq 0 ] ;then
           #    printf " [${GREEN}abinis${NC}] "
           # #WARRNINGS=`rsh $REMOTESERVER "cd $DIRQ;awk '/Delivered/ { print }' log"`
           # CALC=`rsh $REMOTESERVER "cd $DIRQ;awk '/Calculation/ { print }' log"`
           #      if [ -z "$CALC" ];then 
           #        printf "[${RED} ERROR${NC}]\n" 
           #      else
           #        printf [${GREEN}"$CALC${NC}]\n" 
           #      fi 
           # 
           #  else
           #printf " [${GREEN}abinis${NC}] "
           #printf "[${RED} ERROR${NC}]\n" 
           #fi
      done


 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    DIRQ="${WHEREWORKLOCAL[$hh]}"
   rm -v $DIRQ/abineta
   rm -v $DIRQ/rpmnEND
done 




 
exit 0




