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
function select(){























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
echo sdfdsf

}

#types             kl=(["DGFD"]="GDFG" ["FDGDFG"]="DGFDGFD")
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
echo "non";
return 0;
}

function insertnormal(){

typeset -l str="$*";
typeset -a typesnames
typesnames["number"]=1;
typesnames["string"]=2;
typesnames["non"]=99;
#names
typeset tname=`echo $str | cut -f1 -d" " `;
typeset -l names=(`awk -F: '{
    
   print $1;
    }
' $currworkdb/$tname.meta`);

#type
typeset -l types=(`awk -F: '{
    
   print $2;
    }
' $currworkdb/$tname.meta`);


typeset -l pkeys=(`awk '{
    
   print $1;
    }
' $currworkdb/$tname.table`);


#echo "BOD"$str;
typeset body=`echo $str | cut -f2- -d" " `;
body=`delcha "$body" "{"`
body=`delcha "$body" "}"`
echo "BOD"$body;
body=(`echo $body | awk -F, '{
    
    i=1;
    while(i<=NF){
    split($i,a,":");
    print a[2];
    i++;
    }
    
    }
    END{
        print $(i-1);
    }'`);
for pk in ${pkeys[*]}
do

if [ ${body[0]} =  $pk   ]
then
return 4;
fi

done;
typeset -i cntr=0;
for elems in ${body[*]}
do

typeset -l testresult=`isoftype $elems` 
typeset -l tempo=${types[$cntr]};
#echo $testresult$elems
if [ ${typesnames["$testresult"]} -gt ${typesnames[$tempo] }  ]
then
#echo $testresult"5arag"${types[$cntr]}"LOL"$cntr
return 4;
fi
(( cntr=cntr+1 ));
done;

if [ ${#body[*]} -ne  ${#types[*]}  ]
then
return 4;
fi

#echo ${body[*]} >>$currworkdb/$tname.table
#echo "BA7"


}
function insertvalues(){

echo"lessa"

}
function insert(){
typeset -l str="$*";
typeset -A arrlocalinstr
arrlocalinstr["normal"]="insertnormal"
arrlocalinstr["values"]="create-db"
typeset tname=`echo $str | cut -f1 -d" " `

typeset -l instructionpart=`echo $str | grep values -o `
if [ -z "$instructionpart"   ]
then
instructionpart="normal"
fi
echo $instructionpart
${arrlocalinstr["$instructionpart"]}  $str;
#echo "BACK" $?;


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
arrinstr["insert"]="insert"
#str="            ceate       table     {      id:  number,   kek:  string,mg:  number,  sss:string ,a:pk}"
#"            create       Database    SATIMA"
#"insert tname (a,b,c,d,s) "
#"delete table x"
#"delete from tablename where msd=a";
#insert tname {a,b,c,d,s}
#select * from tname where x and d
str="$*"
#str=`clearbeg "$str" " "  `;
#echo "STRING " $str;

ord1=`echo $str | cut -f1 -d" " `
echo "ORDER" $ord1;
body=`echo $str | cut -f2- -d" " `
echo "Body" $body;
#echo "SENT " ${arrinstr[$ord1]}
${arrinstr[$ord1]} $body;
echo "TPTP";
#echo "HAwt bod"$body;
echo "TPTP";
#order=`strfrom "$str" "{"`
#supord=`delcha "$order" " "`
#echo "TPTP";
#supord=`delcha "$supord" "{"`
meta=`delcha "$supord" "}"`
#echo "SUP"$meta;
echo "TPTP";
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
    echo "TPTP";
for typer in ${c[*]};
do
#echo "TPTP";
exit ;
#echo $typer;
#echo "Here's what you gonna do '"
done
#echo $str;






