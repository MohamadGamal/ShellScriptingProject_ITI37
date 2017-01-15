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




function delete
{

#update Tname
#delete tname where a==f 

str="tname where id==1223  "

typeset tname=`echo $str | cut -f1 -d" " `;


typeset condition=`echo $str | cut -f4- -d" " `;

#2





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



