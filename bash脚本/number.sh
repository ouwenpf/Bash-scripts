#!/bin/sh

function Int(){
	expr $1 + 1 &>/dev/null
	if [ $? -ne 0 ]
        then
                echo  请输入大于等于0的整数
		exit
	fi

	echo $1|egrep "\b^[0-9][0-9]{0,}\b"
	if [ $? -ne 0 ]
	then
		echo  请输入大于等于0的整数
	
	elif [ $1 -lt 0 ]
	then
		echo 请输入大于等于0的整数
	fi
	
		


}

Int $1

