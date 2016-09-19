#!/bin/bash
## please keep this history.
##
## LAST MODIFICATION :  Febrero    18 2010 by Cabellos  a 16:52
## LAST MODIFICATION :  Febrero    18 2010 by Cabellos  a 18:06
## LAST MODIFICATION :  Septiembre 28 2010 by Cabellos  a 16:03

RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

WORKZPACE="workspace" 
BASEDIR=`dirname $PWD`
PARENT=`basename $BASEDIR`
CASO=`basename $PWD`
ANFIBIO=`hostname`


declare -a FALSEMACHINES
declare -a VIVOS
declare -a MUERTOS
###################################################################
#### List of Medusa's fat nodes taken from /etc/hosts
###  3 fat(@64)
###   IP                    host name 
IPES[37]="172.17.1.37"	;MAQ501[37]="fat01"
IPES[38]="172.17.1.38"	;MAQ501[38]="fat02"
IPES[39]="172.17.1.39"	;MAQ501[39]="fat03"
###################################################################

function findMaq {
    ALLOWED="0"
    SALIDA="1000"
    local kk=1
    local NOMAQ501a=`echo ${#MAQ501[@]}`
    for ((kk=1;kk<=($NOMAQ501a); kk++));do       
	if [ "${MAQ501[$kk]}" == "$1" ];then 
            SALIDA="$kk"
            ALLOWED=1
	fi 
    done 
}
function findIndex {
    INDES="1000"
    local kk=1
    local NOMAQ501a=`echo ${#MAQ501[@]}`
    for ((kk=1;kk<=($NOMAQ501a); kk++));do       
	if [ "${MAQ501[$kk]}" == "$1" ];then 
            INDES="$kk"
	fi 
    done 
}
function Line {
    printf "\t${BLUE}=============================${NC}\n"
}
echo $1 > dog
name=`awk -F. '{print $2}' dog`
rm dog
cp $1 .$name.original
IN=.$name.original
if [ $# -eq 0 ];then 
    printf "\t ${RED}Hold on !${NC}\n"
    printf "\t I need a input file with the machines QUADxx\n"
    printf "\t ${RED}Stop right now ...${NC}\n"
    exit 0
fi 
if [ ! -e $IN ];then
    printf "\t ${RED}Hold on !, There is not FILE:${NC} $IN    ...create one.\n"
    printf "\t ${RED}Stop right now ...${NC}\n"
    exit 0
else
    FALSEMACHINES=(`cat $IN`)
    NOFALSEMACHINES=`echo ${#FALSEMACHINES[@]}`
    jj=0
    mm=0
    nn=0
    rm -f $IN
    touch $IN
    for ((hh=0;hh<=($NOFALSEMACHINES-1); hh++));do 
	findMaq ${FALSEMACHINES[$hh]}
	if [ "$ALLOWED" == "1" ];then 
	    IPT=`nmap --max_rtt_timeout 20  -oG - -p 514  ${FALSEMACHINES[$hh]} | grep open | cut -d" " -f2`
	    findIndex ${FALSEMACHINES[$hh]}
	    if [ "$IPT" == "${IPES[$INDES]}" ];then 
		let jj++
		let nn++ 
		echo ${FALSEMACHINES[$hh]} >> $IN
	    else 
		let jj++
		let mm++
		MUERTOS[$mm]=${FALSEMACHINES[$hh]}
	    fi 
	fi 
    done     
    NOMUERTOS=`echo ${#MUERTOS[@]}`
    if [ $NOMUERTOS -gt 0 ];then 
	printf "\tYour original $IN has $NOMUERTOS nodes dead that have been eliminated\n"
	for ((hh=1;hh<=($NOMUERTOS); hh++));do
	    printf "\t%4d%12s${RED}%7s${NC}\n" "$hh" "${MUERTOS[$hh]}" "Dead" 
	done 
    fi 
fi 
if [ "$ANFIBIO" == "quad01" ];then 
    if [ ! -e $IN ];then
        printf "\t ${RED}There is not file${NC} $IN\n"
        exit 0
    else
        MACHINESinf=(`cat $IN`)
	NOMACHINESinf=`echo ${#MACHINESinf[@]}`
    fi
else 
#    printf "\t ${RED}Hold on !${NC}\n"
#    printf "\tTo run with infiniband\n"
#    printf "\tyou need to be in quad01\n"
#    printf "\t ${RED}Stop right now ...${NC}\n"
    exit 0 
fi 
######
SAL=0
while [ "$SAL" -lt "10" ];do
    MACHINESinf=(`cat $IN`)
    NOMACHINESinf=`echo ${#MACHINESinf[@]}`
#    Line
#    echo "mpdboot -v -r ssh -f $IN -n $NOMACHINESinf > INFI"
#    Line
    mpdboot -v -r ssh -f $IN -n $NOMACHINESinf > INFI
    QUEPEX=`grep "failed to connect to mpd" INFI`
    rm -f $IN
    touch $IN
    if [ -z "$QUEPEX" ];then 
	printf "\t Infiniband working in alive nodes is ok and your final list is:\n"
	for ((hh=0;hh<=($NOMACHINESinf-1); hh++));do
	    let "PP=hh+1"
	    printf "\t[$PP] ${MACHINESinf[$hh]}\n"
	    echo ${MACHINESinf[$hh]} >> $IN
	done 
	Line
	printf "\tin file ${RED}$IN${NC}\n"
	Line
	SAL=20
    else 
	NODE=`echo ${QUEPEX: -6}`
	for ((hh=0;hh<=($NOMACHINESinf-1); hh++));do
	    if [ ${MACHINESinf[$hh]} != $NODE ];then 
		echo ${MACHINESinf[$hh]} >> $IN 
	    else
		echo -e ${BLUE}******************${NC}
		echo -e ${RED} node ${MACHINESinf[$hh]} does not have infiniband connection${NC}
		echo -e ${BLUE}******************${NC}
	    fi 
	done
    fi 
done      
rm -f INFI
