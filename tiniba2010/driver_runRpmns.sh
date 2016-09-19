#!/bin/bash
## LAST MODIFICATION : Febrero 23 2010 by JL Cabellos
## LAST MODIFICATION : Junio 07 2010 by JL Cabellos

## reporte bugs < sollebac@gmail.com >

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

        DIR=$PWD
       USER=$USER
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     PARENT=`basename $BASEDIR`
  WORKZPACE="workspace"
 WFSCFLOCAL=$CASO'o_DS1_WFK'
WFSCFREMOTE=$CASO'i_DS1_WFK'
        WFK=$CASO'o_DS2_WFK'  
     DIRSCF=$CASO'_scf'
  DONDEVIVO=`dirname $0`     
      
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
      RPMNS_QUAD="$HOME/abinit_shells/matrix_elements/rpmns.quad"
   




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
        REMOTESERVER=${MACHINESpmn[$hh]}
         REMOTE[$hh]="/data/$USER/$WORKZPACE/$PARENT/$CAZO"
         REMOTEs[$hh]="/data.$REMOTESERVER/$USER/$WORKZPACE/$PARENT/$CAZO"
         LOCAL[$hh]="$CAZO"
         #echo ${REMOTEs[$hh]}
   done

###################################################
###################################################
 for ((hh=0;hh<=($NOMACHINESpmn-1); hh++));do
   # for ((hh=0;hh<=(1); hh++));do
    let "HHSU=$hh+1"
       REMOTESERVER=${MACHINESpmn[$hh]}
       REMO=${REMOTE[$hh]}
       REMOS=${REMOTEs[$hh]}
       LOCA=${LOCAL[$hh]}
          QUECORRES="abinis_$HHSU.sh"
          CASI=`basename $REMO`
        CAMINO=`dirname $REMO` 
    printf "\t$REMOTESERVER : $CAMINO/${BLUE}$CASI${NC} \n"
        echo "#!/bin/bash "                  > pmns_$HHSU.sh
        echo "## `date`  :: Cabellos JL"     >>pmns_$HHSU.sh
        echo "## todo corrio en:"            >>pmns_$HHSU.sh
        echo "## $PWD:"                      >>pmns_$HHSU.sh
        echo "  GREEN='\\e[0;32m' "          >>pmns_$HHSU.sh
        echo "    RED='\\e[1;31m' "          >>pmns_$HHSU.sh
        echo "     NC='\\e[0m' # No Color "  >>pmns_$HHSU.sh
        echo " TIMESTARTALL=\`date\`"        >>pmns_$HHSU.sh
        echo " RPMNS_QUAD=$RPMNS_QUAD"       >>pmns_$HHSU.sh
        echo "   printf \"\tRunning: \$RPMNS_QUAD $WFK 2 in [\${GREEN}\`hostname\`\${NC}] \$SAL \n\" " >> pmns_$HHSU.sh
        #echo "        RUN=\$RPMNS_QUAD"      >>pmns_$HHSU.sh 
        echo "$RPMNS_QUAD  $WFK 2  > logfileRPMNS ">>pmns_$HHSU.sh
        echo " sleep 5"        >>pmns_$HHSU.sh
        echo "   printf \"\t  ended: \$RPMNS_QUAD $WFK 2 in [\${GREEN}\`hostname\`\${NC}] \$SAL \n\" " >>pmns_$HHSU.sh 
        echo " TIMEENDALL=\`date\`"                               >>pmns_$HHSU.sh
        echo "     TIME1=\`date --date=\"\$TIMESTARTALL\" +%s\` " >>pmns_$HHSU.sh
        echo "     TIME2=\`date --date=\"\$TIMEENDALL\" +%s\`   " >>pmns_$HHSU.sh
        echo " ELTIME=\$[ \$TIME2 - \$TIME1 ] "                   >>pmns_$HHSU.sh
        echo "   TMIN=\$(echo \"scale=9; \$ELTIME/60\"  | bc)"    >>pmns_$HHSU.sh
        echo "  TMIN1=\$(echo \"scale=9; \$ELTIME/3600\" | bc)"   >>pmns_$HHSU.sh
        echo " printf \"\\t take:   \$TMIN min. \\n\" "           >>pmns_$HHSU.sh
        echo " printf \"\\t take:   \$TMIN1 Hrs.\\n\" "           >>pmns_$HHSU.sh
        echo "printf \"\\t=============================================\\n\" ">>pmns_$HHSU.sh
       chmod 777 pmns_$HHSU.sh
       rcp pmns_$HHSU.sh $REMOTESERVER:$REMO
     rsh $REMOTESERVER "cd $REMO;ls pmns_$HHSU.sh" &
     rsh $REMOTESERVER "cd $REMO;./pmns_$HHSU.sh " &
    sleep 4
  done 
exit 0
