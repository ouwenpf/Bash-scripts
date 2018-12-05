#!/bin/sh
times_table(){
number=${1:-9}
expr $number + 1 &>/dev/null
[ $? -ne 0 ]&& exit
for ((i=1;i<=$number;i++))
do
	for ((j=1;j<=i;j++))
	do
		echo  -n "$i*$j=$((i*j))  "
	done
	echo "" 
done
}

main(){
	times_table $1 
}

main $1 
