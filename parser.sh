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
function create-db(){}
function create-table(){
if [ -d $1$2 -a ! -f  $1$2/$3  ] 
then
touch $1$2/$3.table
$eh $?;
touch $1$2/$3.meta
$eh $?;
touch $1$2/$3.log
$eh $?;
else
return 3;
fi


}
function create(){
typeset -A arrlocalinstr
arrlocalinstr["table"]="create-table"
arrlocalinstr["database"]="create-db"
echo "ININININININININ";
typeset body=$*
echo $body;
}
#echo ${str:i:1}
typeset -A arrinstr
typeset -l str
corestr="~/"
workingstr=""
arrinstr["create"]="create"
arrinstr["delete"]="delete"

str="            create       table     {      id:  number,   kek:  string,mg:  number,  sss:string ,a:pk}"
#"            create       Database    SATIMA"
#"insert (a,b,c,d,s) into tname  "
#"delete table x"
#"delete from tablename where msd=a";


str= $*
#str=`clearbeg "$str" " "  `;
echo $str;

ord1=`echo $str | cut -f3 -d" " `
body=`echo $str | cut -f2- -d" " `
${arrinstr[$ord1]} $body;
#echo "HAwt bod"$body;
order=`strfrom "$str" "{"`
supord=`delcha "$order" " "`
supord=`delcha "$supord" "{"`
meta=`delcha "$supord" "}"`
#echo "SUP"$meta;
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
ls
#echo $typer;
#echo "Here's what you gonna do '"
done
#echo $str;






