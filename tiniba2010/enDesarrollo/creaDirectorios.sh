#!/bin/bash
## LAST MODIFICATION :  Febrero 18 2010 by Cabellos  a 16:52
## AUTHOR            :  J.L. Cabellos 
## REPORTING BUGS    :  Report bugs to <sollebac@gmail.com>.

      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
       NC='\e[0m' # No Color

 declare -a FALSEMACHINESpmn
 declare -a VIVOS
 declare -a MUERTOS

        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace" 
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'
     DIRSCF=$CASO'_scf'
   INTENTOS=6
 INEEDSPLIT=0
  FILE2COPY=$1
  ANFITRION=`hostname`
      WHERE="$HOME/abinit_shells/clustering/itaxeo"

### hha this all the cluster jl
MAQ501[1]="node01";MAQ501[12]="node12";MAQ501[23]="quad04"
MAQ501[2]="node02";MAQ501[13]="node13";MAQ501[24]="quad05"
MAQ501[3]="node03";MAQ501[14]="node14";MAQ501[25]="quad06"
MAQ501[4]="node04";MAQ501[15]="node15";MAQ501[26]="quad07"
MAQ501[5]="node05";MAQ501[16]="itanium01";MAQ501[27]="quad08"
MAQ501[6]="node06";MAQ501[17]="itanium02";MAQ501[28]="quad09"
MAQ501[7]="node07";MAQ501[18]="itanium03";MAQ501[29]="quad10"
MAQ501[8]="node08";MAQ501[19]="itanium04";MAQ501[30]="quad11"
MAQ501[9]="node09";MAQ501[20]="quad01";MAQ501[31]="quad12"
MAQ501[10]="node10";MAQ501[21]="quad02";MAQ501[32]="quad13"
MAQ501[11]="node11";MAQ501[22]="quad03";MAQ501[33]="quad14"
IPES[1]="192.168.1.1";IPES[12]="192.168.1.12";IPES[23]="192.168.1.23"
IPES[2]="192.168.1.2";IPES[13]="192.168.1.13";IPES[24]="192.168.1.24"
IPES[3]="192.168.1.3";IPES[14]="192.168.1.14";IPES[25]="192.168.1.25"
IPES[4]="192.168.1.4";IPES[15]="192.168.1.15";IPES[26]="192.168.1.26"
IPES[5]="192.168.1.5";IPES[16]="192.168.1.16";IPES[27]="192.168.1.27"
IPES[6]="192.168.1.6";IPES[17]="192.168.1.17";IPES[28]="192.168.1.28"
IPES[7]="192.168.1.7";IPES[18]="192.168.1.18";IPES[29]="192.168.1.29"
IPES[8]="192.168.1.8";IPES[19]="192.168.1.19";IPES[30]="192.168.1.30"
IPES[9]="192.168.1.9";IPES[20]="192.168.1.20";IPES[31]="192.168.1.31"
IPES[10]="192.168.1.10";IPES[21]="192.168.1.21";IPES[32]="192.168.1.32"
IPES[11]="192.168.1.11";IPES[22]="192.168.1.22";IPES[33]="192.168.1.33"
function findMaq {
 SALIDA="Not-Found"
  NOMAQ501a=`echo ${#MAQ501[@]}`
   for ((kkk=1;kkk<=($NOMAQ501a); kkk++));do       
     MAQ502a=${MAQ501[$kkk]}
       if [ "$MAQ502a" == "$1" ];then 
          SALIDA="$kkk"
       fi 
   done 
}
##===CHECK IF .machines file exist==================== !!
if [ ! -e .machines_pmn ];then
        printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        exit 0
else
       FALSEMACHINESpmn=(`cat .machines_pmn`)
     NOFALSEMACHINESpmn=`echo ${#FALSEMACHINESpmn[@]}`
         jj=0
         mm=0
         nn=0
         rm -f .machines_pmn
         touch .machines_pmn
    printf "\t   =====================\n"     
    printf "\t   No.     Node   Status         \n"     
    printf "\t   =====================\n"     
     for ((hh=0;hh<=($NOFALSEMACHINESpmn-1); hh++));do
 
         if [[ "${FALSEMACHINESpmn[$hh]}" == "node"* ]] || [[ "${FALSEMACHINESpmn[$hh]}" == "quad"* ]] || [[ "${FALSEMACHINESpmn[$hh]}" == "itanium"* ]] ; then

                
             

              IPT=`nmap --max_rtt_timeout 20  -oG - -p 514  ${FALSEMACHINESpmn[$hh]} | grep open | cut -d" " -f2`
                 findMaq ${FALSEMACHINESpmn[$hh]}
                    if [ "$IPT" == "${IPES[$SALIDA]}" ];then 
                       let jj++
                       let nn++ 
                      VIVOS[$nn]=${FALSEMACHINESpmn[$hh]} 
                      printf "\t%4d%12s${GREEN}%7s${NC}\n" "$jj" "${FALSEMACHINESpmn[$hh]}" "Live" 
                      echo ${FALSEMACHINESpmn[$hh]} >> .machines_pmn
                    else 
                      let jj++
                      let mm++
                       MUERTOS[$mm]=${FALSEMACHINESpmn[$hh]}
                     printf "\t%4d%12s${RED}%7s${NC}\n" "$jj" "${FALSEMACHINESpmn[$hh]}" "Dead" 
                    fi 
         fi 
    done
     printf "\t   =====================\n" 
         NOMUERTOS=`echo ${#MUERTOS[@]}`
         if [ $NOMUERTOS -gt 0 ];then 
            printf "\tYou original .machines_pmn has a $NOMUERTOS node dead  that has been eliminated\n"
             for ((hh=1;hh<=($NOMUERTOS); hh++));do
               printf "\t%4d%12s${RED}%7s${NC}\n" "$hh" "${MUERTOS[$hh]}" "Dead" 
             done 
         fi 
fi

 




exit 0


##################################################
########## WHERE WORK ############################
##################################################
   for ((hh=1;hh<=($NOMACHINESpmn); hh++));do        
       echo ${MACHINESpmn[$hh]}
        #if [[ "${MACHINESpmn[$hh]}" == "node"* ]]; then
          #if [[ "${MACHINESpmn[$hh]}" == "node"* ]]; then
          #  if [[ "${MACHINESpmn[$hh]}" == "itanium"* ]]; then
          #      let "kk=hh+1"
         #       CAZO=$CASO"_"$kk
         #       WHEREWORKREMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         #       WHEREWORKLOCAL[$hh]="$PWD/$CAZO"      
          #  fi 
          #fi 
        #fi        
   done

exit 0

   ##################################################
####========REMOTE DIRECTORIOS====================
##################################################
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${CYAN}Checking${NC} REMOTE directories \n"
     for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        REMOTESERVER=${MACHINESpmn[$hh]}
       # DIRQ=${WHEREWORKREMOTE[$hh]}
       # findMaq $REMOTESERVER

       # BASE=`dirname $DIRQ`
       # DIRE=`basename $DIRQ`
        printf "\t[$REMOTESERVER]:$BASE/${BLUE}$DIRE${NC}\n"          
      #  EXISTE=`rsh $REMOTESERVER 'test -d '$DIRQ'; echo $?'`
      #   if [ $EXISTE -eq 0 ] ;then
      #    printf " [${GREEN}exist${NC}]\n"
      #   else
      #    printf " [${GREEN}making${NC}]\n"
      #    rsh $REMOTESERVER "mkdir -p $DIRQ"
      #   fi
      #  sleep .1
      done
   printf "\t${BLUE}========================${NC}\n"

 exit 0


















##2 Julio at 23:54 hrs.
##FUNCTION:
##copy SCF to dir in .machines_pmn 
##CHILDREN:
##ineedsplitWFSCF.sh
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

##=========FUNCTIONS===============
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127
       }
 function CheckHost {
 ping -c 1 $1 >& /dev/null;
       }
##================================= 
 declare -a MACHINESpmn
 declare -a WHEREWORKREMOTE
 declare -a WHEREWORKLOCAL

        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace" 
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'
     DIRSCF=$CASO'_scf'
   INTENTOS=6
 INEEDSPLIT=0
  FILE2COPY=$1
  ANFITRION=`hostname`
      WHERE="$HOME/abinit_shells/clustering/itaxeo"

    rm -f killme 
    if [ ! -e "$WHERE/ineedsplitWFSCF.sh" ];then
      printf "\tWhere is your FILE: ineedsplitWFSCF.sh \n"
      printf "\tthe path actual is: "
      printf "$WHERE\n"
      touch -f killme
      StopMe
    fi 
   
##===CHECK IF .machines file exist==================== !!
  if [ ! -e .machines_pmn ]
      then
        printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        StopMe
  else
     MACHINESpmn=(`cat .machines_pmn`)
     NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
  fi
##################################################
####========WHERE WORK ===========================
##################################################
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        CAZO=$CASO"_"$kk
        WHEREWORKREMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         WHEREWORKLOCAL[$hh]="$PWD/$CAZO"
   done
##################################################
####========REMOTE DIRECTORIOS====================
##################################################
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${CYAN}Checking${NC} REMOTE directories \n"
     for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        REMOTESERVER=${MACHINESpmn[$hh]}
        DIRQ=${WHEREWORKREMOTE[$hh]}
        BASE=`dirname $DIRQ`
        DIRE=`basename $DIRQ`
        printf "\t[$REMOTESERVER]:$BASE/${BLUE}$DIRE${NC}"          
        EXISTE=`rsh $REMOTESERVER 'test -d '$DIRQ'; echo $?'`
         if [ $EXISTE -eq 0 ] ;then
          printf " [${GREEN}exist${NC}]\n"
         else
          printf " [${GREEN}making${NC}]\n"
          rsh $REMOTESERVER "mkdir -p $DIRQ"
         fi
        sleep .1
      done
   printf "\t${BLUE}========================${NC}\n"

exit 127

##################################################
####======== CHEKING SCF  ========================
##################################################
##===CHECK IF SCF DIR EXIST down======================
  if [ -d "$DIRSCF" ];then
   printf "\t${BLUE}$DIRSCF${NC}  "
   printf "...................[${GREEN}ok${NC},exist] \n"
    if [ -e "$DIRSCF/$WFSCFLOCAL" ];then
     printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL  "
     printf ".................[${GREEN}ok${NC},exist] \n"
     if [ -e "$DIRSCF/log" ];then
       printf "\tBegin to check WF SCF...\n"
         WARRNINGS=`awk '/Delivered/ { print }' $PWD/$DIRSCF/log`
         CALCULATION=`awk '/Calculation/ { print }' $PWD/$DIRSCF/log`
          if [ -z "$CALCULATION" ];then
           printf "\t           ${RED}BUT IS WRONG ${NC}\n"
           printf "\tIt seems that your scf ABINIT did not run properly\n"
           printf "\tlook for error messages in:\n "
           printf "\t$PWD/${BLUE}$DIRSCF${NC}/log \n"
           #printf "\t ${RED}Stoping right now ... ${NC}\n"
           touch killme
           exit 1
          else
           printf "\t${BLUE}$DIRSCF${NC}/log "
           printf ".................[${GREEN}ok${NC},exist] \n"
           printf "\t$WARRNINGS \n"
           printf "\t$CALCULATION\n"
           printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL "
           printf "....... [${GREEN}ok${NC}]\n"
          fi #end CALCULATION
        else #log
        printf "\t$DIRSCF/log doesnt exist \n"
        printf "\t${RED}Stoping right now ... ${NC}\n"
        touch -f killme
        #read -p "Ctrl C to Kill me ..."
        exit 1
        fi # end log
      else # "$DIRSCF/$WFSCFLOCAL"
        printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL doesnt exist...\n"
        printf "\t CAUSE: ABINIT didn't run SCF...  "
        #printf "\t${RED}Stoping right now ... ${NC}\n"
        #read -p "Ctrl C to Kill me ..."
        touch -f killme
        exit 1
      fi # "$DIRSCF/$WFSCFLOCAL"
   else
   printf "\t ${RED}There isn't DIRECTORY ${NC}${BLUE}$DIRSCF${NC} in :\n"
   printf "\t $DIR/ \n"
   printf "\t CAUSE: ABINIT didn't run SCF...  "
   printf "${RED}Stoping right now ... ${NC}\n"
   touch -f killme
   #read -p "Ctrl C to Kill me ..."
   exit 1
  fi
  ##===CHECK IF SCF DIR EXIST up======================
##################################################
####========COPYING FILE ========================
##################################################
  exit 127
  TIMER=`date`
  rm -f killme
  rm -f tmp
   printf "\t${CYAN}=================================${NC}\n"
    printf "\t${CYAN}Start to copy at time: $TIMER ${NC}\n"    
     TMP=`md5sum "$PWD/$DIRSCF/$WFSCFLOCAL"`
     echo $TMP>tmp
     MD5LOCAL=`awk '{print $1}' tmp`
     rm -f tmp  
##===============================================
 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    let "HHSU=$hh+1"
    REMOTESERVER=${MACHINESpmn[$hh]}
    ADONDECOPY=${WHEREWORKREMOTE[$hh]}
    ##---------------------------  
    if [[ "$REMOTESERVER" == "itanium"* ]]; then
         MAQUINA501=$REMOTESERVER
         SWITCHNAME="Using ethernet"
    fi
    #
    if [[ "$REMOTESERVER" == "node"* ]]; then
          if [ $ANFITRION == "master" ];then
           MAQUINA501=$REMOTESERVER"m"
           SWITCHNAME="Using myrinet"
          else
           MAQUINA501=$REMOTESERVER
           SWITCHNAME="No using myrinet"
          fi              
    fi
    #
    if [[ "$REMOTESERVER" == "quad"* ]]; then
        
        if [ $ANFITRION == "quad01" ];then
          MAQUINA501=$REMOTESERVER"ib"
          SWITCHNAME="Using infiniband"
        else
          MAQUINA501=$REMOTESERVER
          SWITCHNAME="No using infiniband"
        fi        
    fi 
    ##---------------------------
     SALIDAeq=1
     SALIDAneq=1
 until [ "$SALIDAneq" -eq "$INTENTOS" ] || [ $SALIDAeq -eq 2 ];do
  EXISTE=`rsh $REMOTESERVER 'test -e '$ADONDECOPY/$WFSCFREMOTE'; echo $?'`
    sleep .1
    if [ $EXISTE -eq 0 ] ;then ##existe
      rm -f tmp1
      TMP1=`rsh $REMOTESERVER 'md5sum '$ADONDECOPY/$WFSCFREMOTE''`
      echo $TMP1>>tmp1
      MD5REMOTE=`awk '{print $1}' tmp1`
      rm -f tmp1  
    fi 
  if [ $EXISTE -ne 0 ] ;then ##no existe      
             if [ "$INEEDSPLIT" -eq 0 ];then
                 $WHERE/ineedsplitWFSCF.sh
                 let "INEEDSPLIT+=1"
                 printf "\tSplitting the $DIRSCF/$WFSCFLOCAL..."
                 printf "\ttake a while..!!\n"
             fi 
   rcp $DIRSCF/$WFSCFLOCAL.block* $MAQUINA501:$ADONDECOPY/
   rsh $MAQUINA501 "cd $ADONDECOPY; cat $WFSCFLOCAL.block* > $WFSCFREMOTE; rm -f $WFSCFLOCAL.block*"
       printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
       printf "  [${GREEN}copying${NC}] Attempt $SALIDAneq\n"
       printf "\t ${GREEN}$SWITCHNAME${NC}\n"
      #-------------
      rm -f tmp1
      TMP1=`rsh $REMOTESERVER 'md5sum '$ADONDECOPY/$WFSCFREMOTE''`
      echo $TMP1>>tmp1
      MD5REMOTE=`awk '{print $1}' tmp1`
      rm -f tmp1  
      #-------------
  fi  ##no existe 
##################
      if [ "$MD5REMOTE" == "$MD5LOCAL" ];then
      SALIDAeq=2
      printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
      printf " [${GREEN}identical${NC}]\n"
      
      else
      ## I need to copy again but first erase
      printf " $MAQUINA501: $ADONDECOPY/$WFSCFREMOTE"
      printf " [${RED}NO Identical${NC}] $SALIDAneq \n" 
       let "INTE=INTENTOS-1"
       if [ $SALIDAneq -eq $INTE ];then
              printf "\t-----${RED}HOLD ON !!!!!${NC}-------\n"
              printf "after $SALIDAneq ATTEMPT "
              printf "Im not able to get the same copy, "
              printf "try to hand from:\n"
              printf "$PWD/$DIRSCF/$WFSCFLOCAL \n"
              printf "$MAQUINA502: $ADONDECOPY\n"
              printf "\t ${RED}Stoping right now ... ${NC}\n"
              read -p "any key to continue or Ctrl C to Kill me"
              # touch -f killme
              # exit 1
              fi
      let "SALIDAneq+=1"
      rsh $MAQUINA501 "cd $ADONDECOPY;rm -f $WFSCFREMOTE;rm -f $WFSCFLOCAL.block00;rm -f $WFSCFLOCAL.block01;rm -f $WFSCFLOCAL.block02;rm -f $WFSCFLOCAL.block03"  
      fi 
done ##until  
    sleep .2
  done
  ##--------------------------
  TIMER=`date`
  printf "\t${CYAN}End to copy at time: $TIMER ${NC}\n"
  rm -rf $PWD/$DIRSCF/$WFSCFLOCAL.block* #erase all children Local   
     
##StopMe
##nothing under here
