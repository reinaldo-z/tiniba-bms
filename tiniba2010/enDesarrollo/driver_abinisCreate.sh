#!/bin/bash
##
GREEN='\e[0;32m'
green='\e[1;32m'
YELLOW='\e[1;33m'
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color
##copiaCASOin.sh
##copiaSTANDAR.sh
## cabellos-Quiroz J. L.
        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace"
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'  
  #   DIRSCF=$CASO'_scf'
  DONDEVIVO=`dirname $0`     
  SETUPABINIT=setUpAbinit_$CASO.in
 # CUAL_ONE=$DONDEVIVO/one_node_cabellos.sh
  #WAVEFUNCTION=$REALCAZO"o_DS2_WFK"
  #   ABINITIN=$REALCAZO.in
  #ABINITFILES=$REALCAZO.files
  #  DONTATODO=`dirname $7`
          WFK=$CASO'o_DS2_WFK' 
   PUTASALIDA=$CASO.out
   PUTASALIDAall=$CASO.out*
     ABINITFILES=$CASO.files

  
     BASEABINIT="/home/prog/abinit"
     ABINIs_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinis.xeon"
     ABINIp_XEON="$BASEABINIT/ABINITv4.6.5_XEON/abinip.xeon"
     ABINIs_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinis.itan"
     ABINIp_ITAN="$BASEABINIT/ABINITv4.6.5_ITAN/abinip.itan"
     ABINIs_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinis.quad"
     ABINIp_QUAD="$BASEABINIT/ABINITv4.6.5_QUAD/abinip.quad"
      MPICH_XEON="/usr/local/mpich_gm_intel9/bin"
      MPICH_ITAN="/usr/local/mpich-itanium-intel9/bin"
      MPICH_QUAD="/home/mvapich-intel/bin/mpirun_rsh"
        

##====== FUNCTIONS ============ 
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127    
       }
############################################## cabellos ####################
############################################## cabellos ####################
############################################## cabellos ####################
##===CHECK IF .machines file exist==================== !!
  if [ ! -e .machines_pmn ]
      then
        printf "\t ${RED}There is not .machines_pmn${NC}\n"
        touch -f killme
        StopMe
  else
     MACHINESpmn=(`cat .machines_pmn`)
     NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
  fi
###################################################
###################################################
##################################################
   for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
        let "kk=hh+1"
        CAZO=$CASO"_"$kk
         REMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         LOCAL[$hh]="$PWD/$CAZO"
   done
###################################################
###################################################
  for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
    let "HHSU=$hh+1"
       REMOTESERVER=${MACHINESpmn[$hh]}
       REMO=${REMOTE[$hh]}
       LOCA=${LOCAL[$hh]}
       printf "\tCreating:  abinis_$HHSU.sh \n"
        echo "#!/bin/bash "                  > abinis_$HHSU.sh
        echo "## `date`  :: Cabellos JL"      >> abinis_$HHSU.sh
        echo "## todo corrio en:"           >> abinis_$HHSU.sh
        echo "## $PWD:"                     >> abinis_$HHSU.sh
        echo "  GREEN='\\e[0;32m' "         >> abinis_$HHSU.sh
        echo "    RED='\\e[1;31m' "         >> abinis_$HHSU.sh
        echo "     NC='\\e[0m' # No Color " >> abinis_$HHSU.sh
        echo " TIMESTARTALL=\`date\`"  >> abinis_$HHSU.sh 
        echo "  HOSTIASANTA=\`hostname\`"  >> abinis_$HHSU.sh 
        echo "  ABINITFILES=$ABINITFILES"      >> abinis_$HHSU.sh     
        echo "          WFK=$WFK"      >> abinis_$HHSU.sh 
        echo "   PUTASALIDA=$PUTASALIDA"      >> abinis_$HHSU.sh   
        echo "PUTASALIDAall=$PUTASALIDAall"      >> abinis_$HHSU.sh
        echo "  ABINIs_XEON=$ABINIs_XEON"        >> abinis_$HHSU.sh
        echo "  ABINIs_ITAN=$ABINIs_ITAN"  >> abinis_$HHSU.sh
        echo "  ABINIs_QUAD=$ABINIs_QUAD"  >> abinis_$HHSU.sh
        echo "  if [[ "\$HOSTIASANTA" == "node"* ]]; then " >> abinis_$HHSU.sh 
        echo "        ABIRUN=\$ABINIs_XEON"  >> abinis_$HHSU.sh 
        echo "  fi"   >> abinis_$HHSU.sh 
        echo "  if [[ "\$HOSTIASANTA" == "itanium"* ]]; then " >> abinis_$HHSU.sh 
        echo "        ABIRUN=\$ABINIs_ITAN"  >> abinis_$HHSU.sh 
        echo "  fi"   >> abinis_$HHSU.sh 
        echo "  if [[ "\$HOSTIASANTA" == "quad"* ]]; then " >> abinis_$HHSU.sh 
        echo "        ABIRUN=\$ABINIs_QUAD"  >> abinis_$HHSU.sh 
        echo "  fi"   >> abinis_$HHSU.sh 

        echo "    RUNABISPA=0 "        >> abinis_$HHSU.sh 
        echo "          SAL=\$1 "        >> abinis_$HHSU.sh 
        echo "if [ -e \"\$WFK\" ] && [ -e \"\$PUTASALIDA\" ];then "  >> abinis_$HHSU.sh  
        echo "         WHEN=\`stat \$WFK | grep Modify\`"          >> abinis_$HHSU.sh 
        echo "  CALCULATION=\`awk '/Calculation/ { print }' \$PUTASALIDA\`" >> abinis_$HHSU.sh   
        echo "      if [ -z \"\$CALCULATION\" ];then " >> abinis_$HHSU.sh
        echo "             RUNABISPA=1"  >> abinis_$HHSU.sh
        echo "              rm -f \$PUTASALIDAall" >> abinis_$HHSU.sh    
        echo "      else"   >> abinis_$HHSU.sh   
        echo "      CUANTO=\`du -h \$WFK\` "  >> abinis_$HHSU.sh   
        echo "        printf \"\\t\$CUANTO : \${GREEN}\$CALCULATION \${NC} \" "  >> abinis_$HHSU.sh
        echo "        printf \"in node [\${GREEN}\`hostname\`\${NC}]\\n\" "   >> abinis_$HHSU.sh
        echo " touch abineta " >> abinis_$HHSU.sh
        echo " ./pmn_$HHSU.sh " >> abinis_$HHSU.sh
        echo "      fi"   >> abinis_$HHSU.sh 
        echo "else" >> abinis_$HHSU.sh
        echo "             RUNABISPA=1"  >> abinis_$HHSU.sh                     
        echo "fi"   >> abinis_$HHSU.sh                        
        #echo "       echo \$ABIRUN " >> abinis_$HHSU.sh 
        #####
        #####
       
        echo " if [ \$RUNABISPA -eq 1 ];then " >> abinis_$HHSU.sh      
 echo "   printf \"\tRunning: \$ABIRUN in [\${GREEN}\`hostname\`\${NC}] \$SAL \n\" " >> abinis_$HHSU.sh
 echo "rm -f $CASO.out* " >> abinis_$HHSU.sh 
 echo "time \$ABIRUN < \$ABINITFILES > log " >> abinis_$HHSU.sh 
       echo "sleep 3"   >> abinis_$HHSU.sh
        echo "             let \"SAL=SAL+1\" " >> abinis_$HHSU.sh
     echo " if [ \"\$SAL\" -lt \"4\" ];then " >> abinis_$HHSU.sh          
            echo "  \`basename \$0\` \$SAL " >> abinis_$HHSU.sh 
          echo "else" >> abinis_$HHSU.sh
           echo " printf \"\\tIn node [\${GREEN}\`hostname\`\${NC}] Im not able to run:\\n\" "   >> abinis_$HHSU.sh
          echo "printf \"\\t\$ABIRUN < \$ABINITFILES > log\\n\" ">> abinis_$HHSU.sh
          echo "printf \"\t\${RED}Stop Right now ...\${NC}\\n\" ">> abinis_$HHSU.sh
          echo "fi"   >> abinis_$HHSU.sh                                      
        echo "fi"   >> abinis_$HHSU.sh                        
       chmod 777 abinis_$HHSU.sh
       #$DONDEVIVO/copiaSTANDAR.sh abinis_$HHSU.sh   $REMOTESERVER $REMO
        mv abinis_$HHSU.sh $LOCA/
  done 
