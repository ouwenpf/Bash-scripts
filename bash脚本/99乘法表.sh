#!/bin/sh

number=$1
array1=(`eval echo {1..${number:-9}}`)
array2=(`eval echo {1..${number:-9}}`)

USAGE(){
expr $number + 1 &>/dev/null
[ $? -ne 0  ]&& exit
[ $number -le 0  ]&& exit
}

count(){	 	
for i in ${array1[*]}
do
	for n  in ${array2[*]}
	do
		if [ $n -le $i ]
		then
			echo -ne "$i*$n=`echo $(($i*$n))` "
		fi
	done
	echo  ""
done
}

main(){
	USAGE
	count	
}


main 
