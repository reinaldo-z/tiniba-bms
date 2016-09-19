#!/bin/bash 

 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 NC='\e[0m' # No Color
 declare -a GFILES
 function StopMe {
      if [ -z "$1" ];then
        printf "\t${RED}Stoping right now... ${NC}\n"
        exit 127
      else
         printf "\t$1 \n"
         printf "\t${RED}Stoping right now... ${NC}\n"
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

##############################
##############################
##############################

  BASEDIR=`dirname $PWD`
    LOCAL=`basename $PWD`
     CASO=`basename $BASEDIR`
   
 if [ $LOCAL != "whichCubesToDivide" ];then
 StopMe "Just I can run in a dir called: ${BLUE}whichCubesToDivide${NC}"
 else
  printf "\t is your case: ${BLUE}$CASO ${NC} (YES=ENTER, NO=ctrl C)"
  read -p ""
 fi 

 
    FILES="kpoints.reciprocal*"
      ii=0
      for file in $FILES; do
       let "ii=ii+1"
        if [ ! -e "$file" ];then       # Check if file exists
         printf  "\t there are no files with *.g \n"
         printf  "\t Stoping Right now .......\n"
         exit 1
        fi
        GFILES[$ii]=$file
      done 
     
      NOGFILES=`echo ${#GFILES[@]}`
      printf "\t${BLUE}==========================${NC}\n"
      for ((jj=1;jj<=($NOGFILES); jj++));do
          isThereFile ${GFILES[$jj]} ## because im paranoid 
          NKPT=`wc ${GFILES[$jj]} | awk '{print $1}'` 
          printf "\t[${GREEN}$jj${NC}] ${GFILES[$jj]}  [ $NKPT ] kp\n"
     done
     ###############
      printf "\tChoose one file: \n"
      read FILECHO
       if [ -z $FILECHO ];then
        StopMe "You have to choose one file\n"
       fi
       INPUTFILE=${GFILES[$FILECHO]}
       printf "\t$INPUTFILE\n"
      
        if [ "$INPUTFILE" == "kpoints.reciprocal" ];then
         printf "\t ${GREEN}You choose no pASS ${NC}\n"
                KpointsWien2k=kpoints.wien2k
            KpointsReciprocal=kpoints.reciprocal
             KpointsCartesian=kpoints.cartesian
                   Tetrahedra=tetrahedra     
                   Symmetries=Symmetries.Cartesian
               
        else
        PASS=`echo ${INPUTFILE:(-1)}`
        printf "\t ${GREEN}You choose paass: $PASS ${NC}\n"
        KpointsWien2k=kpoints.wien2k"$PASS"
        KpointsReciprocal=kpoints.reciprocal"$PASS"
          KpointsCartesian=kpoints.cartesian"$PASS"
                Tetrahedra=tetrahedra"$PASS"     
                Symmetries=Symmetries.Cartesian  ### this dont change ja 
        fi

  
      
        
        isThereFile $KpointsReciprocal
        isThereFile $KpointsCartesian
        isThereFile $Tetrahedra
        isThereFile $Symmetries


        NKPT=`wc $KpointsReciprocal | awk '{print $1}'` 

          if [ -e $KpointsWien2k ];then 
           NKPTW=`wc $KpointsWien2k | awk '{print $1}'` 
           let "NKPTW=NKPTW-1"
           cp  $KpointsWien2k kpoints.wien2k"_"$NKPTW
           printf "\t cp $KpointsWien2k ==> kpoints.wien2k"_"$NKPTW\n"
          fi 



        
        cp  $KpointsReciprocal $CASO.klist_$NKPT
        cp  $KpointsCartesian  $CASO.kcartesian_$NKPT
        cp  $Tetrahedra  tetrahedra_$NKPT
        cp  $Symmetries  Symmetries.Cartesian_$NKPT
        printf "\t cp  $KpointsReciprocal   $CASO.klist_$NKPT\n"
        printf "\t cp   $KpointsCartesian   $CASO.kcartesian_$NKPT\n"
        printf "\t cp          $Tetrahedra   tetrahedra_$NKPT \n"
        printf "\t cp $Symmetries   Symmetries.Cartesian_$NKPT\n"


      if [ -d ../symmetries ];then
        printf "\t${GREEN}Copy to:${NC} ../${BLUE}symmetries${NC}\n" 
        cp  $CASO.kcartesian_$NKPT ../symmetries
        cp  tetrahedra_$NKPT  ../symmetries
        cp  Symmetries.Cartesian_$NKPT  ../symmetries   
        cp  $CASO.klist_$NKPT ../$CASO.klist_$NKPT
        printf "\t cp      $CASO.kcartesian_$NKPT ../${BLUE}symmetries${NC} \n"
        printf "\t cp                tetrahedra_$NKPT ../${BLUE}symmetries${NC}\n"
        printf "\t cp     Symmetries.Cartesian_$NKPT  ../${BLUE}symmetries${NC}\n"
        printf "\t cp           $CASO.klist_$NKPT ../$CASO.klist_$NKPT\n"
      fi 
     

      StopMe "I found the end"



  ## jl 
