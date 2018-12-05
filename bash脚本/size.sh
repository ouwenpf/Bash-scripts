#!/bin/sh
################################
#nginx，apache访问流量统计
################################
traffic() {
[ ! -f $1 ]&&{ 
	echo "No such file $1"
	exit
}
sum=0
for size in `cat $1|awk '{print $10}'`
do
	expr $size + 1 &>/dev/null
	[ $? -ne 0 ] && continue
	((sum+=size))
done  
echo "$1总流量为：`echo $sum|awk '{printf "%.2f\n", $1/1024 }'`M"
}


for n in $@

do
	traffic $n
done



