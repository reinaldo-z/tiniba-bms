#!/bin/bash
##
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color
##
case=`basename $PWD`
    espin=`grep nspinor $case'_check'/$case.out | awk -F= '{print $4}' | awk '{print $1}'`
    ecut=`grep ecut setUpAbinit_$case.in  |  awk '{print $2}'`
    printf "\t$espin $ecut\n"
    if [ $espin == '1' ]
    then
	ospin='nospin'
    else
	ospin='spin'
    fi
    last_name='_'$ecut'-'$ospin
##
    function Line {
	printf "\t${BLUE}=============================${NC}\n"
    }
##
    clear
##
    if [ "$#" -eq 0 ]
    then
	Line
	printf "\truns any response for 4 cuadrants\n"
	printf "\tkz>0\n"
	printf "\tkx>0,ky>0=>${red}c1${NC},kx<0,ky>0=>${red}c2${NC},kx<0,ky<0=>${red}c3${NC},kx>0,ky<0=>${red}c4${NC}\n"
	printf "\tkz<0\n"
	printf "\tkx>0,ky>0=>${red}c5${NC},kx<0,ky>0=>${red}c6${NC},kx<0,ky<0=>${red}c7${NC},kx>0,ky<0=>${red}c8${NC}\n"
	printf "\tusage:\n"
	printf "\t Edit 4cuadrants-res.sh with the options you want to use, then:\n"
	printf "\t${blue}4cuadrants-res.sh${NC} [${red}Nk${NC}]\n"
	Line
	exit 1
    fi
    if [ ! "$#" -eq 0 ]
    then
	Nk=$1
	cual=symmetries/$case.kcartesian_$Nk
# generates the kpoints for the four kz>0 cuadrants
# c1-direct lattice
	cp $case.klist_$Nk $case.klist_$Nk.c1 
# c2: change k-cartesian  and then transform to k-direct-lattice
	awk '{print -$1,$2,$3}' $cual > fort.9
	echo $Nk 1 | rkcart2dlatt > $case.klist_$Nk.c2 
# c3: change k-cartesian  and then transform to k-direct-lattice
	awk '{print -$1,-$2,$3}' $cual > fort.9 
	echo $Nk 1 | rkcart2dlatt > $case.klist_$Nk.c3 
# c4: change k-cartesian  and then transform to k-direct-lattice
	awk '{print $1,-$2,$3}' $cual > fort.9
	echo $Nk 1 | rkcart2dlatt > $case.klist_$Nk.c4
# generates the kpoints for the c7 kz<0 cuadrant
# c7: change k-cartesian  and then transform to k-direct-lattice
	awk '{print -$1,-$2,-$3}' $cual > fort.9
	echo $Nk 1 | rkcart2dlatt > $case.klist_$Nk.c7
#
	rm fort.9
# runs for each set of k-points
#    exit 1
# chose the number of layers
	Nlayers=3
# chose the cuadrants to be run
	cases=(c1 c2 c3 c4 c7)
	for c in ${cases[@]}
	do
	    Line
	    printf "\t runing for $c $Nk\n"
	    Line
	    cp $case.klist_$Nk.$c $case.klist_$Nk 
	    run_tiniba.sh -r run -k $Nk -N $Nlayers -x 2 -w -e -p -l
	    mv eigen_$Nk$last_name eigen_$Nk$last_name.$c
	    mv me_pmn_$Nk$last_name me_pmn_$Nk$last_name.$c
	    mv me_pnn_$Nk$last_name me_pnn_$Nk$last_name.$c
	    if [ 1 == 1 ]
	    then
## chose the layers to be run
#		layers=(1 2 3 4 5 6 7 8 9 10 11 12)
	        layers=(1 12 middle)
		for L in ${layers[@]}
		do
		    mv me_cpnn_$Nk'_'$L$last_name me_cpnn_$Nk'_'$L$last_name.$c
		done
	    fi
	done
# return to the original k-points
	cp $case.klist_$Nk.c1 $case.klist_$Nk  
    fi
