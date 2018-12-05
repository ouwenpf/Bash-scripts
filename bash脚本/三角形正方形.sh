#!/bin/sh

number=${1:-10}

USAGE(){
expr $number + 1 &>/dev/null
[ $? -ne 0  ]&& exit
[ $number -le 0  ]&& exit
}

count(){	 	
	for ((i=0;i<number;i++ ))
	do
		for ((n=0;n<=i;n++))
		do
			echo -n "& "
		done

		echo  ""
	done
}

main(){
	USAGE
	count	
}


main 
