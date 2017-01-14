#!/bin/bash


#call all stuff
#files:
#query processor
#meta processor
#
function clearbeg(){
typeset str=$1
typeset i=0;
while [ "${str:i:${#2}}" = "$2" ]
do
((i += ${#2}));
done;

echo ${str:(i)}

}

function strfrom(){
typeset str=$1
typeset i=0;
while [ "${str:i:${#2}}" != "$2" ]
do
((i += ${#2}));
done;

echo ${str:(i)}

}

function delcha(){
typeset str=$1
typeset strtemp="";
typeset -i i=0;
while [ $i -lt ${#str}  ]
do
if [ "${str:i:${#2}}" != "$2" ]
then
strtemp=$strtemp${str:i:${#2}};
fi
((i += ${#2}));
done;
echo $strtemp

}
function delcha(){
typeset str=$1
typeset strtemp="";
typeset -i i=0;
while [ $i -lt ${#str}  ]
do
if [ "${str:i:${#2}}" != "$2" ]
then
strtemp=$strtemp${str:i:${#2}};
fi
((i += ${#2}));
done;
echo $strtemp

}
#echo ${str:i:1}
str="            create       table     {         msd:  string,mg:  number,  sss:string ,a:pk}"

#str=`clearbeg "$str" " "  `;
echo $str


ord1=`echo $str | cut -f3 -d" " `
order=`strfrom "$str" "{"`
supord=`delcha "$order" " "`
supord=`delcha "$supord" "{"`
meta=`delcha "$supord" "}"`
echo "SUP"$meta;
c=(`echo $meta | awk -F, '{
    
    i=1;
    while(i<=NF){
    split($i,a,":");
    print a[2];
    i++;
    }
    
    }
    END{
        print $(i-1);
    }'`)
for typer in ${c[*]};
do
echo $typer;
echo "Here's what you gonna do '"
done
#echo $str;






