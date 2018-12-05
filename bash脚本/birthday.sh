#!/bin/sh
Year=`date +%F|awk -F "-" '{print $1}'`
Birthday="$Year-$1"
Today=`date +%F`
NextYear=$((Year+1))
number2=`date -d "$Today" +%j`

if [ $# -eq 0 ];then
	echo "USAGE{mm-dd}"
	exit
fi 

date -d "$Birthday" +%j &>/dev/null
if [ $? -ne 0 ]
 then
	echo "请输入正确的时间"
	exit
fi

number1=`date -d "$Birthday" +%j`
if [ $number1 -gt $number2 ]
 then 
	#Day=$((${number1}-${number2}))
	#Day=(expr ${number1} - ${number2})
	expr ${number1} - ${number2}
elif [ $number1 -eq $number2 ]
 then
	echo "今天是你的生日哦，祝你生日快"
 else
	number3=`date -d "$Year-12-31" +%j` 
	number4=`date -d "$NextYear-$1" +%j`
	#Day=$(($number3-$number2+$number4))
	expr $number3 - $number2 + $number4 
fi
