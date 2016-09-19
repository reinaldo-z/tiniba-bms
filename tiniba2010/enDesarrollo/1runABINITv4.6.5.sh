#!/bin/bash
## CHILDREN : checkPSPabinit.pl
## please keep the history modification and send me (sollebac@gmail.com) a copy
## LAST MODIFICATION : 15 Febrero 2010 by Cabellos JL 
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
        GA='31ga.3.hgh-PRU'
        AS='33as.5.hgh-PRU'
      CASO='GaAs'
### define my diccionary 
DICC[0]="xeonp"
DICC[1]="xeons"
DICC[2]="itaniums"
DICC[3]="itaniump"
DICC[4]="quads"
DICC[5]="quadp"
###
###
help ()
{
 printf "\tUsage: `dirname $0`/${GREEN}`basename $0`${NC} [${GREEN}option${NC}] \n"
  printf "\t[${GREEN}option${NC}] could be:\n"
  printf "\t ${GREEN}xeons ${NC}   : run serial in master\n"
  printf "\t ${GREEN}xeonp ${NC}   : run parall in machines given in: machinesXEON\n"
  printf "\t ${GREEN}itaniums${NC} : run serial in itanium01\n"
  printf "\t ${GREEN}itaniump${NC} : run parall in machines given in: machinesITAN\n"
  printf "\t ${GREEN}quads${NC}    : run serial in quad01\n"
  printf "\t ${GREEN}quadp${NC}    : run parall in machines given in: machinesQUAD\n"
  printf "\t Stoping right now ...\n"
  exit 0
}
###
###
  if [ $# -eq 0 ];then
   help ## get out of here
  fi 
###
###    
INPUT=`echo $1  | tr '[A-Z]' '[a-z]'`
  NODICC=`echo ${#DICC[@]}`
  OUT=1
  for ((hh=0;hh<=($NODICC-1); hh++));do
      LOOK=${DICC[$hh]}
     if [ "$INPUT" == "$LOOK" ];then
      OUT=0       
     fi
  done

   if [ "$OUT" == "1" ];then
     help  ## get out of here
   fi 


  echo "#!/usr/bin/perl"        >  $CHPSP
  echo " use File::Basename; "  >> $CHPSP
  echo " use Cwd; "             >> $CHPSP
  echo " use File::Copy; "      >> $CHPSP
  echo " use Term::ANSIColor; " >> $CHPSP
  echo " ## There is not warranty JL Cabellos "                 >> $CHPSP
  echo " ## create on: `date`  by $USER "                       >> $CHPSP
  echo " ## Any change done here is going to lost ..."          >> $CHPSP
  echo " ## better modificate `basename $0` atte. JL Cabellos " >> $CHPSP
  echo " my \$minombre=basename(\$0); "                         >> $CHPSP
  echo " my \$midir=dirname(\$0); "                             >> $CHPSP
  #echo " print \"\\t\$midir/\$minombre\\n\"; "                  >> $CHPSP
  echo "if ((@ARGV=~0)){ "                                      >> $CHPSP
  echo " print \"\\t Usage: \$minombre [namefile.files] \\n\";" >> $CHPSP 
  echo "   die \"\\t I need a input FILE:  *.files\\n\";"       >> $CHPSP 
  echo "   }"                                                   >> $CHPSP
  echo " else { "                                               >> $CHPSP
  echo "   \$ABINITfiles=\$ARGV[0]; "                           >> $CHPSP
  echo "    system(\"rm -f killmePSP\");"                       >> $CHPSP
  echo "   } "                                                  >> $CHPSP 
  echo " open( MANOfiles, \"<\$ABINITfiles\") or die \"Cannot open \$mynombre\";" >> $CHPSP
  echo "    { " >> $CHPSP
  echo "       foreach \$LINEA (<MANOfiles>) { " >> $CHPSP
  echo "       chomp(\$LINEA); " >> $CHPSP
  echo "        if ((\$LINEA =~ m/.hgh/) && (\$LINEA !~ /[\\#]/))  { " >> $CHPSP
  echo "           if (-e \"\$LINEA\") " >> $CHPSP
  echo "            { "  >> $CHPSP
  echo "              print \"\\t \$LINEA [\";" >> $CHPSP
  echo "              print color 'green'; " >> $CHPSP
  echo "              print \"ok\"; " >> $CHPSP
  echo "              print color 'reset';" >> $CHPSP
  echo "               print \"]\\n\"; "  >> $CHPSP            
  echo "            } "  >> $CHPSP            
  echo "else { "         >> $CHPSP            
  echo "    system(\"touch killmePSP\"); "  >> $CHPSP            
  echo "    printf \"\\t=========================\\n\"; "  >> $CHPSP            
  echo "    print \"\\t \$LINEA [\"; " >> $CHPSP            
  echo "    print color 'red'; "       >> $CHPSP            
  echo "    print \"not exist\"; "     >> $CHPSP            
  echo "    print color 'reset'; "     >> $CHPSP            
  echo "    print \"]\\n\"; "          >> $CHPSP            
  echo "    printf \"\\t Hold on! \";" >> $CHPSP            
  echo "    printf \"Your PSP doesnt exist...fix your \$ABINITfiles \\n\";" >> $CHPSP            
  echo "    printf \"\\t=========================\\n\";" >> $CHPSP            
  echo "          } #end else "   >> $CHPSP                      
  echo "         }#end if "       >> $CHPSP            
  echo "	}#close foreach " >> $CHPSP            
  echo "       }#close open "     >> $CHPSP            
###
###
###
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

echo "$CASO.in"  > $CASO.files 
echo "$CASO.out">> $CASO.files 
echo "$CASO"i"" >> $CASO.files 
echo "$CASO"o"" >> $CASO.files 
echo "$CASO"    >> $CASO.files 
echo "$PWD/$GA" >> $CASO.files 
echo "$PWD/$AS" >> $CASO.files 

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
