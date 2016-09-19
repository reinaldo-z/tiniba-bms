#!/bin/bash
## please keep this history.
## LAST MODIFICATION :  Febrero 18 2010 by Cabellos  a 16:52
## LAST MODIFICATION :  Febrero 18 2010 by Cabellos  a 18:06
## LAST MODIFICATION :  Marzo   02 2010 by Cabellos  a 10:27 anexed to wien2k
## AUTHOR            :  J.L. Cabellos 
## REPORTING BUGS    :  Report bugs to <sollebac@gmail.com>.

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
     


 declare -a FALSEMACHINESpmn
 declare -a VIVOS
 declare -a MUERTOS
 rm -f killme
### hha this all the cluster jl, wien2k runs only in xeon 32 bits ...
MAQ501[1]="node01";MAQ501[12]="node12"
MAQ501[2]="node02";MAQ501[13]="node13"
MAQ501[3]="node03";MAQ501[14]="node14"
MAQ501[4]="node04";MAQ501[15]="node15"
MAQ501[5]="node05"
MAQ501[6]="node06"
MAQ501[7]="node07"
MAQ501[8]="node08"
MAQ501[9]="node09"
MAQ501[10]="node10"
MAQ501[11]="node11"
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
if [ ! -e .machines ];then
    printf "\t ${RED}WARNING${NC}: there isnt file: .machines... creating one .\n"
echo "granularity:1" > .machines
echo "1:node15:1" >> .machines
echo "1:node15:1" >> .machines
echo "1:node14:1" >> .machines
echo "1:node14:1" >> .machines
echo "1:node13:1" >> .machines
echo "1:node13:1" >> .machines
echo "1:node12:1" >> .machines
echo "1:node12:1" >> .machines
echo "1:node11:1" >> .machines
echo "1:node11:1" >> .machines
echo "1:node10:1" >> .machines
echo "1:node10:1" >> .machines
echo "1:node09:1" >> .machines
echo "1:node09:1" >> .machines
echo "1:node07:1" >> .machines
echo "1:node07:1" >> .machines
echo "1:node06:1" >> .machines
echo "1:node06:1" >> .machines
echo "1:node05:1" >> .machines
echo "1:node05:1" >> .machines
echo "1:node04:1" >> .machines
echo "1:node04:1" >> .machines
echo "1:node03:1" >> .machines
echo "1:node03:1" >> .machines
echo "1:node02:1" >> .machines
echo "1:node02:1" >> .machines
fi   



#        touch -f killme
#        exit 0
#else
 FALSEMACHINESpmn=(`cat .machines`)
  NOFALSEMACHINESpmn=`echo ${#FALSEMACHINESpmn[@]}`
   jj=0
    mm=0
     nn=0
      #rm -f .machines
      # touch .machines
         for ((hh=0;hh<=($NOFALSEMACHINESpmn-1); hh++));do
            perro=${FALSEMACHINESpmn[$hh]}
               if [[ "$perro" == *"node"* ]]; then
                 RODI=`echo ${perro:2:6}`
                 findMaq $RODI
               fi 
            
            if [ "$ALLOWED" == "1" ];then 
             IPT=`nmap --max_rtt_timeout 20  -oG - -p 514  $RODI | grep open | cut -d" " -f2`
               findIndex $RODI
                 if [ "$IPT" == "${IPES[$INDES]}" ];then 
                   let jj++
                   let nn++ 
                    printf "\t[$RODI] ${GREEN}Alive${NC}\n" 
                 else 
                   let jj++
                   let mm++
                    MUERTOS[$mm]=$RODI
                 fi 
           fi 
         done     
            NOMUERTOS=`echo ${#MUERTOS[@]}`
             if [ $NOMUERTOS -gt 0 ];then 
              printf "\tYou original .machines has a $NOMUERTOS node dead ... fix it now ...\n"
               for ((hh=1;hh<=($NOMUERTOS); hh++));do
                printf "\t%4d%12s${RED}%7s${NC}\n" "$hh" "${MUERTOS[$hh]}" "Dead" 
               done 
              touch killme
             fi 
#fi 
######
######
exit 0







