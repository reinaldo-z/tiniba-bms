#!/bin/bash
## THERE IS NOT WARRRANTY :: NADA, NOTHING, NITCH, NULLA by Cabellos 
## Version 0.60   
## LAST MODIFICATION ::   Aug 24 2010 at 14:40 by cabellos
## LAST MODIFICATION ::   Aug 30 2010 at 12:38 by cabellos
## LAST MODIFICATION ::   Sep 01 2010 at 01:00 by cabellos
 
   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color

WHOKK=( 1 21 22 63 64 65 )
NOWHOKK=`echo ${#WHOKK[@]}`
NAMERES[1]=chi1                  ;SIZERES[1]="2"
NAMERES[2]=shiftCurrent          ;SIZERES[2]="3"
NAMERES[3]=eta2                  ;SIZERES[3]="3"
NAMERES[4]=S                     ;SIZERES[4]="2"
NAMERES[5]=C                     ;SIZERES[5]="2"
NAMERES[6]=Ctilde                ;SIZERES[6]="2"
NAMERES[7]=E                     ;SIZERES[7]="2"
NAMERES[8]=Etilde                ;SIZERES[8]="2"
NAMERES[9]=staticChi1            ;SIZERES[9]="2"
NAMERES[10]=staticS              ;SIZERES[10]="2"
NAMERES[11]=staticC              ;SIZERES[11]="2"
NAMERES[12]=staticCtilde         ;SIZERES[12]="2"
NAMERES[13]=staticE              ;SIZERES[13]="2"
NAMERES[14]=staticEtilde         ;SIZERES[14]="2"
NAMERES[15]=staticChi2i          ;SIZERES[15]="2"
NAMERES[16]=staticChi2e          ;SIZERES[16]="2"
NAMERES[17]=zeta1--NO--KK        ;SIZERES[17]="3"
NAMERES[18]=spinCurrent          ;SIZERES[18]="3"
NAMERES[19]=xi2                  ;SIZERES[19]="2"
NAMERES[20]=eta3                 ;SIZERES[20]="2"
NAMERES[21]=shg1_la              ;SIZERES[21]="3"
NAMERES[22]=shg2_la              ;SIZERES[22]="3"
NAMERES[23]=LEO                  ;SIZERES[23]="2"
NAMERES[24]=calChi1              ;SIZERES[24]="2"
NAMERES[25]=caleta2              ;SIZERES[25]="2"
NAMERES[26]=shg1_tg              ;SIZERES[26]="3"
NAMERES[27]=shg2_tg              ;SIZERES[27]="3"
NAMERES[28]="no_used"            ;SIZERES[28]="3"
NAMERES[29]="no_used"            ;SIZERES[29]="3"
NAMERES[30]="no_used"            ;SIZERES[30]="3"
NAMERES[31]="no_used"            ;SIZERES[31]="3"
NAMERES[32]="no_used"            ;SIZERES[32]="3"
NAMERES[33]="no_used"            ;SIZERES[33]="3"
NAMERES[34]="no_used"            ;SIZERES[34]="3"
NAMERES[35]="no_used"            ;SIZERES[35]="3"
NAMERES[36]="no_used"            ;SIZERES[36]="3"
NAMERES[37]="no_used"            ;SIZERES[37]="3"
NAMERES[38]="no_used"            ;SIZERES[38]="3"
NAMERES[39]="no_used"            ;SIZERES[39]="3"
NAMERES[40]=shg1_Length_ER       ;SIZERES[40]="3"
NAMERES[41]=shg1_Length_RA       ;SIZERES[41]="3"
NAMERES[42]=shg1_Length_ER_1     ;SIZERES[42]="3"
NAMERES[43]=shg1_Length_ER_2     ;SIZERES[43]="3"
NAMERES[44]=shg1_Length_RA_1     ;SIZERES[44]="3"
NAMERES[45]=shg1_Length_RA_2     ;SIZERES[45]="3"
NAMERES[46]=shg1_Length_RA_3     ;SIZERES[46]="3"
NAMERES[47]=shg2_Length_ER       ;SIZERES[47]="3"
NAMERES[48]=shg2_Length_RA       ;SIZERES[48]="3"
NAMERES[49]=shg2_Length_RA_1     ;SIZERES[49]="3"
NAMERES[50]=shg2_Length_RA_2     ;SIZERES[50]="3"
NAMERES[51]=Rabc_1     ;SIZERES[51]="3"
NAMERES[52]=Rabc_2     ;SIZERES[52]="3"
NAMERES[53]=Rabc_3     ;SIZERES[53]="3"
NAMERES[54]=Rabc_3     ;SIZERES[54]="3"
NAMERES[55]=Rabc_3     ;SIZERES[55]="3"
NAMERES[56]=Rabc_3     ;SIZERES[56]="3"
NAMERES[57]=Rabc_3     ;SIZERES[57]="3"
NAMERES[58]=Rabc_3     ;SIZERES[58]="3"
NAMERES[59]=Rabc_3     ;SIZERES[59]="3"
NAMERES[60]=shg1_tl    ;SIZERES[60]="3"
NAMERES[61]=shg1_wt    ;SIZERES[61]="3"
NAMERES[62]=shg2_tl    ;SIZERES[62]="3"
NAMERES[63]=shg2_wt    ;SIZERES[63]="3"
NAMERES[64]=shg1_ta    ;SIZERES[64]="3"
NAMERES[65]=shg2_ta    ;SIZERES[65]="3"
NAMERES[66]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[66]="3"
NAMERES[67]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[67]="3"
NAMERES[68]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[68]="3"
NAMERES[69]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[69]="3"
NAMERES[70]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[70]="3"
NAMERES[71]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[71]="3"
NAMERES[72]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[72]="3"
NAMERES[73]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[73]="3"
NAMERES[74]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[74]="3"
NAMERES[75]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[75]="3"
NAMERES[76]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[76]="3"
NAMERES[77]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[77]="3"
NAMERES[78]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[78]="3"
NAMERES[79]=shg2_LeitsmanTwo_ER+RA     ;SIZERES[79]="3"
NAMERES[80]=shg1_ll                    ;SIZERES[80]="3"
NAMERES[81]=shg2_ll                    ;SIZERES[81]="3"
NAMERES[82]=shg1_Sharma_ER+RA          ;SIZERES[82]="3"
NAMERES[83]=shg2_Sharma_ER+RA          ;SIZERES[83]="3"
T3XYZ[1]='xxx';T3XYZ[10]='yxx';T3XYZ[19]='zxx';T2XYZ[1]='xx' 
T3XYZ[2]='xxy';T3XYZ[11]='yxy';T3XYZ[20]='zxy';T2XYZ[2]='xy'
T3XYZ[3]='xxz';T3XYZ[12]='yxz';T3XYZ[21]='zxz';T2XYZ[3]='xz'
T3XYZ[4]='xyx';T3XYZ[13]='yyx';T3XYZ[22]='zyx';T2XYZ[4]='yx'
T3XYZ[5]='xyy';T3XYZ[14]='yyy';T3XYZ[23]='zyy';T2XYZ[5]='yy'
T3XYZ[6]='xyz';T3XYZ[15]='yyz';T3XYZ[24]='zyz';T2XYZ[6]='yz'
T3XYZ[7]='xzx';T3XYZ[16]='yzx';T3XYZ[25]='zzx';T2XYZ[7]='zx'
T3XYZ[8]='xzy';T3XYZ[17]='yzy';T3XYZ[26]='zzy';T2XYZ[8]='zy'
T3XYZ[9]='xzz';T3XYZ[18]='yzz';T3XYZ[27]='zzz';T2XYZ[9]='zz'
MAQ[1]="quad01";MAQ[10]="quad10";MAQ[19]="node05";MAQ[28]="node14"
MAQ[2]="quad02";MAQ[11]="quad11";MAQ[20]="node06";MAQ[29]="node15"
MAQ[3]="quad03";MAQ[12]="quad12";MAQ[21]="node07";MAQ[30]="itanium01"
MAQ[4]="quad04";MAQ[13]="quad13";MAQ[22]="node08";MAQ[31]="itanium02"
MAQ[5]="quad05";MAQ[14]="quad14";MAQ[23]="node09";MAQ[32]="itanium03"
MAQ[6]="quad06";MAQ[15]="node01";MAQ[24]="node10";MAQ[33]="itanium04"
MAQ[7]="quad07";MAQ[16]="node02";MAQ[25]="node11"   
MAQ[8]="quad08";MAQ[17]="node03";MAQ[26]="node12"   
MAQ[9]="quad09";MAQ[18]="node04";MAQ[27]="node13"
function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stopping right now... ${NC} `basename $0`\n"
   exit 127
 else
   printf "\t${RED}Stopping right now... ${NC} `basename $0`\n"
   printf "\t$1\n\n"
   exit 127
 fi
    }
function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127
      fi
      }
        TOLDEF=0.03d0
           DIR=$PWD
          ODIR=$PWD
         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`
    PADREAMARO=`basename $WHERE`
     SETUPxeon="$WHERE/set.xeon"
     SETUPitan="$WHERE/set.itan"
     SETUPquad="$WHERE/set.quad"
      LATMxeon="$WHERE/tetra.xeon"
      LATMitan="$WHERE/tetra.itan"
      LATMquad="$WHERE/tetra.quad"
     SMEARxeon="$WHERE/smear.xeon"
     SMEARitan="$WHERE/smear.itan"
     SMEARquad="$WHERE/smear.quad"
        KKxeon="$WHERE/kk.xeon"
        KKitan="$WHERE/kk.itan"
         KKquad="$WHERE/kk.quad"
       CONxeon="$WHERE/conSetInput.xeon"
       CONitan="$WHERE/conSetInput.itan"
       CONquad="$WHERE/conSetInput.quad"
      laheylib="env LD_LIBRARY_PATH=/usr/local/lf9562/lib"
          ii=1
# BO has to match the number of input parameters
          BO="6"
          for arg in "$@";do
            if [ $ii -le $BO ]; then
             BASICOPTIONS[$ii]=$arg
            else
             arg1=`echo $arg | tr A-Z a-z`
             TENSORXYZ[$ii-$BO]=$arg1
            fi 
               let "ii+=1"
           done
             MACHINESres=(`cat .machines_res`)
             NOMACHINESres=`echo ${#MACHINESres[@]}`
#          for ((hh=0;hh<=($NOMACHINESres-1); hh++));do        
#           echo ${MACHINESres[$hh]}
#          done
         

           #------------------------------
           NOBASICOPTIONS=`echo ${#BASICOPTIONS[@]}`
              NOTENSORXYZ=`echo ${#TENSORXYZ[@]}`
	          NOT2XYZ=`echo ${#T2XYZ[@]}`
                  NOT3XYZ=`echo ${#T3XYZ[@]}`  
                    NOMAQ=`echo ${#MAQ[@]}`
#              echo $NOBASICOPTIONS
           if [ "$NOBASICOPTIONS" -ne "$BO" ];then
	       if [ $WHERE/menu.sh ];then 
		   $WHERE/menu.sh ${NAMERES[*]}                         
	       fi
	       grep nband2 setUpAbinit_$CASO.in > tmp1
	       NMAX=`head -1 tmp1 | awk '{print $2}'`
	       grep -n 'occ ' $CASO'_check'/$CASO.out > tmp2
	       iocc=`awk -F: '{print $1}' tmp2`
	       grep -n 'prtvol' $CASO'_check'/$CASO.out > tmp2
	       iprtvol=`awk -F: '{print $1}' tmp2`
	       awk 'NR=='$iocc',NR=='$iprtvol'' $CASO'_check'/$CASO.out > tmp3
# for spin-orbit each state has only one electron for a given spin
	       grep -o 1.000 tmp3 > tmp4
	       NVF=`wc tmp4 | awk '{print $2}'`
	       if [ $NVF == '0' ];then
		   grep -o 2.000 tmp3 > tmp4
		   NVF=`wc tmp4 | awk '{print $2}'`
		   NCT=`expr $NMAX - $NVF`
	       fi
    printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
     printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
    printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
    printf "\t =================\n"

#              printf "\tYou have 11 basic input + n components of tensor\n"
              printf "\tUsage:\n"
# read from command line
#              printf "\t${GREEN}`basename $0`${NC} [${GREEN}tol${NC}] "
#              printf "[${GREEN}tolSHGL(DR)${NC}] "
#              printf "[${GREEN}tolSHGt${NC}] "
#
              printf "\t${GREEN}`basename $0` "
              printf "[${GREEN}total/layer${NC}] "
              printf "[${GREEN}_CASE${NC}] [${GREEN}Scissors${NC}]"
              printf " [${GREEN}Valence Bands${NC}] [${GREEN}Conduction Bands${NC}] "
              printf "[${GREEN}Response Number] [components]${NC}\n"
	      printf "\t${CYAN}==============================${NC}\n"
          
              printf "\tNo input arguements ...\n"
              printf "\tThe machines where is going to run are provided in file: .machines_res\n"

	      printf "\t${CYAN}==============================${NC}\n"
              printf "\tyou have the following cases\n"
	      ls pmn* cpmnd* csmnd* jnnlk*
	      printf "\n"
	      printf "\t${CYAN}==============================${NC}\n"
              exit 0
           fi 



# the following values give the results of PRB 80, 155205 􏰬(2009)
	   tol=0.001
	   tolSHGL=0
	   tolSHGt=0
# or uncomment the following three and read from the command line
#         tol=${BASICOPTIONS[1]}
#     tolSHGL=${BASICOPTIONS[2]}
#     tolSHGt=${BASICOPTIONS[3]}
#
       TOTAL=`echo ${BASICOPTIONS[1]} | tr A-Z a-z`
       PFILE=${BASICOPTIONS[2]}
       BANDGAP=${BASICOPTIONS[3]}
       ISB=S
       NBVA=${BASICOPTIONS[4]}
       NBCO=${BASICOPTIONS[5]}
     WHATANS=${BASICOPTIONS[6]}
     PMNFILE=pmn_"$PFILE"
   EIGENFILE=eigen_$"$PFILE"
    SPINFILE=spinmn_$"$PFILE"
  ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
         let "NMAXCC=NBVA+NBCO"
      echo $PFILE > tmp5       
      NK=`awk -F _ '{print $1}' tmp5`
      


 #    echo "tol=$tol"
 #    echo "tolSHGL=$tolSHGL"
 #    echo "tolSHGt=$tolSHGt"
 #    echo $TOTAL
 #    echo $PFILE
 #    echo $BANDGAP
 #    echo $ISB
 #    echo $NBVA
 #    echo $NBCO
 #    echo $WHATANS

aa=0
kk=1
 NOTNOTALLOWED=0
  for ((ii=1;ii<=($NOTENSORXYZ); ii++));do
    FINDONE=0
     if [ ${SIZERES[$WHATANS]} == "3" ];then 
      for ((jj=1;jj<=($NOT3XYZ); jj++));do
        if [ ${TENSORXYZ[$ii]} == ${T3XYZ[$jj]} ];then          
           FINDONE=1
            PERMITIDOS[$aa]=${TENSORXYZ[$ii]}
            let "aa=aa+1"
        fi 
      done 
     fi 
if [ ${SIZERES[$WHATANS]} == "2" ];then 
 for ((jj=1;jj<=($NOT2XYZ); jj++));do
   if [ ${TENSORXYZ[$ii]} == ${T2XYZ[$jj]} ];then          
     FINDONE=1
      PERMITIDOS[$aa]=${TENSORXYZ[$ii]}
      let "aa=aa+1"
   fi 
 done 
fi 
if [ "$FINDONE" == "0" ];then
 TNOTALLOWED[$kk]=${TENSORXYZ[$ii]}
  let "kk=kk+1"
   fi 
  done
   NOTNOTALLOWED=`echo ${#TNOTALLOWED[@]}`
     for ((ii=1;ii<=($NOTNOTALLOWED); ii++));do
       printf "\tTensor(${RED}Not ALLOWED${NC}) ${TNOTALLOWED[$ii]}\n"
     done 
     if [ "$NOTNOTALLOWED" -gt "0" ];then 
       printf "\tThere are $NOTNOTALLOWED tensores not allowed \n" 
       printf "\tor the dimension of RESPONSE "
       printf "$WHATANS (${NAMERES[$WHATANS]})\n"
       printf "\tfor this answer the dimension has to be"
       printf "(${SIZERES[$WHATANS]})\n"
       #exit 1 
     fi

 printf "\t${BLUE}=================================${NC}\n"
   NOPERMITIDOS=`echo ${#PERMITIDOS[@]}`
   if [ $NOPERMITIDOS -eq 0 ];then 
    printf  "\tThere is not one allowed tensor ... What are you doing?\n" 
    exit 127      
   fi 

   for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
    AP=$AP"_"${PERMITIDOS[$jj]}
   done 
  for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
  let "uka=jj+1"
  SET1[$jj]="set1""$uka"
  SET2[$jj]="set2""$uka"
  printf "\t$uka ).- ${PERMITIDOS[$jj]} [${GREEN}ALLOWED${NC}] ${MAG}${SET1[$jj]}${NC} ${MAG}${SET2[$jj]}${NC}\n"
  done 
 printf "\t${BLUE}=================================${NC}\n"
  cp -f symmetries/tetrahedra_$NK  .
  cp -f symmetries/Symmetries.Cartesian_$NK  Symmetries.Cartesian
  grep nband2 setUpAbinit_$CASO.in > tmp1
  NMAX=`head -1 tmp1 | awk '{print $2}'`
  grep -n 'occ ' $CASO'_check'/$CASO.out > tmp2
  iocc=`awk -F: '{print $1}' tmp2`
  grep -n 'prtvol' $CASO'_check'/$CASO.out > tmp2
  iprtvol=`awk -F: '{print $1}' tmp2`
  awk 'NR=='$iocc',NR=='$iprtvol'' $CASO'_check'/$CASO.out > tmp3
  grep -o 1.000 tmp3 > tmp4
  NVF=`wc tmp4 | awk '{print $2}'`
    if [ $NVF == '0' ];then
	grep -o 2.000 tmp3 > tmp4
	NVF=`wc tmp4 | awk '{print $2}'`
    fi
    NCT=`expr $NMAX - $NVF`
    printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
     printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
    printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
    printf "\t               Numeber of K points=$NK \n"
    printf "\t =================\n"
  for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
       let "ee=jj+1"
       echo nMaxCC                     $NMAXCC     > ${SET1[$jj]}
       if [ "$ISB" == "B" ];then 
         echo actual_band_gap         $BANDGAP    >>${SET1[$jj]}
       fi 
       if [ "$ISB" == "S" ];then 
         echo scissor                 $BANDGAP    >>${SET1[$jj]}
       fi   
        echo tol                        $tol        >>${SET1[$jj]}
        echo tolSHGt                    $tolSHGt    >>${SET1[$jj]}
        echo tolSHGL                    $tolSHGL    >>${SET1[$jj]}
        echo nSpinor                    $ESPINsetUp >>${SET1[$jj]}
        echo energy_data_filename       $EIGENFILE  >>${SET1[$jj]}
        echo pmn_data_filename          $PMNFILE    >>${SET1[$jj]}
        if [ $ESPINsetUp -eq 2 ];then 
         echo smn_data_filename         $SPINFILE    >>${SET1[$jj]}
        fi
        echo energys_data_filename      energys.d$ee >>${SET1[$jj]}
        echo $NK >                                 info_shg 
        echo $NBVA >>                              info_shg 
        nbms=`awk 'END{print NF}' $EIGENFILE`
        let "ntot=nbms-1"
        let "nc=ntot-NBVA"
        echo $nc >>                                info_shg            
   done 
      for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
       let "kk=jj+1"
       tetrapack=tetra"$kk"
        xyz123=`echo ${PERMITIDOS[$jj]} | sed s/x/' 1'/g  | sed s/y/' 2'/g | sed s/z/' 3'/g`
        echo 1 > ${SET2[$jj]}
        echo $WHATANS  $tetrapack  54  T >> ${SET2[$jj]}
        echo $xyz123 >> ${SET2[$jj]}
      done 
      rm -f END*


       for ((hh=0;hh<=($NOPERMITIDOS-1); hh++));do        
          MAQUINA501=${MACHINESres[$hh]}
          let "kk=hh+1"
       if [[ "$MAQUINA501" == "node"* ]]; then
          SET="$SETUPxeon"
       fi
       if [[ "$MAQUINA501" == "itanium"* ]];then
          SET="$SETUPitan"
       fi
       if [[ "$MAQUINA501" == "quad"* ]]; then
          SET="$SETUPquad"
       fi
        REMOTO=$PWD 
        FIN=END$kk
        rsh -n $MAQUINA501 "cd $REMOTO; $SET ${SET1[$hh]} ${SET2[$hh]} > infoSET$kk;touch $FIN"&
            printf  "[${MAG}$MAQUINA501${NC}]  Running ... \n"
        sleep 1
      done 



  for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
      let "kk=jj+1"
       FIN=END$kk
      INFO=infoSET$kk
      SALIDA=0
      while [ "$SALIDA" -lt "10" ]; do
       sleep 3
       if [ -e $FIN ];then
       SALIDA=20
           printf "\t$[ kk ] response $WHATANS ${PERMITIDOS[$jj]} finished (checking it)\n"
               ESTABIENEIGEN=`grep Reached infoSET$kk`
                 ESTABIENPMN=`grep reached infoSET$kk`
                   if [ -z "$ESTABIENPMN" ] || [ -z "$ESTABIENEIGEN" ] ;then
                     echo stop
                     exit 0 
                   else 
                   printf "\t${GREEN}$ESTABIENEIGEN${NC} \n"
                   printf "\t    ${GREEN}$ESTABIENPMN${NC}\n"
                   OUT1="$INFO"
                   UNSC=`grep Unscissored $OUT1`
                   ADJU=`grep Adjusted  $OUT1`
                   TIJ1=`grep Scissor $OUT1`
                   DIRE=`grep Direct $OUT1`
        printf "\t${MAG}====================${NC}\n"
        printf "\t$UNSC\n"
        printf "\t$ADJU\n"
        printf "\t$TIJ1\n"
        printf "$DIRE\n"
              echo "================="
              grep Scissor $INFO 
          fi
       fi
     done
  done 
rm -f tetrapack*
for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
      let "kk=jj+1"
      SPE="spectrum_"${PERMITIDOS[$jj]}"$kk"
                               echo nMaxCC $NMAXCC > tetrapack$kk
                           echo energy_min  0      >> tetrapack$kk
                           echo energy_max  20     >> tetrapack$kk
                        echo energy_steps  2001    >> tetrapack$kk
        echo energys_data_filename  energys.d$kk  >> tetrapack$kk
           echo tet_list_filename  tetrahedra_$NK >> tetrapack$kk
    echo integrand_filename              tetra$kk >> tetrapack$kk
                    echo spectrum_filename  $SPE  >> tetrapack$kk
 done 
rm -f FIN*
#read -p "press"
       sleep 1

      for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
            let "kk=jj+1"
            teti=tetrapack"$kk"
            MAQUINA501=${MACHINESres[$jj]}
            if [[ "$MAQUINA501" == "node"* ]]; then
             TET="$LATMxeon"
            fi
            if [[ "$MAQUINA501" == "itanium"* ]];then
             TET="$LATMitan"
            fi
            if [[ "$MAQUINA501" == "quad"* ]]; then
              TET="$LATMquad"
            fi
              REMOTO=$PWD 
              FIN="FIN$kk"
             rsh $MAQUINA501 "cd $REMOTO; $TET $teti >infoTET$kk;touch $FIN;"&
             #rsh $MAQUINA501 "cd $REMOTO; $TET $teti "
            #printf  "[${MAG}$MAQUINA501${NC}] $TET $teti\n"
             printf  "[${MAG}$MAQUINA501${NC}] Running ...\n"
            sleep 1
      done 




##########################
##########################
##########################
 for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
      let "kk=jj+1"
      SPE="spectrum_"${PERMITIDOS[$jj]}"$kk"  
       FIN="FIN$kk"
      SALIDA=0
        while [ "$SALIDA" -lt "10" ]; do
         if [ -e $FIN ];then
           SALIDA=30
         fi
      done
 done

PP=0
for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
      let "kk=jj+1"
      MAQUINA501=${MACHINESres[0]}
             if [[ "$MAQUINA501" == "quad"* ]]; then
              kki=$KKquad
             fi
             if [[ "$MAQUINA501" == "itan"* ]]; then
              kki=$KKitan
             fi
             if [[ "$MAQUINA501" == "node"* ]]; then
              kki=$KKxeon
             fi
       BUSCA=0
      for ((ii=0;ii<=($NOWHOKK-1); ii++));do       
         if [ "${WHOKK[$ii]}" == "$WHATANS" ];then 
           BUSCA=1
         fi 
      done 
           if [ $BUSCA -ne 0 ];then 
             isThereFile $kki
              UKA[$PP]="spectrum.kk_"${PERMITIDOS[$jj]}"$kk"
              REMOTO=$PWD
              rsh $MAQUINA501 "cd $REMOTO; $kki 1 $SPE ${UKA[$PP]} > infoKK$kk"
              let "PP=PP+1"
           else 
             UKA[$PP]="spectrum_"${PERMITIDOS[$jj]}"$kk"
             let "PP=PP+1"
           fi
 done 
#############
#############


NOUKA=`echo ${#UKA[@]}`
for ((ii=0;ii<=($NOUKA-1); ii++));do
   let "kk=ii+1"
   if [ -e ${UKA[$ii]} ];then
            BUSCAPIES=0
              for ((jj=0;jj<=($NOWHOKK-1); jj++));do       
                if [ "${WHOKK[$jj]}" == "$WHATANS" ];then 
                   BUSCAPIES=1
                fi 
              done 
                if [ $BUSCAPIES -ne 0 ];then 
                     if [ $ii -lt 1 ];then
                       cp -f ${UKA[$ii]} gato$kk
                       else 
                       awk '{print $2,$3}' "${UKA[$ii]}" > "gato$kk"
                     fi 
                     CAB=${NAMERES[$WHATANS]}".kk"$AP"_"$NBCO"_"$PFILE"_s_"$BANDGAP
                      #printf "\tthis answer [$WHATANS] need kk output will be: "
                      #printf "$kk  ${UKA[$ii]} [`awk 'END{print NF}' ${UKA[$ii]}`]\n" 
                else              
                     if [ $ii -lt 1 ];then
                       cp -f ${UKA[$ii]} gato$kk
                       else 
                       awk '{print $2}' "${UKA[$ii]}" > "gato$kk"
                     fi
                     CAB=${NAMERES[$WHATANS]}$AP"_"$NBCO"_"$PFILE"_s_"$BANDGAP
                     #printf "\tthis answer [$WHATANS] no need kk output will be: "
                     #printf "$kk  ${UKA[$ii]} [`awk 'END{print NF}' ${UKA[$ii]}`]\n" 
                                     
                fi
   fi   
done 
# p
GL="glue.sh"
rm -f $GL
touch $GL
printf "## This a file was done by: `basename $0`\n" >> $GL    
printf "## Any change here will be lost: JL  Cabellos \n" >> $GL   
printf "#!/bin/bash\n" >> $GL
echo "  GREEN='\\e[0;32m' "         >> $GL
echo "    RED='\\e[1;31m' "         >> $GL
echo "    BLU='\\e[1;34m' "         >> $GL
echo "     NC='\\e[0m' # No Color " >> $GL
printf  "paste " >> $GL
let "HASTA=NOPERMITIDOS-1"
for ((jj=0;jj<=($NOPERMITIDOS-1); jj++));do
      let "kk=jj+1"
      SPEKK=gato$kk
     if [ "$kk" -gt "$HASTA" ];then 
      printf " $SPEKK > $CAB\n" >> $GL  
     else 
      printf " $SPEKK " >>  $GL
     fi 
done 
echo "  if [  -e \"$CAB\" ];then "  >> $GL
echo "    mv \"$CAB\" res/\"$CAB\" " >> $GL
echo "   printf \"\\tOut put is: \${BLU}res\${NC}/\${GREEN}$CAB \${NC}  [\`awk 'END{print NF}' res/$CAB\`] \\n \" "  >>  $GL 
echo "  fi"   >>$GL
 

          if [ -e $GL ];then          
             chmod 777 $GL
             ./$GL
           fi
######
######




printf "\t end end ...bye \n"
     exit 127
