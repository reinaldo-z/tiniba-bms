#!/bin/bash
##FUNCTION: DON GET CONFUSED WITH ARE YOU PASTE  
##CHILDREN:
##LAST UPDATE: Octuber 2007 11 at 11:25 by JL
RED='\e[0;31m'
BLUE='\e[0;34m'
BLU='\e[1;34m'
CYAN='\e[0;36m'
GREEN='\e[0;32m'
GRE='\e[1;32m'
YELLOW='\e[1;33m'
MAG='\e[0;35m'
NC='\e[0m' # No Color
declare -a PRIMERO 
declare -a SEGUNDO 
declare -a OUTPUT
FECHA=`date`



function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   exit 127
 else
   printf "\t${RED}Stoping right now... ${NC} `basename $0`\n"
   printf "\t$1\n\n"
   exit 127
 fi
}

function howto {
    printf "\tUsage:\n"
    printf "\t`dirname $0`/${GREEN}`basename $0`${NC}"
    printf "  [${MAG}option${NC}${MAG}1${NC}]"
    printf "  [${MAG}option${NC}${MAG}2${NC}]\n"
    printf "\t[${MAG}option${NC}${MAG}1${NC}] = "
    printf " both \n"
    printf "\t[${MAG}option${NC}${MAG}2${NC}] = "
    printf " sm  kk \n"
    printf "\t example:\n"
    printf "\t`dirname $0`/${GREEN}`basename $0`${NC} both sm \n"
    StopMe 
 }


####################
####################
####################


   if [ "$#" -eq 0 ];then
    howto        
   fi
###### 
  # shg1_Length_ER+RA shg1_Length
   if [ "$1" != "length" ];then   
    if [ "$1" != "tran" ];then   
     if [ "$1" != "both" ];then   
              howto 
     fi
    fi 
   fi       


   if [ "$2" != "kk" ];then   
    if [ "$2" != "sm" ];then   
      howto
    fi  
   fi 
   #######
   SHG=$1
    KK=$2
   
    echo $QUEES 
    if [ "$SHG" == "length" ];then 
	printf "\t look for file: shg1_Length and shg2_Length  $KK \n"
    fi 
    if [ "$SHG" == "tran" ];then 
        printf "\t look for file: shg1_Tran and shg2_Tran  $KK \n"
    fi 
    if [ "$SHG" == "both" ];then 
        printf "\t look for file: shg1_Tran and shg2_Tran  $KK \n"
        printf "\t look for file: shg1_Length and shg2_Length $KK \n"
    fi 
  
     ii=0
     FILES="shg1_Length*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
              ISSM=(`echo $file | tr '_' ' '`)         
              if [ "$KK" == "${ISSM[4]}" ];then
               let "ii=ii+1"
                #echo $file 
               SHG1L[$ii]=$file
              fi
            fi
           fi
         fi
       fi  
       
      done
    #######
        ii=0
     FILES="shg2_Length*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
              ISSM=(`echo $file | tr '_' ' '`)
              if [ "$KK" == "${ISSM[4]}" ];then
                 #echo $file
                let "ii=ii+1" 
                SHG2L[$ii]=$file
              fi
            fi
           fi
         fi
       fi  
      done
    #######
        ii=0
     FILES="shg1_Tran*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
             
              
              ISSM=(`echo $file | tr '_' ' '`)
               
              if [ "$KK" == "${ISSM[4]}" ];then
                #echo $file
               let "ii=ii+1" 
               SHG1T[$ii]=$file
              fi
            fi
           fi
         fi
       fi  
      done
   #######
        ii=0
     FILES="shg2_Tran*"
     for file in $FILES; do  
        if [ -e $file ];then       
         if [ "${file#*.}" != "g" ];then
           if [ "${file#*.}" != "eps" ];then
            if [ "${file#*.}" != "pdf" ];then
                           
              ISSM=(`echo $file | tr '_' ' '`)
               
              if [ "$KK" == "${ISSM[4]}" ];then
              ##echo $file
               let "ii=ii+1" 
               SHG2T[$ii]=$file
              fi
            fi
           fi
         fi
       fi  
      done
##################333
##################
##################
NOSHG1L=`echo ${#SHG1L[@]}`
NOSHG2L=`echo ${#SHG2L[@]}`
NOSHG1T=`echo ${#SHG1T[@]}`
NOSHG2T=`echo ${#SHG2T[@]}`


 if [ $NOSHG1L -eq 0 ];then 
    printf "\t No SHG1 LENGTH FILES\n"
    exit 127
 fi 
 if [ $NOSHG2L -eq 0 ];then 
    printf "\t No SHG2 LENGTH FILES\n"
    exit 127
 fi 
 if [ $NOSHG1T -eq 0 ];then 
    printf "\t No SHG1 TRAN FILES\n"
    exit 127
 fi 
 if [ $NOSHG2T -eq 0 ];then 
    printf "\t No SHG2 TRAN FILES\n"
    exit 127
 fi 

################
################
################

################
################ HERE BEGIN LOOKING FOR BROTHERS 
################
    BBRR=0

    printf "\t=====================\n"
   for ((hh=1;hh<=($NOSHG1L); hh++));do
   # printf "\t [$hh] ${SHG1L[$hh]}\n"
      stringZ=${SHG1L[$hh]}
        QUE=`echo ${#stringZ}`
        WHAT=`expr index "$stringZ" A`
     #     echo $WHAT
        APELLIDO1=`echo ${stringZ:$WHAT:$QUE}`
   # printf "                              ${MAG}$APELLIDO1${NC}\n"
        
    ### rigth now look for the same apellido in shg2L
        #   printf "\t=====================\n"
       for ((jj=1;jj<=($NOSHG2L); jj++));do
           ESCRIBE=0
           stringSHG2L=${SHG2L[$jj]}
            QUE=`echo ${#stringSHG2L}`
           WHAT=`expr index "$stringSHG2L" A`
          APELLIDO2=`echo ${stringSHG2L:$WHAT:$QUE}`
         if [ $APELLIDO1 == $APELLIDO2 ];then
          #printf "\t$stringZ\n"
          #printf "\t$stringSHG2L\n"
          #printf "\t------------------\n"
           ### rigth now look for the same apellido in shg1T
               for ((ii=1;ii<=($NOSHG1T); ii++));do 
                  stringSHG1T=${SHG1T[$jj]}
            QUE=`echo ${#stringSHG1T}`
           WHAT=`expr index "$stringSHG1T" A`
          APELLIDO3=`echo ${stringSHG1T:$WHAT:$QUE}`
                     if [ $APELLIDO1 == $APELLIDO3 ];then
                       #printf "\t$stringZ\n"
                       #printf "\t$stringSHG2L\n"
                       #printf "\t  $stringSHG1T\n"
                       #printf "\t------------------\n"
                       ### rigth now look for the same apellido in shg2T 
                        for ((iz=1;iz<=($NOSHG2T); iz++));do
                         stringSHG2T=${SHG2T[$iz]}
                         QUE=`echo ${#stringSHG2T}`
                         WHAT=`expr index "$stringSHG2T" A`
                         APELLIDO4=`echo ${stringSHG2T:$WHAT:$QUE}`
                           if [ $APELLIDO1 == $APELLIDO4 ];then
                             if [ $ESCRIBE -eq 0 ];then
                              let "BBRR=BBRR+1"
       #### cambia aqui el nombre 
       #### cambia aqui el nombre 
       #### cambia aqui el nombre 
FUERA="shg1L_shg2L_shg1T_shg2T$APELLIDO1"-wien2k""
                               echo "#!/bin/bash" > paste_$BBRR.sh
                               echo "## $FECHA " >> paste_$BBRR.sh
                               echo "## $PWD " >> paste_$BBRR.sh
                               echo "## USER = $USER " >> paste_$BBRR.sh
                               echo "## begin code ##" >> paste_$BBRR.sh
                               echo "rm -f tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7" >> paste_$BBRR.sh   
                               echo "FILE1=\"$stringZ\"" >> paste_$BBRR.sh
                               echo "FILE2=\"$stringSHG2L\"" >> paste_$BBRR.sh
                               echo "FILE3=\"$stringSHG1T\"" >> paste_$BBRR.sh
                               echo "FILE4=\"$stringSHG2T\"" >> paste_$BBRR.sh
                               
                               echo "OUTPUT=\"$FUERA\"" >> paste_$BBRR.sh
                               #FUERA="shg1L_shg2L_shg1T_shg2T$APELLIDO1"
 echo "awk '{print \$1,\$2,\$3}' \$FILE1 > tmp1" >>paste_$BBRR.sh  
 echo "awk '{print \$2,\$3}' \$FILE2 > tmp2" >>paste_$BBRR.sh  
 echo "awk '{print \$2,\$3}' \$FILE3 > tmp3" >>paste_$BBRR.sh  
 echo "awk '{print \$2,\$3}' \$FILE4 > tmp4" >>paste_$BBRR.sh  
 echo "paste tmp1 tmp2 tmp3 tmp4 > \$OUTPUT" >>paste_$BBRR.sh   
 echo "printf \"\\tOutput: \$OUTPUT\\n\"" >>paste_$BBRR.sh
 echo "NCOL=\`awk 'END{print NF}' \$OUTPUT\`" >>paste_$BBRR.sh  
 echo "printf \"\\tNumber of Columnas: \$NCOL\\n\"" >>paste_$BBRR.sh
        printf "\t=====================\n"
                             printf "\t $BBRR \n" 
                             printf "\t$stringZ\n"
                             printf "\t$stringSHG2L\n"
                             printf "\t  $stringSHG1T\n"
                             printf "\t  $stringSHG2T\n"
                              #printf "\t------------------\n"        
                              chmod 777 paste_$BBRR.sh                
                             ./paste_$BBRR.sh
                             
 #### here same do the .g file 
########################
########################
########################  
toGNUplot="$FUERA"-Length-Transv.g
printf "\tOutPut: $toGNUplot\n"    
echo "## $PWD" > $toGNUplot
echo "## $FECHA" >> $toGNUplot
echo "## USER = $USER" >> $toGNUplot  
echo "K=4.189E-4*1E12" >> $toGNUplot
echo "##pag. 53 Nonlinear Optics Robert Boyd" >> $toGNUplot
echo "set term pslatex color solid aux " >> $toGNUplot
echo "set output 'fig.tex'" >> $toGNUplot
echo "set multiplot" >> $toGNUplot
echo "set lmargin 0" >> $toGNUplot
echo "set ylabel '\small{$|\chi^{(2)}_{xyz}|(-2\omega;\omega,\omega)|$ [p/V]}' 0,-1" >> $toGNUplot
echo "set xlabel '\Large photon energy (ev)' 0,-1" >> $toGNUplot
echo "set xrange [0:5]" >> $toGNUplot
echo "set yrange [0:3E-6]" >> $toGNUplot
echo "set yrange [0:1200]" >> $toGNUplot
echo "set key spacing 1.75" >> $toGNUplot
echo "ANCHO=1">> $toGNUplot
echo "plot '$FUERA' u 1:(K*(sqrt((\$2+\$4)*(\$2+\$4)+(\$3+\$5)*(\$3+\$5))))   title 'shg Length' w l lw ANCHO,\\" >> $toGNUplot 
echo "     '$FUERA' u 1:(K*(sqrt((\$6+\$8)*(\$6+\$8)+(\$7+\$9)*(\$7+\$9))))   title 'shg Trans' w l lw ANCHO" >> $toGNUplot 
echo "## 1 Energy "  >> $toGNUplot 
echo "## 2 Re shg1 Length" >> $toGNUplot 
echo "## 3 Im shg1 Length" >> $toGNUplot
echo "## 4 Re shg2 Length" >> $toGNUplot
echo "## 5 Im shg2 Length" >> $toGNUplot 
echo "## 6 Re shg1 Trans" >>  $toGNUplot 
echo "## 7 Im shg1 Trans" >> $toGNUplot       
echo "## 8 Re shg2 Trans" >> $toGNUplot
echo "## 9 Im shg2 Trans" >> $toGNUplot   
################
################
########################
########################
########################  
toGNUplot="$FUERA"-Length.g  
printf "\tOutPut: $toGNUplot\n"  
echo "## $PWD" > $toGNUplot
echo "## $FECHA" >> $toGNUplot
echo "## USER = $USER" >> $toGNUplot  
echo "K=4.189E-4*1E12" >> $toGNUplot
echo "##pag. 53 Nonlinear Optics Robert Boyd" >> $toGNUplot
echo "set term pslatex color solid aux " >> $toGNUplot
echo "set output 'fig.tex'" >> $toGNUplot
echo "set multiplot" >> $toGNUplot
echo "set lmargin 0" >> $toGNUplot
echo "set ylabel '\small{$|\chi^{(2)}_{xyz}|(-2\omega;\omega,\omega)|$ [p/V]}' 0,-1" >> $toGNUplot
echo "set xlabel '\Large photon energy (ev)' 0,-1" >> $toGNUplot
echo "set xrange [0:5]" >> $toGNUplot
echo "set yrange [0:3E-6]" >> $toGNUplot
echo "set yrange [0:1200]" >> $toGNUplot
echo "set key spacing 1.75" >> $toGNUplot
echo "ANCHO=1">> $toGNUplot
echo "plot '$FUERA' u 1:(K*(sqrt((\$2+\$4)*(\$2+\$4)+(\$3+\$5)*(\$3+\$5))))   title 'shg Length' w l lw ANCHO" >> $toGNUplot 
echo "## 1 Energy "  >> $toGNUplot 
echo "## 2 Re shg1 Length" >> $toGNUplot 
echo "## 3 Im shg1 Length" >> $toGNUplot
echo "## 4 Re shg2 Length" >> $toGNUplot
echo "## 5 Im shg2 Length" >> $toGNUplot 
echo "## 6 Re shg1 Trans" >>  $toGNUplot 
echo "## 7 Im shg1 Trans" >> $toGNUplot       
echo "## 8 Re shg2 Trans" >> $toGNUplot
echo "## 9 Im shg2 Trans" >> $toGNUplot
########################
########################
########################  
toGNUplot="$FUERA"-Transv.g
printf "\tOutPut: $toGNUplot\n"  
echo "## $PWD" > $toGNUplot
echo "## $FECHA" >> $toGNUplot
echo "## USER = $USER" >> $toGNUplot  
echo "K=4.189E-4*1E12" >> $toGNUplot
echo "##pag. 53 Nonlinear Optics Robert Boyd" >> $toGNUplot
echo "set term pslatex color solid aux " >> $toGNUplot
echo "set output 'fig.tex'" >> $toGNUplot
echo "set multiplot" >> $toGNUplot
echo "set lmargin 0" >> $toGNUplot
echo "set ylabel '\small{$|\chi^{(2)}_{xyz}|(-2\omega;\omega,\omega)|$ [p/V]}' 0,-1" >> $toGNUplot
echo "set xlabel '\Large photon energy (ev)' 0,-1" >> $toGNUplot
echo "set xrange [0:5]" >> $toGNUplot
echo "set yrange [0:3E-6]" >> $toGNUplot
echo "set yrange [0:1200]" >> $toGNUplot
echo "set key spacing 1.75" >> $toGNUplot
echo "ANCHO=1">> $toGNUplot 
echo "plot '$FUERA' u 1:(K*(sqrt((\$6+\$8)*(\$6+\$8)+(\$7+\$9)*(\$7+\$9))))   title 'shg Trans' w l lw ANCHO" >> $toGNUplot 
echo "## 1 Energy "  >> $toGNUplot 
echo "## 2 Re shg1 Length" >> $toGNUplot 
echo "## 3 Im shg1 Length" >> $toGNUplot
echo "## 4 Re shg2 Length" >> $toGNUplot
echo "## 5 Im shg2 Length" >> $toGNUplot 
echo "## 6 Re shg1 Trans" >>  $toGNUplot 
echo "## 7 Im shg1 Trans" >> $toGNUplot       
echo "## 8 Re shg2 Trans" >> $toGNUplot
echo "## 9 Im shg2 Trans" >> $toGNUplot 

#printf "\t=====================\n"
                              
                           
                             ESCRIBE=1 
                             fi  
                       
                           fi 
                         done 
                     fi 
  
               done
          
         fi  
        done ## NOSHG2L)
    done ## $NOSHG1L

























    exit 127
   if [ "$QUEES" == "1e" ];then 
    LOOKFOR=shg2e.
    WHAT="e"
   fi 

   if [ "$QUEES" == "2e" ];then 
    LOOKFOR=shg1e.
    WHAT="e"
   fi 

   if [ "$QUEES" == "1T" ];then 
    LOOKFOR=shg2T.
    WHAT="T"
   fi 
   
   if [ "$QUEES" == "2T" ];then 
    LOOKFOR=shg1T.
    WHAT="T"
   fi 
    
 
  if [ "$SHG" == "shg2e" ] || [ "$SHG" == "shg2T" ];then
     ii=0
     FILES="$SHG*"$KK"*"
     for file in $FILES; do  
       SEG="$LOOKFOR${file:6}"     
       if [ -e $SEG ];then       
        let "ii=ii+1"  
        PRIMERO[$ii]=$SEG
        SEGUNDO[$ii]=$file
         OUTPUT[$ii]=abs_$WHAT'.'${file:6}
       fi  
       #printf '%s\t%s \n' "$BAR" "$FOO" 
      done
  fi     
          
  
      ############################
      ############################
      ############################
      ############################
   if [ "$SHG" == "shg1e" ] || [ "$SHG" == "shg1T" ];then
     ii=0
     FILES="$SHG*"$KK"*"
     for file in $FILES; do  
       SEG="$LOOKFOR${file:6}"     
       if [ -e $SEG ];then       
        let "ii=ii+1"  
        PRIMERO[$ii]=$file
        SEGUNDO[$ii]=$SEG
         OUTPUT[$ii]=abs_$WHAT'.'${file:6}
       fi  
       #printf '%s\t%s \n' "$BAR" "$FOO" 
      done
  fi 
     ## debug jl 
     #echo ii = $ii 
     #read -p ""
     if [ "$ii" == "0" ];then 
      printf "\t Nothing to do here\n"
      printf "\t go to dir : ${BLUE}res${NC}\n"
      StopMe 
     fi 


      
##########################
##########################
##########################
NOPRIMERO=`echo ${#PRIMERO[@]}`
printf "${MAG}===================================${NC}\n"
for ((hh=1;hh<=($NOPRIMERO); hh++));do
 PRIM=${PRIMERO[$hh]}
 SECO=${SEGUNDO[$hh]}
 OUTP=${OUTPUT[$hh]}
 #printf ' %s\t%s\t%s \n' "$PRIM " "$SECO"  "$OUTP"
 printf "[${GREEN}$hh${NC}]"
 printf '%s\t%s\n' "$PRIM " "$SECO" 
done 
printf "${MAG}===================================${NC}\n"
printf "\t choose one set of FILES(1-$NOPRIMERO):  "
read RESPUESTA

echo $RESPUESTA 
if [ -z $RESPUESTA ];then 
 StopMe "choose one set of FILES:  (1 - $NOPRIMERO )"
fi

FILE1=${PRIMERO[$RESPUESTA]}
FILE2=${SEGUNDO[$RESPUESTA]}  
SALID=${OUTPUT[$RESPUESTA]}

######
###### PARANOIA JL 
 if [ ! -e $FILE1 ];then 
  StopMe "There isnt FILE: $FILE1\n"
 fi 
 if [ ! -e $FILE2 ];then 
  StopMe "There isnt FILE: $FILE2\n"
 fi 


NR1=`awk 'END{print NR}' $FILE1`
NR2=`awk 'END{print NR}' $FILE2`
NF1=`awk 'END{print NF}' $FILE1`
NF2=`awk 'END{print NF}' $FILE2`

printf "\t${MAG}===================================${NC}\n"
printf "\t $FILE1   [$NR1]  [$NF1]\n"
printf "\t $FILE2   [$NR2]  [$NF2]\n"

printf "\t${MAG}===================================${NC}\n"

rm -f tmp 
rm -f tmp2 
rm -f tmp3 
rm -f tmp4 

awk '{print $1, $2, $3}' $FILE1 > tmp
awk '{print $2,$3}' $FILE2 > tmp2
paste tmp tmp2 > tmp3
awk '{print $1, $2+$4, $3+$5}' tmp3 > tmp4
awk '{print $1, $2, $3, sqrt($2*$2+$3*$3)}' tmp4 > $SALID 

 if [ -e $SALID ];then 
  printf "\n"
  printf "\t${GREEN}Output${NC}: $SALID \n"
  printf "\n"
  printf "\tIt has 4 columns\n"
  printf "\teV, Re, Im, Abs \n"
 else 
  StopMe "no file produced: $SALID"
 fi 
rm -f tmp 
rm -f tmp2 
rm -f tmp3 
rm -f tmp4 

printf "\t${GREEN}I found the end Ok${NC}\n"
printf "\n"
exit 127
#StopMe "${GREEN}I found the end Ok${NC}"
