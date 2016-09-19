#!/bin/bash
exec< $1
echo "data in $1 will be processed now."
input=[]
i=0
while read line
do
        input[$i]=$line;
        let "i = i + 1"
done
 
echo {$input[*]}
 
MA=`echo ${#input[@]}`
#echo $NOMACHINESpmn
 for ((hh=0;hh<=($MA-1); hh++));do
     let "kk=hh+1"
     echo $hh ${input[$hh]}
 done

exit 0












MACHINESpmn=(`cat  setUpAbinit_gaas.in` )
NOMACHINESpmn=`echo ${#MACHINESpmn[@]}`
echo $NOMACHINESpmn
cat $1 | while read line; do
    echo "$i    $line"
     let "i++"
    #if [[ $line =~ .*kpt.* ]];then
    #   echo "$i line : $line"
    # else   
    #  A=0
    #   let "j=j+1"
    #   echo $j
       perro[1]="$line"
       A=1
   # fi
done 
echo ${MACHINESpmn[@]}

MA=`echo ${#perro[@]}`
echo $MA

exit 0




declare -a AR



#ii=0
cat $1 | while read line; do
   echo "$ii line : $line"
    let "ii++";
    AR[$ii]=$line;
    done

MA=`echo ${#AR[@]}`
echo $MA
 for ((hh=0;hh<=($MA-1); hh++));do
     let "kk=hh+1"
     echo $hh ${AR[$hh]}
 done
