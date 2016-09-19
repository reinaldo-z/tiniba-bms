#!/bin/bash
## CHILDREN:
## checkPSPabinit.pl
## abchck.pl
## INPUTS: 
## $1=[SERIAL O PARALELO] $2=ABINIp_xx
## LAST MODIFICATION : Febrero 22 2010 at 18:58 by cabellos
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 MAG='\e[0;35m'
 NC='\e[0m' # No Color
##################################################
####################SCF XEON######################
##################################################
   rm -rf killme
      

##==============================
        WHERE=`dirname $0`
        printf "\t${MAG}Running: ${NC} $WHERE/`basename $0` $1 \n"
      BASEDIR=`dirname $PWD`
         CASO=`basename $PWD`
       PARENT=`basename $BASEDIR`
       DIRSCF=$CASO'_scf'
  ABINITfiles=$CASO'.files'
     ABINITin=$CASO'.in'
   WFSCFLOCAL=$CASO'o_DS1_WFK'
  WFSCFREMOTE=$CASO'i_DS1_WFK'
   WF2DATASET=$CASO'o_DS2_WFK'
CUANTOSEGUNDOS="1"          
    WORKZPACE="workspace"   
      FILEscf="$DIRSCF/.machines_scf"
      ABfiles="$DIRSCF/$ABINITfiles"
         ABin="$DIRSCF/$ABINITin"
    ANFITRION=`hostname`
##==============================
   ABINIs_XEON="/home/narzate/share_new/abinit-4.6.5/abinis"
   ABINIp_XEON="/home/narzate/share_new/abinit-4.6.5/abinip"
    MPICH_XEON="/usr/local/mpich_gm_intel9/bin"
##==============================
         declare -a MACHINESscf
##====== FUNCTIONS ============= 
 function StopMe {
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127    
       }
 function IsThereError {
     if [ -e killme ]; then
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127
     fi
    }
 function Duerme {
      if [ "$1" -gt 0 ];then
       printf "\t${BLU}Sleeping:${NC} $1 seconds\n"
       sleep $1
      fi 
       }
 function Line {
      printf "\t${BLUE}=============================${NC}\n"
       }
 function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      touch killme
      exit 127 
      fi
      }    
##====== BEGIN CODE =========== 
     if  [ $# -ne 1 ];then
         printf "\tUsage: \n"
         printf "\t `basename $0` [Option1]\n"
         printf "\t [Option1]= 2=paralelo 1=serial\n"
         StopMe
     fi
     ## 
     PARALELO=$1
     if [ "$PARALELO" != 1 ];then
        if [ "$PARALELO" != 2 ];then
          printf "\t [Option1] has to be 1=serial 2=paralelo\n"
          StopMe
        fi
     fi  
     ##=================================================
###########################
########################### PARALELO
###########################
     
     if [ $PARALELO -eq 2 ];then ##run in parallel
        Line
        DIRMEMORY=$PWD
        TIMESTARTSCF=`date`
        isThereFile $ABINIp_XEON
        isThereFile $FILEscf ##paranoia
        isThereFile $ABfiles ##.files abinit
        isThereFile $ABin ##.in abinit
        $WHERE/abchk.pl $ABin ##chekc variables in ab.in file
        IsThereError
        $WHERE/checkPSPabinit.pl  $ABfiles  ##chekc psp in ab.files file
        IsThereError
        rm -f tmpQ
        sed '/^ *$/d' $FILEscf > tmpQ
        mv tmpQ $FILEscf
        MACHINESscf=(`cat $FILEscf`)
        NOMACHINESscf=`echo ${#MACHINESscf[@]}`
        ##
        if [[ "${MACHINESscf[0]}" != "node"* ]]; then
         printf "\t $FILEscf is not a nodeXX \n"
         StopMe
        fi 

       isThereFile $CASO.files 
        RUNSCFXEON="$MPICH_XEON/mpirun -machinefile .machines_scf  -np $NOMACHINESscf  $ABINIp_XEON<$CASO.files>&log "   
                              
        HASrunSCF="$DIRSCF/runSCF"
        FORCErunSCF="$DIRSCF/forceRunSCF"
          if [ -e $FORCErunSCF ];then
           printf "\tForce to ${GREEN}run SCF${NC}...\n"
           rm -f $FORCErunSCF
           rm -f $HASrunSCF
          fi 

        if [ -e $HASrunSCF ];then
         WHEN=`stat $DIRSCF/runSCF | grep Modify` 
         printf "\t${GREEN}Jumping SCF${NC}..has been calculated before\n"
         printf "\t$WHEN \n"
        else
         touch $HASrunSCF
         printf "\tSCF in Parallel at ${GREEN}XEON${NC} in node $ANFITRION\n"
         printf "\tStarting SCF in parallel at time: "
         printf " ${GREEN}$TIMESTARTSCF ${NC}\n"
           if [ "$ANFITRION" == "master" ];then
                cd $DIRMEMORY/$DIRSCF
		$MPICH_XEON/mpirun -machinefile .machines_scf  -np $NOMACHINESscf  $ABINIp_XEON<$CASO.files>&log 
                cd ..
           else
               rsh master "cd $DIRMEMORY/$DIRSCF;$RUNSCFXEON "   
           fi
           ####################
            TIMEENDSCF=`date`
            TIME1s=`date --date="$TIMESTARTSCF" +%s`
            TIME2s=`date --date="$TIMEENDSCF" +%s`
            printf "\t  End SCF in parallel at time: "
            printf " ${GREEN}$TIMEENDSCF ${NC}\n"
            ELTIMEs=$[ $TIME2s - $TIME1s ]
            TMINs=$(echo "scale=9; $ELTIMEs/60" | bc)
            TMIN1s=$(echo "scale=9; $ELTIMEs/3600" | bc)
            printf "\t CPU time SCF:   $TMINs min. or $TMIN1s Hrs \n"
        fi ##runSCF       
    ##begin to check
     Line
     printf "\tLet me check ... begin to check WF SCF\n"  
      if [ -e "$DIRSCF/$WFSCFLOCAL" ];then
       printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL  "
       printf ".................[${GREEN}ok${NC},exist] \n"
        if [ -e "$DIRSCF/log" ];then
         WARRNINGS=`awk '/Delivered/ { print }' $PWD/$DIRSCF/log`
         CALCULATION=`awk '/Calculation/ { print }' $PWD/$DIRSCF/log`
           if [ -z "$CALCULATION" ];then
           printf "\t ${RED}BUT IS WRONG ${NC}\n"
           printf "\tIt seems that your scf ABINIT did not run properly\n"
           printf "\tlook for error messages in:\n "
           printf "\t$DIRSCF/log \n"
           StopMe
           else
           printf "\t${BLUE}$DIRSCF${NC}/log "
           printf ".................[${GREEN}ok${NC},exist] \n"
           printf "\t${BLUE}$DIRSCF${NC}/$WFSCFLOCAL "
           printf "....... [${GREEN}ok${NC},seems]\n"
           printf "\t$WARRNINGS \n"
           printf "\t${GREEN}$CALCULATION${NC}\n"
           printf "\t${CYAN}=================================${NC}\n"
           fi
        else
           printf "\t${BLUE}$DIRSCF${NC}/log "
           printf ".................[${RED}NO${NC},exist] \n"
           printf "\tParanoia your abinit doesnt run parallel well\n"
           StopMe
 
        fi
      else
         printf "\tParanoia your abinit doesnt run parallel\n"
         printf "\tThere is not file: $WFSCFLOCAL in\n"
         printf "\t$DIRSCF\n"
         StopMe
      fi ##begin check 
 fi ## end PARALELO
###########################
########################### SERIAL 
###########################
     if [ $PARALELO -eq 1 ];then ##run in SERIAL 
     Line
     printf "\tSerial no yet implemeted... \n"
     printf "\tImplement in line=192 `basename $0`  Atte: cabellos\n"
     StopMe
     fi
