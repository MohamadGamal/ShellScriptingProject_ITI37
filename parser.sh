#!/bin/bash


#call all stuff
#files:
#query processor
#meta processor
#


function ErrorHandler
{
    typeset -a errorslist=("SUCCESSFULLY COMPLETED" "Operation not allowed" "Already exists" "table does not exist");
   # echo "IN" $1;
if [ $1 -eq 0  ] 
then
echo ${errorslist[ $1 ]};
return 0;
return 0;
else
echo ${errorslist[ $1 ]};
return $1;
fi
}

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



############################################################################################
######UPDATE

function update
{

#update Tname
#update tname a=3,b=2 where a==f 
#"tname mg=7,kek='top' where a==f "
typeset -l str="$*"

typeset tname=`echo $str | cut -f1 -d" " `;

typeset changeble=`echo $str | cut -f2 -d" " `;
#echo $changeble;
typeset condition=`echo $str | cut -f4- -d" " `;

typeset  names=(`awk -F: '{

   print $1;
    }
' $currworkdb/$tname.meta `);
typeset  types=(`awk -F: '{
    
   print $2;
    }
' $currworkdb/$tname.meta `);
typeset  pkis=${names[0]};
#echo $changeble
typeset keys=(`echo $changeble | awk -F, '{
    
    i=1;
    while(i<=NF){
    split($i,a,"=");
    print a[1];
    i++;
    }
    
    }
   '`)
typeset values=(`echo $changeble | awk -F, '{
    
    i=1;
    while(i<=NF){
    split($i,a,"=");
    print a[1];
    i++;
    }
    
    }
   '`)

if [ -z "$condition" ]
then 
condition=1;
fi;

pk=${names[0]}
for i in ${keys[*]}
do

typeset ticky=0;


for j in ${names[*]}
do
if [ $i = $j ]
then
ticky=1;

fi
done




if [ $ticky -eq 0 ]
then
return 4;
fi


done
#2


#echo "HERE";
typeset haspk=0;

for j in ${keys[*]}
do
#echo $j $pkis
if [ $pkis = $j ]
then

haspk=1;

fi
done

#echo "HASPK"$haspk;




typeset -A namesnew;
typeset cntr=1;
for j in ${names[*]}
do

namesnew[$j]=$cntr;
((cntr=cntr+1));
done

#echo $condition
condition=`echo $condition | sed -e 's/ and /\&\&/g' -e 's/ or /||/g'`;

#echo $condition
#echo "NAMES IS" ${names[*]};

namestyp=`echo ${names[*]} | sed s/" "/,/g  `

changeble=`echo $changeble | sed s/%/$namestyp/g `
#echo "PRINTI" $printable
for j in ${names[*]}
do
c=" s/$j/\$${namesnew[$j]}/g"
#echo $c
condition=`echo $condition | sed $c  `;
changeble=`echo $changeble | sed $c  `;
done
#echo "COND" $condition 
#printable=`echo "$printable "| sed 's/,/"-------"/g'  `;
#echo
condition=`echo $condition | sed "s/'/\"/g"  `
condition=`delcha "$condition" " "`
changeble=`delcha "$changeble" " "`
changeble=`echo $changeble | sed s/,/\;/g `
changeble=`echo $changeble | sed "s/'/\"/g"  `
#echo "cond" $condition "print"$printable
tbd=" awk  {if($condition){print\$0;};}   $currworkdb/$tname.table";
cmd=" awk {if($condition){$changeble;};print\$0;} $currworkdb/$tname.table";
#echo $tbd
tbf=`$tbd | wc -l `;
#echo $tbf
if [ $tbf -gt 1 -a $haspk -eq 1 ]
then
return 4;
else
#echo $cmd
$cmd >$currworkdb/$tname.table.temp
cat $currworkdb/$tname.table.temp > $currworkdb/$tname.table
rm $currworkdb/$tname.table.temp
fi
#$tbd

}

############################################################################################
######delete






function delete
{
typeset -l str="$*"
#update Tname
#delete tname where a==f 


typeset tname=`echo $str | cut -f2 -d" " `;

#echo $str
typeset condition=`echo $str | cut -f4- -d" " `;

#2

typeset  names=(`awk -F: '{
    
   print $1;
    }
' $currworkdb/$tname.meta `);
typeset -A namesnew;
typeset cntr=1;
for j in ${names[*]}
do

namesnew[$j]=$cntr;
((cntr=cntr+1));
done

if [ -z "$condition" ]
then 
condition=1;
fi;

condition=`echo $condition | sed -e 's/ and /\&\&/g' -e 's/ or /||/g'`;

#echo "NAMES IS" ${names[*]};

namestyp=`echo ${names[*]} | sed s/" "/,/g  `

#echo "PRINTI" $printable
for j in ${names[*]}
do
c=" s/$j/\$${namesnew[$j]}/g"
#echo $c
condition=`echo $condition | sed $c  `;

done
#echo "COND" $condition 
#printable=`echo "$printable "| sed 's/,/"-------"/g'  `;
condition=`echo $condition | sed "s/'/\"/g"  `
condition=`delcha "$condition" " "`

#echo "cond" $condition "print"$printable
tbd=" awk  {if($condition){print\$0;};}    $currworkdb/$tname.table";
cmd=" awk {if(!($condition)){print\$0;};}  $currworkdb/$tname.table";
#echo $cmd;



$cmd >$currworkdb/$tname.table.temp
cat $currworkdb/$tname.table.temp > $currworkdb/$tname.table
rm $currworkdb/$tname.table.temp
#$tbd




}

























############################################################################################
######SELECT



function selectfn
{


typeset -l str="$*";

typeset tname=`echo $str | cut -f3 -d" " `;

typeset printable=`echo $str | cut -f1 -d" " `;

typeset condition=`echo $str | cut -f5- -d" " `;
#echo $condition
if [ -z "$condition" ]
then 
condition=1;
fi;


typeset  names=(`awk -F: '{
    
   print $1;
    }
' $currworkdb/$tname.meta `);
typeset -A namesnew;
typeset cntr=1;
for j in ${names[*]}
do

namesnew[$j]=$cntr;
((cntr=cntr+1));
done



condition=`echo $condition | sed -e 's/ and /\&\&/g' -e 's/ or /||/g'`;

#echo "NAMES IS" ${names[*]};

typeset namestyp=`echo ${names[*]} | sed s/" "/,/g  `

printable=`echo $printable | sed s/%/$namestyp/g `
typeset printabletemp=$printable;
#echo "PRINTI" $printable
for j in ${names[*]}
do
typeset c=" s/$j/\$${namesnew[$j]}/g"
#echo $c
condition=`echo $condition | sed $c  `;
printable=`echo $printable | sed $c  `;
done
#echo "COND" $condition 
#printable=`echo "$printable "| sed 's/,/"-------"/g'  `;
condition=`echo $condition | sed "s/'/\"/g"  `
condition=`delcha "$condition" " "`
printable=`delcha "$printable" " "`
#echo "cond" $condition "print"$printable
typeset cmd=" awk {if($condition){print$printable;};} $currworkdb/$tname.table";
#echo $cmd
echo $printabletemp | sed s/,/" "/g  
$cmd




}



############################################################################################
######INSERT
function insertnormal(){

typeset -l str="$*";
typeset  -A typesnamesa

typesnamesa["non"]=99
typesnamesa["number"]=1
typesnamesa["string"]=2
#names
typeset tname=`echo $str | cut -f1 -d" " `;
typeset  names=(`awk -F: '{
    
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
#echo "BOD"$body;

body=(`echo $body | sed 's/,/ /g'`) 


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
typeset -l tempo=${types["$cntr"]};
#echo "HONGA !!" ${typesnamesa["number"] }" d" ${typesnamesa["$testresult"]}"dgg"$tempo"OTHER"$testresult;
if [    ${typesnamesa["$testresult"]} -gt  ${typesnamesa["$tempo"] }  ]
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

echo ${body[*]} >>$currworkdb/$tname.table
#echo "BA7"


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
#echo $instructionpart
${arrlocalinstr["$instructionpart"]}  $str;
#echo "BACK" $?;


}

function use {
if [ -d  $workingstr/$1   ]
then
    currworkdb=$workingstr/$1
else
return 5;
fi


}
#########################################################################################################
#echo ${str:i:1}
#"            create       Database    SATIMA"
#"insert tname (a,b,c,d,s) "
#"delete table x"
#"delete from tablename where msd=a";
#insert tname {a,b,c,d,s}
#select % from tname where x==3 and d<4
#Example : select % from alpha where id\<121
#update tname a=3,b=2 where a==f 
typeset -A arrinstr
typeset -l str
typeset -lrx corestr="."
typeset -lrx workingstr=$corestr"/dbmsroot"
typeset -lx currworkdb=$workingstr"/amr"
typeset isusingdb=0
ls $workingstr;
arrinstr["create"]="create"
arrinstr["delete"]="delete"
arrinstr["insert"]="insert"
arrinstr["select"]="selectfn"
arrinstr["update"]="update"
arrinstr["use"]="use"


while ((1))
do
read str
ord1=`echo $str | cut -f1 -d" " `
echo "ORDER" $ord1;
body=`echo $str | cut -f2- -d" " `
${arrinstr[$ord1]} $body;

done












#str="            ceate       table     {      id:  number,   kek:  string,mg:  number,  sss:string ,a:pk}"
#"            create       Database    SATIMA"
#"insert tname (a,b,c,d,s) "
#"delete table x"
#"delete from tablename where msd=a";
#insert tname {a,b,c,d,s}
#select % from tname where x==3 and d<4
#Example : select % from alpha where id\<121
#update tname a=3,b=2 where a==f 

str="$*"
#str=`clearbeg "$str" " "  `;
#echo "STRING " $str;


#echo "Body" $body;
#echo "SENT " ${arrinstr[$ord1]}
${arrinstr[$ord1]} $body;
#echo "TPTP";
#echo "HAwt bod"$body;
#echo "TPTP";
#order=`strfrom "$str" "{"`
#supord=`delcha "$order" " "`
#echo "TPTP";
#supord=`delcha "$supord" "{"`
meta=`delcha "$supord" "}"`
#echo "SUP"$meta;
#echo "TPTP";
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
  #  echo "TPTP";
for typer in ${c[*]};
do
#echo "TPTP";
exit ;
#echo $typer;
#echo "Here's what you gonna do '"
done
#echo $str;






