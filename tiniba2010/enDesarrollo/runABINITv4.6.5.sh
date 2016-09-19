#!/bin/bash
## CHILDREN : checkPSPabinit.pl
## please keep the history modification and send me (sollebac@gmail.com) a copy
## LAST MODIFICATION : 15 Febrero 2010 at 16:00 hrs by Cabellos JL 
## LAST MODIFICATION : 16 Febrero 2010 at 17:55 hrs by Cabellos JL 
## NOTE              : This is the most advanced script 
## This is free software; .There is NO warranty. jl
   RED='\e[0;31m'
   BLUE='\e[0;34m'
    BLU='\e[1;34m'
   CYAN='\e[0;36m'
  GREEN='\e[0;32m'
    GRE='\e[1;32m'
 YELLOW='\e[1;33m'
    MAG='\e[0;35m'
     NC='\e[0m' # No Color

## DEFINITION OF ABINIT 
## DEFINITION OF ABINIT 
## DEFINITION OF ABINIT 

 ABINIs_XEON='/home/prog/abinit/ABINITv4.6.5_XEON/abinip.xeon'
 ABINIp_XEON='/home/prog/abinit/ABINITv4.6.5_XEON/abinip.xeon'
 ABINIs_ITAN='/home/prog/abinit/ABINITv4.6.5_ITAN/abinis.itan'
 ABINIp_ITAN='/home/prog/abinit/ABINITv4.6.5_ITAN/abinip.itan'
 ABINIs_QUAD='/home/prog/abinit/ABINITv4.6.5_QUAD/abinis.quad'
 ABINIp_QUAD='/home/prog/abinit/ABINITv4.6.5_QUAD/abinip.quad'

  MPICH_XEON='/usr/local/mpich_gm_intel9/bin'
  MPICH_ITAN='/usr/local/mpich-itanium-intel9/bin'

     WHERE=`dirname $0`
      JOSE=`basename $0`
     CHPSP='/tmp/checkpsp.pl'
        GA='31ga.3.hgh-cabellos'
        AS='33as.5.hgh-cabellos'
      CASO='GaAs'
       DIR=$PWD
### define my diccionary 
### define my diccionary 
### define my diccionary 
DICC[0]="xeonp"
DICC[1]="xeons"
DICC[2]="itaniums"
DICC[3]="itaniump"
DICC[4]="quads"
DICC[5]="quadp"
DICC[6]="check"
###
###
### hha this all the cluster jl
MAQ501[1]="node01";MAQ501[12]="node12";MAQ501[23]="quad04"
MAQ501[2]="node02";MAQ501[13]="node13";MAQ501[24]="quad05"
MAQ501[3]="node03";MAQ501[14]="node14";MAQ501[25]="quad06"
MAQ501[4]="node04";MAQ501[15]="node15";MAQ501[26]="quad07"
MAQ501[5]="node05";MAQ501[16]="itanium01";MAQ501[27]="quad08"
MAQ501[6]="node06";MAQ501[17]="itanium02";MAQ501[28]="quad09"
MAQ501[7]="node07";MAQ501[18]="itanium03";MAQ501[29]="quad10"
MAQ501[8]="node08";MAQ501[19]="itanium04";MAQ501[30]="quad11"
MAQ501[9]="node09";MAQ501[20]="quad01";MAQ501[31]="quad12"
MAQ501[10]="node10";MAQ501[21]="quad02";MAQ501[32]="quad13"
MAQ501[11]="node11";MAQ501[22]="quad03";MAQ501[33]="quad14"
###
###
IPES[1]="192.168.1.1";IPES[12]="192.168.1.12";IPES[23]="192.168.1.23"
IPES[2]="192.168.1.2";IPES[13]="192.168.1.13";IPES[24]="192.168.1.24"
IPES[3]="192.168.1.3";IPES[14]="192.168.1.14";IPES[25]="192.168.1.25"
IPES[4]="192.168.1.4";IPES[15]="192.168.1.15";IPES[26]="192.168.1.26"
IPES[5]="192.168.1.5";IPES[16]="192.168.1.16";IPES[27]="192.168.1.27"
IPES[6]="192.168.1.6";IPES[17]="192.168.1.17";IPES[28]="192.168.1.28"
IPES[7]="192.168.1.7";IPES[18]="192.168.1.18";IPES[29]="192.168.1.29"
IPES[8]="192.168.1.8";IPES[19]="192.168.1.19";IPES[30]="192.168.1.30"
IPES[9]="192.168.1.9";IPES[20]="192.168.1.20";IPES[31]="192.168.1.31"
IPES[10]="192.168.1.10";IPES[21]="192.168.1.21";IPES[32]="192.168.1.32"
IPES[11]="192.168.1.11";IPES[22]="192.168.1.22";IPES[33]="192.168.1.33"
###
###
function findMaq {
OUTA=1
 SALIDA="Not-Found"
  NOMAQ501a=`echo ${#MAQ501[@]}`
   for ((kk=1;kk<=($NOMAQ501a); kk++));do       
     MAQ502a=${MAQ501[$kk]}
       if [ "$MAQ502a" == "$1" ];then 
         OUTA=0
          SALIDA="$kk"
       fi 
   done 
}
###
###
###
function help {
 printf "\tUsage: `dirname $0`/${GREEN}`basename $0`${NC} [${GREEN}option${NC}] \n"
  printf "\t[${GREEN}option${NC}] could be:\n"
  printf "\t ${GREEN}xeons ${NC}   : run serial in master\n"
  printf "\t ${GREEN}xeonp ${NC}   : run parall in machines given in: machinesXEON\n"
  printf "\t ${GREEN}itaniums${NC} : run serial in itanium01\n"
  printf "\t ${GREEN}itaniump${NC} : run parall in machines given in: machinesITAN\n"
  printf "\t ${GREEN}quads${NC}    : run serial in quad01\n"
  printf "\t ${GREEN}quadp${NC}    : run parall in machines given in: machinesQUAD\n"
  printf "\t ${GREEN}check${NC}    : check if all things are mounted ...\n"
  printf "\t Stoping right now ...\n"
  exit 0
}
###
###
function galium {
echo "Hartwigsen-Goedecker-Hutter psp for Ga,  from PRB58, 3641 (1998)" >$GA
echo "   31   3  010605 zatom,zion,pspdat" >> $GA
echo " 3 1   2 0 2001 0  pspcod,pspxc,lmax,lloc,mmax,r2well " >> $GA
echo "  0.560000    0.000000    0.000000    0.000000   0.000000 rloc, c1, c2, c3, c4" >> $GA
echo "  0.610791    2.369325   -0.249015   -0.551796          rs, h11s, h22s, h33s" >> $GA
echo "  0.704596    0.746305   -0.513132    0.000000          rp, h11p, h22p, h33p" >> $GA
echo "              0.029607   -0.000873    0.000000                          k11p, k22p, k33p" >> $GA
echo "  0.982580    0.075437    0.000000    0.000000          rd, h11d, h22d, h33d" >> $GA
echo "              0.001486    0.000000    0.000000                          k11d, k22d, k33d" >> $GA
echo "  0.000000    0.000000    0.000000    0.000000          rf, h11f, h22f, h33f" >> $GA
echo "              0.000000    0.000000    0.000000                          k11f, k22f, k33f" >> $GA
}
function arsenico {
echo "Hartwigsen-Goedecker-Hutter psp for As,  from PRB58, 3641 (1998) ">$AS
echo "   33   5  010605 zatom,zion,pspdat">>$AS
echo " 3 1   2 0 2001 0  pspcod,pspxc,lmax,lloc,mmax,r2well ">>$AS
echo "  0.520000    0.000000    0.000000    0.000000   0.000000 rloc, c1, c2, c3, c4">>$AS
echo "  0.456400    4.560761    1.692389   -1.373804          rs, h11s, h22s, h33s">>$AS
echo "  0.550562    1.812247   -0.646727    0.000000          rp, h11p, h22p, h33p">>$AS
echo "              0.052466    0.020562    0.000000                          k11p, k22p, k33p">>$AS
echo "  0.685283    0.312373    0.000000    0.000000          rd, h11d, h22d, h33d">>$AS
echo "              0.004273    0.000000    0.000000                          k11d, k22d, k33d">>$AS
echo "  0.000000    0.000000    0.000000    0.000000          rf, h11f, h22f, h33f">>$AS
echo "              0.000000    0.000000    0.000000                          k11f, k22f, k33f">>$AS
}
function files {
echo "$CASO.in"  > $CASO.files 
echo "$CASO.out">> $CASO.files 
echo "$CASO"i"" >> $CASO.files 
echo "$CASO"o"" >> $CASO.files 
echo "$CASO"    >> $CASO.files 
echo "$PWD/$GA" >> $CASO.files 
echo "$PWD/$AS" >> $CASO.files 
}
function puntoIn {
echo "# GaAs by J.L. Cabellos" > $CASO.in  
echo "#" >> $CASO.in  
echo "# Computation o the band structure." >> $CASO.in  
echo "# First, a SCF density computation, then a non-SCF band structure calculation." >> $CASO.in  
echo "ndtset 2" >> $CASO.in  
echo "prtvol2 10" >> $CASO.in  
echo "prtvol1 10" >> $CASO.in  
echo "prtvha 1" >> $CASO.in  
echo "prteig 1" >> $CASO.in                       
echo "#Dataset 1 : usual self-consistent calculation" >> $CASO.in  
echo "kptopt1 1          # Option for the automatic generation of k points," >> $CASO.in  
                   # taking into account the symmetry" >> $CASO.in  
echo "nshiftk1 4" >> $CASO.in  
echo "shiftk1  0.5 0.5 0.5  # These shifts will be the same for all grids" >> $CASO.in  
echo "         0.5 0.0 0.0" >> $CASO.in  
echo "         0.0 0.5 0.0" >> $CASO.in  
echo "         0.0 0.0 0.5" >> $CASO.in  
echo "ngkpt1  4 4 4  " >> $CASO.in  
echo "prtden1  1         # Print the density, for use by dataset 2" >> $CASO.in  
echo "toldfe1  1.0d-6" >> $CASO.in  
echo "#Dataset 2 : the band structure" >> $CASO.in  
echo "iscf2    -2" >> $CASO.in  
echo "getden2  -1" >> $CASO.in  
echo "kptopt2  -3" >> $CASO.in  
echo "nband2   30" >> $CASO.in  
echo "ndivk2   100 120 170   # 10, 12 and 17 divisions of the 3 segments," >> $CASO.in  
echo "                       # by 4 points." >> $CASO.in  
echo "kptbounds2  0.5  0.0  0.0 # L point" >> $CASO.in  
echo "            0.0  0.0  0.0 # Gamma point" >> $CASO.in  
echo "            0.0  0.5  0.5 # X point" >> $CASO.in  
echo "            1.0  1.0  1.0 # Gamma point in another cell." >> $CASO.in  
echo "tolwfr2  1.0d-12" >> $CASO.in  
echo "enunit2  1             # Will output the eigenenergies in eV " >> $CASO.in  
echo "#Definition of the unit cell" >> $CASO.in  
echo "#acell 3*10.676952 " >> $CASO.in         
echo "acell 3*10.646952  " >> $CASO.in        
echo "rprim  0.0  0.5  0.5   # FCC primitive vectors (to be scaled by acell)" >> $CASO.in  
echo "       0.5  0.0  0.5   " >> $CASO.in  
echo "       0.5  0.5  0.0" >> $CASO.in  
echo "#Definition of the atom types" >> $CASO.in  
echo "ntypat 2       # There are  only 2 type of atom" >> $CASO.in  
echo "znucl  31 33    # The keyword "znucl" refers to the atomic number of the " >> $CASO.in  
echo "                # possible type(s) of atom. The pseudopotential(s) " >> $CASO.in  
echo "                # mentioned in the "files" file must correspond" >> $CASO.in  
echo "                  # to the type(s) of atom. Here, the only type is Silicon." >> $CASO.in  
echo "#Definition of the atoms" >> $CASO.in  
echo "natom 2           # There are two atoms" >> $CASO.in  
echo "typat 1 2         # ga as." >> $CASO.in  
echo "xred              # This keyword indicate that the location of the atoms" >> $CASO.in  
echo "                  # will follow, one triplet of number for each atom" >> $CASO.in  
echo "   0.0  0.0  0.0  # Triplet giving the REDUCED coordinate of atom 1." >> $CASO.in  
echo "  1/4  1/4  1/4  # Triplet giving the REDUCED coordinate of atom 2." >> $CASO.in  
echo "#Definition of the planewave basis set" >> $CASO.in  
echo "ecut 10         # Maximal kinetic energy cut-off, in Hartree" >> $CASO.in  
echo "#so_typat      1 1" >> $CASO.in  
echo "so_psp      1 1" >> $CASO.in  
echo "nspinor     1 " >> $CASO.in  
echo "#Definition of the SCF procedure" >> $CASO.in  
echo "nstep 100          # Maximal number of SCF cycles" >> $CASO.in  
echo "diemac 12.0       # Although this is not mandatory, it is worth to" >> $CASO.in  
echo "                  # precondition the SCF cycle. The model dielectric" >> $CASO.in  
echo "                  # function used as the standard preconditioner" >> $CASO.in  
echo "                  # is described in the "dielng" input variable section." >> $CASO.in  
echo "                  # Here, we follow the prescription for bulk silicon." >> $CASO.in  
}
################################
###### Begin code ##############
################################
  if [ $# -eq 0 ];then
   help ## get out of here
  fi 
###
###    
  ARCH=`echo $1  | tr '[A-Z]' '[a-z]'`
   NODICC=`echo ${#DICC[@]}`
    OUT=1
     for ((hh=0;hh<=($NODICC-1); hh++));do
       LOOK=${DICC[$hh]}
        if [ "$ARCH" == "$LOOK" ];then
         OUT=0       
        fi
     done
       if [ "$OUT" == "1" ];then
        help  ## get out of here
       fi 
###
###
###
   if [ ! -e $GA ];then 
     galium
   fi 
###
###
###
   if [ ! -e $AS ];then 
     arsenico
   fi    
###
###
###
   if [ ! -e $CASO.files ];then 
     files
   fi 
###
###
###
   if [ -e $CASO.in ];then 
    #printf "\tFile:  $CASO.in [${GREEN}exist${NC}]\n"
    #printf "\tIf you want to take this:  press enter to continue  or ctrl c to kill me\n"
    #read -p ""
   #else 
   puntoIn 
   fi
    TIMESTARTALL=`date` 
################################
########### QUAD PARALLEL ######
################################

if [ "$ARCH" == "quadp" ];then 
     ARQ="quad" 
 ARCHIVO="machinesQUAD"
   if [ ! -e $ARCHIVO ];then
       printf "\tThere is not FILE: $ARCHIVO, Im going to do one now ... \n"
        NOMAQ501=`echo ${#MAQ501[@]}`
         jj=0
          rm -f $ARCHIVO ## paranoia jl
           touch $ARCHIVO
            for ((hh=1;hh<=($NOMAQ501); hh++));do       
              MAQ502=${MAQ501[$hh]}
               if [[ "$MAQ502" == "$ARQ"* ]]; then
                echo "$MAQ502" >> $ARCHIVO
               fi 
            done 
   fi 
    rm -f tmpQ 
     sed '/^ *$/d' $ARCHIVO  >  tmpQ
      mv tmpQ $ARCHIVO
       rm -f tmpQ
        MACH=(`cat $ARCHIVO`)
         NOMACH=`echo ${#MACH[@]}`
          jj=0
           rm -f $ARCHIVO
            touch $ARCHIVO
             for ((hh=0;hh<=($NOMACH-1); hh++));do       
               MAQ502=${MACH[$hh]}
                if [[ "$MAQ502" == "$ARQ"* ]]; then
                  IPT=`nmap --max_rtt_timeout 20  -oG - -p 514  $MAQ502 | grep open | cut -d" " -f2`
                   findMaq $MAQ502 
                    if [ "$IPT" == "${IPES[$SALIDA]}" ];then
                      let "jj=jj+1"
                       printf "\t$jj) $MAQ502    [${GREEN}Alive${NC}]\n"
                        echo "$MAQ502" >> $ARCHIVO
                    else 
                       let "jj=jj+1"
                        printf "\t$jj) ${RED}$MAQ502${NC}    [${RED}Dead${NC}]\n"
                    fi 
               fi 
             done
###
      rm -f tmpQ 
       sed '/^ *$/d' $ARCHIVO  >  tmpQ
        mv tmpQ $ARCHIVO
         rm -f tmpQ
          NMA=`wc $ARCHIVO | awk '{print$1}'` 
           printf "\t========================================\n"
           printf "\tIm going to run in ${GREEN}$NMA${NC} machines that are found in file $ARCHIVO\n"
###
###

 if [  -e $ABINIp_QUAD ];then 
    printf "\t ===============\n"
     printf "\tLaunching abinip QUAD parallel in $NMA nodes \n"
     printf "\t$ABINIp_QUAD\n"
      printf "\t The number of nuclei by node to be used must be defined\n"
       printf "\t Input number of nuclei ?   \n"
        read nNUCLEI
        if [ $nNUCLEI -eq $nNUCLEI 2> /dev/null ];then
          if   [  -z $nNUCLEI ] || [  "$nNUCLEI" -lt "1" ] ; then
            printf "\t${RED}WARNING${NC}: The number of nuclei of must be input integer > 0\n"
             printf "\t Stop right now ...\n"
              exit 0
          fi 
        else
         printf "\t$nNUCLEI is not a number...hei give me a number...\n"
          exit 0
        fi         
         let "nPROC=$NMA * $nNUCLEI"
          RUN="mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO.files > &log"
          CAMINO="/opt/intel/impi/3.1/bin"
           if [ `hostname` == "quad01" ];then
             cd $DIR
              echo $RUN
                $CAMINO/mpdboot -v -r ssh -f machinesQUAD -n $NMA
                $CAMINO/mpdtrace
                pwd
                hostname
                printf "\tYou are in: `hostname`:$DIR \n"
               printf "\t    runing quad parallel in $NMA machines:\n\t$RUN \n"
                $CAMINO/mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO.files >&log
           else
               printf  "\t Opening the socket \n"
               rsh quad01 "cd $DIR;$CAMINO/mpdboot -v -r ssh -f machinesQUAD -n $NMA"
               rsh quad01 "cd $DIR;$CAMINO/mpdtrace"
               rsh quad01 "cd $DIR;pwd;hostname"
               printf "\tYou are in: `hostname`:$DIR \n"
               printf "\t    runing quad parallel in $NMA machines:\n\t$RUN \n"
               rsh quad01 "cd $DIR;$CAMINO/mpiexec  $CAMINO/$RUN"
                ###================= taking time
           fi 
               TIMEENDALL=`date`
               printf "\t--------------------------------------------------\n"
               printf "\tFinished all at time: $TIMEENDALL \n"
               printf "\t--------------------------------------------------\n"
               TIME1=`date --date="$TIMESTARTALL" +%s`
               TIME2=`date --date="$TIMEENDALL" +%s`
               ELTIME=$[ $TIME2 - $TIME1 ]
               TMIN=$(echo "scale=9; $ELTIME/60" | bc)
               TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
               printf "\t take:   $TMIN min. \n"
               printf "\t take:   $TMIN1 Hrs. \n"
               printf "\t--------------------------------------------------\n"
  
 else
    printf "\tI can find: $ABINIp_QUAD \n"
    printf "\tStoping right now ...\n"
    exit 0
 fi ### 
fi  ### 
################################
########### QUAD SERIAL ########
################################ 
  if [ "$ARCH" == "quads" ];then
   
    if [  -e $ABINIs_QUAD ];then 
      printf "\t ===============\n"
      printf "\t${BLUE} Launching abinis${NC} QUAD "
      printf "SERIAL in quad01 machine \n"
      RUN="$ABINIs_QUAD <$CASO.files > &log"
      rsh quad01 "cd $DIR;pwd;hostname"
      echo $RUN
      rsh quad01 "cd $DIR;$RUN"
       ###================= taking time
      TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: $TIMEENDALL \n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
   ###=================    
    else 
      printf "\t${RED}I can find:${NC} $ABINITs_QUAD \n"
      printf "\tStoping right now ...\n"
  exit 1
    fi 
   fi ##
################################
########### XEON PARALLEL ######
################################ 
if [ "$ARCH" == "xeonp" ];then 
     ARQ="node" 
 ARCHIVO="machinesXEON"
   if [ ! -e $ARCHIVO ];then
       printf "\tThere is not FILE: $ARCHIVO, Im going to do one now ... \n"
        NOMAQ501=`echo ${#MAQ501[@]}`
         jj=0
          rm -f $ARCHIVO ## paranoia jl
           touch $ARCHIVO
            for ((hh=1;hh<=($NOMAQ501); hh++));do       
              MAQ502=${MAQ501[$hh]}
               if [[ "$MAQ502" == "$ARQ"* ]]; then
                echo "$MAQ502" >> $ARCHIVO
               fi 
            done 
   fi 
    rm -f tmpQ 
     sed '/^ *$/d' $ARCHIVO  >  tmpQ
      mv tmpQ $ARCHIVO
       rm -f tmpQ
        MACH=(`cat $ARCHIVO`)
         NOMACH=`echo ${#MACH[@]}`
          jj=0
           rm -f $ARCHIVO
            touch $ARCHIVO
             for ((hh=0;hh<=($NOMACH-1); hh++));do       
               MAQ502=${MACH[$hh]}
                if [[ "$MAQ502" == "$ARQ"* ]]; then
                  IPT=`nmap --max_rtt_timeout 20  -oG - -p 514  $MAQ502 | grep open | cut -d" " -f2`
                   findMaq $MAQ502 
                    if [ "$IPT" == "${IPES[$SALIDA]}" ];then
                      let "jj=jj+1"
                       printf "\t$jj) $MAQ502    [${GREEN}Alive${NC}]\n"
                        echo "$MAQ502" >> $ARCHIVO
                    else 
                       let "jj=jj+1"
                        printf "\t$jj) ${RED}$MAQ502${NC}    [${RED}Dead${NC}]\n"
                    fi 
               fi 
             done
###
      rm -f tmpQ 
       sed '/^ *$/d' $ARCHIVO  >  tmpQ
        mv tmpQ $ARCHIVO
         rm -f tmpQ
          NMA=`wc $ARCHIVO | awk '{print$1}'` 
           printf "\t========================================\n"
           printf "\tIm going to run in ${GREEN}$NMA${NC} machines that are found in file $ARCHIVO\n"
          if [  -e $ABINIp_XEON ];then
     printf "\t ===============\n"
      printf "\t${BLUE} Launching abinip${NC} XEON \n"
      printf "parall  in $NMA machines \n"
/usr/local/mpich_gm_intel9/bin/mpirun -machinefile machinesXEON -np $NMA  $ABINIp_XEON < GaAs.files >&log 
          fi
     ###================= taking time
###
###
fi 


 exit 0
 exit 0












 ARCH=$1
 DIR=$PWD
 CASO='GaAs.files'
 ABINIs_XEON='/home/narzate/share_new/abinit-4.6.5/abinis'
 ABINIs_ITAN='/home/narzate/share_new/abinit-4.6.5/abinis.itanium'
 ABINIs_QUAD='/home/prog/abinit/prueba/abinit-4.6.5/abinis'

 ABINIp_XEON='/home/narzate/share_new/abinit-4.6.5/abinip'
 ABINIp_ITAN='/home/narzate/share_new/abinit-4.6.5/abinip.itanium'
 ABINIp_QUAD='/home/prog/abinit/ABINITv4.6.5_QUAD/abinip'


 MPICH_XEON=/usr/local/mpich_gm_intel9/bin
 MPICH_ITAN=/usr/local/mpich-itanium-intel9/bin

  if [ $# -eq 0 ];then
  printf "\tUsage: `basename $0` [option] \n"
  printf "\t[option] could be:\n"
  printf "\t xeons    : run serial in master\n"
  printf "\t xeonp    : run parall in machines given in: machinesXEON\n"
  printf "\t itaniums : run serial in itanium01\n"
  printf "\t itaniump : run parall in machines given in: machinesITAN\n"
  printf "\t quads    : run serial in quad01\n"
  printf "\t quadp    : run parall in machines given in: machinesQUAD\n"
  printf "\t Stoping right now ...\n"
  exit 1
  fi 

 TIMESTARTALL=`date`
 printf "\tAll Started at: $TIMESTARTALL \n"
 if [ ! -e $HOME/bin/checkPSPabinit.pl ];then    
  cp /home/jl/bin/checkPSPabinit.pl  $HOME/bin/ 
 else 
   rm -f killmePSP
   $HOME/bin/checkPSPabinit.pl $CASO 
    if [ -e  killmePSP ];then 
      printf "\t Hold on you have some problems whit your PSP\n"
      printf "\t Stoping right now ...\n"
      exit 1
    fi 
 fi 


################################
################################
if [ "$ARCH" == "quadp" ];then  
   if [ ! -e machinesQUAD ];then
     printf "\tThere is not FILE: machinesQUAD \n"
     printf "\t Stoping right now ...\n"
     exit 1
   else  
      rm -f tmpQ 
      sed '/^ *$/d' machinesQUAD  >  tmpQ
      mv tmpQ machinesQUAD
      rm -f tmpQ
      NMA=`wc machinesQUAD | awk '{print$1}'` 
   fi 
 if [  -e $ABINIp_QUAD ];then 
   printf "\t ===============\n"
   printf "\t Launching abinip QUAD parallel in $NMA nodes \n"
   printf "\t The number of nuclei by node to be used must be defined\n"
   printf "\t Input number of nuclei: ?   \n"
   read nNUCLEI
   if   [  -z $nNUCLEI ]; then
     printf "\t WARNING: The number of nuclei of must be input\n"
     printf "\t EXIT"
     exit 1
   fi 
   let "nPROC=$NMA * $nNUCLEI"

#   RUN="/home/mvapich-intel/bin/mpirun_rsh -rsh -hostfile machinesQUAD -np $NMA $ABINIp_QUAD < $CASO > &log"

   RUN="mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO > &log"
   printf "\t $RUN\n"
   if [ `hostname` == "quad01" ]
   then
    cd $DIR
    echo $RUN
     mpdboot -v -r ssh -f machinesQUAD -n $NMA
     mpdtrace
mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO >&log
   else
     echo `hostname`
     printf  "\t Opening the socket \n"
 rsh quad01 "cd $DIR;mpdboot -v -r ssh -f machinesQUAD -n $NMA;mpdtrace"
    rsh quad01 "cd $DIR;pwd;hostname"
   rsh quad01 "cd $DIR;mpiexec -ppn $nNUCLEI -n $nPROC -env I_MPI_DEVICE rdssm  $ABINIp_QUAD < $CASO >&log"
   fi

   ###================= taking time
      TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: $TIMEENDALL \n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"

   ###=================
 else
  printf "\tI can find: $ABINIp_QUAD \n"
  printf "\tStoping right now ...\n"
  exit 1
 fi
fi
###################################################
###############################SERIAL QUAD
   if [ "$ARCH" == "quads" ];then
   
    if [  -e $ABINIs_QUAD ];then 
      printf "\t ===============\n"
      printf "\t${BLUE} Launching abinis${NC} QUAD "
      printf "SERIAL in quad01 machine \n"
      RUN="$ABINIs_QUAD <$CASO > &log"
      rsh quad01 "cd $DIR;pwd;hostname"
      echo $RUN
      rsh quad01 "cd $DIR;$RUN"
       ###================= taking time
      TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: $TIMEENDALL \n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
   ###=================    
    else 
      printf "\t${RED}I can find:${NC} $ABINITs_QUAD \n"
      printf "\tStoping right now ...\n"
  exit 1
    fi 
   fi ##
  
#################################################
#################################################
#################################################
#################################################
if [ "$ARCH" == "xeonp" ];then
    if [ ! -e machinesXEON ];then
     printf "\tThere is not FILE: machinesXEON \n"
     printf "\t Stoping right now ...\n"
     exit 1
   else  
      rm -f tmpX 
      sed '/^ *$/d' machinesXEON  >  tmpX
      mv tmpX machinesXEON
      rm -f tmpX
      NMA=`wc machinesXEON | awk '{print$1}'` 
   fi
    if [  -e $ABINIp_XEON ];then
     printf "\t ===============\n"
      printf "\t${BLUE} Launching abinip${NC} XEON \n"
      printf "parall  in $NMA machines \n"
/usr/local/mpich_gm_intel9/bin/mpirun -machinefile machinesXEON -np $NMA  $ABINIp_XEON < GaAs.files >&log      
     ###================= taking time
      TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: $TIMEENDALL \n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
   ###=================  
   else
      printf "\t${RED}I can find:${NC} $ABINITp_XEON \n"
      printf "\tStoping right now ...\n"
  exit 1
   fi    
fi
#################################################
#################################################
 if [ "$ARCH" == "xeons" ];then
     if [  -e $ABINIs_XEON ];then
      printf "\t ===============\n"
      printf "\t${BLUE} Launching abinis${NC} XEON \n" 
     $ABINIs_XEON < GaAs.files >&log
         ###================= taking time
      TIMEENDALL=`date`
      printf "\t--------------------------------------------------\n"
      printf "\tFinished all at time: $TIMEENDALL \n"
      printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
   ###================= 
    else
      printf "\t${RED}I can find:${NC} $ABINITs_XEON \n"
      printf "\tStoping right now ...\n"
  exit 1    
  fi 
fi
#################################################
#################################################


if [ "$ARCH" == "itaniums" ];then 
 if [  -e $ABINIs_ITAN ];then
    printf "\t ===============\n"
    printf "\t${BLUE} Launching abinis${NC} ITANIUM serial" 
    rsh itanium01 "cd $DIR; $ABINIs_ITAN < GaAs.files >&log"
       ###================= taking time
      TIMEENDALL=`date`
      printf "\t--------------------------------------------------\n"
      printf "\tFinished all at time: $TIMEENDALL \n"
      printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"
   ###================= 
 else
      printf "\t${RED}I cant find:${NC} $ABINITs_ITAN \n"
      printf "\tStoping right now ...\n"
  exit 1
 fi
fi   
################################3
#################################3
###################################
  if [ "$ARCH" == "itaniump" ];then
     if [  -e $ABINIp_ITAN ];then
    printf "\t ===============\n"
    printf "\t${BLUE} Launching abinis${NC} ITANIUM parallel\n " 
     if [ ! -e machinesITAN ];then
     printf "\tThere is not FILE: machinesITAN \n"
     printf "\t Stoping right now ...\n"
     exit 1
   else  
      rm -f tmpI
      sed '/^ *$/d' machinesITAN  >  tmpI
      mv tmpI machinesITAN
      rm -f tmpI
      NMA=`wc machinesITAN | awk '{print$1}'` 
   fi
    
        rsh  itanium01 "cd $DIR;$MPICH_ITAN/mpirun -np $NMA  -machinefile machinesITAN $ABINIp_ITAN < GaAs.files > log"

     else
         printf "\t${RED}I cant find:${NC} $ABINITs_ITAN \n"
      printf "\tStoping right now ...\n"
  exit 1
 fi
  fi 
