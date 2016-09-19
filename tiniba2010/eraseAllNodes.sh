#!/bin/bash
##AUTHOR: Jose Luis Cabellos 
##Centro de Investigaciones en Optica A.C.
##Leon, Guanajuato Mexico
## LAST MODIFICATION :: Febrero 25 2010 at 01:25 by jlc

    RED='\e[0;31m'
   BLUE='\e[0;34m'
    BLU='\e[1;34m'
   CYAN='\e[0;36m'
  GREEN='\e[0;32m'
    GRE='\e[1;32m'
 YELLOW='\e[1;33m'
     NC='\e[0m' # No Color
   BASEDIR=`dirname $PWD`
      CASO=`basename $PWD`
    PARENT=`basename $BASEDIR`
  HOSTNAME=`hostname`
  DIRSCF=$CASO'_scf'
 SETUPABINITp=.setUpAbinit_"$CASO".in
 COORDINATESp=."$CASO".xyz
  declare -a MACHINESpmn
     if [ $# -ne 1 ];then
         printf "\tUsage: `basename $0` erase\n"
         printf "\tUsage: `basename $0` erasescf\n"
         exit 1
     else 
        if [ ! -e .machines_pmn ];then
         printf "\t.machines_pmn doesnt exist ... \n"
         printf "\t${RED}Stoping right now ...${NC}"
         exit 1
        else
         MACHINESpmn=(`cat .machines_pmn`)
         NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
        fi
        #
        if [ ! -e .machines_scf ];then
         printf "\t.machines_scf doesnt exist ... \n"
         printf "\t${RED}Stoping right now ...${NC}"
         exit 1
        else
         MACHINESscf=(`cat .machines_scf`)
         NOMACHINESscf=`echo ${#MACHINESscf[@]}`
        fi 
        ####--------------
        if [ $1 -eq $1 2> /dev/null ]; then
          printf "\tUsage: `basename $0` erase\n"
          printf "\tUsage: `basename $0` erasescf\n"
          exit 1
        else 
         INPUT=`echo $1 | tr A-Z a-z`
          if [ "$INPUT" == "erase" ] || [ "$INPUT" == "erasescf" ] ;then 
          printf "\n"
          else
           printf "\tUsage: `basename $0` erase\n"
           printf "\tUsage: `basename $0` erasescf\n"
           exit 1
          fi
        fi
     fi

if [ "$INPUT" == "erase" ];then
  printf "\t Erasing REMOTE\n"
  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
   sleep .3
   let "kk=hh+1"
     MAQUINA501=${MACHINESpmn[$hh]}
     CAZO=$CASO"_"$kk
     BORRAREMOTE="/data/$USER/workspace/$PARENT"  
     BORRAREMOTEA="/data/$USER/workspace"
     EXISTEa=`rsh $MAQUINA501 'test -d '$BORRAREMOTE'; echo $?'`
     if [ $EXISTEa -eq 0 ] ;then
      printf " [$kk] $MAQUINA501:$BORRAREMOTEA/${BLUE}$PARENT${NC} "     
      printf "/${BLUE}$CAZO${NC} [${GREEN}erasing${NC}] (Remote)\n" 
      #printf " [${GREEN}abinis${NC}] [${GREEN}Finish${NC}] "   
      rsh $MAQUINA501 "rm -rf $BORRAREMOTE"
     else 
      printf " [$kk] $MAQUINA501:$BORRAREMOTEA/${BLUE}$PARENT${NC} "     
      printf "/${BLUE}$CAZO${NC} [${GREEN}alrready erased${NC}] (Remote)\n" 
     fi 
     
   done
    for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
     sleep .1
     let "kk=hh+1"
     CAZO=$CASO"_"$kk
     BORRALOCAL=$PWD/$CAZO
   printf " [$kk] $PWD/${BLUE}$CAZO${NC} [${GREEN}erasing${NC}] (Local)\n"   
     rm -rf $BORRALOCAL    
    done
    printf "\n"
fi # fi erase
    if [ "$INPUT" == "erasescf" ];then
       rm -f  $SETUPABINITp
       rm -f $COORDINATESp
       printf "\t Erasing SCF\n"
       WHATDIR="$PWD/$DIRSCF"
        printf "\t$PWD${BLUE}/$DIRSCF${NC} "
        printf "   [${GREEN}erasing${NC}]\n"
        rm -rf $PWD/$DIRSCF
    fi 
exit 0
