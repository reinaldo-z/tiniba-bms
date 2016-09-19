#!/bin/bash
## FUNCTION MAKE A REFINE "refine in a coloquial way is defined as: to eat"
## AUTHOR : J.L. Cabellos and Bernardo S. Mendoza
## FINISHED AT : APRIL 22 at 13:24 
 
 RED='\e[0;31m'
 BLUE='\e[0;34m'
 BLU='\e[1;34m'
 CYAN='\e[0;36m'
 GREEN='\e[0;32m'
 GRE='\e[1;32m'
 YELLOW='\e[1;33m'
 NC='\e[0m' # No Color

 
      WHERE=`dirname $0`
        IBZ="$WHERE/SRC_ibz/ibzNew/ibz.quad"  
    BASEDIR=`dirname $PWD`
       CASO=`basename $PWD`
     DIRSCF=$CASO'_scf'
      CHECK="$CASO"_check"/$CASO.out"
SETUPABINIT=setUpAbinit_"$CASO".in
 WFSCFLOCAL=$CASO'o_DS1_WFK'
  WFSCFREMOTE=$CASO'i_DS1_WFK'
   WF2DATASET=$CASO'o_DS2_WFK'

 declare -a malla
 declare -a kpoint
 declare -a ARCHIVOS 
 declare -a EIGEN
 declare -a NKEIGENname
 declare -a NKEIGENcoun

 declare -a ENERGYS
 declare -a NKENERGYS
 declare -a WHATKLIST



ARCHIVOS[1]="cubes0"
ARCHIVOS[2]="grid0"
ARCHIVOS[3]="kpoints.cartesian0"
ARCHIVOS[4]="kpoints.map0"
ARCHIVOS[5]="kpoints.reciprocal0"
ARCHIVOS[6]="tetrahedra0"


NOARCHIVOS=`echo ${#ARCHIVOS[@]}`

#########################
#########################
#########################



function StopMe {
 if [ -z "$1" ];then
   printf "\t${RED}Stoping right now...${NC}\n\t`dirname $0`/${GREEN}`basename $0`${NC}\n"
   exit 127
 else 
   printf "\t${RED}Stoping right now...${NC}\n\t`dirname $0`/${GREEN}`basename $0`${NC}\n"
   printf "\t$1\n\n"
   exit 127
 fi 
    }

function howto {
printf "\tUsage:\n"
printf "\t`dirname $0`/${GREEN}`basename $0`${NC}"
printf " abinit first\n"
printf "\t`dirname $0`/${GREEN}`basename $0`${NC}"
printf " abinit refine noscissors\n"
printf "\t`dirname $0`/${GREEN}`basename $0`${NC}"
printf " abinit refine scissors\n"
  printf "\n"
  StopMe "I need input Args"
 }
function checkinput {
   echo $4
   #if [  "$4" == "0" ] || [ $4 -gt 3 ] ;then
   if [  "$4" == "0" ];then
      howto 
   fi
   if [ "$1" !=  "abinit" ];then 
      howto 
   fi 
   if [ "$2" !=  "refine" ];then
     if [ "$2" !=  "first" ];then
      howto 
     fi 
   fi 
   if [  "$4" == "3" ];then
     if [ "$3" !=  "scissors" ];then  
       if [ "$3" !=  "noscissors" ];then  
        howto
       fi 
     fi 
   fi
} 

function check0 {
  if [ -e cubes0 ];then 
   printf "\tcubes0              [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: cubes0"
  fi 
  if [ -e grid0 ];then 
   printf "\tgrid0               [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: grid0"
  fi 
  if [ -e kpoints.cartesian0 ];then 
   printf "\tkpoints.cartesian0  [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: kpoints.cartesian0"
  fi 
   if [ -e kpoints.map0 ];then 
   printf "\tkpoints.map0        [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: kpoints.cartesian0"
  fi 
  if [ -e kpoints.reciprocal0 ];then 
   printf "\tkpoints.reciprocal0 [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: kpoints.reciprocal0"
  fi  
  if [ -e tetrahedra0 ];then 
   printf "\ttetrahedra0         [${GREEN}ok${NC}]\n"
  else 
   printf "\t`dirname $0`/`basename $0` abinit first\n"
   StopMe "There isnt FILE: tetrahedra0"
  fi  

}
#########################
#########################HERE BEGIN THE CODE 
#########################
   checkinput $1 $2 $3 $# 
#############################################################
 rm -f tmpX
    grep nband2 setUpAbinit_$CASO.in > tmpX
    Nmax=`head -1 tmpX | awk '{print $2}'`
    rm -f tmpX

    rm -f tmpA tmpB tmpC tmpD
    grep -n 'occ ' $CHECK > tmpA
    iocc=`awk -F: '{print $1}' tmpA`
    grep -n 'prtvol' $CHECK > tmpB
    iprtvol=`awk -F: '{print $1}' tmpB`
    awk 'NR=='$iocc',NR=='$iprtvol'' $CHECK > tmpC
    grep -o 1.000 tmpC > tmpD

    Nvf=`wc tmpD | awk '{print $2}'`
    
      if [ $Nvf == '0' ];then
	grep -o 2.000 tmpC > tmpD
        Nvf=`wc tmpD | awk '{print $2}'`
      fi


    Nct=`expr $Nmax - $Nvf`
    



    rm -f tmpA tmpB tmpC tmpD

    
    printf "\t  valencia bands = $Nvf\n"
    printf "\tconduction bands = $Nct\n"
    printf "\t     Total bands = $Nmax\n"

#exit 127







#############################################################
   TIJERAS=$3
   if [ -z $TIJERAS ];then 
    printf  "\t${RED}WARRNING:${NC}scissors=empty\n" 
   fi 

   if [ ! -e $IBZ ];then 
    printf "\t${RED}HOLD ON: !${NC} there isnt FILE: $IBZ \n"
    StopMe "do you know where it is?  jl"
   fi 
   ##<><><><><><><>
   ##<><><><><><><>
   if [ ! -e symmetries/pvectors ];then
      StopMe "Because there isnt file : ${BLUE}symmetries${NC}/pvectors"
   fi
   ##<><><><><><><>
   ##<><><><><><><>
   if [ ! -e symmetries/sym.d ];then
      StopMe "Because there isnt file : ${BLUE}symmetries${NC}/sym.d"
   fi
   ##<><><><><><><>
   ##<><><><><><><>
   if [ ! -d whichCubesToDivide ];then 
     printf "\tMaking ${BLUE}whichCubesToDivide${NC}\n"
     mkdir whichCubesToDivide
   else 
     printf "\t${BLUE}whichCubesToDivide${NC}    [${GREEN}ok${NC}]\n"
   fi    
   ##<><><><><><>
   ##<><><><><><>
    printf "\n"
    printf "\tEnergias sin tijeras \n"
    printf "\t==============================\n"
    FILES1="eigen_*" 
        ii=0
           for file in $FILES1; do
            # echo $file
            otro=$file"_ORIGINAL"

        if [ ! -e $file"_ORIGINAL" ];then
            uta=11 ## uta madre esto es nasty    
        else 
        
        
             if [ -e $file ];then 
               let "ii=ii+1"
               NKbyNAME=`echo $file | tr '_' ' ' | awk '{print $2 }'`  
               NKbyCOUN=`wc $file | awk '{print $1}'`
               ABSNK=$NKbyCOUN
                
               if [ "$ABSNK" == "$NKbyNAME" ];then
                EIGEN[$ii]=$file
                NKEIGEN[$ii]=$ABSNK
                WHATKLIST[$ii]=$CASO.klist_$ABSNK
               printf "\t%s\t%s \n" $file ${WHATKLIST[$ii]}
                #printf "$file ${WHATKLIST[$ii]} ok\n"
                #printf "[$ABSNK]  $file ${WHATKLIST[$ii]} ok\n"
               else 
               echo perroote
               StopMe "$ABSNK"
               
               fi 
             fi
         fi   
           done 
   printf "\n"
  
  


   printf "\tEnergias con tijeras \n"
   printf "\t==============================\n"
   ##<><><><><><><>
   ##<><><><><><><>
    FILES1="energys.d_*" 
        ii=0
           for file in $FILES1; do
             if [ -e $file ];then 
               let "ii=ii+1"
               NKbyNAME=`echo $file | tr '_' ' ' | awk '{print $2 }'`
               NKbyCOUN=`wc $file | awk '{print $1}'`
               #let "ABSNK = NKbyCOUN-3"
               echo $NKbyCOUN $file
               ABSNK=$NKbyCOUN
              if [ "$ABSNK" == "$NKbyNAME" ];then
                ENERGYS[$ii]=$file
                NKENERGYS[$ii]=$ABSNK
                printf "\t%s \n" $file 
                #printf " $file \n"
               else 
               StopMe "pero $ABSNK $NKbyNAME"
               fi 
             fi 
           done 
    printf "\n"
    printf "\tque pex  \n"
   # printf "\t==============================\n"


  cd whichCubesToDivide
  
  

   

  if [ "$1" == "abinit" ] && [ "$2" == "refine" ];then

      #printf "\tremember esta comentada erasing  energys.d \n" 
      rm -f energys.d        
      printf "\t=====================\n" 
      check0
      printf "\t=====================\n" 
      ### make sure erase energys.d 
       
      
       printf "\n"       
       FILES2="kpoints.reciprocal*" 
        ii=0
           for file in $FILES2; do
             if [ -e $file ];then 
               let "ii=ii+1"
               pkn=`wc $file | awk '{print $1}'`
                wc $file
               printf "\t $file  perr  [$pkn]\n"
               kpoint[$ii]=$file
               echo $file
             fi 
           done

         
       #################
     
       FILEkpoint=${kpoint[$ii]}
       if [ -e $FILEkpoint ];then
        NKPTkpoints=`wc $FILEkpoint  | awk '{print $1}'`
       else 
        StopMe "no file $FILEkpoint" 
       fi 
       ### IM GOING TO DO A CICLE OVER ALL POSIBLE EIGEN ENERGYS 
       
      if [ "$NOEIGEN" == 0 ];then
       printf "\t no files eigen \n"      
       StopMe "if there  isnt files eigen_ supose no hay files energys_\n"
      fi 
    NOEIGEN=`echo ${#EIGEN[@]}`
  NONKEIGEN=`echo ${#NKEIGEN[@]}`
  NOENERGYS=`echo ${#ENERGYS[@]}`
NONKENERGYS=`echo ${#NKENERGYS[@]}`
   for ((hh=1;hh<=($NONKEIGEN); hh++));do
     NKE=${NKEIGEN[$hh]}
     echo whathell
     echo $NKE $NKPTkpoints perroteote
     if [ "$NKE" == "$NKPTkpoints" ];then   
       SINTIJERAS=${EIGEN[$hh]} 
       CONTIJERAS=${ENERGYS[$hh]}

        echo con $SINTIJERAS
        echo sin $CONTIJERAS
        printf "\t ${NKEIGEN[$hh]} $NKPTkpoints\n"
        printf "\t  $hh ${EIGEN[$hh]}      NO SCISSORS ENERGY \n"
        printf "\t ${ENERGYS[$hh]}   SCISSORS ENERGY  \n"
        printf "que onda nada "
     fi 
   done 

   echo que onda tijeras $CONTIJERAS
     

   if [ -z $CONTIJERAS ];then
    StopMe "There isnt file: energys_ perro"
   fi 
    
 if [ $TIJERAS == "scissors" ];then 
  FILEAUSAR=$CONTIJERAS
  QUETI="TIJERAS"
 fi 
 if [ $TIJERAS == "noscissors" ];then 
  FILEAUSAR=$SINTIJERAS
  QUETI=" NOTIJERAS"
 fi  
  ## you dont have to check here this file exist one dir back 
  printf "\n"
  printf "\t==========================\n"
  printf "\t USING:  \n"
  printf "\t ${GREEN}$FILEAUSAR ${NC} "
  printf "\t ${GREEN}$QUETI${NC} \n"
  printf "\t for generate the next set of kpoints\n"
  printf "\t==========================\n"
  cp -v ../$FILEAUSAR energys.d
  printf "\t==========================\n"
 

  if [ -e energys.d ];then   
   NKK=`wc energys.d | awk '{print $1}'`
   #let "NKen = NKK-3"
   NKen=$NKK
  else 
   Stop "no file energys.d"
  fi 
 

  if [ $NKen == $NKPTkpoints ];then
  printf "\tK points from energys.d           ${GREEN}$NKen${NC}\n"
  printf "\tK points from $FILEkpoint ${GREEN}$NKPTkpoints${NC}\n" 
  else 
  StopMe "No agree NKP energys.d=$NKen  $NKPTkpoints"
  fi 

  echo "$NKK" > fort.35
  echo "$Nvf" >> fort.35 
  echo "$Nct" >> fort.35

   
   
  printf "\t==========================\n"
  printf "\t you are going to do a refine \n"
  
  lchr=`expr substr $FILEkpoint ${#FILEkpoint} 1`
  printf "\t Please enter the pass"
  printf " number you want to process \n"
  printf "\t RESPUESTA=${GREEN}$lchr${NC} \n"  

      

  if [ `hostname` == "master" ];then
  REFINE=$WHERE/SRC_ibz/Grids/refine.xeon
  fi 
  if [ `hostname` == "quad02" ];then
  REFINE=$WHERE/SRC_ibz/Grids/refine.quad
  fi   
  if [ `hostname` == "itanium01" ];then
  REFINE=$WHERE/SRC_ibz/Grids/refine.itan
  fi 

  if [ ! -e $REFINE ];then 
    printf "\t${RED}HOLD ON: !${NC} there isnt FILE: $REFINE \n"
    StopMe "do you know where it is?  jl"
  fi 
  
  $REFINE
   
 

     

       rm -f buscaAtras 

      printf "\t==========================\n"
      printf " Im looking for a FILE: $WFSCFLOCAL in:\n"
      printf " $PWD \n"
      if [ ! -e "$WFSCFLOCAL" ];then        
        printf " ${RED}There isnt FILE:${NC}\n"
        printf " $PWD/$WFSCFLOCAL\n" 
        printf "\t=========================\n"
        touch buscaAtras
      else 
        printf "  There is FILE: \n"
        printf " \t ${GREEN}$WFSCFLOCAL${NC}\n"  
        printf "\t=========================\n"
        rm -f buscaAtras
      fi
       #printf "\t==========================\n"
       if [ -e buscaAtras ];then 
        printf " Im looking for a FILE: $WFSCFLOCAL in:\n"  
        printf " $OLDPWD/$DIRSCF \n"
          if [ ! -e ../$DIRSCF/$WFSCFLOCAL ];then 
           printf " ${RED}There isnt FILE:${NC}in\n" 
           printf " $OLDPWD/$DIRSCF/$WFSCFLOCAL\n"
           printf "\t=========================\n"
           StopMe "I need this file in order to generete klist"
          else 
           printf " ${GREEN}There is FILE:${NC}\n"
           printf " $OLDPWD/$DIRSCF/${GREEN}$WFSCFLOCAL${NC}\n"  
           printf " ${GREEN}Right now copying ...${NC}\n"
           printf "\t=========================\n"
           cp -v $OLDPWD/$DIRSCF/$WFSCFLOCAL .
           
          fi 
       fi ## buscaAtras

      rm -f buscaAtras

   DIR=$PWD
   let "PASS=$lchr+1"
  
  printf "\t${GREEN} you are going to do: pass $PASS ${NC} \n"

  if [ `hostname` == "quad02" ];then
   $IBZ -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map -pass $PASS
  else  
   rsh quad02 "cd $DIR; $IBZ -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map -pass $PASS"  
  fi 


############# 
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
          
          NKPT=`wc ${GFILES[$jj]} | awk '{print $1}'`
          printf "\t[${GREEN}$jj${NC}] ${GFILES[$jj]}  [ $NKPT ] kp\n"
     done
     printf "\tChoose one file: \n"
      read FILECHO
       if [ -z $FILECHO ];then
        StopMe "You have to choose one file\n"
       fi
       INPUTFILE=${GFILES[$FILECHO]}
       printf "\t$INPUTFILE\n"
       PASZ=`echo ${INPUTFILE:(-1)}`
        printf "\t ${GREEN}You choose paass: $PASZ ${NC}\n"
        KpointsWien2k=kpoints.wien2k"$PASZ"
        KpointsReciprocal=kpoints.reciprocal"$PASZ"
          KpointsCartesian=kpoints.cartesian"$PASZ"
                Tetrahedra=tetrahedra"$PASZ"
                Symmetries=Symmetries.Cartesian  ### this dont change ja

 NKPT=`wc $KpointsReciprocal | awk '{print $1}'`
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

  echo $CASO.klist_$NKPT $QUETI $FILEAUSAR >> INFO.klist
  cp -f INFO.klist ../

  #$WHERE/whichCubes.sh
  fi ### abinit refine  
   
###############################33
###############################33
###############################33
###############################33
###############################33
###############################33


if [ "$1" == "abinit" ] && [ "$2" == "first" ];then
     printf "\tset grid:(I need the grid first time)\n"
       printf "\t Give me the value of the grid X Y Z : "
       read -r  gridxyz
       INDEX=1
       for GRI in $gridxyz;do
         malla[$INDEX]=$GRI
         let "INDEX+=1"
       done
        xxG=${malla[1]}
        yyG=${malla[2]}
        zzG=${malla[3]}
     if [ -z $xxG ];then
      xxG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid X = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid X = $xxG\n"
      #StopMe
     fi
     if [ -z $yyG ];then
      yyG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid Y = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Y = $yyG\n"
      #StopMe

     fi
     if [ -z $zzG ];then
      zzG=35
      printf "\t${RED}WARRNING: ${NC} the value of the grid Z = empty\n"
      printf "\t${GREEN}But taking the fault${NC}  grid Z = $zzG\n"
      #StopMe
     fi
     ##
       printf "\tMaking FILE: grid with: $xxG  $yyG $zzG\n"
      echo $xxG $yyG $zzG > grid

      rm -f buscaAtras 

      printf "\t==========================\n"
      printf " Im looking for a FILE: $WFSCFLOCAL in:\n"
      printf " $PWD \n"
      if [ ! -e "$WFSCFLOCAL" ];then        
        printf " ${RED}There isnt FILE:${NC}\n"
        printf " $PWD/$WFSCFLOCAL\n" 
        printf "\t=========================\n"
        touch buscaAtras
      else 
        printf " ${GREEN}There is FILE:${NC}\n"
        printf " ${GREEN}$WFSCFLOCAL${NC}\n"  
        printf "\t=========================\n"
        rm -f buscaAtras
      fi  
      ########### 
      #printf "\t==========================\n"
       if [ -e buscaAtras ];then 
        printf " Im looking for a FILE: $WFSCFLOCAL in:\n"  
        printf " $OLDPWD/$DIRSCF \n"
          if [ ! -e ../$DIRSCF/$WFSCFLOCAL ];then 
           printf " ${RED}There isnt FILE:${NC}in\n" 
           printf " $OLDPWD/$DIRSCF/$WFSCFLOCAL\n"
           printf "\t=========================\n"
           StopMe "I need this file in order to generete klist"
          else 
           printf " ${GREEN}There is FILE:${NC}\n"
           printf " $OLDPWD/$DIRSCF/${GREEN}$WFSCFLOCAL${NC}\n"  
           printf " ${GREEN}Right now copying ...${NC}\n"
           printf "\t=========================\n"
           cp -v $OLDPWD/$DIRSCF/$WFSCFLOCAL .
           
          fi 
       fi ## buscaAtras

      rm -f buscaAtras
       DIR=$PWD

if [ `hostname` == "quad02" ];then
 # cd $DIR 
$IBZ -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map
else
 rsh quad02 "cd $DIR; $IBZ -abinit -tetrahedra -cartesian -symmetries -reduced -grid -cubes -map"
fi

 $WHERE/whichCubes.sh
fi ## abinit first 

###############################33
###############################33
###############################33
###############################33
###############################33
###############################33
