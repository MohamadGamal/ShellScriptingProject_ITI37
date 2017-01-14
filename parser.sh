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
function create-db(){
if [ ! -d  $workingstr/$1  ] 
then
mkdir $workingstr/$1
#$eh $?;
else
return 2;
fi
}
function create-table(){
typeset -l str="$*";
typeset tname=`echo $str | cut -f1 -d" " `
typeset tbod=`echo $str | cut -f2- -d" " `

typeset -A alltypes;
alltypes["number"]=1;
alltypes["string"]=1;
tbod=`delcha "$tbod" " "`
tbod=`delcha "$tbod" "{"`
tbod=`delcha "$tbod" "}"`
echo "NAME :" $tbod" BODY"$tname
coltypes=(`echo $tbod | awk -F, '{
    
    i=1;
    while(i<=NF){
    split($i,a,":");
    print a[2];
    i++;
    }
    
    }
'`)
#echo ${alltypes[*]}
for typecol in ${coltypes[*]}
   do
   
            
            if [ ! ${alltypes[$typecol] } ]  
            then
                return 3;
                
            fi
   
    done
   
#echo "WASAL";

if [ -d $currworkdb -a ! -f  $currworkdb/$tname.table  ]
then
touch $currworkdb/$tname.table
#$eh $?;
touch $currworkdb/$tname.meta

echo $tbod | sed 's/,/\n/g' > $currworkdb/$tname.meta
#$eh $?;
touch $currworkdb/$tname.log
#$eh $?;
else
return 3;
fi


}
function create(){
typeset -A arrlocalinstr
arrlocalinstr["table"]="create-table"
arrlocalinstr["database"]="create-db"
typeset -l str="$*";

instructionpart=`echo $str | cut -f1 -d" " `
typeset -l body=`echo $str | cut -f2- -d" " `
echo "instruction: "$instructionpart" body "$body
${arrlocalinstr[$instructionpart]}  $body;
}

function delete(){

echo "ININININININININ";
}
#echo ${str:i:1}

typeset -A arrinstr
typeset -l str
typeset -lrx corestr="."
typeset -lrx workingstr=$corestr"/dbmsroot"
typeset -lx currworkdb=$corestr"/dbmsroot/amr"
typeset isusingdb=0
ls $workingstr;
arrinstr["create"]="create"
arrinstr["delete"]="delete"

#str="            ceate       table     {      id:  number,   kek:  string,mg:  number,  sss:string ,a:pk}"
#"            create       Database    SATIMA"
#"insert (a,b,c,d,s) into tname  "
#"delete table x"
#"delete from tablename where msd=a";


str="$*"
#str=`clearbeg "$str" " "  `;
#echo "STRING " $str;

ord1=`echo $str | cut -f1 -d" " `
echo "ORDER" $ord1;
body=`echo $str | cut -f2- -d" " `
echo "Body" $body;
#echo "SENT " ${arrinstr[$ord1]}
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
exit ;
#echo $typer;
#echo "Here's what you gonna do '"
done
#echo $str;






