#!/bin/sh
function IP(){
	
	echo "$1"|egrep -q "\b^([1-9]{2,3}\.)([0-9]{1,3}\.){2}([0-9]{1,3}{1})\b"
	[ $? -ne 0 ] && {
			echo "请输入正确的IP"
			exit
			}
	num1=`echo "$1"|awk -F "." '{print $1}'`
	num2=`echo "$1"|awk -F "." '{print $2}'`
	num3=`echo "$1"|awk -F "." '{print $3}'`
	num4=`echo "$1"|awk -F "." '{print $4}'`
	if [ $num1 -gt 255 -o $num2 -gt 255 -o $num3 -gt 255 -o $num4 -gt 255 ]
	 then
		echo "输入正确的IP"
		exit
	fi		

}

IP $1
