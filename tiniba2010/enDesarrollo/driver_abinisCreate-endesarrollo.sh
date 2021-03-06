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
             DIR=$PWD
            USER=$USER
         BASEDIR=`dirname $PWD`
            CASO=`basename $PWD`
          PARENT=`basename $BASEDIR`
       WORKZPACE="workspace"
      WFSCFLOCAL=$CASO'o_DS1_WFK'
     WFSCFREMOTE=$CASO'i_DS1_WFK'  
       DONDEVIVO=`dirname $0`     
     SETUPABINIT=setUpAbinit_$CASO.in
             WFK=$CASO'o_DS2_WFK' 
      PUTASALIDA=$CASO.out
   PUTASALIDAall=$CASO.out*
     ABINITFILES=$CASO.files
         PUNTOIN=$CASO.in
     
  
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
 function chabinit {
echo perro
}




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
       echo "#!/bin/bash "                  >> abinis_$HHSU.sh
       echo "## `date`  :: Cabellos JL"      >> abinis_$HHSU.sh
       echo "## todo corrio en:"           >> abinis_$HHSU.sh

       #echo "echo \"hola\" > perro " > abinis_$HHSU.sh
       echo "echo \"#!/usr/bin/perl \" >perro "  >> abinis_$HHSU.sh
       echo "echo \"use Term::ANSIColor;\" >>perro " >> abinis_$HHSU.sh
       #echo "echo \"
       #@abinit_variables = (\\\"acell\\\",\\\"angdeg\\\")   
       #\">>perro " >> abinis_$HHSU.sh
        
       echo "echo \"
       @abinit_variables = (\\\"acell\\\",\\\"angdeg\\\",\\\"amu\\\",\\\"algalch\\\",\\\"chkprim\\\",\\\"nsppol\\\",
                     \\\"brvltt\\\",\\\"bdberry\\\",\\\"berryopt\\\",\\\"boxcenter\\\",\\\"boxcutmin\\\",
                     \\\"cmlfile\\\",\\\"chkexit\\\",\\\"chkrprim\\\",\\\"cpus\\\",\\\"cpum\\\",\\\"cpuh\\\",
                     \\\"delayperm\\\",\\\"dilatmx\\\",\\\"dtion\\\",\\\"dsikpt\\\",\\\"diecut\\\",
		     \\\"diegap\\\",\\\"dielam\\\",\\\"dielng\\\",\\\"diemac\\\",\\\"diemix\\\",\\\"dosdeltae\\\",
                     \\\"ecut\\\",\\\"ecutsm\\\",\\\"efield\\\",\\\"enunit\\\",
                     \\\"friction\\\",\\\"fband\\\",\\\"fixmom\\\",
		     \\\"getddk\\\",\\\"getden\\\",\\\"getkss\\\",\\\"getocc\\\",\\\"getscr\\\",
		     \\\"getwfk\\\",\\\"getwfq\\\",\\\"get1den\\\",\\\"get1wf\\\",\\\"get1wfden\\\",
                     \\\"genafm\\\",\\\"getcell\\\",\\\"getxcart\\\",\\\"getxred\\\",
                     \\\"iscf\\\",\\\"ixc\\\",\\\"iatcon\\\",\\\"iatfix\\\",\\\"iatfixx\\\",\\\"iatfixy\\\",
                     \\\"iatfixz\\\",\\\"ionmov\\\",\\\"irdddk\\\",\\\"irdkss\\\",\\\"irdscr\\\",\\\"irdwfk\\\",
		     \\\"irdwfq\\\",\\\"ird1wf\\\",\\\"iatsph\\\",\\\"iprcel\\\",
                     \\\"jdtset\\\",
                     \\\"kpt\\\",\\\"kptnrm\\\",\\\"kptopt\\\",\\\"kssform\\\",\\\"kberry\\\",\\\"kptbounds\\\",
		     \\\"kptrlatt\\\",\\\"kptrlen\\\",
		     \\\"localrdwf\\\",
                     \\\"mdftemp\\\",\\\"mditemp\\\",\\\"mdwall\\\",\\\"mffmem\\\",\\\"mkmem\\\",
		     \\\"mkqmem\\\",\\\"mk1mem\\\",\\\"mixalch\\\",
                     \\\"natfix\\\",\\\"natfixx\\\",\\\"natfixy\\\",\\\"natfixz\\\",\\\"natcon\\\",
                     \\\"nconeq\\\",\\\"ntime\\\",
                     \\\"natom\\\",\\\"nband\\\",\\\"ndtset\\\",\\\"ngkpt\\\",\\\"nkpt\\\",\\\"nshiftk\\\",
		     \\\"natsph\\\",\\\"nberry\\\",\\\"nbdbuf\\\",\\\"ndivk\\\",\\\"ngfft\\\",\\\"nline\\\",
		     \\\"npsp\\\",\\\"nqpt\\\",\\\"nspinor\\\",\\\"ntypalch\\\",
                     \\\"nspol\\\",\\\"nstep\\\",\\\"nsym\\\",\\\"ntypat\\\",\\\"natrd\\\",\\\"nobj\\\",
                     \\\"occopt\\\",\\\"objatt\\\",\\\"objbat\\\",\\\"objaax\\\",\\\"objbax\\\",\\\"objan\\\",
                     \\\"objbn\\\",\\\"objarf\\\",\\\"objbrf\\\",\\\"objaro\\\",\\\"objbro\\\",\\\"obfatr\\\",
                     \\\"objbtr\\\",\\\"optcell\\\",\\\"occ\\\",\\\"optdriver\\\",
		     \\\"prtcml\\\",\\\"prtden\\\",\\\"prtdos\\\",\\\"prteig\\\",\\\"prtfsurf\\\",\\\"prtgeo\\\",
		     \\\"prtkpt\\\",\\\"prtpot\\\",\\\"prtstm\\\",\\\"prtvha\\\",\\\"prtvhxc\\\",
		     \\\"prtvol\\\",\\\"prtvxc\\\",\\\"prtwf\\\",\\\"prt1dm\\\",\\\"prepanl\\\",\\\"prtbbb\\\",
		     \\\"pspso\\\",
		     \\\"qpt\\\",\\\"qptnrm\\\",
                     \\\"rprim\\\",\\\"restartxf\\\",\\\"rfasr\\\",\\\"rfatpol\\\",\\\"rfdir\\\",\\\"rfelfd\\\",
		     \\\"rfphon\\\",\\\"rfstrs\\\",\\\"rfthrd\\\",\\\"rfuser\\\",\\\"rf1atpol\\\",
		     \\\"rf1dir\\\",\\\"rf1elfd\\\",\\\"rf1phon\\\",\\\"rf2atpol\\\",\\\"rf2dir\\\",
		     \\\"rf2elfd\\\",\\\"rf2phon\\\",\\\"rf3atpol\\\",\\\"rf3dir\\\",\\\"rf3elfd\\\",
		     \\\"rf3phon\\\",\\\"ratsph\\\",
                     \\\"shiftk\\\",\\\"symrel\\\",\\\"spgaxor\\\",\\\"spgorig\\\",\\\"spgroup\\\",
                     \\\"spgroupma\\\",\\\"signperm\\\",\\\"strfact\\\",\\\"strprecon\\\",
                     \\\"strtarget\\\",\\\"sciss\\\",\\\"so_typat\\\",\\\"spinat\\\",\\\"stmbias\\\",
		     \\\"symafm\\\",
                     \\\"tnons\\\",\\\"toldfe\\\",\\\"toldff\\\",\\\"tolvrs\\\",\\\"tolwfr\\\",\\\"typat\\\",
                     \\\"tolmxf\\\",\\\"td_maxene\\\",\\\"td_mexcit\\\",\\\"timopt\\\",
		     \\\"tphysel\\\",\\\"tsmear\\\",
                     \\\"udtset\\\",
                     \\\"vel\\\",\\\"vis\\\",\\\"vacuum\\\",\\\"vacwidth\\\",
                     \\\"wtk\\\",\\\"wtatcon\\\",
                     \\\"xangst\\\",\\\"xcart\\\",\\\"xred\\\",
                     \\\"znucl\\\",\\\"istwfk\\\");
       
          \">>perro " >> abinis_$HHSU.sh





       printf "\tCreating:  abinis_$HHSU.sh \n"
        #echo "#!/bin/bash "                  >> abinis_$HHSU.sh
        #echo "## `date`  :: Cabellos JL"      >> abinis_$HHSU.sh
        echo "## todo corrio en:"           >> abinis_$HHSU.sh
        echo "## $PWD:"                     >> abinis_$HHSU.sh
        echo "  GREEN='\\e[0;32m' "         >> abinis_$HHSU.sh
        echo "    RED='\\e[1;31m' "         >> abinis_$HHSU.sh
        echo "     NC='\\e[0m' # No Color " >> abinis_$HHSU.sh
        echo " TIMESTARTALL=\`date\`"  >> abinis_$HHSU.sh 
        echo "  HOSTIASANTA=\`hostname\`"  >> abinis_$HHSU.sh 
        echo "  ABINITFILES=$ABINITFILES"      >> abinis_$HHSU.sh     
        echo "      PUNTOIN=$PUNTOIN"      >> abinis_$HHSU.sh     
        echo "          WFK=$WFK"      >> abinis_$HHSU.sh 
        echo "   PUTASALIDA=$PUTASALIDA"      >> abinis_$HHSU.sh   
        echo "PUTASALIDAall=$PUTASALIDAall"      >> abinis_$HHSU.sh
        echo "  WFSCFREMOTE=$WFSCFREMOTE"      >> abinis_$HHSU.sh
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

        echo "if [ ! -e \"\$WFSCFREMOTE\" ];then "  >> abinis_$HHSU.sh  
        echo " printf \"\\tThere is not file: \$WFSCFREMOTE \\n\" " >> abinis_$HHSU.sh  
        echo " exit 0 "  >> abinis_$HHSU.sh  
        echo "fi "  >> abinis_$HHSU.sh 
        echo "if [ ! -e \"\$PUNTOIN\" ];then "  >> abinis_$HHSU.sh  
        echo " printf \"\\tThere is not file: \$PUNTOIN \\n\" " >> abinis_$HHSU.sh  
        echo " exit 0 "  >> abinis_$HHSU.sh  
        echo "fi "  >> abinis_$HHSU.sh 
        echo "if [ ! -e \"\$ABINITFILES\" ];then "  >> abinis_$HHSU.sh  
        echo " printf \"\\tThere is not file: \$ABINITFILES \\n\" " >> abinis_$HHSU.sh  
        echo " exit 0 "  >> abinis_$HHSU.sh  
        echo "fi "  >> abinis_$HHSU.sh 
        echo "    RUNABISPA=0 "        >> abinis_$HHSU.sh 
        echo "          SAL=\$1 "        >> abinis_$HHSU.sh 
        echo "if [ -e \"\$WFK\" ] && [ -e \"\$PUTASALIDA\" ];then "  >> abinis_$HHSU.sh  
        echo "         WHEN=\`stat \$WFK | grep Modify\`"          >> abinis_$HHSU.sh 
        echo "           CALCULATION=\`awk '/Calculation/ { print }' \$PUTASALIDA\`" >> abinis_$HHSU.sh   
        echo "      if [ -z \"\$CALCULATION\" ];then " >> abinis_$HHSU.sh
        echo "             RUNABISPA=1"  >> abinis_$HHSU.sh
        echo "              rm -f \$PUTASALIDAall" >> abinis_$HHSU.sh    
        echo "      else"   >> abinis_$HHSU.sh   
        echo "      CUANTO=\`du -h \$WFK\` "  >> abinis_$HHSU.sh   
        echo "        printf \"\\t\$CUANTO : \${GREEN}\$CALCULATION \${NC} \" "  >> abinis_$HHSU.sh
        echo "        printf \"in node [\${GREEN}\`hostname\`\${NC}]\\n\" "   >> abinis_$HHSU.sh
        #echo " touch abineta " >> abinis_$HHSU.sh
        #echo " ./pmn_$HHSU.sh " >> abinis_$HHSU.sh
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
       mv abinis_$HHSU.sh $LOCA/
  done 
