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
         #WHERE="/home/jl/vino"
         WHERE=`dirname $0`
        WIEN2K="/home/bms/wien2k_04"
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`


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

  if [ -e $CASO.klist ];then
   NK=`wc -l $CASO.klist | awk '{print $1}'`
    let "NKPT = NK-1"
   printf "\t Taking Number of K points = ${GREEN}$NKPT${NC}"
   printf " in from   : "
   printf "${GREEN}$CASO.klist${NC}\n"
  else
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
echo $CASO.mme.abinit_$NKPT >> in2mmeReader
sed -e 's/mme/energy/g' in2mmeReader > in2energyReader
NATOM=`echo n | instgen | awk '{print $1}' | head -1`
    
echo in2energyReader  $NATOM  | $WHERE/energyReader 
printf "\t${GREEN}press any key to continue....${NC}\n"
read -p " "
echo in2mmeReader  | $WHERE/mmeReader
                    










