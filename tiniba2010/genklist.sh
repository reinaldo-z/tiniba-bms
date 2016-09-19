#!/bin/bash
## capelly 
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 NC='\e[0m' # No Color

 
      WHERE=`dirname $0`
        IBZ="$WHERE/SRC_ibz/ibzNew/ibz.quad"  
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     DIRSCF=$CASO'_scf'
      CHECK="$CASO"_check"/$CASO.out"
SETUPABINIT=setUpAbinit_"$CASO".in
 WFSCFLOCAL=$CASO'o_DS1_WFK'
  WFSCFREMOTE=$CASO'i_DS1_WFK'
   WF2DATASET=$CASO'o_DS2_WFK'



 declare -a malla
#########################
#########################
#########################
function message {
printf "\t$1\n"
}
function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   exit 127
 else 
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   printf "\t$1\n\n"
   exit 127
 fi 
    }
  ##<><><><><><><>
 
   if [ ! -e $IBZ ];then 
    printf "\t${RED}HOLD ON: !${NC} there isnt FILE: $IBZ \n"
    StopMe "do you know where it is?  jl"
   fi 

   if [  $# -eq 0 ] || [ $# -gt 2 ] || [ $# -eq 1 ] ;then
    message "Usage:"
    message "${GREEN}`basename $0`${NC} firstpass abinit"
    message "${GREEN}`basename $0`${NC} firstpass wien2k"
    message "${GREEN}`basename $0`${NC} npass abinit"
    message "${GREEN}`basename $0`${NC} npass wien2k"
    StopMe "Need arguments..."
   fi
   
   if [ "$1" != "firstpass" ];then  
     if [ "$1" != "npass" ];then  
      message "Usage:"
      message "${GREEN}`basename $0`${NC} firstpass abinit"
      message "${GREEN}`basename $0`${NC} firstpass wien2k"
      message "${GREEN}`basename $0`${NC} npass abinit"
      message "${GREEN}`basename $0`${NC} npass wien2k"
      StopMe "Need arguments..." 
     fi
   fi
    if [ "$2" != "abinit" ];then  
     if [ "$2" != "wien2k" ];then  
      message "Usage:"
      message "${GREEN}`basename $0`${NC} firstpass abinit"
      message "${GREEN}`basename $0`${NC} firstpass wien2k"
      message "${GREEN}`basename $0`${NC} npass abinit"
      message "${GREEN}`basename $0`${NC} npass wien2k"
      StopMe "Need arguments..."
     fi
   fi


   ### paranoia dejalo jl 
   if [ ! -e $IBZ ];then
    StopMe "There isnt FILE: $IBZ"
   fi 



   if [ ! -d symmetries ];then
      StopMe "Because there isnt dir : ${BLUE}symmetries${NC}"  
   fi
   ##<><><><><><><>
   if [ ! -e symmetries/pvectors ];then
      StopMe "Because there isnt file : ${BLUE}symmetries${NC}/pvectors"
   fi
   ##<><><><><><><>
   if [ ! -e symmetries/sym.d ];then
      StopMe "Because there isnt file : ${BLUE}symmetries${NC}/sym.d"
   fi
   ##<><><><><><><>
   if [ ! -d whichCubesToDivide ];then 
     message "Making ${BLUE}whichCubesToDivide${NC}"
     mkdir whichCubesToDivide
   else 
     message "${BLUE}whichCubesToDivide${NC}          [${GREEN}ok${NC}]"
   fi 
   ##<><><><><><><>
    
   
   
if [ ! -e symmetries/pvectors ];then
 message "copy symmetries/pvectors  ${BLUE}whichCubesToDivide${NC}"
 cp symmetries/pvectors  whichCubesToDivide 
else 
 message "${BLUE}whichCubesToDivide${NC}/pvectors [${GREEN}ok${NC}]"
fi 
##<><><><><><><>
if [ ! -e symmetries/sym.d ];then
 message "copy symmetries/sym.d  ${BLUE}whichCubesToDivide${NC}"
 cp symmetries/sym.d  whichCubesToDivide  
else 
  message "${BLUE}whichCubesToDivide${NC}/sym.d    [${GREEN}ok${NC}]"
fi 
 
  ##<><><><><><><>
  ##<><><><><><><>
  ##<><><><><><><>
  
cd  whichCubesToDivide
 DIR=`pwd`

 if [ $1 == "firstpass" ];then 
       printf "\tset grid:(I need the grid first time)\n"
       printf "\t Give me the value of the grid X Y Z : "
       read -r  gridxyz
       INDEX=1
       for GRI in $gridxyz;do
         malla[$INDEX]=$GRI
         let "INDEX+=1"
       done
        xxG=${malla[1]}
        yyG=${malla[2]}
        zzG=${malla[3]}
     if [ -z $xxG ];then
      xxG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid X = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid X = $xxG\n"
      #StopMe
     fi
     if [ -z $yyG ];then
      yyG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid Y = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Y = $yyG\n"
      #StopMe

     fi
     if [ -z $zzG ];then
      zzG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid Z = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Z = $zzG\n"
      #StopMe
     fi
     ##
       printf "\tMaking FILE: grid with: $xxG  $yyG $zzG\n"
      echo $xxG $yyG $zzG > grid
      ls *WFK*
      rsh quad01 "cd $DIR; $IBZ -"$2" -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map"  
      if [ -e $WHERE/whichCubes.sh ];then 
       read -p "press"
       $WHERE/whichCubes.sh
      else 
       StopMe "I need $WHERE/whichCubes.sh"
      fi 
 fi ## firspaass 
########
########
########
######## 
if [ $1 == "npass" ];then 
printf "\tgive me pass: "
    read PASS
    if [ -z $PASS ] || [ "$PASS" == "0" ];then
      StopMe "pass has to be a bigger than 0"
    fi 
    let "PAZ=PASS-1"
    KpointsReciprocal=kpoints.reciprocal"$PAZ"
    CubesToDivide=cubesToDivide"$PAZ"
    if [ ! -e $CubesToDivide ];then
    printf "\tRun first refine: \n"
    StopMe "There isnt file: $CubesToDivide\n" 
    fi 

    NKPTT=`wc $KpointsReciprocal | awk '{print $1}'`
    if [ -e ../energys.d_$NKPTT* ];then     
     cp -v ../energys.d_$NKPTT* energys.d
    else 
     printf  "\tyou have to generate a file:  energys.d_$NKPTT*\n" 
     StopMe "run a any response first ..." 
    fi 


    echo $NKPTT 
    echo $PASS
      ls *WFK*
       
      rsh quad01 "cd $DIR; $IBZ -"$2" -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map -pass $PASS"  
      #$HOME/macondo/whichCubes.sh
      echo running ...
      $WHERE/whichCubes.sh
       StopMe


fi 












StopMe "Wait"

 printf "\t===============\n"
 printf "${GREEN}/home/jl/macondo/SRC_ibz/ibzNew/ibz.quad -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map${NC}\n"
 printf "\t===============\n"
printf "${GREEN}/home/jl/tiniba/ibz/ibzNew/ibz.quad -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map -pass 1${NC}\n"

 
