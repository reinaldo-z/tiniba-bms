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
    printf "  [${MAG}option${NC}${MAG}2${NC}]"
    printf "  [${MAG}option${NC}${MAG}3${NC}]\n"
    printf "\t[${MAG}option${NC}${MAG}1${NC}] = "
    printf " both \n"
    printf "\t[${MAG}option${NC}${MAG}2${NC}] = "
    printf " NOKK  \n"
    printf "\t[${MAG}option${NC}${MAG}3${NC}] = "
    printf " cutEnergy  (despues the este valor voy a poner ceros\n"
    printf "\t example:\n"
    printf "\t`dirname $0`/${GREEN}`basename $0`${NC} both NOKK 6.0\n"
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

   QUES="NOKK"

  # if [ "$2" != "kk" ];then   
    if [ "$2" != "$QUES" ];then   
      howto
    fi  
  # fi 
    if [ -z "$3" ];then   
      howto
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
               if [[ "${ISSM[12]}" != "cutUp"* ]]; then          
                if [ "$KK" == "${ISSM[4]}" ];then
                 let "ii=ii+1"
                  #echo $file 
                 SHG1L[$ii]=$file
                fi
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
              if [[ "${ISSM[12]}" != "cutUp"* ]]; then          
               if [ "$KK" == "${ISSM[4]}" ];then
                 #echo $file
                let "ii=ii+1" 
                SHG2L[$ii]=$file
               fi
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
                if [[ "${ISSM[12]}" != "cutUp"* ]]; then          
              if [ "$KK" == "${ISSM[4]}" ];then
                #echo $file
               let "ii=ii+1" 
               SHG1T[$ii]=$file
              fi
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
              if [[ "${ISSM[12]}" != "cutUp"* ]]; then            
               if [ "$KK" == "${ISSM[4]}" ];then
               ##echo $file
               let "ii=ii+1" 
               SHG2T[$ii]=$file
               fi
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
FUERA="shg1L_shg2L_shg1T_shg2T$APELLIDO1"-abinit""
                          #     echo "#!/bin/bash" > paste_$BBRR.sh
                          #     echo "## $FECHA " >> paste_$BBRR.sh
                          #     echo "## $PWD " >> paste_$BBRR.sh
                          #     echo "## USER = $USER " >> paste_$BBRR.sh
                          #     echo "## begin code ##" >> paste_$BBRR.sh
                          #     echo "rm -f tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7" >> paste_$BBRR.sh   
                          #     echo "FILE1=\"$stringZ\"" >> paste_$BBRR.sh
                          #     echo "FILE2=\"$stringSHG2L\"" >> paste_$BBRR.sh
                          #     echo "FILE3=\"$stringSHG1T\"" >> paste_$BBRR.sh
                          #     echo "FILE4=\"$stringSHG2T\"" >> paste_$BBRR.sh
                               
                          #     echo "OUTPUT=\"$FUERA\"" >> paste_$BBRR.sh
                               #FUERA="shg1L_shg2L_shg1T_shg2T$APELLIDO1"
 #echo "awk '{print \$1,\$2,\$3}' \$FILE1 > tmp1" >>paste_$BBRR.sh  
 #echo "awk '{print \$2,\$3}' \$FILE2 > tmp2" >>paste_$BBRR.sh  
 #echo "awk '{print \$2,\$3}' \$FILE3 > tmp3" >>paste_$BBRR.sh  
 #echo "awk '{print \$2,\$3}' \$FILE4 > tmp4" >>paste_$BBRR.sh  
 #echo "paste tmp1 tmp2 tmp3 tmp4 > \$OUTPUT" >>paste_$BBRR.sh   
 #echo "printf \"\\tOutput: \$OUTPUT\\n\"" >>paste_$BBRR.sh
 #echo "NCOL=\`awk 'END{print NF}' \$OUTPUT\`" >>paste_$BBRR.sh  
 #echo "printf \"\\tNumber of Columnas: \$NCOL\\n\"" >>paste_$BBRR.sh
        printf "\t=====================\n"
     
             wh=$3
              cutName=`echo ${wh/./-}`
                                                echo $cutName
                             printf "\tthis is  $BBRR \n" 
                            NCOL=`awk 'END{print NF}' $stringZ`
                             printf "\t$stringZ [$NCOL columns]\n"
                             NCOL=`awk 'END{print NF}' $stringSHG2L`
                             printf "\t$stringSHG2L [$NCOL columns]\n"
                             NCOL=`awk 'END{print NF}' $stringSHG1T`
                             printf "\t  $stringSHG1T [$NCOL columns]\n"
                             NCOL=`awk 'END{print NF}' $stringSHG2T`
                             printf "\t  $stringSHG2T [$NCOL columns]\n"

 SALIDA1="$stringZ"_cutUp$cutName"eV"
 awk '{ if ($1 <= '$3') {print $1, $2} else {print $1,0.0E} }' $stringZ > $SALIDA1                        
 SALIDA2="$stringSHG2L"_cutUp$cutName"eV"
 awk '{ if ($1 <= '$3') {print $1, $2} else {print $1,0.0E} }' $stringSHG2L > $SALIDA2                        

SALIDA3="$stringSHG1T"_cutUp$cutName"eV"
 awk '{ if ($1 <= '$3') {print $1, $2} else {print $1,0.0E} }' $stringSHG1T > $SALIDA3                        

SALIDA4="$stringSHG2T"_cutUp$cutName"eV"
 awk '{ if ($1 <= '$3') {print $1, $2} else {print $1,0.0E} }' $stringSHG2T > $SALIDA4                        
 
 printf "\t============= \n"
 printf "\t  $SALIDA1\n"
 printf "\t  $SALIDA2\n"
 printf "\t  $SALIDA3\n"
 printf "\t  $SALIDA4\n"

                                   
                             ESCRIBE=1 
                             fi  
                       
                           fi 
                         done 
                     fi 
  
               done
          
         fi  
        done ## NOSHG2L)
    done ## $NOSHG1L

