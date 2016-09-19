#!/bin/bash 
#  1 de Febrero 2007 by jl at 18:19 HRS 
function block () {
local l
local b=0

read line
echo gato

while [ "$line" ]; do
echo perro
case "$line" in

  kpt*) b=$((b+1))
  echo "========================beginning of block $b $l"
l=1 ;; 
   *)a=1  #echo "line $l"
    l=$((l+1))
 newl=`echo $line | tr "\n" " "`
 #$newl
echo $newl
# k="${k}$newl"

esac

#if [ $b -gt 0 ];then
#echo perro
#fi

read line
done
}
#######
#######
i=0
j=0
cat $1 | while read line; do

block

done
