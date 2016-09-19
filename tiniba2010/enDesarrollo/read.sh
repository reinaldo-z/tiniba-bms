#!/bin/bash 
#  1 de Febrero 2007 by jl at 18:19 HRS 
function block () {
local l
local b=0

read line
while [ "$line" ]; do
case "$line" in
kpt*) b=$((b+1))
echo "beginning of block $b"
l=1 ;;
*)  a=1 #echo "line $l of block $b"
l=$((l+1))
 echo $line
esac
read line
done
}
i=0
j=0
cat $1 | while read line; do
    
    #echo "$i line : $line"
    if [[ $line =~ .*kpt.* ]];then
       echo "$i line : $line"
     else 
     block
     fi 
    #   A=0
    #else 
    #   let "j=j+1"
    #   #echo $j
    #   #p[$j]=$line
    #   A=1
    #fi

    #if [ $A == "4" ];then
    #let "i=i+1"
    #fi 
    #echo $i
done
