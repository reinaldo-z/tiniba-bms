#!/bin/bash 
# 
# runs abinit to check for symmetries
## CHILDREN 
## LAST MODIFICATION :: Martes 11 Marzo 2010 
  RED='\e[0;31m'
 BLUE='\e[0;34m'
  BLU='\e[1;34m'
 CYAN='\e[0;36m'
GREEN='\e[0;32m'
  GRE='\e[1;32m'
 YELLOW='\e[1;33m'
  MAG='\e[0;35m'
   NC='\e[0m' # No Color

### define in nice way.
    WHERE=`dirname $0`
  BASEDIR=`dirname $PWD`
     CASO=`basename $PWD`
   PARENT=`basename $BASEDIR`
   DIRSCF=$CASO'_scf'
 if [ "$#" -eq 0 ];then 
     printf  "\tUsage: \n"
     printf  "\t$WHERE/${GREEN}`basename $0${NC}` 1\n"
     printf  "\t$WHERE/${GREEN}`basename $0${NC}` 2\n"
     exit 0 
 fi   



 printf "\t${MAG}Running: ${NC} $WHERE/${GREEN}`basename $0${NC}` $1 \n"

exit 0


##
clear
host=`hostname`
case=`echo $PWD | awk -F / '{print$NF}'`
dir=$PWD
ab_exec_xeon=/home/narzate/share_new/abinit-4.6.5/abinis
where=$HOME/abinit_shells/utils
whereset=$HOME/abinit_shells/clustering/itaxeo



if [[ ! -e .machines_pmn || ! -e .machines_scf ]]
    then
    echo -e ${cyan} %%%%%%%%%%%%%%%% ${NC}
    echo -e "${RED}   .machines_pmn or .machines_scf don't exist"
    echo -e "${blue}               create both!"
    echo -e ${cyan} %%%%%%%%%%%%%%%% ${NC}
exit 1
fi
if [ "$#" -eq 0 ]
    then   # Script needs at least one command-line argument.
    echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    echo -e "${blue}runs abinit to check for symmetries${NC}"
    echo -e "run with: ~/spin/abinit/utils/abinit_check.sh ${RED}1-set up${NC}; ${BLUE}2-symmetries${NC}"
    echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    exit 1
fi
####
if [ -z "$2" ]
    then   # checks if the 2nd argument is given
    cual=0 # if not
    else
    cual=1 #if yes
fi
if [ $1 == '1' ] 
    then
    if [ -e $case'_'check ]
	then
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	echo -e ${RED} $case'_'check exists${NC} remove if you want to run anyway: ${BLUE}rm -rf $case'_'check${NC}
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	exit 1
    fi
    if [ -e $case'_'scf ]
	then
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	echo  $case'_'scf exists  moving to $case'_'scf_aux 
	mv $case'_'scf $case'_'scf_aux
    fi
# strips strange characters from setUp
    sed 's/[[:cntrl:]]//g' setUpAbinit_$case.in > perro
    mv perro setUpAbinit_$case.in
    echo 0 0 0 > uno
    $whereset/set.pl uno 1 0 > rem
    rm rem uno
#    setUpAbinit_$case.in uno 1 0 > dos
    rm -fr $case'_'1
    rm -fr $case'_'bandstructure
#    rm -fr JOBS
    mv $case'_'scf $case'_check'
    cd $case'_check'
    grep -v prtvol $case.in > hoy
    echo prtvol -1 >> hoy
    mv hoy $case.in
    $ab_exec_xeon < $case.files > log
#    echo -e ${RED}aqui${NC}
    cd ..
#exit 1
    if [ -e $case'_'scf_aux ]
	then
	echo  $case'_'scf_aux exists  moving to $case'_'scf 
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	mv $case'_'scf_aux $case'_'scf
    fi
    echo -e "${CYAN}%%%%%%%%%%%%%%%%%%%%%%%%%%%${NC}"
    echo -e  ${red}output in ${blue}$case'_'check${NC}
    echo -e "${CYAN}%%%%%%%%%%%%%%%%%%%%%%%%%%%${NC}"
    rm -f $case.files
    exit 1
fi
if [ $1 == '2' ] 
    then
# create symmetries if doesn't exist
if [ ! -e symmetries ]
    then
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "making symmetries"
    mkdir symmetries
fi
# extracts symmetry matrices
    echo -e "${CYAN}%%%%%%%%%%%%%%%%%%%%%%%%%%%${NC}"
    echo -e  info from ${BLUE}$case'_'check/$case.out${NC}
    group=`grep "space group" $case'_'check/$case.out | awk -F: '{print $2}'`
    nsym=`grep nsym $case'_'check/$case.out | tail -1 | awk '{print $2}'`
    nlines=`echo "scale=0; $nsym/2" | bc -l`
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo -e ${red}$group${NC}
    echo -e "${red}nsym${NC}=${blue}$nsym${NC} in $nlines lines"
    nlines=`echo "scale=0; $nlines - 1" | bc -l`
    if [ $nlines != '-1' ]
	then
 	grep -A$nlines symrel $case'_'check/$case.out
 	grep -A$nlines symrel $case'_'check/$case.out > hoy
    else
 	grep  symrel $case'_'check/$case.out
 	grep  symrel $case'_'check/$case.out > hoy
    fi
    sed s/symrel// hoy > hoy1
    awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,"\n",$10,$11,$12,$13,$14,$15,$16,$17,$18}' hoy1 > hoy2
    nt=`wc hoy2 | awk '{print $1}'`
    if [ $nsym != $nt ] 
	then
	if [ $nsym = '1' ]
	    then
	    echo -e "${red}nsym=$nsym which imply identinty as the only symmetry${NC}"
	    echo 1 > sym.d
	    echo 1 0 0 >> sym.d
	    echo 0 1 0 >> sym.d
	    echo 0 0 1 >> sym.d
	    mv sym.d symmetries/.
	echo "output in symmetries/sym.d"
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	else
	echo "nsym=$nsym not equal to number of lines $nt, check something is wrong"
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	exit 1
	fi
    else
	echo $nt > hoy1
	cat hoy1 hoy2 > sym.d
	mv sym.d symmetries/.
	echo "nsym=$nsym equal to $nt lines in symmetries/sym.d"
	echo -e ${CYAN}"%%%%%%%%%%%%%%%%%%%%%%%%%%%"${NC}
    fi
# looks for centrosymmetry
    rm -f ifcentrosymmetric
    cp symmetries/sym.d fort.9
    if [ "$host" == 'master' ]; then
    sim=`$where/inversion`
    fi
    if [ "$host" == 'quad01' ]; then
    sim=`$where/inversion-quad`
    fi
    rm fort.9
    if [ $sim == 'scs' ]
	then
	echo yes > ifcentrosymmetric
	echo -e "${RED} SLAB IS CENTROSYMMETRIC:${BLUE} for an odd rank tensor surface response"${NC} 
	echo -e "${blue}                 run: ${RED}odd_rank.sh"${NC}
    else
	if [ $cual == '1' ]
	then
	echo odd_rank no > ifcentrosymmetric
	else
	echo no > ifcentrosymmetric
	fi
	echo -e ${RED} SLAB IS NOT CENTROSYMMETRIC
    fi
	echo -e ${CYAN}"%%%%%%%%%%%%%%%%%%%%%%%%%%%"${NC}
# extracts primitive vectors
    a0=`grep a0b setUpAbinit_$case.in | awk '{print $5}'`
    a1=`grep -e acell setUpAbinit_$case.in | awk '{print $2}'`
    a2=`grep -e acell setUpAbinit_$case.in | awk '{print $3}'`
    a3=`grep -e acell setUpAbinit_$case.in | awk '{print $4}'`
    echo -e a0=${RED}$a0${NC} Bohrs a1=$a1 a2=$a2 a3=$a3
#    a10=`echo "scale=6; $a1/$a0" | bc -l`
#    a20=`echo "scale=6; $a2/$a0" | bc -l`
#    a30=`echo "scale=6; $a3/$a0" | bc -l`
    p1=`grep  -e rprim setUpAbinit_$case.in | awk '{print $2,$3,$4}'`
    p2=`grep -A1 -e rprim setUpAbinit_$case.in | tail -1 | awk '{print $1,$2,$3}'`
    p3=`grep -A2 -e rprim setUpAbinit_$case.in | tail -1 | awk '{print $1,$2,$3}'`
    echo primitive vectors
    echo $p1 
    echo $p2 
    echo $p3
#    echo a1/a0=$a10 a2/a0=$a20 a3/a0=$a30
    echo a1=$a1 a2=$a2 a3=$a3
    echo -e "${CYAN}%%%%%%%%%%%%%%%%%%%%%%%%%%%${NC}"
    echo $p1 >  symmetries/pvectors
    echo $p2 >> symmetries/pvectors
    echo $p3 >> symmetries/pvectors
#    echo $a10 $a20 $a30 >> symmetries/pvectors
    echo $a1 $a2 $a3 >> symmetries/pvectors
    nat=`grep natom $case'_check'/$case.out | grep -v nkpt | awk '{print $2}'`
    z1=`grep xcart $case'_check'/$case.out | awk '{print $4}'`
    natm1=`echo "scale=0; $nat - 1" | bc -l`
    z2=`grep -C $natm1 xcart $case'_check'/$case.out | tail -1 | awk '{print $3}'`
    if [ '$host' == 'master' ]; then
    echo $z1 $z2 $a3 | $where/suma
    fi
    if [ '$host' == 'quad01' ]; then
    echo $z1 $z2 $a3 | $where/suma-quad
    fi
    npw=`grep mpw $case'_check'/$case.out | awk '{print $12}'`
    echo -e ${RED} number of plane waves = $npw ${NC}
    echo -e "${CYAN}%%%%%%%%%%%%%%%%%%%%%%%%%%%${NC}"
    grep -A3 -B1 job $case'_check'/$case.out
    rm -f hoy*
    exit 1
fi


