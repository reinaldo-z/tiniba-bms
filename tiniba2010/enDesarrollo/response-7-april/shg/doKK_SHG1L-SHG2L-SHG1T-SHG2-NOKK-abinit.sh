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

WHERE=`dirname $0`
HOST=`hostname`
       KKxeon="$WHERE/kk.xeon"
       KKitan="$WHERE/kk.itan"
       KKquad="$WHERE/kk.quad"

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
    printf " smNOKK  NOKK \n"
    printf "\t example:\n"
    printf "\t`dirname $0`/${GREEN}`basename $0`${NC} both smNOKK \n"
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


   if [ "$2" != "NOKK" ];then   
    if [ "$2" != "smNOKK" ];then   
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
     #FILES="shg1_Length*"
     FILES="shg1_Length*NOKK*"
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
     #FILES="shg2_Length*"
     FILES="shg2_Length*NOKK*"
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
     #FILES="shg1_Tran*"
     FILES="shg1_Tran*NOKK*"
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
     #FILES="shg2_Tran*"
     FILES="shg2_Tran*NOKK*"
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
  # for ((hh=1;hh<=($NOSHG1L); hh++));do
  
   if [[ "$HOST" == "node"* ]]; then
      KKRUN=$KKxeon   
    fi
       if [[ "$HOST" == "itanium"* ]]; then
        KKRUN=$KKitan
       fi

       if [[ "$HOST" == "quad"* ]]; then
         KKRUN=$KKquad
      fi
  if [ ! -e $KKRUN ];then
  printf "\t THere isnt file: $KKRUN\n"
  printf "\t Stopping rigth now...\n"
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
  FUERA="shg1L_shg2L_shg1T_shg2T$APELLIDO1"-abinit
 
                              printf "\t $BBRR \n" 
                             printf "\t$stringZ\n"
                             printf "\t$stringSHG2L\n"
                             printf "\t  $stringSHG1T\n"
                             printf "\t  $stringSHG2T\n"
                        ## i can find why use this stringZ 
                            NstringSHG1L=`echo ${stringZ/NOKK/YESKK}`
                            NstringSHG2L=`echo ${stringSHG2L/NOKK/YESKK}`
                            NstringSHG1T=`echo ${stringSHG1T/NOKK/YESKK}` 
                            NstringSHG2T=`echo ${stringSHG2T/NOKK/YESKK}` 
                          sleep 5
                        echo $NstringSHG1L
                        echo $NstringSHG2L
                        echo $NstringSHG1T
                        echo $NstringSHG2T
printf "Doing KK $stringZ  $NstringSHG1L\n"
$KKRUN 1 $stringZ  $NstringSHG1L > KK_1    
printf "Doing KK $stringSHG2L $NstringSHG2L\n"               
$KKRUN 1 $stringSHG2L $NstringSHG2L >KK_2
printf "Doing KK $stringSHG1T $NstringSHG1T\n"               
$KKRUN 1 $stringSHG1T $NstringSHG1T >KK_3
printf "Doing KK $stringSHG2T $NstringSHG2T\n"               
$KKRUN 1 $stringSHG2T $NstringSHG2T >KK_4

            #$KKRUN 1  $stringZ  $NstringSHG1L >KKSALIDA1
              
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
  
