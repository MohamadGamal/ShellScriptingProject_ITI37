#!/bin/bash


#call all stuff
#files:
#query processor
#meta processor
#
 typeset -a errorslist=("YOU DIED" "hey");
echo  ${errorslist[1]};

echo "SFDFDFDSF" "$*"
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




function update
{

#update Tname
#update tname a=3,b=2 where a==f 

str="tname mg=7,kek='top' where a==f "

typeset tname=`echo $str | cut -f1 -d" " `;

typeset changeble=`echo $str | cut -f2 -d" " `;
echo $changeble;
typeset condition=`echo $str | cut -f4 -d" " `;

typeset  names=(`awk -F: '{

   print $1;
    }
' /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.meta `);
typeset  types=(`awk -F: '{
    
   print $2;
    }
' /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.meta `);
typeset  pkis=${names[0]};
echo $changeble
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
echo $j $pkis
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


condition=`echo $condition | sed -e 's/AND/\&\&/g' -e 's/OR/||/g'`;

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
condition=`echo $condition | sed "s/'/\"/g"  `
condition=`delcha "$condition" " "`
changeble=`delcha "$changeble" " "`
changeble=`echo $changeble | sed s/,/\;/g `
changeble=`echo $changeble | sed "s/'/\"/g"  `
#echo "cond" $condition "print"$printable
tbd=" awk  {if($condition){print\$0;};}   /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table";
cmd=" awk {if($condition){$changeble;print\$0;};} /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table";
echo $tbd
tbf=`$tbd | wc -l `;
echo $tbf
if [ $tbf -gt 1 -a $haspk -eq 1 ]
then
echo "cant"
else
$cmd >/home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table.temp
cat /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table.temp > /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table
rm /home/Mgamal/git.work/BashDBMS/dbmsroot/amr/alpha.table.temp
fi
#$tbd




}




















update

a=`isoftype 1234` 
if [ -n "$a"  ]
then
echo "A IS "$a
else
echo "fashal"
fi



