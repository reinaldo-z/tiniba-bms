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

WHERE=`dirname $0`

##====== DEFINITIONS ===========
printf "\t${MAG} Run with script: $WHERE/wien2k.sh${NC}\n"
printf "\t$WHERE/wien2k.sh \n"
printf "\t$WHERE/wien2k.sh scf \n"
printf "\t$WHERE/vino/wien2k.sh klist \n"
printf "\t$WHERE/vino/wien2k.sh run \n"
printf "\t here you be able to run: response_bms.sh \n"
printf "\t end procedure\n"
 printf "\t******************************\n"
 printf "\t******************************\n"
 printf "\t******************************\n"
 printf "\t******************************\n"
 printf "\t******************************\n"
#printf "\t \n"
#printf "\t \n"
#printf "\t \n"

printf "\t ${MAG}Runing by hand : CASO NON-CENTRSYMMETRIC like sibulk ${NC}  \n"

printf "\t ============================\n"
printf "\t The esential files to run wien2k are:\n"
printf "\t (example of Si bulk )\n"
printf "\t 1.-sibulk.struct\n"
printf "\t 2.-.machines    \n"
printf "\t 3.-sibulk.inop  \n"
printf "\t ============================\n"


printf "\t ${MAG}STEP 1${NC} :/home/bms/wien2k_04/instgen_lapw \n"
printf "\t ${MAG}STEP 2${NC} :/home/bms/wien2k_04/init_lapw \n"
printf "\t Generate SCF \n"
printf "\t ${MAG}STEP 3${NC} :/home/bms/wien2k_04/run_lapw -ec .001 -p \n"
printf "\t ${MAG}STEP 4${NC} : mv sibulk.klist sibulk.klist_scf\n"
printf "\t Here you need: in oreder to generate a list of kpoints \n"
printf "\t 1.-setUpAbinit_sibulk.in \n" 
printf "\t 2.-sibulk.xyz  \n" 
printf "\t 3.-.machines_*  \n" 
printf "\t ${MAG}STEP 5${NC} : ~/abinit_shells/utils/abinit_check.sh 1\n"
printf "\t ${MAG}STEP 6${NC} : ~/abinit_shells/utils/abinit_check.sh 2\n"
printf "\t ${MAG}STEP 7${NC} : $WHERE/rklistwien2k.sh 30 30 30 wien2k \n"
printf "\t if centrosymmetric as Si\n"
printf "\t ${MAG}STEP 8${NC} : /home/bms/wien2k_04/x lapw1 -p \n"
printf "\t ${MAG}STEP 9${NC} : /home/bms/wien2k_04/x optic -p \n"
printf "\t ${MAG}STEP 10${NC} : $WHERE/group.sh  \n"
printf "\t  righ now:  ~/abinit_shells/utils/response_bms.sh\n"
printf "\t end procedure\n"
printf "\t ============================\n"
printf "\tExample files: \n"
printf "\t$WHERE/files/sibulk.struct \n"
printf "\t$WHERE/files/sibulk.inop \n"
printf "\t$WHERE/files/.machines  \n"
printf "\t$WHERE/files/setUpAbinit_sibulk.in  \n"
printf "\t$WHERE/files/sibulk.xyz\n"
printf "\t$WHERE/files/.machines_*  \n"
printf "\t$WHERE/files/gaas.struct\n"
printf "\t$WHERE/files/setUpAbinit_gaas.in  \n"
printf "\t$WHERE/files/gaas.xyz  \n"
