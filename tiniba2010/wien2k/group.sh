#!/bin/bash
      RED='\e[0;31m'
     BLUE='\e[0;34m'
      BLU='\e[1;34m'
     CYAN='\e[0;36m'
    GREEN='\e[0;32m'
      GRE='\e[1;32m'
   YELLOW='\e[1;33m'
  MAGENTA='\e[0;35m'
       NC='\e[0m' # No Color
##====== DEFINITIONS ===========


         
         ###WHERE="/home/jl/vino"
         ## WHERE="/home/$USER/vino"
         WHERE=`dirname $0`
      printf "\t$WHERE/`basename $0`\n"

       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
     ANFITRION=`hostname`
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>

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
function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127
      fi
      }
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>
###<><><>><><><><><><><><><><><>

   if [ -e $SETUPABINIT ];then 
    ECUTsetUp=`grep ecut $SETUPABINIT  |  awk '{print $2}'`
    ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
    printf "\tfrom $SETUPABINIT :\n"
    printf "\t========================\n"
    printf "\tecut = $ECUTsetUp\n"
    printf "\tspin = $ESPINsetUp\n"
    printf "\t========================\n"
    if [ $ESPINsetUp == "1" ];then 
      NAM="nospin"
    fi 
    ###
    if [ $ESPINsetUp == "2" ];then 
      NAM="spin"
    fi     
   else 
   printf "\t You need a file: $SETUPABINIT \n"
   printf "\t Stop right now ...\n"
   exit 127
   fi 


if [ ! -d res ];then 
 mkdir res
fi 



  if [ -e $CASO.klist ];then
   NK=`wc -l $CASO.klist | awk '{print $1}'`
    let "NKPT = NK-1"
   printf "\t Taking Number of K points = ${GREEN}$NKPT${NC}"
   printf "  from   : "
   printf "${GREEN}$CASO.klist${NC}\n"
  else
    printf "\t There isnt FILE: $CASO.klist\n"
    StopMe
  fi 

rm -rf tmp1
ls $CASO.mme_* > tmp1
CUANTOS=`wc -l tmp1 | awk '{print $1}'`
rm -rf tmp1
 ii=0
while [ "$ii" -lt "$CUANTOS" ]; do
let "ii=ii+1"
  if [ "$ii" == "1" ];then
   echo  $CASO.mme_"$ii" > in2mmeReader
  else
   echo  $CASO.mme_"$ii" >> in2mmeReader
  fi
done

sed -e 's/mme/energy/g' in2mmeReader > in2energyReader
  echo pmn_$NKPT"_"$ECUTsetUp"-"$NAM >> in2mmeReader
echo eigen_$NKPT"_"$ECUTsetUp"-"$NAM >> in2energyReader

NATOM=`echo n | instgen | awk '{print $1}' | head -1`
 


if [ "$ANFITRION" == "master" ];then 
 isThereFile $WHERE/energyReader.xeon 
 isThereFile $WHERE/mmeReader.xeon
 echo in2energyReader  $NATOM  | $WHERE/energyReader.xeon 
 echo in2mmeReader | $WHERE/mmeReader.xeon
fi                     

if [ "$ANFITRION" == "itanium01" ];then  
  isThereFile $WHERE/energyReader.itan
  isThereFile $WHERE/mmeReader.itan
 echo in2energyReader  $NATOM  | $WHERE/energyReader.itan
 echo in2mmeReader | $WHERE/mmeReader.itan
fi 

if [ "$ANFITRION" == "quad01" ];then  
  isThereFile $WHERE/energyReader.quad
  isThereFile $WHERE/mmeReader.quad
 echo in2energyReader  $NATOM  | $WHERE/energyReader.quad
 echo in2mmeReader | $WHERE/mmeReader.quad
fi 


