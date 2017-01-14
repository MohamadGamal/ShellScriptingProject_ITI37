#!/bin/bash


#call all stuff
#files:
#query processor
#meta processor
#
 typeset -a errorslist=("YOU DIED" "hey");
echo  ${errorslist[1]};

function isoftype {

typeset -A alltypes;
alltypes["number"]="^[[:digit:]]+$";
alltypes["string"]="^[[:alnum:]]+$";
typeset -a typenames=("number" "string");
for type in ${typenames[*]}
do
if [[ $1 =~ ${alltypes[$type]} ]]
then
echo $type
return 1;

fi

done;
return 0




}


a=`isoftype 1234` 
if [ -n "$a"  ]
then
echo "A IS "$a
else
echo "fashal"
fi



