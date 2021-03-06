#!/bin/bash
##
## output
# standard: file_ii_components_Nk_Ecut_spin_
# layered: file_ii_components_Nk_Layer_Ecut_spin_Nc 
##
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
MAG='\e[0;35m'
NC='\e[0m' # No Color
##
## thanks
function gracias {
    printf "\tThanks for using ${cyan}TINIBA${NC}: ${RED}NO WARRANTIES WHATSOEVER\n${NC}"
}
##
function Line {
    printf "\t${cyan}--------------------${NC}\n"
}
##
exec="$TINIBA/utils/responses.sh"
## input at will
########### this is really set in responses.sh 
eminw=0
emaxw=20
stepsw=2001
#sicw=0
###########
#toldef=0.015 ## zeta 
#toldef=0.045 ## zeta 
#toldef=0.15 ## zeta 

toldef=0.03  ## original

##
declare -a scases
where_trunc=$TINIBA/clustering/itaxeo
dir=$PWD
case=`echo $PWD | awk -F / '{print$NF}'`
    latm="latm_new"
    grep nband2 setUpAbinit_$case.in > hoy
    Nband=`head -1 hoy | awk '{print $2}'`
    Nmax=$Nband
#
####################################################################
    ESPINsetUp=`grep nspinor setUpAbinit_$case.in  |  awk '{print $2}'`
    if [ -z $ESPINsetUp ];then
	Line
        printf "\tESPINsetUp= $ESPINsetUp"
        printf "you have to define your spin in: setUpAbinit_$case.in\n"
        exit 127
    fi
    if [ "$ESPINsetUp" -eq "1" ] || [ "$ESPINsetUp" -eq "2" ] ;then
	nada=0
#         printf "\tESPINsetUp= $ESPINsetUp ok \n"
    else 
        printf "spin has to be 1 or 2 ...\n"
        exit 127 
    fi   
     ##==========================
    
# checks if res directory exists ifnot creates it
    
    if [ ! -d res ] 
    then
	echo -e ${RED} creating ${BLUE}res${NC} directory  
	mkdir res
    fi
    
# gets the nodes to be used and stores them into an array.
    
    if [ ! -e '.machines_res.original' ]
    then
	Line
	echo -e "The file $blue .machines_res.original $NC was not found. Please create one before running the script"
	Line
	exit 1
    else
	cp .machines_res.original .machines_res
    fi
    if [ ! -e '.machines_latm.original' ]
    then
	Line
	echo -e "The file $blue .machines_latm.original $NC was not found. Please create one before running the script"
	Line
	exit 1
    else
	cp .machines_latm.original .machines_latm
    fi
    
    i=0;
    for inode in `cat .machines_res`
    do
	i=$(( i + 1 )) 
	nodes[$i]=$inode
#  echo nodo  ${nodes[$i]}
    done
    for inode in `cat .machines_latm`
    do
	latm_node=$inode
    done
    
    
#used_node=` $where/trunc.sh $latm_node`
    
    used_node=`$where_trunc/trunc.sh $latm_node`
    
# echo ${#nodes[@]}
    
    
####################################################################
# counts the number of occupied states from acs_check/case.out file
    grep -n 'occ ' $case'_check'/$case.out > hoyj
    iocc=`awk -F: '{print $1}' hoyj`
    grep -n 'prtvol ' $case'_check'/$case.out > hoyj
    iprtvol=`awk -F: '{print $1}' hoyj`
    awk 'NR=='$iocc',NR=='$iprtvol'' $case'_check'/$case.out > hoyj2
# for spin-orbit each state has only one electron for a given spin
    grep -o 1.000 hoyj2 > hoyj3
    Nvf=`wc hoyj3 | awk '{print $2}'`
    if [ $Nvf == '0' ]
    then
	grep -o 2.000 hoyj2 > hoyj3
	Nvf=`wc hoyj3 | awk '{print $2}'`
    fi
    Nct=`expr $Nmax - $Nvf`
    rm -f hoyj*
#
    if [ "$#" -eq 0 ]
    then   # Script needs at least one command-line argument.
	clear
	echo -e ${cyan}--------- ${BLUE} choose a response ${cyan}---------${NC}
	$TINIBA/utils/print_responses.pl
	Line
	echo Check/Change Emin=$eminw, Emax=$emaxw and $stepsw intervals
	echo -e Check/Change ${blue}tolerance${NC} value of ${RED}$toldef${NC}
	Line
	echo -e "There are ${RED}$Nmax${NC} bands, so choose Nv=${RED}$Nvf${NC} and up to Nc=${RED}$Nct${NC} "
####################################################################
	Line
	printf "all_responses.sh -w [${red}layer${NC} or ${red}total${NC}] -m [_${red}case${NC}] -s [${red}scissors${NC}] -o [${red}1${NC}-full or ${red}2${NC}-vc] -v [${red}Nv${NC}] -c [${red}Nc${NC}] -r [response${red}#${NC}] -t [tensor ${red}\"ijk ...\" ${NC}]\n"
	Line
	echo you have the following options:
	ls me_pmn*
	ls me_pnn*
	ls me_rhoccp*
	ls me_cpnn*
	ls me_cpmn*
	ls me_csccp*
	ls me_sccp*
#	echo You can use the following k-points files:
#	ls *klist*
	Line
	exit 1
    fi
# gets options
    while getopts ":w:m:s:o:v:c:r:t:" OPTION
    do
	case $OPTION in
            w)
		lt=$OPTARG
		;;
            m)
		caso=$OPTARG
		pfix=$OPTARG
		;;
            s)
		tijera=$OPTARG
		;;
            o)
		option=$OPTARG
		;;
            v)
		Nv=$OPTARG
		;;
            c)
		Nc=$OPTARG
		;;
            r)
		response=$OPTARG
		;;
            t)
		scases=($OPTARG) #the parenthesis () are so it reads an array 
		;;
            ?)
		printf "\t${RED}error${NC}\n"
		exit
		;;
	esac
    done
## starts the overall time
    TIMESTARTALL=`date`
    Line
    printf "\tStarting at: $TIMESTARTALL \n" 
    Line
    if [ $lt == 'layer' -o $lt == 'total' ]
    then
	echo $caso > chispas
	Nk=`awk -F _ '{print $1}' chispas`
	rm chispas
#
# if in medusa or any hexa, copy to the node given in .machines_latm.original
# so the calculation is done locally, thus faster.
#
	
	adondi=`awk '{print $1}' .machines_latm`
	quien=`whoami`
	yesno=no
	printf "\tLATM to be run at $adondi\n"
	if [[ "$adondi" == "medusa" || "$adondi" == "hexa"* ]]
	then
	    printf "\tCopying the required files through infiniband\n"
# present hexa
	    yesno=si
	    ontoi=`hostname`
	    aqui=`pwd`
# creates the working directory 
	    ssh $adondi "mkdir -p /data/$quien/workspace/$case"
# copies all the required files
	    rcp $case.xyz $adondi"ib":/data/$quien/workspace/$case/.
	    rcp setUpAbinit_$case.in $adondi"ib":/data/$quien/workspace/$case/.
	    rcp .machines_res $adondi"ib":/data/$quien/workspace/$case/.
	    rcp .machines_latm $adondi"ib":/data/$quien/workspace/$case/.
	    rcp -r symmetries $adondi"ib":/data/$quien/workspace/$case/.
	    rcp -r $case"_check" $adondi"ib":/data/$quien/workspace/$case/.
	    rcp eigen_* $adondi"ib":/data/$quien/workspace/$case/.
	    rcp me*_* $adondi"ib":/data/$quien/workspace/$case/.
	else
	    printf "\tLocal calculation, no copying required\n"
	fi
# SHG Length Gauge
	if [ $response -eq "21" ]
	then
	    Line
	    printf "\t${RED}Calculating Length Gauge shg1 and shg2${NC}\n"
	    Line
#
	    Line
	    printf "\t${RED}shg1${NC}\n"
	    Line
	    response=21
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/21* $qui:$aqui/."
	    else
		mtita
		rm mtita
	    fi
#
	    Line
	    printf "\t${RED}shg2${NC}\n"
	    Line
	    response=22
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/22* $qui:$aqui/."
	    else
		mtita
		rm mtita
	    fi
#
	    if [ -e 'fallo' ]
	    then
		rm fallo
		exit 1
	    fi
# puts shg1 and shg2 into one file
# kk
	    f1w=`awk '{print $1}' 21.kk.dat`
	    f2w=`awk '{print $1}' 22.kk.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2L. '{print $2}' 22.kk.dat`
	    paste res/$f1w perro > res/shgL.$lastname 
	    printf  "\t${blue}===== above are erased ==============${NC}\n"
	    Line
	    printf  "\t${blue}1-w and 2-w in:${NC}\n"
	    printf  "\t${blue}res/${GREEN}shgL.$lastname${NC}\n"
	    rm -f perro
# sm
	    f1w=`awk '{print $1}' 21.sm.dat`
	    f2w=`awk '{print $1}' 22.sm.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2L. '{print $2}' 22.sm.dat`
	    paste res/$f1w perro > res/shgL.$lastname 
	    printf "\t${blue}res/${GREEN}shgL.$lastname${NC}\n"
	    Line
	    rm -f perro
	    rm 21* 22*
	    rm -f res/shg2L.kk* res/shg2L.sm*
	    rm -f res/shg1L.kk* res/shg1L.sm*
#
	fi
#
# SHG Layer-Length Gauge
	if [ $response -eq "44" ]
	then
	    Line
	    printf "\t${RED}Calculating Layer Length Gauge shg1 and shg2${NC}\n"
	    Line
#
	    Line
	    printf "\t${RED}shg1${NC}\n"
	    Line
	    response=44
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/44* $qui:$aqui/."
#		mtita
#		rm mtita
	    else
		mtita
		rm mtita
	    fi
#
	    Line
	    printf "\t${RED}shg2${NC}\n"
	    Line
	    response=45
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/45* $qui:$aqui/."
#		mtita
#		rm mtita
	    else
		mtita
		rm mtita
	    fi
#
	    if [ -e 'fallo' ]
	    then
		rm fallo
		exit 1
	    fi
# puts shg1 and shg2 into one file
# kk
	    f1w=`awk '{print $1}' 44.kk.dat`
	    f2w=`awk '{print $1}' 45.kk.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2C. '{print $2}' 45.kk.dat`
	    paste res/$f1w perro > res/shgC.$lastname 
	    printf  "\t${blue}===== above are erased ==============${NC}\n"
	    Line
	    printf  "\t${blue}1-w and 2-w in:${NC}\n"
	    printf  "\t${blue}res/${GREEN}shgC.$lastname${NC}\n"
	    rm -f perro
# sm
	    f1w=`awk '{print $1}' 44.sm.dat`
	    f2w=`awk '{print $1}' 45.sm.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2C. '{print $2}' 45.sm.dat`
	    paste res/$f1w perro > res/shgC.$lastname 
	    printf "\t${blue}res/${GREEN}shgC.$lastname${NC}\n"
	    Line
	    rm -f perro
	    rm 44* 45*
	    rm -f res/shg2C.kk* res/shg2C.sm*
	    rm -f res/shg1C.kk* res/shg1C.sm*
#
	fi
# SHG Velocity Gauge
	if [ $response -eq "42" ]
	then
	    Line
	    printf "\t${RED}Calculating Velocity Gauge shg1 and shg2${NC}\n"
	    Line
#
	    Line
	    printf "\t${RED}shg1${NC}\n"
	    Line
	    response=42
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/42* $qui:$aqui/."
	    else
		mtita
		rm mtita
	    fi
#
	    Line
	    printf "\t${RED}shg2${NC}\n"
	    Line
	    response=43
	    echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	    chmod +x mtita
# decides if it runs locally or non-locally 
	    if [ "$yesno" == "si" ]
	    then
		rcp mtita $adondi"ib":/data/$quien/workspace/$case/.
		qui=$ontoi"ib"
		ssh $adondi "cd /data/$quien/workspace/$case/;mtita;rcp res/* $qui:$aqui/res/.;rm -f res/*;rm mtita"
		ssh $adondi "rcp /data/$quien/workspace/$case/43* $qui:$aqui/."
	    else
		mtita
		rm mtita
	    fi
#
	    if [ -e 'fallo' ]
	    then
		rm fallo
		exit 1
	    fi
# puts shg1 and shg2 into one file
# kk
	    f1w=`awk '{print $1}' 42.kk.dat`
	    f2w=`awk '{print $1}' 43.kk.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2V. '{print $2}' 43.kk.dat`
	    paste res/$f1w perro > res/shgV.$lastname 
	    printf  "\t${blue}===== above are erased ==============${NC}\n"
	    Line
	    printf  "\t${blue}1-w and 2-w in:${NC}\n"
	    printf  "\t${blue}res/${GREEN}shgV.$lastname${NC}\n"
	    rm -f perro
# sm
	    f1w=`awk '{print $1}' 42.sm.dat`
	    f2w=`awk '{print $1}' 43.sm.dat`
	    awk '{print $2,$3}' res/$f2w > perro
	    lastname=`awk -Fshg2V. '{print $2}' 43.sm.dat`
	    paste res/$f1w perro > res/shgV.$lastname 
	    printf "\t${blue}res/${GREEN}shgV.$lastname${NC}\n"
	    Line
	    rm -f perro
	    rm 42* 43*
	    rm -f res/shg2V.kk* res/shg2V.sm*
	    rm -f res/shg1V.kk* res/shg1V.sm*
#
	fi
#
# Other than SHG
#
	if [[ ! $response -eq "21"  &&  ! $response -eq "42" &&  ! $response -eq "44" &&  ! $response -eq "22"  &&  ! $response -eq "43" &&  ! $response -eq "45" ]]
	    then
#
	    Line
	printf "\t${RED}Calculating other than shg1 and shg2${NC}\n"
	Line
	echo $exec -w $lt -m $caso -s $tijera -o $option -v $Nv -c $Nc -r $response  -t \"${scases[@]}\" > mtita
	chmod +x mtita
	mtita
	rm mtita
#
	fi
#
	if [[ "$adondi" == "medusa" || "$adondi" == "hexa"* ]]
	then
	    printf "\tErasing files at $adondi:/data/$quien/workspace/$case\n"
	    ssh $adondi "rm -rf /data/$quien/workspace/$case"
	fi
	TIMEENDALL=`date`
	printf "\t--------------------------------------------------\n"
	printf "\t     Started at time: ${GREEN}$TIMESTARTALL ${NC}\n"
	printf "\t--------------------------------------------------\n"
	printf "\tFinished all at time: ${GREEN}$TIMEENDALL ${NC}\n"
	printf "\t--------------------------------------------------\n"
	TIME1=`date --date="$TIMESTARTALL" +%s`
	TIME2=`date --date="$TIMEENDALL" +%s`
	ELTIME=$[ $TIME2 - $TIME1 ]
	TMIN=$(echo "scale=9; $ELTIME/60" | bc)
	TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
	printf "\t total time:   $TMIN min. \n"
	printf "\t               $TMIN1 Hrs. \n"
	printf "\t--------------------------------------------------\n"
###
	Line
	gracias
	Line
    fi
    
