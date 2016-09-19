#!/bin/bash
##
##PARENTS:
##2resposeSHG.sh
   RED='\e[0;31m'
  BLUE='\e[0;34m'
   BLU='\e[1;34m'
  CYAN='\e[0;36m'
 GREEN='\e[0;32m'
   GRE='\e[1;32m'
YELLOW='\e[1;33m'
   MAG='\e[0;35m'
    NC='\e[0m' # No Color

       DIR=$PWD
         WHERE=`dirname $0`
       BASEDIR=`dirname $PWD`
          CASO=`basename $PWD`
        PARENT=`basename $BASEDIR`
   SETUPABINIT=setUpAbinit_"$CASO".in
          HOST=`hostname`


##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
##<><><><><><><><><><><><><><><><>
  declare -a NAMERES

    if [ $# -eq "0" ];then 
      printf "\t Stop rigth now ... Im children you can use me alone"
      exit 127
    fi 

      ii=0
      for file in $@; do
      let "ii=ii+1"
      NAMERES[$ii]=$file
      done 
 #      printf "\t${GREEN}21${NC}  ${BLU}${NAMERES[21]}${NC}  (Contributions 1 omega intERband+IntRAband)\n"
     




 # printf "\t${GREEN}1${NC}  ${BLU}${NAMERES[1]}${NC}\n"
  #printf "\t${GREEN}2${NC}  ${BLU}${NAMERES[2]}${NC}  shiftCurrent\n"
  #printf "\t${GREEN}3${NC}  ${BLU}${NAMERES[3]}${NC}  eta2\n"
  
 
 #printf "\t${CYAN}========= Length Gauge =============${NC}\n"
 #printf "\tNOTA:\n"
 #printf "\tER=int${CYAN}ER${NC}band\n"
 #printf "\tRA=int${CYAN}RA${NC}band\n"
 #printf "\t${CYAN}--------- 1 Omega ------------------${NC}\n"
 #printf "\t(IntERband 1 omega has 2 terminos pag. 19 ec. 2.96)\n"
 #printf "\t(IntRAband 1 omega has 3 terminos pag. 19 ec. 2.98)\n"
 #printf "\t${GREEN}21${NC}  ${BLU}${NAMERES[21]}${NC}  (Contributions 1 omega intERband+IntRAband)\n"
 
 #printf "\t${GREEN}40${NC}  ${BLU}${NAMERES[40]}${NC}     (Contributions 1 omega intERband+    0    ) Termino(1+2)\n"

 #printf "\t${GREEN}42${NC}  ${BLU}${NAMERES[42]}${NC}   (Contributions 1 omega intERband+    0    ) Termino(1)\n"
 #printf "\t${GREEN}43${NC}  ${BLU}${NAMERES[43]}${NC}   (Contributions 1 omega intERband+    0    ) Termino(2)\n"
 ### intRAband
 #printf "\t${GREEN}41${NC}  ${BLU}${NAMERES[41]}${NC}     (Contributions 1 omega     0    +intRAband) Termino(1+2+3)\n"
#printf "\t${GREEN}44${NC}  ${BLU}${NAMERES[44]}${NC}   (Contributions 1 omega     0    +intRAband) Termino(1)\n"
#printf "\t${GREEN}45${NC}  ${BLU}${NAMERES[45]}${NC}   (Contributions 1 omega     0    +intRAband) Termino(2)\n"
#printf "\t${GREEN}46${NC}  ${BLU}${NAMERES[46]}${NC}   (Contributions 1 omega     0    +intRAband) Termino(3)\n"

printf "\n"
#printf "\t${CYAN}--------- 2 Omega ------------------${NC}\n"  
#printf "\t(IntERband 2 omega has 1 terminos pag. 19 ec. 2.96)\n"
#printf "\t(IntRAband 2 omega has 2 terminos pag. 19 ec. 2.98)\n"
#printf "\t${GREEN}22${NC}  ${BLU}${NAMERES[22]}${NC}  (Contributions 2 omega intERband+IntRAband)\n"
#printf "\t${GREEN}47${NC}  ${BLU}${NAMERES[47]}${NC}     (Contributions 2 omega intERband+    0    ) Termino(1)\n"
### intRAband
# printf "\t${GREEN}48${NC}  ${BLU}${NAMERES[48]}${NC}     (Contributions 2 omega     0    +intRAband) Termino(1+2)\n"
# printf "\t${GREEN}49${NC}  ${BLU}${NAMERES[49]}${NC}   (Contributions 2 omega     0    +intRAband) Termino(1)\n"
# printf "\t${GREEN}50${NC}  ${BLU}${NAMERES[50]}${NC}   (Contributions 2 omega     0    +intRAband) Termino(2)\n"
#printf "\t${CYAN}========= Length Gauge =============${NC}\n"
printf "\t${GREEN}21${NC} ${BLU}${NAMERES[21]}${NC}  (${GREEN}Length 1 omega${NC})\n"
printf "\t${GREEN}22${NC} ${BLU}${NAMERES[22]}${NC}  (${GREEN}Length 2 omega${NC})\n"


 #printf "\t${CYAN}========= Transversal Gauge ========${NC}\n"
# printf "\t${MAG}26${NC} ${BLU}${NAMERES[26]}${NC}\n"   
# printf "\t${MAG}27${NC} ${BLU}${NAMERES[27]}${NC}\n"
# printf "\t${CYAN}==============================${NC}\n"
# printf "\t${CYAN}========= Transversal Gauge LEITSMANN ========${NC}\n"
# printf "\t${MAG}60${NC} ${BLU}${NAMERES[60]}${NC} (transversal Leitsman 1 omega)\n"
 printf "\t${GREEN}64${NC} ${BLU}${NAMERES[64]}${NC} (${GREEN}transversal Articulo  1 omega${NC})\n"
  printf "\t${GREEN}65${NC} ${BLU}${NAMERES[65]}${NC} (${GREEN}transversal Articulo  2 omega${NC})\n"
   
 printf "\t${MAG}61${NC} ${BLU}${NAMERES[61]}${NC} (${MAG}transversal Articulo 1 omega WRONG )${NC}\n"
# printf "\t${MAG}62${NC} ${BLU}${NAMERES[62]}${NC} (transversal Leitsman 2 omega)\n"
 printf "\t${MAG}63${NC} ${BLU}${NAMERES[63]}${NC} (${MAG}transversal Articulo 2 omega WRONG)${NC}\n"
 
# printf "\t${CYAN}==============================${NC}\n"
#printf "\t${CYAN}========= ETA + OMEGA  LEITSMANN ========${NC}\n"
# printf "\t${MAG}80${NC} ${BLU}${NAMERES[80]}${NC}\n"
# printf "\t${MAG}81${NC} ${BLU}${NAMERES[81]}${NC}\n"
#printf "\t${CYAN}========= SHARMA ========${NC}\n"
 #printf "\t${GREEN}82${NC} ${BLU}${NAMERES[82]}${NC}\n"
 #printf "\t${GREEN}83${NC} ${BLU}${NAMERES[83]}${NC}\n"



 #printf "\t${CYAN}========= Transversal Rabc Gauge ========${NC}\n"
 #printf "\t${GREEN}51${NC} ${BLU}${NAMERES[51]}${NC}\n"   
 #printf "\t${GREEN}52${NC} ${BLU}${NAMERES[52]}${NC}\n"
 #printf "\t${GREEN}53${NC} ${BLU}${NAMERES[53]}${NC}\n"
 printf "\t${CYAN}==============================${NC}\n"








#grep nband2 setUpAbinit_$CASO.in > tmp1
#  NMAX=`head -1 tmp1 | awk '{print $2}'`
#  grep -n 'occ ' $CASO'_check'/$CASO.out > tmp2
#  iocc=`awk -F: '{print $1}' tmp2`
#  grep -n 'prtvol' $CASO'_check'/$CASO.out > tmp2
#  iprtvol=`awk -F: '{print $1}' tmp2`
#  awk 'NR=='$iocc',NR=='$iprtvol'' $CASO'_check'/$CASO.out > tmp3
# for spin-orbit each state has only one electron for a given spin
#  grep -o 1.000 tmp3 > tmp4
#  NVF=`wc tmp4 | awk '{print $2}'`
#    if [ $NVF == '0' ];then
#	grep -o 2.000 tmp3 > tmp4
#	NVF=`wc tmp4 | awk '{print $2}'`
#    fi
#    NCT=`expr $NMAX - $NVF`
#    printf "\t   Number of Valence Bands(abinit)=${MAG}$NVF${NC}\n"
#    printf "\tNumber of Conduction Bands(abinit)=${MAG}$NCT${NC}\n"
#    printf "\t        Number Total Bands(abinit)=${MAG}$NMAX${NC}\n"
#    printf "\t =================\n"
#    printf "\t Im going take all things from:\n"
#    printf "\t$WHERE\n"
    

       
