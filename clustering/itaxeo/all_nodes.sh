#!/bin/bash
debug=false
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
## global variables
ontoy=`hostname`
# reads TINIBA version from version-tiniba.txt
source version-tiniba.txt
# reads DP version from version-dp.txt
source version-dp.txt
#
##====== FUNCTIONS ============ 
## Line
function Line {
    printf "\t${BLUE}=============================${NC}\n"
}
##
 function StopMe {
      printf "\t${RED}Stoping right now... ${NC}\n"
      exit 127    
       }
# Main, set up diectories, loop over number of jobs, call eachnode, and clean up.
trunc_dir=$TINIBA/clustering/itaxeo
######################################### RUN below
if [ $1 == '1' ]
then
#reads data from run_all.sh
    Nk=$2
    Nlayers=$3
    serialp=$4
    last_name=$5
    wfa=$6
    rho=$7
    em=$8
    pmn=$9
    rhoccp=${10}
    lpmn=${11}
    lpmm=${12}
    sccp=${13}
    lsccp=${14}
    vnlkss=${15}
    calvnlkss=${16}
    wfcheck=${17}
    options="$rho $em $pmn $rhoccp $lpmn $lpmm $sccp $lsccp $vnlkss $calvnlkss $wfcheck"
## executables
    allexec=$TINIBA/clustering/itaxeo
## reads abinit executables from version-abinit.txt
source version-abinit.txt
##
    cual_scf=$allexec/scf.sh
    quien=`whoami`
##
    if [ ! -e logfiles ]
    then
	mkdir logfiles
    fi
    
    if [ ! -e $allexec ]
    then
	Line
	echo "Cannot find shell script $allexec"
	echo "needed for the parallel execution of the matrix element generator."
	Line
    fi
#
    echo "#!/bin/bash"> como_corri.sh
    echo "`date`      ">> como_corri.sh
    echo "`dirname $0`/`basename $0` $@ " >> como_corri.sh
    chmod 777 como_corri.sh
#
    dir=$PWD
    case=`echo $PWD | awk -F / '{print$NF}'`
	parent=`echo $PWD | awk -F / '{a=NF; print $(a-1)}'`
	output=$dir/res
	Line
	printf "\tRunning as user $USER.  This username is used for file storage.\n"
	Line
	
	if [ ! -d $output ]
	then
	    echo "Making directory $output"
	    mkdir $output
	fi
	
	if [ ! -e .machines_scf ] || [ ! -e .machines_pmn ]
	then
	    Line
	    printf "\tA .machines_scf or .machines_pmn file does not exist.  Create one.\n"
	    Line
	    echo "Error in: all_nodes.sh at line 105" > error 
	    exit 1
	fi
##
	declare -a nodeArray_scf
	declare -a nodeArray_pmn
	nodeArray_pmn=(`cat .machines_pmn`)
	nodeArray_scf=(`cat .machines_scf`)
	numberOfNodes_pmn=`echo ${#nodeArray_pmn[@]}`
	numberOfNodes_scf=`echo ${#nodeArray_scf[@]}`
	Line
	printf "\tWe will use $numberOfNodes_scf nodes for SCF\n"
	printf "\tand $numberOfNodes_pmn nodes for Pmn\n"
	Line
#####========= Run SCF calculation=============
	dirscf=$case'_scf'
	if [ ! -e $dirscf ]
	then
	    Line
	    printf "\tA $dirscf directory does not exist, one will be created\n"
	    Line
	    mkdir -f $dirscf
	fi
#
	wffile=$case'o_DS1_DEN'
	time=`date`
#
####### SCF cycle: begin
	if [ ! -e $dirscf/$wffile ]
	then
#######
	    Line
	    printf "\t${red}Runing SCF${NC}\n"
# serial
	    if [ $serialp == '1' ]; then
		Line
		printf "\t${RED}SERIAL RUN DOES NOT WORK, CHECK /data for Itanium${NC}\n"
		printf "\t${red}EXITING${NC}\n"
		Line
		exit 1
		cp -r $dirscf /data.itanium01/$quien/.
        ##copy .machines for parallel mpi execution of SCF
		cp .machines_scf /data.itanium01/$quien/$dirscf/.
		echo "sending $dirscf to itanium01 at $time"
		input=/data/$USER/$dirscf
		echo ssh itanium01 "cd $input;$cual_scf $case $dir $serialp"
		ssh itanium01 "cd $input; $cual_scf $case $dir $serialp" &
	    fi
##PARALLEL
	    if [ $serialp == '2' ];then
		cp .machines_scf $dirscf/.
		Line
		printf "\tSending $dirscf to be run in parallel at $time\n"
		Line
		input=$dirscf
		cd $dirscf
		$cual_scf $case $dir $serialp &
		cd ..
	    fi
#    
	    while [ ! -e finished_scf ];do
		continue
	    done
#    
	    time=`date`
	    rm -f finished_scf
	    time=`date`
	    Line
	    printf "\tSCF: $dirscf ${red}has finished${NC} at $time\n"
	    Line
	    #checking if SCF really produced a wavefunction
	    #printf "\tACA:$dirscf/$wffile\n" #DEBUG
	    #exit 1 #DEBUG
	    if [ ! -e $dirscf/$wffile* ]
	    then
		Line
		printf "\t${RED}ERROR $dirscf/$wffile DOES NOT EXISTS:${NC}check ${BLUE}$dirscf/$case.out${NC}\n"
		printf "\t${blue} exiting the ${RED} all_nodes.sh ${BLUE}shell\n"
		touch -f nojalo
		exit 1
	    fi
#
# serial
	    if [ $serialp == '1' ]; then
		printf "\tnow copying /data.itanium01/$USER/workspace/$parent/$case_scf/$wffile to  $dirscf/$wffile,\n"
		printf "\tmay take a while!\n"
		cp /data.itanium01/$USER/workspace/$parent/$case'_scf'/$wffile $dirscf/$wffile
	    fi
# paralel
	    if [ $serialp == '2' ]
	    then
		printf "\tsince it's parallel $wffile is already in $dirscf\n"
	    fi
	    Line
####### SCF cycle
	else
#######
	    Line
	    printf "\tFile $dirscf/$wffile exists, skiping SCF calculation\n"
	    timeb=`date`
	    Line
	    printf "\tstarts copying at $timeb\n"
	    Line
####### SCF cycle:END
	fi
#######
#######
# Copy wavefunction $caseo_DS1_DEN to all the nodes
# that we want to use and to $PWD/$case_scf for keeps
# also copy $PWD/$case_$N to /data.$node/$USER/$case'_'$N
# serial
	if [ $serialp == '1' ]
	then
	    wf=/data.itanium01/$USER/workspace/$parent/$case'_scf'/$wffile
	fi
# parallel
	if [ $serialp == '2' ]
	then
	    wf=$case'_scf'/$wffile
	fi
############################### nuevo
### BEGIN TO COPY 
	printf "\t${BLUE}checking whether the $case.in files have changed or not\n${NC}"
	Line
	wffilei=$case'o_DS1_DEN'
	Ncpu=`wc .machines_pmn | awk '{print $1}'`
	N=0
	for node in `cat .machines_pmn`
	do
	    N=`expr $N + 1`
	    if [[ "$ontoy" == "hexa"* ]]
	    then
		wavefunction=/data/$USER/workspace/$parent/$case'_'$N/$wffilei
		EXISTEWF=`ssh $node 'test -e '$wavefunction'; echo $?'`
	    else
		wavefunction=/data/$USER/workspace/$parent/$case'_'$N/$wffilei
		EXISTEWF=`ssh $node 'test -e '$wavefunction'; echo $?'`
	    fi
    #### AQUI AQUI AQUI perhaps this might not be required
	    if [[ "$ontoy" == "hexa"* ]]
	    then
		dire=/data/$quien/workspace/$parent 
	    else
		dire=/data/$quien/workspace/$parent 
	    fi
	    nodepmn=`head -1 .machines_pmn`
	    if [[ "$nodepmn" == "hexa"* ]] 
	    then
		dire=/data/$quien/workspace/$parent 
	    else
		dire=/data/$quien/workspace/$parent 
	    fi
	
    #######################################################
	    EXISTEDIR=`ssh $node 'test -d '$dire'; echo $?'`
# to avoid poll: protocol failure in circuit setup
	    sleep .05
#
	    if [ $EXISTEWF -ne 0 ] ;then
		if [ $EXISTEDIR -ne 0 ] ;then
		    printf "\tssh $node mkdir -p $dire\n"
		    ssh $node "mkdir -p $dire"
		fi
		if [ "$ontoy" == "medusa" ]
		then
		    if [[ "$nodepmn" == "hexa"* ]] 
		    then
#			printf "\taquia:$ontoy $nodepmn $dire\n"
			dire=/data/$quien/workspace/$parent 
			caseN=$case'_'$N
			scp -r $caseN $node:$dire/. >& /dev/null
			printf "\tonly copying $caseN/${blue}$case.in${NC} -> $node:$dire/$caseN/${blue}.${NC}\n"
			scp  $caseN/$case.in $node:$dire/$caseN/. >& /dev/null
		    else
			dire=/data/$quien/workspace/$parent 
			caseN=$case'_'$N
			scp -r $caseN /$node.$dire/. >& /dev/null
			printf "only copying $caseN/${blue}$case.in${NC} -> /$node.$dire/$caseN/${blue}.${NC}\n"
			scp  $caseN/$case.in /$node.$dire/$caseN/. >& /dev/null
		    fi
		else
		    scp -r $case'_'$N $node:$dire/. >& /dev/null
		    caseN=$case'_'$N
		    printf "only copying $caseN/${blue}$case.in${NC} -> $node:$dire/$caseN/${blue}.${NC}\n"
		    scp  $case'_'$N/$case.in $node:$dire/$case'_'$N/. >& /dev/null
		fi
#		exit 1
	    fi
	    casein=/data/$quien/workspace/$parent/$case'_'$N/$case.in
	    EXISTEIN=`ssh $node 'test -e '$casein'; echo $?'`
	    if [ $EXISTEIN -eq 0 ] ;then
		rm -f tmp1
		rm -f tmp2
		cazo=$case'_'$N
		TMP1=`md5sum "$cazo/$case.in"`
		echo $TMP1 > tmp1
		MD5LOCAL=`awk '{print $1}' tmp1`
		echo $MD5LOCAL > tmp1
		TMP2=`ssh $node 'md5sum '$casein''`
		echo $TMP2 > tmp2
		MD5REMOTE=`awk '{print $1}' tmp2`
		echo $MD5REMOTE > tmp2
		#BMSVer3.0d
                # compares the two caso.in files 
		# and if the two files only differ by
                # ndtset nkpt3 istwfk3
                # the files are identical as far as 
		# a calculation of TINIBA (ABINIT) is concern
		# Is this needed????
		#diff $casein $cazo/$case.in > nhoy
		#grep \<          nhoy  > nhoy1
		#grep \>          nhoy >> nhoy1
		#grep -v ndtset   nhoy1 > nhoy2
		#grep -v nkpt3    nhoy2 > nhoy3
		#grep -v istwfk3  nhoy3 > $case.diff
		#rm nhoy*
		diff tmp1 tmp2 > $case.diff
		#BMSVer3.0u
		if [ "$ontoy" == "medusa" ]
		then
		    if [[ "$nodepmn" == "hexa"* ]] 
		    then
			scp $case.diff $node:$dire/$case'_'$N/. >& /dev/null
		    else
			scp $case.diff /$node.$dire/$case'_'$N/. >& /dev/null
		    fi
		else
		    scp $case.diff $node:$dire/$case'_'$N/. >& /dev/null
		fi
#
		rm -f tmp1 tmp2 $case.diff
	    fi
	    if [ ! $Nlayers == '0' ]; then
		if [ "$ontoy" == "medusa" ]
		then
		    if [[ "$nodepmn" == "hexa"* ]] 
		    then
			scp .ab_layers.d $node:$dire/$case'_'$N/fort.99 >& /dev/null
		    else
			scp .ab_layers.d /$node.$dire/$case'_'$N/fort.99 >& /dev/null
		    fi
		else
		    scp .ab_layers.d $node:$dire/$case'_'$N/fort.99 >& /dev/null
		fi
	    fi
	done
	Line
	printf "\t${BLUE} Done!${NC}\n"
	Line
##
## Copy WF to all working directories
##
##check and copy WF SCF to all nodes 
	if [ $wfcheck == 'true' ]
	then
	    Line
	    printf "\t${RED}Bypassing${NC} the WF check of identical copies among the nodes\n"
	    printf "\t${red}Never${NC} choose option ${blue}-b${NC} on first run \n"
	    Line
	else
	    $allexec/copySCF2allnodes.sh
	fi
##
## if -w is the only option, the shell is done and exists
##
	if [[ $wfa == 'true' ]] && [[ $rho == 'false' ]] && [[ $em == 'false' ]] && [[ $pmn == 'false' ]] && [[ $rhoccp == 'false' ]] && [[ $lpmn == 'false' ]] && [[ $lpmm == 'false' ]] && [[ $sccp == 'false' ]] && [[ $lsccp == 'false' ]] && [[ $vnlkss == 'false' ]] && [[ $calvnlkss == 'false' ]]
	then
	    Line
	    printf "\trun_all.sh: only -w option selected => exiting\n"
	    Line
	    exit 1
	fi
##
	if [ -e killme ];then
	    exit 1
	fi
#
	if [ $N != $Ncpu ]
	then
	    echo "Number of processes not equal to number of cpus"
	    exit 1
	fi
##
## run in different nodes
##
	N=0
	for node in `cat .machines_pmn`
	do
	    N=`expr $N + 1`
	    time=`date`
#
# displays the chosen options 
#
	    caso=
	    if [[ $rho == 'true' ]]
	    then
		caso="rho"
	    fi
	    if [[ $em == 'true' ]]
	    then
		caso="$caso Em(k)"
	    fi
	    if [[ $pmn == 'true' ]]
	    then
		caso="$caso Pmn(k)"
	    fi
	    if [[ $rhoccp == 'true' ]]
	    then
		caso="$caso rhoccp(l;k)"
	    fi
	    if [[ $lpmn == 'true' ]]
	    then
		caso="$caso CalPmn(k)"
	    fi
	    if [[ $lpmm == 'true' ]]
	    then
		caso="$caso CalPmm(k)"
	    fi
	    if [[ $sccp == 'true' ]]
	    then
		caso="$caso Scc'(k)"
	    fi
	    if [[ $lsccp == 'true' ]]
	    then
		caso="$caso CalScc'(k)"
	    fi
	    if [[ $vnlkss == 'true' ]]
	    then
		caso="$caso v^nl_mn(k)"
	    fi
	    if [[ $calvnlkss == 'true' ]]
	    then
		caso="$caso calv^nl_mn(k)"
	    fi
##
	    if [ $debug == 'true' ]
	    then
		Line
		echo running $caso for $Nlayers Layers at $node:$ADONDECOPY/$USER/workspace/$parent/$case'_'$N/ at $time
		Line
	    fi
#
	    cual_one=$allexec/one_node.sh
	    if [[ "$ontoy" == "hexa"* ]]
	    then
		dirnode=/data/$USER/workspace/$parent/$case'_'$N/
	    else
		dirnode=/data/$USER/workspace/$parent/$case'_'$N/
	    fi
	    # copy the number of valence bands fnval to each working node
# to be used by S_{cc'}
	    if [ "$ontoy" == "medusa" ]
	    then
		if [[ "$nodepmn" == "hexa"* ]] 
		then
		    scp -r .fnval $node:/data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		else
		    scp -r .fnval /$node.data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		fi
	    else
		scp -r .fnval $node:$dirnode >& /dev/null
	    fi
#BMSVer3.0d
# copy dp-vnl-case.in and fort.69 to each working directory
# to be used by V^\nl_{nm} through DP code
	    if ( "$vnlkss" == "true" || "$calvnlkss" == "true" )
	    then
		aux=dp-vnl-$case.in
		if [ "$ontoy" == "medusa" ]
		then
		    if [[ "$nodepmn" == "hexa"* ]] 
		    then
			scp -r $aux $node:/data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
			scp -r fort.69 $node:/data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		    else
			scp -r $aux /$node.data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
			scp -r fort.69 /$node.data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		    fi
		else
		    scp -r $aux $node:$dirnode >& /dev/null
		    scp -r fort.69 $node:$dirnode >& /dev/null
		fi
	    fi
#BMSVer3.0u
# copy the chosen layer to each working node
	    if [ ! $Nlayers == '0' ]; then
		if [ "$ontoy" == "medusa" ]
		then
		    if [[ "$nodepmn" == "hexa"* ]] 
		    then
			scp -r .lista_layers $node:/data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		    else
			scp -r .lista_layers /$node.data/$USER/workspace/$parent/$case'_'$N/ >& /dev/null
		    fi
		else
		    scp -r .lista_layers $node:$dirnode >& /dev/null
		fi
	    fi
##
	    nodo=`$trunc_dir/trunc.sh $node`
##
	    if [ $nodo = 'node' ]
	    then
		ssh $node "$cual_one $node $dirnode $ab_exec_xeon $case $dir $N $output $Nlayers $Nk $last_name $options $dp_exec_xeon" &
	    fi
##
	    if [ $nodo = 'itanium' ]
	    then
		ssh $node "$cual_one $node $dirnode $ab_exec_itanium $case $dir $N $output $Nlayers $Nk $last_name $options $dp_exec_itanium" &
	    fi
##
	    if [ $nodo = 'quad' ]
	    then
		ssh $node "$cual_one $node $dirnode $ab_exec_quad $case $dir $N $output $Nlayers $Nk $last_name $options $dp_exec_hexa" &
	    fi
##
	    if [ $nodo = 'hexa' ]
	    then
		ssh $node "$cual_one $node $dirnode $ab_exec_hexa $case $dir $N $output $Nlayers $Nk $last_name $options $dp_exec_hexa" &
	    fi
##
	    if [ $nodo = 'fat' ]
	    then
		ssh $node "$cual_one $node $dirnode $ab_exec_hexa $case $dir $N $output $Nlayers $Nk $last_name $options $dp_exec_hexa" &
	    fi
###
	done
#
	Line
	printf "\t`basename $0`: ${GREEN}all subsets of k-points have been sent to the nodes${NC}\n"
###########
fi
######################################### RUN above
######################################### delete nodes below
if [ $1 == '2' ]
then
    dir=$PWD
    case=`echo $PWD | awk -F / '{print$NF}'`
	parent=`echo $PWD | awk -F / '{a=NF; print $(a-1)}'`
	rm -fr JOBS
	rm -f finished*
	N=0
	for node in `cat .machines_pmn`
	do
	    N=`expr $N + 1`
	    if [[ "$ontoy" == "hexa"* ]]
	    then
		ADONDEBORRO=/data
		echo deleting directory $node:$ADONDEBORRO/$USER/workspace/$parent/$case'_'$N
		ssh $node "rm -rf /$ADONDEBORRO/$USER/workspace/$parent/$case'_'$N"
	    else
		ADONDEBORRO=/data
		echo deleting directory $node:$ADONDEBORRO/$USER/workspace/$parent/$case'_'$N
		ssh $node "rm -rf $ADONDEBORRO/$USER/workspace/$parent/$case'_'$N"
	    fi
	    echo and $dir/$case'_'$N
	    rm -rf $dir/$case'_'$N
#  echo $node:$ADONDEBORRO/$USER/workspace/$parent/$case'_'$N deleted too
#  ssh $node "rm -rf $ADONDEBORRO/$USER/workspace/$parent/$case'_'$N"
	done
fi
######################################### delete nodes above
######################################### delete SCF below
if [ $1 == '3' ]
then
    dir=$PWD
    case=`echo $PWD | awk -F / '{print$NF}'`
	rm -fr JOBS
	rm -f finished*
	echo and $dir/$case'_scf'
	rm -rf $dir/$case'_scf'
fi
######################################### delete SCF above
