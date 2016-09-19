#!/bin/bash
## CHILDREN:
## checkPSPabinit.pl
## abchck.pl
## INPUTS: 
## $1=[SERIAL O PARALELO] $2=ABINIp_xx
## LAST MODIFICATION : Miercoles 3 Marzo 2010 by Cabellos 
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 MAG='\e[0;35m'
 NC='\e[0m' # No Color

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
##=========================
   ABINIs_QUAD="/home/prog/abinit/ABINITv4.6.5_QUAD/abinis.quad"
   ABINIp_QUAD="/home/prog/abinit/ABINITv4.6.5_QUAD/abinip.quad" 
    MPICH_QUAD="/home/mvapich-intel/bin/mpirun_rsh"
##==============================
         declare -a MACHINESpmn
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
        cp .machines_scf $DIRSCF
        printf "\tUsing: $ABINIp_QUAD \n"  
        Line
        DIRMEMORY=$PWD    
        TIMESTARTSCF=`date`
        isThereFile $ABINIp_QUAD
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
        nNUCLEI=4 ### NUMERO DE NUCLEOS USADOS 
        let "nPROC=$NOMACHINESscf * $nNUCLEI"        
        RUN="mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO.files > &log"


        if [[ "${MACHINESscf[0]}" != "quad"* ]]; then
         printf "\t $FILEscf is not a quad \n"
         StopMe
        fi 

        CAMINO="/opt/intel/impi/3.1/bin"
       # RUNSCFQUAD="$MPICH_QUAD -rsh -hostfile .machines_scf -np $NOMACHINESscf $ABINIp_QUAD < $CASO.files > log" 
               
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
         printf "\tSCF in Parallelo at ${GREEN}QUAD${NC}\n"
         printf "\tStart to Runing SCF in parallel at time: "
         printf " ${GREEN}$TIMESTARTSCF ${NC}\n"
           if [ "$ANFITRION" == "quad01" ];then
              cd $DIRMEMORY/$DIRSCF
                echo $RUN
                 $CAMINO/mpdboot -v -r ssh -f machinesQUAD -n $NMA
                 $CAMINO/mpdtrace
                 pwd
                 hostname
                 printf "\tYou are in: `hostname`:$DIR \n"
                 printf "\t    runing quad parallel in $NMA machines:\n\t$RUN \n"
                 $CAMINO/mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO.files >&log
             cd ..
           else
              printf  "\t Opening the socket \n"
               rsh quad01 "cd $DIRMEMORY/$DIRSCF;$CAMINO/mpdboot -v -r ssh -f .machines_scf -n $NOMACHINESscf"
               rsh quad01 "cd $DIRMEMORY/$DIRSCF;$CAMINO/mpdtrace"
               rsh quad01 "cd $DIRMEMORY/$DIRSCF;pwd;hostname"
               printf "\tYou are in: `hostname`:$DIRMEMORY \n"
               printf "\t    runing quad parallel in $NOMACHINESscf machines:\n\t$RUN \n"
               rsh quad01 "cd $DIRMEMORY/$DIRSCF;$CAMINO/mpiexec  $CAMINO/$RUN"
               #rsh quad01 "cd $DIRMEMORY/$DIRSCF;$RUNSCFQUAD"
           fi
           ####################
            TIMEENDSCF=`date`
            TIME1s=`date --date="$TIMESTARTSCF" +%s`
            TIME2s=`date --date="$TIMEENDSCF" +%s`
            printf "\t  End to Runing SCF in parallel at time: "
            printf " ${GREEN}$TIMEENDSCF ${NC}\n"
            ELTIMEs=$[ $TIME2s - $TIME1s ]
            TMINs=$(echo "scale=9; $ELTIMEs/60" | bc)
            TMIN1s=$(echo "scale=9; $ELTIMEs/3600" | bc)
            printf "\ttake SCF:   $TMINs min.\n"
            printf "\ttake SCF:   $TMIN1s Hrs.\n"
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
#mpdboot -v -r ssh -f .machines_scf -n 8 > perro
#grep failed perro | awk '{print $NF}'
