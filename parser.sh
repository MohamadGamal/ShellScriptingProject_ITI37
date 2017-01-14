#!/bin/bash


#call all stuff
#files:
#query processor
#meta processor
#
function clearbeg(){
str=$1
typeset i=0;
while [ "${str:i:${#2}}" = "$2" ]
do
((i += 1));
done;

echo ${str:(i)}

}
echo ${str:i:1}
str="            create    table {msd:string,mg:number,sss:string}"

#str=`clearbeg "$str" " "  `;
ord1=`echo $str | cut -f3 -d" " `

echo $ord1
#echo $str;






