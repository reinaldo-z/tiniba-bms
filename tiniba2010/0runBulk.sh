#!/bin/bash
## FUNCTION: 
## FOR BULK CALCULATIONS using abinit code  
## CHILDREN
## setKp.sh
## arrangeMachines.pl
## eraseAllNodes.sh
## abchk.pl
## checkPSPabinit.pl
## printWhatOptionMenu.sh
## set.pl
## driver_copySCF.sh
## LAST MODIFICATION : Lunes Marzo 1 2010 jl cabellos
    EACHTIMECHECKabinis=10 ## abinis
     EACHTIMECHECKrpmns=10  ## rpmns

    RED='\e[0;31m'
   BLUE='\e[0;34m'
    BLU='\e[1;34m'
   CYAN='\e[0;36m'
  GREEN='\e[0;32m'
    GRE='\e[1;32m'
 YELLOW='\e[1;33m'
    MAG='\e[0;35m'
     NC='\e[0m' # No Color


           WHERE=`dirname $0`
      NAMESCRIPT=`basename $0`

      BASEABINIT="/home/prog/abinit"
         BASEDIR=`dirname $PWD`
            CASO=`basename $PWD`
          PARENT=`basename $BASEDIR`
          DIRSCF=$CASO'_scf'
        DIRCHECK=$CASO'_check'
     SETUPABINIT=setUpAbinit_"$CASO".in
      WFSCFLOCAL=$CASO'o_DS1_WFK'
     WFSCFREMOTE=$CASO'i_DS1_WFK'
      WF2DATASET=$CASO'o_DS2_WFK'
  CUANTOSEGUNDOS="1"          
       WORKZPACE="workspace"
            HOST=`hostname`   
           INDEX=1

         declare -a INPUTARGS
         declare -a MACHINESpmn
         declare -a MACHINESscf
         declare -a WORKpmnRemot
         declare -a WORKpmnLocal
         declare -a ENDABINIS
         declare -a RPMNSTERMINARON

##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>

     ABINIs_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinis.xeon"
     ABINIp_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinip.xeon"
     ABINIs_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinis.itan"
     ABINIp_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinip.itan"
     ABINIs_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinis.quad"
     ABINIp_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinip.quad"
      MPICH_XEON="/usr/local/mpich_gm_intel9/bin"
      MPICH_ITAN="/usr/local/mpich-itanium-intel9/bin"
      MPICH_QUAD="/home/mvapich-intel/bin/mpirun_rsh"
        PMN_XEON="$WHERE/SRC_readwfk/readwfk.xeon"
        PMN_ITAN="$WHERE/SRC_readwfk/readwfk.itan"
        PMN_QUAD="$WHERE/SRC_readwfk/readwfk.quad"


##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>


 function StopMe {
      printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
      exit 127    
       }
 function IsThereError {
     if [ -e killme ]; then
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      rm -rf killme
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
      exit 127 
      fi      
      }

 
##<><><><><><><><><><><><><><><>
##<><><><> BEGIN CODE <><><><><>
##<><><><><><><><><><><><><><><>


     printf "\n"
     printf "\tTaking all scripts from: $WHERE\n"
     Line
     isThereFile $ABINIs_XEON
     isThereFile $ABINIp_XEON
     isThereFile $ABINIs_ITAN
     isThereFile $ABINIp_ITAN
     isThereFile $ABINIs_QUAD
     isThereFile $ABINIp_QUAD
     isThereFile $PMN_XEON
     isThereFile $PMN_ITAN
     isThereFile $PMN_QUAD
     isThereFile $SETUPABINIT
     isThereFile .machines_pmn
     isThereFile .machines_scf
     isThereFile .machines_latm
     isThereFile .machines_res
      ##==========================
     if [  $# -eq 4 ] && [ "$1" == "setkp" ];then
        rm -rf killme
        $WHERE/setKp.sh $1 $2 $3 $4
         IsThereError     
        StopMe
      fi
     ##==========================
     if [ ! -e pesoITAN ] || [ ! -e pesoQUAD ] ;then
      printf "\t${RED}There is not FILE:${NC} 'pesoITAN' or 'pesoQUAD'\n"
      printf "\t you must run first: \n"
      $WHERE/setKp.sh 
      StopMe 
     fi 
     ##==========================
     if  [ $# -eq 1 ];then
         if [ "$1" == "erase" ] || [ "$1" == "erasescf" ];then
          $WHERE/eraseAllNodes.sh $1
          StopMe
         fi 
         if [ "$1" == "GaAs" ];then
         printf "\tMaking example for GaAs  (Abinit an Wien2k)\n"
         StopMe
         fi  
     fi 
     $WHERE/anyChanges.sh
     ##==========================
      if [  $# -eq 6 ] && [ "$1" == "run" ];then
        for arg in "$@";do
         INPUTARGS[$INDEX]=$arg
         let "INDEX+=1"
        done
      fi 
     ##==========================
     if [  $# -gt 6 ] || [  $# -eq 0 ]  || [  $# -eq 2 ];then
        rm -rf killme 
        $WHERE/checkAllFilesNeed.sh
        IsThereError
        Duerme 1
        Line
        printf "$WHERE/${GREEN}creatingTree.sh${NC} erase \n"
        printf "$WHERE/${GREEN}`basename $0`${NC} erase \n"
        printf "$WHERE/${GREEN}`basename $0`${NC} erasescf\n"
        printf "$WHERE/${GREEN}checkAllFilesNeed.sh${NC}\n" 
        printf "$WHERE/${GREEN}isAlive.sh${NC} \n" 
        printf "$WHERE/${GREEN}driver_abinisCheck.sh${NC}\n"  
        printf "$WHERE/${GREEN}limpiaSetUpAbinit.pl${NC}\n"       
        Line

        printf "$WHERE/${GREEN}`basename $0`${NC} "
        printf "[${GREEN}setkp${NC}] [$CASO.klist_${GREEN}?${NC}] "
        printf "[${GREEN}xeon/itan${NC}] [${GREEN}xeon/itan${NC}]\n"
         FILESx="*.klist*"
         for file in $FILESx; do
          printf " ${BLUE}-${NC} $file \n"
         done
        printf "$WHERE/${GREEN}`basename $0`${NC} "
        printf "[${GREEN}run${NC}]  [$CASO.klist_${GREEN}?${NC}] "
        printf "[${GREEN}N_Layer${NC}] [${GREEN}SCF s=1 p=2${NC}] "
        printf "[${BLUE}options${NC}]\n" 
      Line
        printf "\t[${BLUE}options${NC}]:\n"  
        printf "        ${BLUE}0 1${NC} ONLY "
        printf "calculates energies for band structure (so is faster)\n"
        printf "        ${BLUE}0 2${NC} NORMAL optics "
        printf "calculation, calculates both energies and pmn \n"
        printf "        ${BLUE}3 0${NC} SPIN MATRIX elements only!\n"
        printf "        ${BLUE}3 1${NC} BULK: optics "
        printf "and spin density/current calculation\n"
        for file in $FILESx; do
        nk=`wc $file | awk '{print $1}'`
       printf "\t--------------\n"
       printf "\t#$WHERE/`basename $0` "
       printf "${GREEN}setkp $nk 2 5 ${NC}   ## option setkp \n"
       printf "\t#$WHERE/`basename $0` "
       printf "${GREEN}run $nk 0 2 ${NC}${BLUE}3 1 ${NC} ## option 3 1\n"
       done
       StopMe
     fi 


##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><>



            MACHINESpmn=(`cat .machines_pmn`)
            MACHINESscf=(`cat .machines_scf`)
          NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
          NOMACHINESscf=`echo ${#MACHINESscf[@]}`
            ISRUN=${INPUTARGS[1]}
             NKPT=${INPUTARGS[2]}
           NLAYER=${INPUTARGS[3]}
          SCFPARA=${INPUTARGS[4]}
             OPT1=${INPUTARGS[5]}
             OPT2=${INPUTARGS[6]}
             
TIMESTARTALL=`date`
      printf "\tAll Started at: $TIMESTARTALL \n" 
      $WHERE/checkAllFilesNeed.sh
      IsThereError
      $WHERE/checkOptions.sh $OPT1 $OPT2 1
      IsThereError
      $WHERE/printWhatOptionMenu.sh $OPT1 $OPT2  
      IsThereError
      #Duerme $CUANTOSEGUNDOS
      #$WHERE/isAliveServer.pl 
      #IsThereError        
      Duerme $CUANTOSEGUNDOS
      $WHERE/abchk.pl $SETUPABINIT
      IsThereError     
      #printf "\t Making files check nodes:\n"
      #$WHERE/mkFile2CheckNodes.pl .machines_pmn
      #$WHERE/mkFile2CheckNodes.pl .machines_scf
      ##==========================  
       if [ "$NLAYER" != "0" ];then
          printf "\tFor this NLAYER=$NLAYER has to be ZERO\n"
          StopMe
       fi
     ##==========================  
     ESPINsetUp=`grep nspinor setUpAbinit_$CASO.in  |  awk '{print $2}'`
       if [ -z $ESPINsetUp ];then 
         printf "\tESPINsetUp= $ESPINsetUp"
         printf "you have to define your spin in: setUpAbinit_$CASO.in\n"
         StopMe
       fi 
     ##==========================   
       if [ "$ESPINsetUp" -eq "1" ] || [ "$ESPINsetUp" -eq "2" ];then 
          rm -f spin_info 
          echo $ESPINsetUp > spin_info    
          printf "\tMaking FILE: spin_info   [${GREEN}Ok${NC}]\n"
       else 
          printf "\tSpin has to be 1 or 2\n"
          StopMe
       fi    
     ##==========================
     if [ ! -e res ];then
             mkdir res
     fi
     FILEKLIST=$CASO.klist_"$NKPT"
     isThereFile $FILEKLIST
          isThereFile pesoITAN
          isThereFile pesoQUAD #paranoia
          WEIGHT=`awk '{print $1}' pesoITAN`       
        pesoITAN=`awk '{print $1}' pesoITAN`
        pesoQUAD=`awk '{print $1}' pesoQUAD`         
     ##==========================
      if [ ! -d "$DIRSCF" ];then
         mkdir $DIRSCF
         cp .machines_scf $DIRSCF
      else
         cp .machines_scf $DIRSCF 
      fi
     ##==========================
     rm -f killme
     $WHERE/checkPSPabinit.pl $SETUPABINIT 1       
     IsThereError
     isThereFile spin_info #paranoia
     IsThereError
     ##==========================

   ##<><><><><><><><><><><><><><><>
   ##<><><><><><><><><><><><><><><>
   ##<><><><><><><><><><><><><><><>
  






   ##<><><><><><><><><><><><><>
   ##<><><><><><><><><><><><><>
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
     let "kk=hh+1"
     WORKpmnLocal[$hh]="$PWD/$CASO"_""$kk""
     WORKpmnRemot[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CASO"_""$kk""
   done    
   ####========LOCAL DIRECTORIOS======================
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${CYAN}Checking${NC} LOCAL directories \n"
      for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        MAQUINA501=${WORKpmnLocal[$hh]}
        BASENAMEL=`basename ${WORKpmnLocal[$hh]}`
          DIRNAMEL=`dirname ${WORKpmnLocal[$hh]}`    
          CHILDSL=${WORKpmnLocal[$hh]}
         if [ -d "$CHILDSL" ];then
         printf "\t $DIRNAMEL/${BLUE}$BASENAMEL${NC}"
         printf " [${GREEN}exist${NC}]\n"
        else
         printf "\t $DIRNAMEL/${BLUE}$BASENAMEL${NC}"
         printf " [${GREEN}making${NC}]\n"
         mkdir -p $CHILDSL
        fi
      done 
     Duerme $CUANTOSEGUNDOS
####========REMOTE DIRECTORIOS====================
    printf "\t${BLUE}========================${NC}\n"
    printf "\t${CYAN}Checking${NC} REMOTE directories \n"
     for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
      REMOTESERVER=${MACHINESpmn[$hh]} 
      DIRQ=${WORKpmnRemot[$hh]}
      BASENAMER=`basename ${WORKpmnRemot[$hh]}`
       DIRNAMER=`dirname ${WORKpmnRemot[$hh]}`
        printf "\t[$REMOTESERVER]  $DIRNAMER/${BLUE}$BASENAMER${NC}"
        EXISTE=`rsh $REMOTESERVER 'test -d '$DIRQ'; echo $?'`
        if [ $EXISTE -eq 0 ] ;then
         printf " [${GREEN}exist${NC}]\n"
        else
         printf " [${GREEN}making${NC}]\n"
         rsh $REMOTESERVER "mkdir -p $DIRQ"
        fi
        #
        sleep .1
      done 
     Duerme $CUANTOSEGUNDOS

####========DISTRIBUTING K POINTS===================

  printf "\t${BLUE}========================${NC}\n"
  printf "\t${CYAN}Distributing K points${NC} in machines \n"
 $WHERE/arrangeMachines.pl $FILEKLIST $NOMACHINESpmn $pesoITAN $pesoQUAD
  IsThereError
  Duerme 2
 $WHERE/set.pl $FILEKLIST $NOMACHINESpmn $NLAYER 
     if [ -d JOBS ];then
       rm -rf JOBS
     fi 
 $WHERE/concatena.pl $FILEKLIST $NOMACHINESpmn $NLAYER
  rm -f master.jdf
  rm -f startpoint.txt
  rm -f endpoint.txt
  rm -f klist_length.txt


####======== SCF QUAD ============================

 if [[ "${MACHINESscf[0]}" == "quad"* ]]; then 
  rm -f killme
  $WHERE/SCFquad.sh $SCFPARA
  IsThereError
 fi
   
 if [[ "${MACHINESscf[0]}" == "node"* ]]; then 
   rm -f killme
   $WHERE/SCFxeon.sh $SCFPARA
   IsThereError
  fi
  if [[ "${MACHINESscf[0]}" == "itanium"* ]]; then 
   rm -f killme
   printf "\tcheck  runSCFitan.sh i didnt check yet...sorry..\n"
   $WHERE/SCFitan.sh $SCFPARA
   IsThereError
 fi

####====================================
 #$WHERE/copySCF2nodesWithCheck.sh ## COPY SIN CHECAR
$WHERE/driver_copySCF.sh ## COPY SIN CHECAR
 #$WHERE/copySCF2nodes.sh         ## COPY SPLIT Y CHECK
##################################################
##################################################
####################COPY .in   ###################
################################################## 
   Line
   printf "\tCopying: $CASO.in \n"
    for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
       DONDEWORKRE=${WORKpmnRemot[$hh]}
       DONDEWORKLO=${WORKpmnLocal[$hh]}
       REMOTESERVER=${MACHINESpmn[$hh]}
    ##------------------------
    if [[ "$REMOTESERVER" == "quad"* ]]; then
         if [ "$HOST" == "quad01" ];then 
           MAQUINA503=$REMOTESERVER"ib"
         fi 
         if [ "$HOST" == "master" ];then 
           MAQUINA503=$REMOTESERVER         
         fi 

    fi 
    #
    if [[ "$REMOTESERVER" == "itanium"* ]]; then
         MAQUINA503=$REMOTESERVER       
    fi
    #
    if [[ "$REMOTESERVER" == "node"* ]]; then
        if [ "$HOST" == "quad01" ];then 
           MAQUINA503=$REMOTESERVER
        fi
        if [ "$HOST" == "master" ];then 
           MAQUINA503=$REMOTESERVER"m"         
        fi 
       
    fi
    ##------------------------
    isThereFile $DONDEWORKLO/$CASO.in
    IsThereError
    $WHERE/abchk.pl $DONDEWORKLO/$CASO.in 
    IsThereError
    rcp $DONDEWORKLO/$CASO.in $MAQUINA503:$DONDEWORKRE/
       BASENAMEL=`basename $DONDEWORKLO`
       BASENAMER=`basename $DONDEWORKRE`
        DIRNAMER=`dirname $DONDEWORKRE`
       printf " ${BLUE}$BASENAMEL${NC}/$CASO.in ${GREEN}==>${NC}"
       printf "$REMOTESERVER:$DIRNAMER/${BLUE}$BASENAMER${NC}/$CASO.in\n" 
       sleep .2
   done 

  

##################################################
##################################################
####################COPY .files   ################
################################################## 
   Line
   printf "\tCopying: $CASO.files \n"
    for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
       DONDEWORKRE=${WORKpmnRemot[$hh]}
       DONDEWORKLO=${WORKpmnLocal[$hh]}
       REMOTESERVER=${MACHINESpmn[$hh]}
    ##------------------------
    if [[ "$REMOTESERVER" == "quad"* ]]; then
         if [ "$HOST" == "quad01" ];then 
           MAQUINA503=$REMOTESERVER"ib"
         fi 
         if [ "$HOST" == "master" ];then 
           MAQUINA503=$REMOTESERVER         
         fi 
    fi 
    #
    if [[ "$REMOTESERVER" == "itanium"* ]]; then
         MAQUINA503=$REMOTESERVER       
    fi
    #
    if [[ "$REMOTESERVER" == "node"* ]]; then
        if [ "$HOST" == "quad01" ];then 
           MAQUINA503=$REMOTESERVER
        fi
        if [ "$HOST" == "master" ];then 
           MAQUINA503=$REMOTESERVER"m"         
        fi 
       
    fi
    ##------------------------
    isThereFile $DONDEWORKLO/$CASO.files
    IsThereError
    $WHERE/checkPSPabinit.pl $DONDEWORKLO/$CASO.files
    IsThereError
    rcp $DONDEWORKLO/$CASO.files $MAQUINA503:$DONDEWORKRE/
       BASENAMEL=`basename $DONDEWORKLO`
       BASENAMER=`basename $DONDEWORKRE`
        DIRNAMER=`dirname $DONDEWORKRE`
    printf " ${BLUE}$BASENAMEL${NC}/$CASO.files ${GREEN}==>${NC}"
    printf "$REMOTESERVER:$DIRNAMER/${BLUE}$BASENAMER${NC}/$CASO.files\n" 
    sleep .2
   done 
##################################################
####################  RUN ABINIS SERIAL  #########
##################################################  
  TIMESTARTABINIS=`date`
  Line
  printf "\tRunning: abinis(serial) \n"
  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    MAQUINA502=${MACHINESpmn[$hh]}
    DONDECORRE=${WORKpmnRemot[$hh]}
    DONDEWORKLO=${WORKpmnLocal[$hh]}
    rm -f $DONDEWORKLO/abinitEND
     #---------------------
       if [[ "$MAQUINA502" == "node"* ]]; then       
         ABINITEXEC=$ABINIs_XEON
       fi      
       if [[ "$MAQUINA502" == "itanium"* ]]; then       
         ABINITEXEC=$ABINIs_ITAN
       fi
     
       if [[ "$MAQUINA502" == "quad"* ]]; then       
         ABINITEXEC=$ABINIs_QUAD
       fi
     #---------------------
     
      CUALABI=`basename $ABINITEXEC`

  rsh  $MAQUINA502 "cd $DONDECORRE; rm -f $CASO.outA;rm -f $CASO.outB;rm -f $CASO.outC;rm -f $CASO.outD;rm -f $CASO.outE;rm -f $CASO.outF;rm -f $CASO.out;" 
   sleep .05
  rsh  $MAQUINA502 "cd $DONDECORRE; rm -f abinitEND; rm -f log" 
   sleep .05 
   rm -f $DONDEWORKLO/abinitEND
   MKabinitEND="rsh $HOST 'cd $DONDEWORKLO;touch abinitEND'"
      rsh -n $MAQUINA502 "cd $DONDECORRE; $ABINITEXEC <$CASO.files>&log;touch abinitEND;touch abinitEND; $MKabinitEND"&
      ENDABINIS[$hh]=1
      BASENAME=`basename $DONDECORRE`
       DIRNAME=`dirname $DONDECORRE`
        printf " $DIRNAME/${BLUE}$BASENAME${NC} "
         printf "[${GREEN}Working${NC}] [${GREEN}$CUALABI${NC}] "
          printf "[${CYAN}$MAQUINA502${NC}] \n"
       sleep .2
done
##################################################
####################  WAIT  ABINIS  ##############
################################################## 
Line
       $WHERE/printWhatOptionMenu.sh $OPT1 $OPT2      
       printf "\tWait for ${CYAN}$NOMACHINESpmn${NC} works ABINIS\n"
       Line
       #####################
       printf "\tBegin to check if some works Abinis ended \n"
       printf "\teach time ${GREEN}$EACHTIMECHECKabinis seconds${NC} \n"
for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    HOWMANYTIMES=0
    SALIDA=0 
    MAQUINA502=${MACHINESpmn[$hh]}
    DONDECORRE=${WORKpmnRemot[$hh]}
    DONDEWORKLO=${WORKpmnLocal[$hh]}
 
     cd $DONDEWORKLO
     while [ "$SALIDA" -lt "10" ]; do 
       sleep $EACHTIMECHECKabinis
       let "HOWMANYTIMES=HOWMANYTIMES+1"
    if [ -e abinitEND ];then 
        EACHTIMECHECKabinis=1
        SALIDA=20
        printf "\t$DONDECORRE "
        printf "\t[${GREEN}end${NC}] [${BLU}$MAQUINA502]${NC}\n"
        printf "\tBegin to check WF ${CYAN}$WF2DATASET${NC}\n"
        rm -f log
         rcp  $MAQUINA502:$DONDECORRE/log .
         WARRNINGS=`awk '/Delivered/ { print }' log`
         CALCULATION=`awk '/Calculation/ { print }' log`
         printf "\t$WARRNINGS \n"
         printf "\t${GREEN}$CALCULATION ${NC}\n"
         if [ -z "$CALCULATION" ];then
           printf "\t           ${RED}BUT IS WRONG ${NC}\n"
           printf "\tIt seems that your ABINIT did not run properly\n"
           printf "\tlook for error messages in:\n "
           printf "\t$MAQUINA502:$$DONDECORRE/log \n"
           read -p "press any key..."
         fi
        let "NOOFWR=hh+1"
        printf "\t Work No. ${GREEN}$NOOFWR${NC} "
        printf "of total ${GREEN}$NOMACHINESpmn${NC}\n"
        printf "\t${GREEN}------------${NC}\n"
        rm -f log
     fi 
     done
     cd .. 
done
##################################################        
       Line
       IsThereError   
       TIMEENDABINIS=`date`
        TIME1s=`date --date="$TIMESTARTABINIS" +%s`
        TIME2s=`date --date="$TIMEENDABINIS" +%s`
        printf "\tStart to Runing ABINIS in parallel at time: "
        printf " ${GREEN}$TIMESTARTABINIS ${NC}\n"
        printf "\t  End to Runing ABINIS in parallel at time: "
        printf " ${GREEN}$TIMEENDABINIS ${NC}\n"
        ELTIMEs=$[ $TIME2s - $TIME1s ]
        TMINs=$(echo "scale=9; $ELTIMEs/60" | bc)
        TMIN1s=$(echo "scale=9; $ELTIMEs/3600" | bc)
        printf "\ttake Abinis:   $TMINs min.\n"
        printf "\ttake Abinis:   $TMIN1s Hrs.\n" 
   

##################################################
####################  rpmns ######################
################################################## 
##################################################
####################  RUN rpmns SERIAL  ##########
##################################################  
 TIMESTARTRPMNS=`date`
        Line
   printf "\tRunning: rpmns(serial) \n"
  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    MAQUINA502=${MACHINESpmn[$hh]}
    DONDECORRE=${WORKpmnRemot[$hh]}
    DONDEWORKLO=${WORKpmnLocal[$hh]}
     #---------------------
       if [[ "$MAQUINA502" == "node"* ]]; then       
         RPMNSEXEC=$PMN_XEON     
       fi      
       #
       if [[ "$MAQUINA502" == "itanium"* ]]; then       
         RPMNSEXEC=$PMN_ITAN     
       fi
       # 
       if [[ "$MAQUINA502" == "quad"* ]]; then  
         RPMNSEXEC=$PMN_QUAD     
       fi
     #---------------------
     CUALRP=`basename $RPMNSEXEC`
 # rsh  $MAQUINA502 "cd $DONDECORRE; rm -f rpmnEND;" 

  rm -f $DONDEWORKLO/rpmnEND 
 MKrpmnEND="rsh $HOST 'cd $DONDEWORKLO;touch rpmnEND'"
    rm -f $DONDEWORKLO/rpmnEND
  if [ "$ESPINsetUp" == "1" ];then
     rsh -n $MAQUINA502 "cd $DONDECORRE;$RPMNSEXEC -ene -mme $WF2DATASET > logfile;$MKrpmnEND"&
  OPT1=0
  OPT2=2
  else
     rsh -n $MAQUINA502 "cd $DONDECORRE;$RPMNSEXEC -ene -mme -sme $WF2DATASET > logfile;$MKrpmnEND"&  
  fi 


  RPMNSTERMINARON[$hh]=1          
  printf " $DONDECORRE [${GREEN}working${NC}] [$MAQUINA502] [$CUALRP]\n" 
   sleep .1
done
##################################################
####################  WAIT  RPMNS  #### #########great jl 
################################################## 
      Line
      printf "\tWait for ${CYAN}$NOMACHINESpmn${NC} works rpmns\n"
      Line 
       #####################
      EACHTIMECHECK=20
      printf "\tBegin to check if some works rpmns ended \n"
      printf "\teach time ${GREEN}$EACHTIMECHECKrpmns seconds${NC} \n" 
for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    HOWMANYTIMES=0
    SALIDA=0 
    MAQUINA502=${MACHINESpmn[$hh]}
    DONDECORRE=${WORKpmnRemot[$hh]}
    DONDEWORKLO=${WORKpmnLocal[$hh]}
 
     cd $DONDEWORKLO
     while [ "$SALIDA" -lt "10" ]; do 
       sleep $EACHTIMECHECKrpmns
       let "HOWMANYTIMES=HOWMANYTIMES+1"
    if [ -e rpmnEND ];then 
        EACHTIMECHECKrpmns=1
        SALIDA=20
        printf "\t$DONDECORRE "
        printf "\t[${GREEN}end${NC}] [${BLU}$MAQUINA502]${NC}\n" 
        printf "\t${GREEN}-------------${NC}\n"
         let "NOOFWR=hh+1"
         printf "\t Work No. ${GREEN}$NOOFWR${NC} "
         printf "of total ${GREEN}$NOMACHINESpmn${NC}\n"
         printf "\t${GREEN}------------${NC}\n"       
     fi 
     done
     cd .. 
done

#  printf "\tI have checked: ${GREEN}$HOWMANYTIMES${NC} times\n"
  TIMEENDRPMNS=`date`
        TIME1s=`date --date="$TIMESTARTRPMNS" +%s`
        TIME2s=`date --date="$TIMEENDRPMNS" +%s`
        printf "\tStart to Runing RPMNS in parallel at time: "
        printf " ${GREEN}$TIMESTARTRPMNS ${NC}\n"
        printf "\t  End to Runing RPMNS in parallel at time: "
        printf " ${GREEN}$TIMEENDRPMNS ${NC}\n"
        ELTIMEs=$[ $TIME2s - $TIME1s ]
        TMINs=$(echo "scale=9; $ELTIMEs/60" | bc)
        TMIN1s=$(echo "scale=9; $ELTIMEs/3600" | bc)
        printf "\ttake RPMNS:   $TMINs min.\n"
        printf "\ttake RPMNS:   $TMIN1s Hrs.\n" 
##################################################
####################  COPYING FROM REMOTE  #######
##################################################  
    Line
    TIMESTARTco=`date`
    printf "\t${CYAN}Begin to copy from remotes servers${NC}\n" 
    for  ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
     sleep .1
     let "kk=hh+1"
     CAZO=$CASO"_"$kk
      REMOTESERVER=${MACHINESpmn[$hh]}
      WWLO="$PWD/$CAZO"
      DEDONDECOPY="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
      rsh $REMOTESERVER "cd $DEDONDECOPY;$WHERE/execCopyRemoteServer.sh $HOST $WWLO"
     done 
   TIMEENDco=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: ${GREEN}$TIMEENDco ${NC}\n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTco" +%s`
      TIME2=`date --date="$TIMEENDco" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"

    Line       
##################################################
####################just look for the name########
################################################## 

ESPINcheck=`grep nspinor $CASO'_check'/$CASO.out | awk -F= '{print $4}' | awk '{print $1}'`

ESPINsetUp=`grep nspinor setUpAbinit_$CASO.in  |  awk '{print $2}'`     
    if [ $ESPINsetUp == '1' ];then
               WHATSPIN='nospin'
    else
               WHATSPIN='spin'
    fi
    ECUTsetUp=`grep ecut setUpAbinit_$CASO.in  |  awk '{print $2}'`
     LASTNAME='_'$ECUTsetUp'-'$WHATSPIN
    printf "\t${GREEN}Concatenating ....${NC}\n"
    JOBS/concatenatefiles.pl $OPT1 $OPT2 $ESPINsetUp


    rm -f tmpX
    grep nband2 setUpAbinit_$CASO.in > tmpX
    Nmax=`head -1 tmpX | awk '{print $2}'`
    rm -f tmpX

    rm -f tmpA tmpB tmpC tmpD
    grep -n 'occ ' $DIRCHECK/$CASO.out > tmpA
    iocc=`awk -F: '{print $1}' tmpA`
    grep -n 'prtvol' $DIRCHECK/$CASO.out > tmpB
    iprtvol=`awk -F: '{print $1}' tmpB`
    awk 'NR=='$iocc',NR=='$iprtvol'' $DIRCHECK/$CASO.out > tmpC
    grep -o 1.000 tmpC > tmpD

    Nvf=`wc tmpD | awk '{print $2}'`
    if [ $Nvf == '0' ];then
        grep -o 2.000 tmpC > tmpD
        Nvf=`wc tmpD | awk '{print $2}'`
    fi
    Nct=`expr $Nmax - $Nvf`
    rm -f tmpA tmpB tmpC tmpD

   if [ -e energy.d ];then
       echo $NKPT > eigen_$NKPT$LASTNAME
       echo $Nvf >> eigen_$NKPT$LASTNAME
       echo $Nct >> eigen_$NKPT$LASTNAME
    cat energy.d >> eigen_$NKPT$LASTNAME
     printf "\t ${GREEN}You create:${NC}  eigen_$NKPT$LASTNAME\n" 
   fi

   if [ -e pmn.d ];then
       mv pmn.d pmn_$NKPT$LASTNAME
     printf "\t              pmn_$NKPT$LASTNAME \n"  
   fi

   if [ -e spinmn.d ];then
       mv spinmn.d spinmn_$NKPT$LASTNAME
    printf "\t              spinmn_$NKPT$LASTNAME \n"
   fi

### keep memory about you run
     cp -f setUpAbinit_"$CASO".in  .setUpAbinit_"$CASO".in
     cp -f "$CASO".xyz  ."$CASO".xyz

     printf "\t${GREEN}==============================${NC}\n"

  TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: ${GREEN}$TIMEENDALL ${NC}\n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
printf "\t I have find the end ..\n"
