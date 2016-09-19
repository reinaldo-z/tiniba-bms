#!/bin/bash
      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
      MAG='\e[0;35m'
       NC='\e[0m' # No Color

##====== DEFINITIONS ===========   
      
         WHERE=`dirname $0` ## great jl no anymore 
        WIEN2K="/home/bms/wien2k_04" 
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR` 
   SETUPABINIT=setUpAbinit_"$CASO".in
         CHECK="$CASO"_check"/$CASO.out"
      declare -a malla
      declare -a GFILES
##==============================

declare -a malla
###<><><>><><><><><><><><><><><><><><><><><>
###<><><>><><><> functions  <><><><><><><><>
###<><><>><><><><><><><><><><><><><><><><><>
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
 function Line {
      printf "\t${BLUE}=============================${NC}\n"
       }
 function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\tMake or copy one ...\n"
      printf "\t${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127 
      fi 
      }

 function hayArchivo {
      if [ -e "$1" ];then
        printf "\t$1 \n"
      fi 
      }

###<><><>><><><><><><><><><><><><><><><><><>
###<><><>><><><> begin code <><><><><><><><>
###<><><>><><><><><><><><><><><><><><><><><>
     if  [ $# -eq 0 ];then
       printf " Usage: \n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} "
       printf " [${CYAN}option-0${NC}] "
       printf " [${CYAN}option-1${NC}] \n"
       printf "\t[${CYAN}option-0${NC}] = scf "
       printf "   -run ONLY scf \n" 
       printf "\t[${CYAN}option-0${NC}] = klist"
       printf "  -generate rklist\n" 
       printf "\t[${CYAN}option-0${NC}] = run "
       printf "   -run ONLY momentum and energy  matrix elements \n" 
      
       printf "\t[${CYAN}option-0${NC}] = help"
       printf "   -example files for si bulk \n" 
       printf "\t[${CYAN}option-0${NC}] = clean_lapw"
       printf " -remove unnecessary files \n" 
      

       printf "\t[${CYAN}option-0${NC}] = whatneed"
       printf "   -what files I need  \n" 

       printf "\t[${CYAN}option-1${NC}] = 0.001"
       printf "      -energy convercence LIMIT (0.0001 Ry)\n" 

       printf "\t===================\n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} scf 0.001\n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} klist\n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} run \n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} clean_lapw\n"
       printf "\t$WHERE/${GREEN}`basename $0`${NC} help\n"
       StopMe
     fi 

#########################
#########################
#########################    
## jl nasty way to do this but there isnt time go go
 if [ "$1" != "scf" ];then
   if [ "$1" != "klist" ];then 
      if [ "$1" != "run" ];then
       if [ "$1" != "help" ];then
        if [ "$1" != "clean_lapw" ];then
         if [ "$1" != "whatneed" ];then
           printf "\toption no valid:  $1\n"
           printf "\tplease type: \n"
           printf "\t$WHERE/${GREEN}`basename $0`${NC} \n"
           printf "\tfor to view the valid options \n"
           StopMe
         fi       
        fi
       fi
      fi
   fi
 fi


#########################
if [ "$1" == "scf" ];then 
  if [ -z $2 ];then 
  ENERGY=".001"
   printf "\t${RED}WARRNING :${NC} \n"
   printf "\tenergy convercence LIMIT (0.0001 Ry) not defined \n"
   printf "\ttakeing the default: $ENERGY \n" 
   printf "\t4 second to kill me if not Im going to continue\n"
   sleep 4
  fi
fi 

#########################
#########################
#########################
      if [ "$1" == "clean_lapw" ];then 
        printf "\tremove unnecessary files ... \n"
        isThereFile $WIEN2K/clean_lapw
        $WIEN2K/clean_lapw
        StopMe
      fi 
#########################
#########################
#########################


     if [ "$1" == "help" ];then 
       if [ -e $WHERE/help.sh ];then 
       $WHERE/help.sh 
       else 
        printf "\tFiles examples for si bulk\n"
       printf "\t===========================\n"
       hayArchivo $WHERE/files/sibulk.struct
       hayArchivo $WHERE/files/sibulk.inop
       hayArchivo $WHERE/files/.machines 
       hayArchivo $WHERE/files/$SETUPABINIT
       hayArchivo $WHERE/files/sibulk.xyz 
        exit 127
       fi 
       
     fi 


     ## you need 
     if [ $USER != "bms" ];then 
        cp /home/bms/wien2k_04/lapw1 .
        cp /home/bms/wien2k_04/lapw2 .
        cp /home/bms/wien2k_04/lapw3 . 
        cp /home/bms/wien2k_04/lapw1c .
        cp /home/bms/wien2k_04/lapw2c .
        cp /home/bms/wien2k_04/lapw3c .
        cp /home/bms/wien2k_04/optic .
        cp /home/bms/wien2k_04/opticc .
     fi 
    


     
 if [ "$1" == "scf" ];then
  printf "\t ======= SCF ======= \n"
  isThereFile $CASO.struct
  if [ ! -e .machines ];then 
   printf "\t${RED}Hold on!${NC} There isnt FILE: .machines \n"
   printf "\tMake or copy one ...\n"
   printf "\t(be carrefully this is a special file in format WIEN2K)\n"
   printf "\tplase type:\n"
   printf "\t$WHERE/${GREEN}`basename $0`${NC} help\n"
   printf "\t look in the examples \n"
   StopMe
  fi 

  #######
  ####### Paso 1
  #######
  printf "\tStart ${MAG}Step 1${NC} : $WIEN2K/${GREEN}instgen_lapw${NC}\n"
  isThereFile $WIEN2K/instgen_lapw
  $WIEN2K/instgen_lapw  
  printf "\t  End ${MAG}Step 1${NC}\n"
  printf "\tprees any key to${GREEN} continue...${NC}   "
  read -p " "
  clear
  #######
  ####### Paso 2
  #######
  printf "\tStart ${MAG}Step 2${NC}: $WIEN2K/${GREEN}init_lapw${NC} \n"
  isThereFile $WIEN2K/init_lapw
  $WIEN2K/init_lapw
  printf "\t  End ${MAG}Step 2${NC}\n"
  printf "\tprees any key to${GREEN} continue...${NC}   "
  read -p " "
  clear

  if [ -e $CASO.in1c ];then 
      CENTROSYMMETRIC=0
      EMAX=`tail -1 $CASO.in1c | awk '{print $5}'`
      printf "\t${BLUE}===================${NC}\n"
      printf "\t${MAGENTA}non-centrosymmetric case${NC}\n"
      printf "\t${GREEN}$CASO.inop${NC} will be set with "
      printf "Emax=$EMAX from $CASO.in1c\n"
      #### Nkmax=50,000 Emin=-6.0 Emax=$Emax
      printf "\tMaking: $CASO.inop \n"
      echo 50000 1    >  $CASO.inop
      echo -6.0 $EMAX >> $CASO.inop
      echo 0          >> $CASO.inop
      printf "\t${BLUE}===================${NC}\n"
     fi 
     #######
     #######
     #######
     if [ -e $CASO.in1 ];then 
      CENTROSYMMETRIC=1
      EMAX=`tail -1 $CASO.in1 | awk '{print $5}'`
      printf "\t${BLUE}===================${NC}\n"
      printf "\t${MAGENTA}centrosymmetric case${NC}\n"
      printf "\t${GREEN}$CASO.inop${NC} will be set with "
      printf "Emax=$EMAX from $CASO.in1\n"
      #### Nkmax=50,000 Emin=-6.0 Emax=$Emax
      printf "\tMaking: $CASO.inop \n"
      echo 50000 1    >  $CASO.inop
      echo -6.0 $EMAX >> $CASO.inop
      echo 0          >> $CASO.inop
      printf "\t${BLUE}===================${NC}\n"
     fi

  printf "\tprees any key to${GREEN} continue...${NC}   "
  read -p " "
  clear 
  #######
  ####### Paso 2
  #######
  printf "\tStart ${MAG}Step 3${NC}: $WIEN2K/${GREEN}run_lapw -ec $ENERGY  -p${NC} \n"
     isThereFile $WIEN2K/run_lapw
     isThereFile $CASO.klist
     isThereFile .machines
     
  
      if [ -z $ENERGY ];then
        ENERGY=".001" ## THIS IS PARANOIA JL 
       printf "\t${RED}WARRNING :${NC} \n"
       printf "\tenergy convercence LIMIT (0.0001 Ry) not defined \n"
       printf "\ttakeing the default: $ENERGY \n" 
       printf "\t4 second to kill me if not Im going to continue\n"
       sleep 4
      fi
       
       $WIEN2K/run_lapw -ec $ENERGY -p
     


  printf "\t  End ${MAG}Step 3${NC}\n"

  mv $CASO.klist $CASO.klist_scf
  printf "\t${MAG}===============================${NC}\n"
   printf "\tMoving $CASO.klist $CASO.klist_scf  \n"
   printf "\tRight now you have to generate a $CASO.klist\n"
   printf "\trun ... \n"
   printf "\t$WHERE/`basename $0` klist\n"
  printf "\t${MAG}===============================${NC}\n"
  StopMe
 fi 
########################end scf
########################
########################

  if [ "$1" == "klist" ];then 
    printf "\t Generating klist\n"
     isThereFile $SETUPABINIT
     isThereFile $CASO.xyz 
     isThereFile .machines_pmn
     isThereFile .machines_scf
     isThereFile .machines_res
     isThereFile .machines_latm
     isThereFile /home/$USER/abinit_shells/utils/abinit_check.sh
     /home/$USER/abinit_shells/utils/abinit_check.sh 1
     /home/$USER/abinit_shells/utils/abinit_check.sh 2
     printf "\tprees any key to"
         printf "\t${GREEN} continue...${NC}"
         read -p " "
       clear 
      printf "\t${GREEN}Generate k points${NC}\n"
      printf "\t${GREEN}runing rkliswien2k.sh ${NC}\n"
      printf "\tset grid: (GENERATE THE KPOINTS)\n"
     printf "\t Give me the value of the grid X Y Z : " 
     read -r  gridxyz
       INDEX=1
       for GRI in $gridxyz;do
         #echo -n "$GRI"
         malla[$INDEX]=$GRI
         let "INDEX+=1"
       done
       ####
        xxG=${malla[1]}
        yyG=${malla[2]}
        zzG=${malla[3]}
      if [ -z $xxG ];then 
        xxG=35
        printf "\t${RED}Warrning${NC}: taking the fault Xgrid=$xxG\n" 
      fi  
      if [ -z $yyG ];then 
        yyG=35
        printf "\t${RED}Warrning${NC}: taking the fault Ygrid=$yyG\n" 
      fi  
      if [ -z $zzG ];then 
        zzG=35
        printf "\t${RED}Warrning${NC}: taking the fault Zgrid=$zzG\n" 
      fi  
      isThereFile $WHERE/rklistwien2k.sh 
      printf "\t rklistwien2k.sh $xxG $yyG $zzG wien2k \n"
      $WHERE/rklistwien2k.sh $xxG $yyG $zzG wien2k
  fi ## klist 

################
################
################
################
################
    if [ "$1" == "run" ];then 
     if [ -e $CASO.klist ];then 
      NK=`wc -l $CASO.klist | awk '{print $1}'`
      let "NK=NK-1"
        if [ -z $NK ];then
         printf "\t${RED}WARRNING:${NC}NK points=empty "
         printf "\tUnable to calculate N Kpoints of $CASO.klist\n"
         StopMe
        fi
        printf "\t Taking Number of K points = ${GREEN}$NK${NC} "
        printf "from $CASO.klist\n"
        sleep 2
      else 
       printf "\tYou need $CASO.klist \n"
       StopMe
     fi 
    ###
    isThereFile $CASO.struct
    isThereFile .machines
     ## CASO CENTRSYMMETRICO 
     if [ -e $CASO.in1 ];then
       /home/bms/wien2k_04/x lapw1 -p
        printf "\tprees any key to"
        printf "${GREEN} continue with optic...${NC}"
       # read -p " "
       /home/bms/wien2k_04/x optic -p
        printf "\tprees any key to"
        printf "\t${GREEN} continue with concatening...${NC}"
        read -p " "
      fi 
     ## CASO NON-CENTRSYMMETRICO       
      if [ -e $CASO.in1c ];then
        /home/bms/wien2k_04/x lapw1 -p -c
         #printf "\tprees any key to"
         printf "${GREEN} continue with optic...${NC}"
         #read -p " "
        /home/bms/wien2k_04/x optic -p -c
         #printf "\tprees any key to"
         printf "\t${GREEN} continue with concatening...${NC}"
         #read -p " "
      fi
   clear 
   isThereFile $WHERE/group.sh
    rm -f infoenergy2script
    rm -f infomm2script
   $WHERE/group.sh
     ########  


   if [ -e $CHECK ];then
    if [ -e $SETUPABINIT ];then
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

     ECUTsetUp=`grep ecut $SETUPABINIT  |  awk '{print $2}'`
     ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
     printf "\t===================================\n"
     printf "\tfrom $SETUPABINIT :\n"
     printf "\t     Total bands = $Nmax\n"
     printf "\t  valencia bands = $Nvf\n"
     printf "\tconduction bands = $Nct\n"
     printf "\t            ecut = $ECUTsetUp\n"
     printf "\t            spin = $ESPINsetUp\n"
     printf "\t===================================\n"
       if [ $ESPINsetUp == "1" ];then
               NAM="nospin"
       fi
          ###
       if [ $ESPINsetUp == "2" ];then
              NAM="spin"
       fi



    fi      
   fi

     ##############


if [ -e infoenergy2script ];then
       NBANDSwien=`awk '{print $1}' infoenergy2script`
       printf "\t     Total bands WIEN2K= $NBANDSwien\n"

      if [ "$NBANDSwien" != "$Nmax" ];then
       printf "\t${RED}=======================${NC}\n"
       printf "\t${RED}Warrning:(DO THIS PLEASE) ${NC}\n"
       printf "\t${RED}Warrning:(DO THIS PLEASE) ${NC}\n"
       printf "\t${RED}if not you not be able to"
       printf " calculate: responses_bms.sh ${NC}\n"
       printf "\t Modificate your : $SETUPABINIT \n"
       printf "\t put: \n"
       printf "\t nband2 = $NBANDSwien\n"
       printf "\t Actual is :nband2 = $Nmax \n"
       printf "\t${RED}=======================${NC}\n"
      fi  

     printf "\tRight now you are able to run: \n"
     printf "\t~/abinit_shells/utils/response_bms.sh \n"
      if [ -e "pmn_$NK"_"$ECUTsetUp"-"$NAM" ];then
       printf "\t   pmn_$NK"_"$ECUTsetUp"-"$NAM\n"
      fi 
      if [ -e "eigen_$NK"_"$ECUTsetUp"-"$NAM" ];then
       printf "\t eigen_$NK"_"$ECUTsetUp"-"$NAM\n" 
      fi 
      
       printf "\t     Total bands WIEN2K= $NBANDSwien\n"
       printf "\t valence bands & conduction bands \n"
       printf "\t Here you have to be able to calculate the number\n"
       printf "\tof valence and conduction bands, remember there are\n"
       printf "\tcore and semicore states or ask to bms\n"

 fi ## energy reader
      printf "\trun :\n"
      printf "\t$WHERE/revisa.sh\n"  
      printf "\tI found the end ${GREEN}termine ok${NC}\n"
    fi ## run


   if [ "$1" == "whatneed" ];then 
    printf "\t1.- $CASO.struct\n"
    printf "\t2.- .machines\n"
    printf "\t3.- $SETUPABINIT\n"
    printf "\t4.- $CASO.xyz\n"
    printf "\t5.- .machines_pmn\n"
    printf "\t6.- .machines_scf\n"
    printf "\t7.- .machines_res\n"
    printf "\t8.- .machines_latm\n"
    exit 127
   fi 

  #     printf "\t=========================\n"
#      printf "\t NOTA: \n"
#      printf "In Si, there are\n"
#      printf "1s - core state (calculated like a radial problem)\n"
#      printf "2s - core state\n"
#      printf "2p - core state\n"
#      printf "3s - valence state / calculated like a band (4 bands)\n"
#      printf "3p - valence state / calculated like a band (4 bands)\n"
 
#      printf "In GaAs, there are\n"
     
#     printf "\t1s - core state\n"
#     printf "\t2s - core state\n"
#     printf "\t2p - core state\n"
#     printf "\t3s - core state\n"
#     printf "\t3p - core state\n"
#     printf "\t3d - semi-core state / calculated like a band (20 bands)\n"
#     printf "\t4s - valence state  (4 bands)\n"
#     printf "\t4p - valence state  (4 bands)\n"





  
