#!/bin/bash
      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
  MAGENTA='\e[0;35m'
      MAG='\e[0;35m'

       NC='\e[0m' # No Color

##====== DEFINITIONS ===========   
       ##WHERE="/home/$USER/vino"
         WHERE="/home/jl/vino"
       
     WHERE=`dirname $0`    
     printf "\t${BLUE}`dirname $0`/${GREEN}`basename $0`${NC}\n "
     #### great idea jl jajaja september 30 2007
 


       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`  

 

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
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127 
      fi 
      }
###<><><>><><><><><><><><><><><><><><><><><>
###<><><>><><><> begin code <><><><><><><><>
###<><><>><><><><><><><><><><><><><><><><><>
  if [ "$#" -ne 4 ];then
   printf "\tUsage:\n\t$WHERE/`basename $0`"
   printf " [${GREEN}xGrid${NC}]"
   printf " [${GREEN}yGrid${NC}] [${GREEN}zGrid${NC}]"
   printf " [${GREEN}option4${NC}]\n"
   printf "\t[option4] wien2k or abinit \n"
   printf "\t$WHERE/`basename $0`  10 10 10 wien2k\n"
   printf "\t$WHERE/`basename $0`  10 10 10 abinit\n"
   StopMe
  fi 
       
       ####
        xxG=$1        
        yyG=$2
        zzG=$3
       CUAL=$4

   if [ -z $xxG ];then
      xxG=10
      printf "\t${RED}Hold on${NC} the value of the grid X = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid X = $xxG\n"
      #StopMe
     fi
     if [ -z $yyG ];then
      yyG=10
      printf "\t${RED}Hold on${NC} the value of the grid Y = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Y = $yyG\n"
      #StopMe
      
     fi
     if [ -z $zzG ];then
      zzG=10
      printf "\t${RED}Hold on${NC} the value of the grid Z = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Z = $zzG\n"
      #StopMe
     fi
     ##
     if [ -z $CUAL ];then
      CUAL="abinit"
     fi 

###<><><><><><><><><><><><><><><><><><><><>
###<><><><><><><><><><><><><><><><><><><><>
###<><><><><><><><><><><><><><><><><><><><>
     if [ ! -e symmetries/pvectors ];then
     printf "\t There isnt FILE: symmetries/pvectors \n"
     printf "\t Run first: abinit_check.sh \n"
     StopMe
     fi
     if [ ! -e symmetries/sym.d ];then
     printf "\t There isnt FILE: symmetries/sym.d \n"
     printf "\t Run first: abinit_check.sh \n"
     StopMe
     fi
 
     if [ $CUAL == "wien2k" ];then 
       if [ ! -e $CASO.struct ];then 
        printf "\t you need a FILE:  $CASO.struct \n"
        StopMe
       fi 
       if [ ! -d $CASO ];then
       mkdir $CASO
       fi 
       cd $CASO
       printf "\tMaking FILE: grid with: $xxG  $yyG $zzG\n" 
       rm -f grid 
       echo $xxG $yyG $zzG > grid
       cp ../symmetries/pvectors .
       cp ../symmetries/sym.d .
       cp ../$CASO.struct .
       isThereFile $WHERE/ibz.xeon
  rm -f killme 
$WHERE/ibz.xeon -wien2k -tetrahedra -cartesian -symmetries -reduced -mesh 
  if [ -e killme ];then  
   printf "Error with WHERE/ibz.xeon\n"
   StopMe
  fi   
    rm -f $CASO.struct
    isThereFile kpoints.reciprocal
    NKPT=`wc kpoints.reciprocal | awk '{print $1}'`
     cp kpoints.reciprocal ../$CASO.klist_$NKPT
     cp kpoints.reciprocal $CASO.klist_$NKPT
    isThereFile kpoints.cartesian  
     cp kpoints.cartesian ../symmetries/$CASO.kcartesian_$NKPT
     cp kpoints.cartesian $CASO.kcartesian_$NKPT
    isThereFile tetrahedra
     cp tetrahedra ../symmetries/tetrahedra_$NKPT
     cp tetrahedra   tetrahedra_$NKPT
    isThereFile Symmetries.Cartesian
     cp Symmetries.Cartesian ../symmetries/Symmetries.Cartesian_$NKPT
     cp Symmetries.Cartesian Symmetries.Cartesian_$NKPT

     isThereFile kpoints.wien2k
     cp kpoints.wien2k ../$CASO.kpoints.wien2k_$NKPT
     cp kpoints.wien2k  $CASO.kpoints.wien2k_$NKPT 
     printf "\n"
     
     printf "\t files generated\n"
     printf "\twien2k: ${MAGENTA}$CASO.kpoints.wien2k_$NKPT${NC}\n"
     printf "\twien2k: ${MAGENTA}$CASO.kpoints.wien2k_$NKPT -->${NC} " 
     #printf "\tabinit: ${MAGENTA}$CASO.klist_$NKPT${NC}\n"
    cp $CASO.kpoints.wien2k_$NKPT ../$CASO.klist
  
  printf "${MAGENTA}$CASO.klist${NC}\n"   

 
     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}$CASO.kcartesian_$NKPT${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}tetrahedra_$NKPT ${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}Symmetries.Cartesian_$NKPT ${NC}\n"   
    printf "\tyou just generated Nk=${GREEN}$NKPT${NC} kpoints \n" 
  
   printf "\t I found the end ...${GREEN}ok${NC}\n"
    
   cd ..
   exit 127
   fi #### end  wien2k 
   
    if [ $CUAL == "abinit" ];then 
      
      if [ ! -d TMP ];then
       mkdir TMP
      fi 
       cd TMP
       printf "\tMaking FILE: grid with: $xxG  $yyG $zzG\n" 
       rm -f grid 
       echo $xxG $yyG $zzG > grid
       cp ../symmetries/pvectors .
       cp ../symmetries/sym.d .
       isThereFile $WHERE/ibz.xeon
 $WHERE/ibz.xeon -abinit -tetrahedra -cartesian -symmetries -reduced -mesh

    isThereFile kpoints.reciprocal
    NKPT=`wc kpoints.reciprocal | awk '{print $1}'`
     mv kpoints.reciprocal ../$CASO.klist_$NKPT
    isThereFile kpoints.cartesian  
     mv kpoints.cartesian ../symmetries/$CASO.kcartesian_$NKPT
    isThereFile tetrahedra
     mv tetrahedra ../symmetries/tetrahedra_$NKPT
    isThereFile Symmetries.Cartesian
     mv Symmetries.Cartesian ../symmetries/Symmetries.Cartesian_$Nk
     printf "\n"
     printf "\t ABINIT MODE your files generate\n"
     printf "\t${MAGENTA}$CASO.klist_$NKPT${NC}\n"
     
     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}$CASO.kcartesian_$NKPT${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}tetrahedra_$NKPT ${NC}\n"

     printf "\t${BLUE}symmetries${NC}/"
     printf "${MAGENTA}Symmetries.Cartesian_$NKPT ${NC}\n"
  
    printf "\tyou just generated Nk=${GREEN}$NKPT${NC} kpoints \n"    
    printf "\t I found the end ABINIT MODE...${GREEN}ok${NC}\n"
      StopMe
    fi   


  



