#!/bin/bash
## this script just is going to do the set input file 
## in a very simple way ....
## LAST MODIFICATION :: 07 APRIL 2010 by jl cabellos 

   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color

         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`
    PADREAMARO=`basename $WHERE`
FUERA="not-defined"
for ((ii=1;ii<=(100); ii++));do
NAMERES[$ii]="$FUERA"
SIZERES[$ii]="3" 
DESCRI[$ii]="$FUERA"            
done 
##
## Here define the name of your response, its size and description
## Here define the name of your response, its size and description
## Here define the name of your response, its size and description
NAMERES[1]="chi1"        ;SIZERES[1]="2"  ;DESCRI[1]="First Order Response" 
NAMERES[21]="shg1_la"    ;SIZERES[21]="3" ;DESCRI[21]="Length 1 omega"
NAMERES[22]="shg2_la"    ;SIZERES[22]="3" ;DESCRI[22]="Length 2 omega"
NAMERES[61]="shg1_wt"    ;SIZERES[61]="3" ;DESCRI[61]="transversal Articulo 1 omega WRONG"
NAMERES[63]="shg2_wt"    ;SIZERES[63]="3" ;DESCRI[63]="transversal Articulo 1 omega WRONG"
NAMERES[64]="shg1_ta"    ;SIZERES[61]="3" ;DESCRI[64]="transversal Articulo 1 omega"
NAMERES[65]="shg2_ta"    ;SIZERES[63]="3" ;DESCRI[65]="transversal Articulo 1 omega"
## Here define the name of your response, its size and description
## Here define the name of your response, its size and description
## Here define the name of your response, its size and description
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

function menu {
 printf "\n"
 for ((ii=1;ii<=(${#NAMERES[@]}); ii++));do
 if [ "${NAMERES[$ii]}" != "$FUERA" ];then 
 printf "\t[${GREEN}$ii${NC}] ${MAG}${NAMERES[$ii]}${NC}  (${GREEN}${DESCRI[$ii]}${NC})\n"
 fi 
done
}
function bands {
   if [ -e setUpAbinit_$CASO.in ];then 
    grep nband2 setUpAbinit_$CASO.in > tmp1
    NMAX=`head -1 tmp1 | awk '{print $2}'`
   fi 
   if [ -e $CASO'_check'/$CASO.out ];then 
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
   fi 
   
}
function example {
     ik=0
     FILESkpmn="pmn_*"
      for filePMN in $FILESkpmn; do
       let "ik=ik+1"
        if [ ! -e "$filePMN" ];then # Check if file exists.
         printf  "\tThere are no files with pmn_* \n"
         printf  "\tStoping Right now .......\n"
         exit 127
        fi
       pmnFILES[$ik]=$filePMN
       pmnCASO[$ik]=${filePMN:4}
       if [ "$ik" == "1" ];then
        printf "Example :\n"
         
        printf "`dirname $0`/${GREEN}`basename $0`${NC} 0.0d0 0.0d0 0.0d0 quad01 total ${filePMN:4} 1.519d0 B"
        printf " $NVF $NCT 1 xx\n"
       fi 
      done 
}

## here begin the code 
## here begin the code 
## here begin the code 
    if [ $# -eq 0 ];then
     menu 
     bands
     printf "\t${BLUE}=============================================${NC}\n"
     printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
     printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
     printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
     printf "\t${BLUE}=============================================${NC}\n"
     example
     exit 0 
    else 
     args=("$@")
    fi 
         tol=${args[0]}
     tolSHGL=${args[1]}
     tolSHGt=${args[2]}
  MAQUINA501=`echo ${args[3]} | tr A-Z a-z`
       TOTAL=`echo ${args[4]} | tr A-Z a-z`
       PFILE=${args[5]}
     BANDGAP=${args[6]}
         ISB=${args[7]}
        NBVA=${args[8]}
        NBCO=${args[9]}
     WHATANS=${args[10]}
     PMNFILE=pmn_"$PFILE"
   EIGENFILE=eigen_$"$PFILE"
    SPINFILE=spinmn_$"$PFILE"
 if [ -e $SETUPABINIT ];then
  ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
 fi 
     let "NMAXCC=NBVA+NBCO"


     echo "tol=$tol"
     echo "tolSHGL=$tolSHGL"
     echo "tolSHGt=$tolSHGt"
     echo $MAQUINA501
     echo $TOTAL
     echo $PFILE
     echo $BANDGAP
     echo $ISB
     echo "nbva $NBVA"
     echo "nbco $NBCO"
     echo "what $WHATANS"
     



    
exit 0



##
##
## LAST MODIFICATION 06 APRIL 2010 by cabellos at 17:38 
## CHILDREN :
## 
  TOLDEF=0.03d0
 #tolSHGt=0.01d0
 #tolSHGL=0.0001d0
   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color
##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
           DIR=$PWD
          ODIR=$PWD
           
         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`
    PADREAMARO=`basename $WHERE`

    ##------------------
      #TOLDEF=0.03
      #TOLDEF=0.0001d0
      #TOLDEF=0.06d0
      #TOLDEF=0.09d0
      #TOLDEF=0.12d0
     laheylib="env LD_LIBRARY_PATH=/usr/local/lf9562/lib"
        eminw=0
        emaxw=20
       stepsw=2001
       #stepsw=1001
         FHWM=0.15 ## This is the factor of SMEARING by default
                   ## 

  GaAsBandGap=1.519d0
   GaPBandGap=2.26d0
    ##------------------
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
       
 declare -a MACHINESRES
 declare -a MACHINESLATM
 declare -a TENSORXYZ
 declare -a T3XYZ
 declare -a T2XYZ
 declare -a BASICOPTIONS
 declare -a MAQ





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
NAMERES[21]=shg1_la    ;SIZERES[21]="3"
NAMERES[22]=shg2_la    ;SIZERES[22]="3"
NAMERES[23]=LEO                  ;SIZERES[23]="2"
NAMERES[24]=calChi1              ;SIZERES[24]="2" 
NAMERES[25]=caleta2              ;SIZERES[25]="2"  
#NAMERES[26]=shg1_Tran_ER+ER      ;SIZERES[26]="3"
#NAMERES[27]=shg2_Tran_ER+ER      ;SIZERES[27]="3"

NAMERES[26]=shg1_tg      ;SIZERES[26]="3"
NAMERES[27]=shg2_tg      ;SIZERES[27]="3"


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
### Rabc
NAMERES[51]=Rabc_1     ;SIZERES[51]="3"
NAMERES[52]=Rabc_2     ;SIZERES[52]="3"
NAMERES[53]=Rabc_3     ;SIZERES[53]="3"
##
NAMERES[54]=Rabc_3     ;SIZERES[54]="3"
NAMERES[55]=Rabc_3     ;SIZERES[55]="3"
NAMERES[56]=Rabc_3     ;SIZERES[56]="3"
NAMERES[57]=Rabc_3     ;SIZERES[57]="3"
NAMERES[58]=Rabc_3     ;SIZERES[58]="3"
NAMERES[59]=Rabc_3     ;SIZERES[59]="3"
NAMERES[60]=shg1_tl     ;SIZERES[60]="3"
#NAMERES[61]=shg1_ta_wrong       ;SIZERES[61]="3"
NAMERES[61]=shg1_wt       ;SIZERES[61]="3"
NAMERES[62]=shg2_tl             ;SIZERES[62]="3"
#NAMERES[63]=shg2_ta_wrong       ;SIZERES[63]="3"
NAMERES[63]=shg2_wt       ;SIZERES[63]="3"
##
NAMERES[64]=shg1_ta            ;SIZERES[64]="3"
NAMERES[65]=shg2_ta            ;SIZERES[65]="3"
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
NAMERES[80]=shg1_ll     ;SIZERES[80]="3"
NAMERES[81]=shg2_ll     ;SIZERES[81]="3"
NAMERES[82]=shg1_Sharma_ER+RA     ;SIZERES[82]="3"
NAMERES[83]=shg2_Sharma_ER+RA     ;SIZERES[83]="3"

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

##########################################
##########################################
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
##########################################
##########################################
function isThereFile {
      if [ ! -e "$1" ];then
      printf "\t${RED}Hold on!${NC} There isnt FILE: "
      printf "$1\n"
      printf "\t ${RED}Stoping right now ... ${NC} `basename $0`\n"
      exit 127
      fi
      }
##########################################
##########################################
############## Begin Code ################
##########################################
##########################################
     TIMESTARTALL=`date`
    if [ ! -d res ];then 
      mkdir res 
    fi 
    NOT3XYZ=`echo ${#T3XYZ[@]}` 
    NOT2XYZ=`echo ${#T2XYZ[@]}` 
    isThereFile $SETUPxeon
    isThereFile $SETUPitan
    isThereFile $SETUPquad
    isThereFile $LATMxeon
    isThereFile $LATMitan
    isThereFile $LATMquad
    isThereFile $SMEARxeon
    isThereFile $SMEARitan
    isThereFile $SMEARquad
    isThereFile $KKxeon
    isThereFile $KKitan
    isThereFile $KKquad
    isThereFile $CONxeon
    isThereFile $CONitan
    isThereFile $CONquad
    isThereFile .machines_res
    isThereFile .machines_latm
    isThereFile setUpAbinit_$CASO.in
    if [[ $UID -ne 509 ]]; then
     exit 1 
    fi 
 if [ $# -eq 0 ];then
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
    fi
    NCT=`expr $NMAX - $NVF`

    if [ $WHERE/menu.sh ];then 
         $WHERE/menu.sh ${NAMERES[*]}                         
    fi
    printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
     printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
    printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
    printf "\t =================\n"
    printf "\t Im going take all things from:\n"
    printf "\t$WHERE\n"
 printf "\t${GREEN}`basename $0`${NC} [tol] [tolSHGL(DR)] [tolSHGt] [MAQUINA] [total] [CASO] [bandGap] [B]"
 printf " [BANDAS VALENCIA] [BANDAS CONDUCCION] [NUMBER RESPONSE] [TENSOR]\n"
 printf "\t -----------------\n"
 printf "\t[tol]  rpmn \n"
 printf "\t[tolSHGL(DR)] length (DR)\n"
 printf "\t[tolSHGt(DR)] transversal (DR)\n"

     printf "\t =============\n"
     printf "\tEJEMPLO PARA RESPUESTA 1\n"
     printf "$WHERE/\n"
     ik=0
     FILESkpmn="pmn*"
      for filePMN in $FILESkpmn; do
       let "ik=ik+1"
        if [ ! -e "$filePMN" ];then # Check if file exists.
         printf  "\t there are no files with pmn* \n"
         printf  "\t Stoping Right now .......\n"
         exit 127
        fi
       pmnFILES[$ik]=$filePMN
       pmnCASO[$ik]=${filePMN:4}
       #printf  "\t[$ik] ${filePMN:4} \n"
                                 
 #printf "${GREEN}`basename $0`${NC} 0.001d0 0.0001d0 0.03d0 quad01 total ${filePMN:4} 1.519d0 B"
 if [ "$ik" == "1" ];then 
  printf "${GREEN}`basename $0`${NC} 0.0d0 0.0d0 0.0d0 quad01 total ${filePMN:4} 1.519d0 B"
 printf " $NVF $NCT 1 xx\n"
 fi 
      done
   
 

  StopMe "I need arguements like this ...${USER}" 
 fi 

##Let me know what are tensor and separte them
##Let me know what are tensor and separte them
##Let me know what are tensor and separte them
          ii=1
          BA="11"
          for arg in "$@";do
            if [ $ii -le $BA ]; then
             BASICOPTIONS[$ii]=$arg
            else
             arg1=`echo $arg | tr A-Z a-z`
             TENSORXYZ[$ii-$BA]=$arg1
            fi 
               let "ii+=1"
           done
           #------------------------------
           NOBASICOPTIONS=`echo ${#BASICOPTIONS[@]}`
                    NOMAQ=`echo ${#MAQ[@]}`
              NOTENSORXYZ=`echo ${#TENSORXYZ[@]}`
	          NOT2XYZ=`echo ${#T2XYZ[@]}`
                  NOT3XYZ=`echo ${#T3XYZ[@]}`  

    #if [ "$NOBASICOPTIONS" -ne 8 ];then
    if [ "$NOBASICOPTIONS" -ne 11 ];then
      echo que 
      StopMe "You have 11 basic input + n components of tensor"
    fi 
         tol=${BASICOPTIONS[1]}
     tolSHGL=${BASICOPTIONS[2]}
     tolSHGt=${BASICOPTIONS[3]}
  MAQUINA501=`echo ${BASICOPTIONS[4]} | tr A-Z a-z`
       TOTAL=`echo ${BASICOPTIONS[5]} | tr A-Z a-z`
       PFILE=${BASICOPTIONS[6]}
     BANDGAP=${BASICOPTIONS[7]}
         ISB=${BASICOPTIONS[8]}
        NBVA=${BASICOPTIONS[9]}
        NBCO=${BASICOPTIONS[10]}
     WHATANS=${BASICOPTIONS[11]}
     echo "tol=$tol"
     echo "tolSHGL=$tolSHGL"
     echo "tolSHGt=$tolSHGt"
     echo $MAQUINA501
     echo $TOTAL
     echo $PFILE
     echo $BANDGAP
     echo $ISB
     echo $NBVA
     echo $NBCO
     echo $WHATANS
         #--------------------------
     PMNFILE=pmn_"$PFILE"
   EIGENFILE=eigen_$"$PFILE"
    SPINFILE=spinmn_$"$PFILE"
        let "NMAXCC=NBVA+NBCO"
  ESPINsetUp=`grep nspinor $SETUPABINIT | awk '{print $2}'`
      ######################################
######################################
######################################
######################################
              
 #StopMe "here"
 

    ## check if maquina is allowed
          MAQALLOWED=0           
          for ((ii=1;ii<=($NOMAQ); ii++));do
            if [ "$MAQUINA501" == "${MAQ[$ii]}" ];then
               MAQALLOWED=1
            fi 
          done 
          if [ "$MAQALLOWED" -eq 1 ];then 
           printf "\t$MAQUINA501 [${GREEN}allowed${NC}]\n"
          else 
           printf "\t$MAQUINA501 ${RED}NOT allowed ${NC}\n"
           printf "\tOnly this machines are allowed\n"
             HASTA=0
             for ((ii=1;ii<=($NOMAQ); ii++));do
              if [ $HASTA -eq 6 ];then
                printf "\t${MAQ[$ii]}\n"
                  HASTA=0
              else 
                 printf "\t${MAQ[$ii]}"
                 let "HASTA=HASTA+1"
              fi           
             done  
           StopMe 
          fi 
    ## check if total is total     
         if [ "$TOTAL" == "total" ];then
           printf "\t$TOTAL  [${GREEN}allowed${NC}]\n"
         else 
           printf "\t$TOTAL ${RED}NOT allowed${NC}, it has to be: total or TOTAL\n"
           StopMe 
         fi 
    ## check files pmn eigen and spin 
       if [ -e $EIGENFILE ];then  
        CUANTO=`du -h $EIGENFILE  | awk '{print $1}'`
        printf "\t $EIGENFILE  [${GREEN}exist${NC}] [$CUANTO]\n"     
      else 
       StopMe "I need FILE: $EIGENFILE"
      fi
   ########
      if [ -e $PMNFILE ];then  
        CUANTO=`du -h $PMNFILE | awk '{print $1}'`
        printf "\t   $PMNFILE  [${GREEN}exist${NC}] [$CUANTO]\n"     
      else 
        StopMe "I need FILE: $PMNFILE"
      fi
   ########
      if [ -e $SPINFILE   ];then  
        CUANTO=`du -h $PMNFILE | awk '{print $1}'`
        printf "\t$SPINFILE  [${GREEN}exist${NC}] [$CUANTO]\n"   
       else 
        printf "\t${MAG}Non Spin calculation${NC}\n"
        printf "\t there isnt FILE: $SPINFILE \n"  
      fi
##Let me check the tensors 
##Let me check the tensors 
##Let me check the tensors
         ##------------
  kk=1
  NOTNOTALLOWED=0
  for ((ii=1;ii<=($NOTENSORXYZ); ii++));do
    FINDONE=0
   if [ ${SIZERES[$WHATANS]} == "3" ];then 
    for ((jj=1;jj<=($NOT3XYZ); jj++));do
        if [ ${TENSORXYZ[$ii]} == ${T3XYZ[$jj]} ];then          
           FINDONE=1
         printf "\tTensor ${TENSORXYZ[$ii]} [${GREEN}ALLOWED${NC}]\n"
        fi 
    done 
   fi 
   ##-----------
   if [ ${SIZERES[$WHATANS]} == "2" ];then 
    for ((jj=1;jj<=($NOT2XYZ); jj++));do
        if [ ${TENSORXYZ[$ii]} == ${T2XYZ[$jj]} ];then          
           FINDONE=1
         printf "\tTensor ${TENSORXYZ[$ii]} [${GREEN}ALLOWED${NC}]\n"
        fi 
    done 
   fi 
      if [ "$FINDONE" == "0" ];then
           TNOTALLOWED[$kk]=${TENSORXYZ[$ii]}
           let "kk=kk+1"
       fi 
  done

  ##------------
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
       StopMe 
     fi
#############################
#############################
#############################
  tol2name=`echo ${tol/./-}`     
  tolSHGt2name=`echo ${tolSHGt/./-}`
  tolSHGL2name=`echo ${tolSHGL/./-}`
  
  tmp1=tmpo1_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  tmp2=tmpo2_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  tmp3=tmpo3_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  tmp4=tmpo4_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  tmp5=tmpo5_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  
  #tmp1=tmp1_$WHATANS"_"${TENSORXYZ[1]}
  #tmp2=tmp2_$WHATANS"_"${TENSORXYZ[1]}
  #tmp3=tmp3_$WHATANS"_"${TENSORXYZ[1]}
  #tmp4=tmp4_$WHATANS"_"${TENSORXYZ[1]}
  #tmp5=tmp5_$WHATANS"_"${TENSORXYZ[1]}
### HERE THE NAME OF DIR RESPONSE 
### HERE THE NAME OF DIR RESPONSE 
### HERE THE NAME OF DIR RESPONSE 
### HERE THE NAME OF DIR RESPONSE 
  
  WHERETORUN=tmp_"$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name
  if [ -d $WHERETORUN ];then 
  printf "\t This directory exist: ${BLUE} $WHERETORUN ${NC}\n"
  
  #read -p "press any key to erase it" 
  rm -rf $WHERETORUN
  fi 

  LOCAL=$PWD
  REMOTO="/data/$USER/$WHERETORUN"




  if [ -e $tmp1 ];then
   rm -fv $tmp1
  fi
  if [ -e $tmp2 ];then
   rm -fv $tmp2
  fi
  if [ -e $tmp3 ];then
   rm -fv $tmp3
  fi
  if [ -e $tmp4 ];then
   rm -fv $tmp4
  fi
  if [ -e $tmp5 ];then
   rm -fv $tmp5
  fi
  grep nband2 setUpAbinit_$CASO.in > $tmp1
  NMAX=`head -1 $tmp1 | awk '{print $2}'`
  grep -n 'occ ' $CASO'_check'/$CASO.out > $tmp2
  iocc=`awk -F: '{print $1}' $tmp2`
  grep -n 'prtvol' $CASO'_check'/$CASO.out > $tmp2
  iprtvol=`awk -F: '{print $1}' $tmp2`
  awk 'NR=='$iocc',NR=='$iprtvol'' $CASO'_check'/$CASO.out > $tmp3
# for spin-orbit each state has only one electron for a given spin
  grep -o 1.000 $tmp3 > $tmp4
  NVF=`wc $tmp4 | awk '{print $2}'`
    if [ $NVF == '0' ];then
	grep -o 2.000 $tmp3 > $tmp4
	NVF=`wc $tmp4 | awk '{print $2}'`
    fi
    NCT=`expr $NMAX - $NVF`
    printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
    printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
    printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
    #printf "\t$NCT  conduccion (abinit)\n"
    #printf "\t$NMAX total (abinit) \n"
    printf " where to run:${BLUE}$WHERETORUN${NC}\n"
  if [ -e $tmp1 ];then
   rm -fv $tmp1
  fi
  if [ -e $tmp2 ];then
   rm -fv $tmp2
  fi
  if [ -e $tmp3 ];then
   rm -fv $tmp3
  fi
  if [ -e $tmp4 ];then
   rm -fv $tmp4
  fi
  

    
 
      echo $PFILE > $tmp5       
      NK=`awk -F _ '{print $1}' $tmp5`
      printf "\tNumeber of K points = $NK \n"
      #LAST_NAME=`awk -F _ '{print $3}' tmp5`
      #rm -f tmp5
       if [ -e $tmp5 ];then
        rm -fv $tmp5
       fi
       if [ ! -d $WHERETORUN ];then
        printf "\tMaking: ${BLUE} $WHERETORUN ${NC}\n"
        mkdir $WHERETORUN
       fi

      #cp symmetries/tetrahedra_$NK .
      #cp symmetries/Symmetries.Cartesian_$NK Symmetries.Cartesian
      cp -f symmetries/tetrahedra_$NK  $WHERETORUN
      cp -f symmetries/Symmetries.Cartesian_$NK $WHERETORUN/Symmetries.Cartesian
     # echo este es $PFILE 
    printf "\t ===================================\n"
       if [ "$ISB" == "B" ];then 
          QUE="B (Bangap)" 
       fi 
       if [ "$ISB" == "S" ];then 
          QUE="S (Scissors)" 
       fi 

    printf "\t From the input line: \n"
    printf "\t                 tol  = $tol  (AFECTA rmn\n"
    printf "\t             tolSHGt  = $tolSHGt  (AFECTA double resonance shg 1 2 trans \n"
    printf "\t             tolSHGL  = $tolSHGL  (AFECTA double resonance shg 1 2 Lenght \n"
    printf "\t             MAQUINA  = $MAQUINA501\n"
    printf "\t               total  = $TOTAL\n"
    printf "\t                Caso  = $PFILE\n"
    printf "\t      Band Gap Value  = $BANDGAP\n"
    printf "\t  Bandgap or Scisors  = $QUE\n"   
    printf "\t       Valence Bands  = $NBVA       (ABINIT $NVF)\n"   
    printf "\t    Conduction Bands  = $NBCO      (ABINIT $NCT)\n"
    printf "\t              NMAXCC  = $NMAXCC  (suma Valence Band + Conduction Band)\n"          
    printf "\t            Response  = ${NAMERES[$WHATANS]}"
    printf " [${MAG}$WHATANS${NC}]\n" 
    printf "\t              Tensor  =\n"  
        for ((ii=1;ii<=($NOTENSORXYZ); ii++));do
    printf "\t                        ${MAG}${TENSORXYZ[$ii]}${NC} \n"
          done 
        #NCT=`expr $NMAX - $NVF`
       if [ $NBVA -eq 0 ] || [ $NBCO -eq 0 ];then
         printf "\tYou INPUT OF    ${MAG}Valence Bands${NC} is  = $VB zero !!\n"   
         printf "\tYou INPUT OF ${MAG}Conduction Bands${NC} is  = $CB zero !!\n" 
         StopMe
       fi 
       if [ $NMAXCC -gt $NMAX ];then 
        printf "\t${RED}Hold on:${NC}\n"
        printf "\t${RED}Hold on:${NC}\n"
        
        printf "\tYou NUMBER OF     ${MAG}Valence Bands${NC} is(abinit)  = $NVF\n"   
        printf "\tYou NUMBER OF  ${MAG}Conduction Bands${NC} is(abinit)  = $NCT\n"   
        printf "\tYou NUMBER OF       ${MAG}Total Bands${NC} is(abinit)  = $NMAX\n"  
        printf "\tYou INPUT OF    ${MAG}Valence Bands${NC} is  = $NBVA\n"   
        printf "\tYou INPUT OF ${MAG}Conduction Bands${NC} is  = $NBCO\n" 
        printf "\tYou INPUT OF      ${MAG}Total Bands${NC} is  = $NMAXCC\n"
        printf "\t${RED}There are a bigger number of bands  ...$NMAXCC is bigger than $NMAX${NC}\n"
        printf "\t${RED}Stop rigth now ...${NC}\n"     
        exit 127
       fi  
##############################################
##############################################
##############################################
##############################################
        #tol2name=`echo ${tol/./-}`     
    #tolSHGt2name=`echo ${tolSHGt/./-}`
##################
################## here create info_shg 
################## here create info_shg 
################## here create info_shg 
rm -rf info_shg
       echo $NK > info_shg 
       echo $NBVA >> info_shg 
# wrong choice since it can change from run-to-run
#       ntot=`grep nband2 setUpAbinit_$CASO.in | awk '{print $2}'`
# good choice since it always takes the correct value
       nbms=`awk 'END{print NF}' $EIGENFILE`
       let "ntot=nbms-1"
       let "nc=ntot-NBVA"
       echo $nc >> info_shg 
 cp info_shg $WHERETORUN
################## here create info_shg 
################## here create info_shg 
################## here create info_shg 

#StopMe "thispoint"


 for ((ii=1;ii<=($NOTENSORXYZ); ii++));do
      #APELLIDO=$tol2name"_"$tolSHGt2name""_"""$PFILE"_"${TENSORXYZ[$ii]}"
      APELLIDO="$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name 
       SET_set[$ii]="set_input_"$APELLIDO
       ENERGYS[$ii]="energys.d_"$APELLIDO

   printf "\t===========================\n"
    printf "\tMaking FILE: ${MAG}${SET_set[$ii]}${NC}\n"
      printf "\tnMaxCC                = $NMAXCC \n"
      printf "\tactual_band_gap       = $BANDGAP\n"
      printf "\ttol                   = $tol  (AFECTA rmn\n"
      printf "\ttolSHGt               = $tolSHGt  (AFECTA double resonance shg 1 2 trans \n"
      printf "\ttolSHGL               = $tolSHGL  (AFECTA double resonance shg 1 2 lenght \n"
      printf "\tnSpinor               = $ESPINsetUp\n"  
      printf "\tenergy_data_filename  = $EIGENFILE \n"
      printf "\tpmn_data_filename     = $PMNFILE \n"
       if [ $ESPINsetUp -eq 2 ];then 
      printf "\tsmn_data_filename     = $SPINFILE\n" 
       fi
      printf "\tenergys_data_filename = ${ENERGYS[$ii]}\n"
      echo nMaxCC                     $NMAXCC > ${SET_set[$ii]}

      if [ "$ISB" == "B" ];then 
         echo actual_band_gap         $BANDGAP >> ${SET_set[$ii]}
       fi 
       if [ "$ISB" == "S" ];then 
         echo scissor                 $BANDGAP >> ${SET_set[$ii]}
       fi   
      #echo actual_band_gap            $BANDGAP >> ${SET_set[$ii]}
      echo tol                        $tol>>  ${SET_set[$ii]}
      echo tolSHGt                    $tolSHGt>>  ${SET_set[$ii]}
      echo tolSHGL                    $tolSHGL>>  ${SET_set[$ii]}
      echo nSpinor                    $ESPINsetUp  >> ${SET_set[$ii]}
      echo energy_data_filename       $EIGENFILE >>  ${SET_set[$ii]}
      echo pmn_data_filename          $PMNFILE >> ${SET_set[$ii]}
       if [ $ESPINsetUp -eq 2 ];then 
       echo smn_data_filename          $SPINFILE >> ${SET_set[$ii]}
       fi
      echo energys_data_filename   ${ENERGYS[$ii]}>>  ${SET_set[$ii]}
      mv ${SET_set[$ii]} $WHERETORUN
  done 
   ################################
   ################################
   ################################
   ################################
   ################################
   for ((ii=1;ii<=($NOTENSORXYZ); ii++));do
    #APELLIDO=$tol2name"_"$tolSHGt2name""_"""$PFILE"_"${TENSORXYZ[$ii]}"
    APELLIDO="$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name 
    SETSP[$ii]="spectrum_"$APELLIDO
    TO2TETRA="to2tetra_"$APELLIDO
    if [ -e $tmp1 ];then
     rm -f $tmp1
    fi   
    echo ${TENSORXYZ[$ii]}>$tmp1
    xyz123=`sed s/x/' 1'/g $tmp1 | sed s/y/' 2'/g | sed s/z/' 3'/g `
    if [ -e $tmp1 ];then
     rm -f $tmp1
    fi     
    echo 1 > ${SETSP[$ii]}
    #echo $WHATANS  $WHATA  54  T >> ${SETSP[$ii]}
    echo $WHATANS  $TO2TETRA  54  T >> ${SETSP[$ii]}
    echo $xyz123 >> ${SETSP[$ii]}
    printf "\t===================================\n"
    printf "\tMaking FILE: ${MAG}${SETSP[$ii]}${NC} \n"
    printf "\t 1\n"
    printf "\t $WHATANS  $WHATA  54  T\n"
    printf "\t$xyz123\n" 
    mv ${SETSP[$ii]} $WHERETORUN
   done 



 rcp -r $WHERETORUN $MAQUINA501:/data/$USER/
 rcp -r $PMNFILE $MAQUINA501:$REMOTO
 rcp -r $EIGENFILE $MAQUINA501:$REMOTO
if [ -e $SPINFILE   ];then
  rcp -r $SPINFILE $MAQUINA501:$REMOTO
fi 



 



    if [[ "$MAQUINA501" == "node"* ]]; then
         RUNsetUp=$SETUPxeon
          RUNlatm=$LATMxeon
    fi
       if [[ "$MAQUINA501" == "itanium"* ]]; then
         RUNsetUp=$SETUPitan
          RUNlatm=$LATMitan
       fi

       if [[ "$MAQUINA501" == "quad"* ]]; then
         RUNsetUp=$SETUPquad
          RUNlatm=$LATMquad
      fi

   DONDEWORKLO=$PWD/$WHERETORUN

   BASEkk=`basename $RUNsetUp` 
     DIRkk=`dirname $RUNsetUp` 
     printf "\t${MAG}MAQUINA ${NC} [$MAQUINA501]\n"
     printf "$DIRkk/${GREEN}$BASEkk${NC} ${SET_set[1]} ${SETSP[1]} \n"



  

 MKsetEND="rsh $HOST 'cd $DONDEWORKLO;touch setEND'"

rsh $MAQUINA501 "cd $REMOTO; $RUNsetUp ${SET_set[1]} ${SETSP[1]};$MKsetEND " >$WHERETORUN/infoSET
  
  
  SALIDA=0

    cd $WHERETORUN
    ## get into dir where you are runniong the response 
     while [ "$SALIDA" -lt "10" ]; do
       sleep 3
       if [ -e setEND ];then
       SALIDA=20
         rm -f $WHERETORUN/setEND
          ESTABIENEIGEN=`grep Reached infoSET`
           ESTABIENPMN=`grep reached infoSET`
      if [ -z "$ESTABIENPMN" ] || [ -z "$ESTABIENEIGEN" ] ;then
        StopMe
      else 
       printf "\t${GREEN}$ESTABIENEIGEN${NC} \n"
       printf "\t${GREEN}$ESTABIENPMN${NC}\n"
      fi    
       fi
     done 
##################################################
####################  WAIT  set_input  ###########
##################################################
        OUT1="infoSET"
        UNSC=`grep Unscissored $OUT1`
        ADJU=`grep Adjusted  $OUT1`
        TIJ1=`grep Scissor $OUT1`
        DIRE=`grep Direct $OUT1`
        printf "\t${MAG}====================${NC}\n"
        printf "\t$UNSC\n"
        printf "\t$ADJU\n"
        printf "\t$TIJ1\n"
        printf "$DIRE\n"
        rm -f tempo
        rm -f toFortran
        rm -f ZAL
        
        
        grep Scissor $OUT1 > tempo
        TIJER=`awk '{print $4}' tempo`
        printf "\t $TIJER\n"
        echo $TIJER > toFortran
        
       if [[ "$HOST" == "quad"* ]];then
         $CONquad toFortran > /dev/null
         printf "\t  $TIJER\n"
       fi 
       if [[ "$HOST" == "node"* ]];then
         $CONxeon toFortran > /dev/null
        printf "\t  $TIJER\n"
       fi 
       if [[ "$HOST" == "itan"* ]];then
         $CONitan toFortran > /dev/null
        printf "\t  $TIJER\n"
       fi
       if [ "$HOST" == "master" ];then
         $CONxeon toFortran > /dev/null
         printf "\t  $TIJER\n"
       fi  
        


        VALORTIJ=`head -1 ZAL`
        nueva1=`echo ${VALORTIJ}`
         nueva=`echo ${nueva1/./-}` 
        printf "\tvalor de tijeras: $VALORTIJ\n" 
        printf "\t${MAG}====================${NC}\n"
        rm -f tempo
        rm -f toFortran
        rm -f  ZAL

        #echo $PWD
       
#########################################################
#########################################################
#########################################################
#########################################################
#########################################################
#########################################################
  for ((ii=1;ii<=($NOTENSORXYZ); ii++));do 
      #APELLIDO=$tol2name"_"$tolSHGt2name""_"""$PFILE"_"${TENSORXYZ[$ii]}"
       APELLIDO="$MAQUINA501"_$WHATANS"_"${TENSORXYZ[1]}"_"$tolSHGt2name 
      integrandfilename="to2tetra_"$APELLIDO
      TO2TETRA="input2teta_"$APELLIDO
      TETRAN[$ii]="$TO2TETRA"
      SPECTR[$ii]="${NAMERES[$WHATANS]}"_"$APELLIDO"
       printf "\tMaking FILE: ${MAG}${TETRAN[$ii]}${NC} \n"
       
                               echo nMaxCC $NMAXCC > ${TETRAN[$ii]}
                           echo energy_min $eminw >> ${TETRAN[$ii]}
                           echo energy_max $emaxw >> ${TETRAN[$ii]}
                        echo energy_steps $stepsw >> ${TETRAN[$ii]}
     echo energys_data_filename   ${ENERGYS[$ii]} >> ${TETRAN[$ii]}
           echo tet_list_filename  tetrahedra_$NK >> ${TETRAN[$ii]} 
    echo integrand_filename  $integrandfilename   >> ${TETRAN[$ii]}
          echo spectrum_filename   ${SPECTR[$ii]} >> ${TETRAN[$ii]}

     printf "\tnMaxCC                 =$NMAXCC\n"
     printf "\tenergy_min             =$eminw \n"
     printf "\tenergy_max             =$emaxw \n"
     printf "\tenergy_steps           =$stepsw\n"
     printf "\tenergys_data_filename  =${ENERGYS[$ii]}\n"
     printf "\ttet_list_filename      =tetrahedra_$NK \n" 
     printf "\tintegrand_filename     =$integrandfilename\n"
     printf "\tspectrum_filename      =${MAG}${SPECTR[$ii]}${NC}\n"

        
        if [[ "$MAQUINA501" == "quad"* ]]; then
          RUNlatm=$LATMquad
        fi
        if [[ "$MAQUINA501" == "itan"* ]]; then
          RUNlatm=$LATMitan
        fi
        if [[ "$MAQUINA501" == "node"* ]]; then
          RUNlatm=$LATMxeon
        fi

        rcp ${TETRAN[$ii]} $MAQUINA501:$REMOTO
       done


       BASEkk=`basename $RUNlatm` 
     DIRkk=`dirname $RUNlatm` 
     printf "\t${MAG}MAQUINA ${NC} [$MAQUINA501]\n"
     printf "$DIRkk/${GREEN}$BASEkk${NC} ${TETRAN[1]} \n"



       # CUALES=`basename $RUNlatm` 
       #printf "\tRuning:\n"
       #printf "[$MAQUINA501]\n"
       #printf "${GREEN}$CUALES${NC} ${MAG}${TETRAN[1]}${NC} "      
       
       #printf "$RUNlatm ${TETRAN[1]}\n"   
       
     rm -f tetraEND
     rm -f infoTETRA
      DIR=$PWD
       MKsetEND="rsh $HOST 'cd $DIR;touch tetraEND'"
       rsh $MAQUINA501 "cd $REMOTO;$RUNlatm ${TETRAN[1]};$MKsetEND" >infoTETRA
 
      SALIDA=0
      while [ "$SALIDA" -lt "10" ]; do
       sleep 3
       if [ -e tetraEND ];then
       printf "\t${GREEN}tetra end $USER ${NC}\n"
       SALIDA=20
         #rm -f tetraEND
          #ESTABIENEIGEN=`grep Reached infoSET`
          # ESTABIENPMN=`grep reached infoSET`
      #if [ -z "$ESTABIENPMN" ] || [ -z "$ESTABIENEIGEN" ] ;then
      #  StopMe
      #else 
      # printf "\t${GREEN}$ESTABIENEIGEN${NC} \n"
      # printf "\t${GREEN}$ESTABIENPMN${NC}\n"
      #fi    
    fi
     done 
     
    TIJERILLA=`echo ${VALORTIJ/./-}` 
  APELLIDO=$tol2name"_"$tolSHGt2name""_"""$PFILE"_"${TENSORXYZ[$ii]}"
kkFILENAME="${NAMERES[$WHATANS]}"_"${TENSORXYZ[1]}"_kk_"$PFILE"_"$NBCO"_N_"$TIJERILLA"_"$tol2name"_"$tolSHGL2name"L_"$tolSHGt2name"t
beforekkFILENAME="${NAMERES[$WHATANS]}"_"${TENSORXYZ[1]}"_NOKK_"$PFILE"_"$NBCO"_N_"$TIJERILLA"_"$tol2name"_"$tolSHGL2name"L_"$tolSHGt2name"t
#beforekkFILENAME="${NAMERES[$WHATANS]}"_"${TENSORXYZ[1]}"_NOKK_"$PFILE"_"$NBCO"_N_"$TIJERILLA"_"$tol2name"_"$tolSHGt2name"t

 
  #echo =========================

  #echo $kkFILENAME
   
    
        if [[ "$MAQUINA501" == "quad"* ]]; then
             RUNkk=$KKquad
        fi
        if [[ "$MAQUINA501" == "itan"* ]]; then
            RUNkk=$KKitan
        fi
        if [[ "$MAQUINA501" == "node"* ]]; then
          RUNkk=$KKxeon
        fi
   BASEkk=`basename $RUNkk` 
     DIRkk=`dirname $RUNkk` 
   printf "\t${MAG}Doing kk${NC}($MAQUINA501)\n"

    
  
   printf "$DIRkk/${GREEN}$BASEkk${NC} 1 ${SPECTR[1]} spectrum\n"
   #rsh $MAQUINA501 "cd $REMOTO;pwd"
   rsh $MAQUINA501 "cd $REMOTO; $RUNkk 1 ${SPECTR[1]}  spectrum" >infoKK
   rsh $MAQUINA501 "cd $REMOTO; mv spectrum $kkFILENAME"
   rsh $MAQUINA501 "cd $REMOTO; cp ${SPECTR[1]} $beforekkFILENAME"
   rsh $MAQUINA501 "cd $REMOTO; rm -f $PMNFILE;rm -f $EIGENFILE;"
   ##rcp $MAQUINA501:$REMOTO/$kkFILENAME .
   rcp -r $MAQUINA501:$REMOTO/* .
     if [ -e ${ENERGYS[1]} ];then
     # rm -rf ${ENERGYS[1]}
      echo ${ENERGYS[1]}
     fi 
     if [ -e $PMNFILE ];then
      rm -rf $PMNFILE
     fi 
     if [ -e $EIGENFILE ];then
      rm -rf $EIGENFILE
     fi
    
   #echo "ESTE ES EL : $PADREAMARO"
    ISSAL=$kkFILENAME"_"$PADREAMARO
    cp  $kkFILENAME ../res/$ISSAL 
    cp  $beforekkFILENAME ../res

    cd $ODIR
 
  printf "\n "
  printf "\t===================================\n"

  if [ -e res/$ISSAL ];then     
  printf "\t${GREEN}Output${NC}: ${BLUE}res${NC}/$ISSAL\n"
  fi
  if [ -e res/$beforekkFILENAME ];then     
  printf "\t${GREEN}Output${NC}: ${BLUE}res${NC}/$beforekkFILENAME\n"
  fi
  


    rsh $MAQUINA501 "rm -rf $REMOTO"


 # if [ -e .README ];then  
 #  MUCH=`du -h .README`
 #  echo "=============== by $USER" >> .README 
 #  echo `date` >> .README 
 #  echo "$WHERE/`basename $0` $@" >> .README
 # else 
 #  echo "=============== by $USER" > .README 
 #  echo `date` >> .README 
 #  echo "$WHERE/`basename $0` $@" >> .README
 # fi 






TIMEENDALL=`date`
  printf "\t--------------------------------------------------\n"
  printf "\tFinished all at time: ${GREEN}$TIMEENDALL ${NC}\n"
  printf "\t--------------------------------------------------\n"
      TIME1=`date --date="$TIMESTARTALL" +%s`
      TIME2=`date --date="$TIMEENDALL" +%s`
      ELTIME=$[ $TIME2 - $TIME1 ]
      TMIN=$(echo "scale=9; $ELTIME/60" | bc)
      TMIN1=$(echo "scale=9; $ELTIME/3600" | bc)
      printf "\t take:   $TMIN min. \n"
      printf "\t take:   $TMIN1 Hrs. \n"
      printf "\t--------------------------------------------------\n"

      printf "\t$MUCH\n"


  printf "\t ${GREEN}I found the end ok${NC}\n"
  cp  $WHERETORUN/${ENERGYS[1]}  energys.d_"$PFILE" 
  rm -f conmutadorMORE.dat
  rm -f conmutadorLESS.dat
#  cp -v $WHERETORUN/conmutadorMORE.dat .
#  cp -v $WHERETORUN/conmutadorLESS.dat .

#if [ -e $WHERETORUN/resta.dat ];then
#  printf "\tresta.dat evaluacion de la ec. 12 PRBv52p14636 (lado izquierdo)\n" 
#  cp -fv $WHERETORUN/resta.dat .
#fi

#if [ -e $WHERETORUN/sumatoria.dat ];then
#  cp -fv $WHERETORUN/sumatoria.dat .
#fi

if [ -d $WHERETORUN ];then 
  printf "\tBORRANDO ESTE DIRECTORIO: ${BLUE} $WHERETORUN ${NC}\n" 
 #rm -rf $WHERETORUN
  fi 
 
