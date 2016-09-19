#!/bin/bash
##
##LAST MODIFICATION : 
##                   Jun 03 2010 by cabellos a las 12:17 now playing mexico vs italy jjejej 
##FUNCTION          : 
##                   run to cabellos's style 
##CHILDREN          : 
##                   none 
##REPORTING BUGS    :
##                   Report bugs to <sollebac@gmail.com>.
##
## AUTHOR           :
##                   Written by JL Cabellos

GREEN='\e[0;32m'
green='\e[1;32m'
YELLOW='\e[1;33m'
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color
##copiaCASOin.sh
##copiaSTANDAR.sh
## 
        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace"
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'  
     DIRSCF=$CASO'_scf'
      IN=$CASO'.in' 
      FILES=$CASO'.files' 
  DONDEVIVO=`dirname $0`     
  SETUPABINIT=setUpAbinit_$CASO.in
  CUAL_ONE=$DONDEVIVO/one_node_cabellos.sh
  
     BASEABINIT="/home/prog/abinit"
     ABINIs_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinis.xeon"
     ABINIp_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinip.xeon"
     ABINIs_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinis.itan"
     ABINIp_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinip.itan"
     ABINIs_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinis.quad"
     ABINIp_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinip.quad"
      MPICH_XEON="/usr/local/mpich_gm_intel9/bin"
      MPICH_ITAN="/usr/local/mpich-itanium-intel9/bin"
      MPICH_QUAD="/home/mvapich-intel/bin/mpirun_rsh"
      ABC[0]=$CASO'.out' 
      ABC[1]=$CASO'.outA' 
      ABC[2]=$CASO'.outB' 
      ABC[3]=$CASO'.outC' 
      ABC[4]=$CASO'.outD' 
      ABC[5]=$CASO'.outE' 
      ABC[6]=$CASO'.outF' 
      ABC[7]=$CASO'.outG' 
      ABC[8]=$CASO'.outH'
      ABC[9]=$CASO'.outI'
      ABC[10]=$CASO'.outJ'
      ABC[11]=$CASO'.outK'
##====== FUNCTIONS ============ 
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127    
       }
############################################## cabellos ####################
############################################## cabellos ####################
############################################## cabellos ####################
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
##===CHECK IF .machines file exist==================== !!
 if [ ! -e .machines_norun ];then
       printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        StopMe
  else

   exec< .machines_norun
   input=[]
   i=0
   while read line
   do
        dos=`echo $line | awk '{print $2}'` 
        #dos=`line | awk '{print $2}'`
        #input[$i]=line;
        input[$i]=$dos;
        let "i = i + 1"
  done
# MACHINESno=(`cat .machines_norun`)
# NOMACHINESno=`echo ${#MACHINESno[@]}`
  fi
 NOMACHINESno=`echo ${#input[@]}`
 NOABC=`echo ${#ABC[@]}`
 ###################################################
###################################################
##################################################
#  for ((hh=0;hh<=($NOMACHINESno-1); hh++));do
#        let "kk=hh+1"# 
#       echo ${input[$hh]}
##        CAZO=$CASO"_"$kk
##        LOCALno[$hh]="$CAZO"
#   done

          

###################################################
###################################################
##################################################
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        RE=${MACHINESpmn[$hh]}
        CAZO=$CASO"_"$kk
         REMOTE[$hh]="/data.$RE/$USER/$WORKZPACE/$PARENT/$CAZO"
         REMOTEC[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         LOCAL[$hh]="$CAZO"
   done
###################################################
###################################################
#                   for ((nn=0;nn<=($NOABC-1); nn++));do
#            NOMBRE=$CASO'.out'
            
            
#               echo ${ABC[$nn]}         
#               done 
#exit 0








       
       ARCHIVO='machinesQUAD'
       if  [ ! -e $ARCHIVO ];then
        printf "\tNO file: machinesQUAD\n" 
       exit 0 
       fi 
       rm -f tmpQ 
       sed '/^ *$/d' $ARCHIVO  >  tmpQ
       mv tmpQ $ARCHIVO
         rm -f tmpQ
          NMA=`wc $ARCHIVO | awk '{print$1}'` 
           #printf "\t========================================\n"
           #printf "\tIm going to run in ${GREEN}$NMA${NC} machines that are found in file $ARCHIVO\n"


 norun=quad04


  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
       let "kk=hh+1"
      CAZO=$CASO"_"$kk
    let "HHSU=$hh+1"
       REMOTESERVER=${MACHINESpmn[$hh]}
       siOno=${input[$hh]}
       REMO=${REMOTE[$hh]}
       REMOC=${REMOTEC[$hh]}
       LOCA=${LOCAL[$hh]}
          CASI=`basename $REMO`
        CAMINO=`dirname $REMO` 
        #printf "\t${BLUE}$LOCA${NC} ---->  $REMOTESERVER : $CAMINO/${BLUE}$CASI${NC} "
        printf "$REMOTESERVER : $CAMINO/${BLUE}$CASI${NC} "
             
       # if [ -e "$REMO/$IN" ];then 
            #look
            
            
            ######################
            ######################
            ######################
            ######################
            CHECK=0
            ROADRUNER=0
            SALSAL=1  
            LLv=0
            NOMBRE=$CASO'.out'
        EXI=`rsh $REMOTESERVER 'test -e '$REMOC/$NOMBRE'; echo $?'`
          if [ $EXI -eq 0 ];then
            while [ $SALSAL -le 5 ];do              
              EXISTE=`rsh $REMOTESERVER 'test -e '$REMOC/$NOMBRE'; echo $?'`
              if [ $EXISTE -eq 0 ];then
                 let "LLv=LLv+1" 
                 NOMBRE=${ABC[$LLv]} 
              else
                 NOMBRE=${ABC[$LLv-1]}
                 CHECK=1
                SALSAL=20  
              fi         
            done 
            
            #echo NOMBRE FINAL : $NOMBRE
         else
           CHECK=0
           ROADRUNER=1
          printf "\t${RED}Hold on${NC} Abinit didnt run yet \n" 
         fi 
        
         ######################
         ######################
         ######################
         ######################
             if [ $CHECK == "1" ];then
                EXISTE=`rsh $REMOTESERVER 'test -e '$REMOC/$NOMBRE'; echo $?'`
               # EXISTE=`rsh $REMOTESERVER 'test -e '$REMOC/log'; echo $?'`
                      if [ $EXISTE -eq 0 ] ;then
                      CALC=`rsh $REMOTESERVER "cd $REMOC;awk '/Calculation/ { print }' $NOMBRE"`
                        if [ -z "$CALC" ];then 
                          printf "[${RED} ERROR${NC}] [$NOMBRE]\n"
                          ROADRUNER=1 
                        else
                          printf [${GREEN}"$CALC${NC}] [$NOMBRE]\n" 
                          grep "Total wall clock time" $REMO/$NOMBRE
                        fi

                     else 
                       printf " [${GREEN}abinis${NC}] [${RED}NO FINISH${NC}] \n" 
                  fi
             fi 
         ######################
         ######################
         ######################
         ######################
           #ROADRUNER=2
     if [ $ROADRUNER == "1" ];then
       #  mem=$PWD
         TIMESTARTALL=`date`
       #  cp .machines_scf $REMO/machinesQUAD
       #  cd $REMO
       #  ~/2010/tiniba2010/runPuntoFiles.sh quadp $FILES
       #  cd $mem
    
     fi   #ROADRUNER 
       sleep .1
  done 
exit 0
