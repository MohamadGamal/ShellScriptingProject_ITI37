#!/bin/bash
eh=ErrorHandler
function createDB
{
if [ ! -d  $1$2  ] 
then
mkdir $1$2
$eh $?;
else
return 2;
fi
}
function ErrorHandler
{
    typeset -a errorslist=("Operation not allowed" "Already exists" "table does not exist");
   # echo "IN" $1;
if [ $1 -eq 0  ] 
then
return 0;
else
echo ${errorslist[ (($1 - 1)) ]};
fi
}


typeset source="./"
#cd source;
typeset name="dbmsroot"
typeset workingsource
if [ ! -d  $source$name  ] 
then
mkdir $source$name 
fi
$eh $?;
workingsource=$source$name/
createDB $workingsource fd
createTable  $workingsource fd table1
$eh $?;



