#!/bin/bash
#
[ $# -ne 3 ] && echo "Usage $0:请输入三个参数，第一个参数为0(表示当天)格式如：20180101，后面两个参数为日志格式如：201801010000" && exit

if [ -z "$1" -o "$1" !=  "0" ];then
	logdir="/data/www/loginfo/Logs/$1"
else
	logdir="/data/www/loginfo/Logs/$(date  +%Y%m%d)"
fi

[ ! -f ${logdir}/log.txt ] && exit || > $logdir/analysi_time.log


a=$2
b=$3

list=`grep 'GAME.*ReConn'  $logdir/log.txt|sort -t '-'  -k1rn|awk  -F '"' '$1>"'$a'" && $1<"'$b'" {print $4}'|awk '{a[$1]++}END{for(i in a)print i,a[i]}'|sort -t " " -k2rn|awk   '{OFS="-";print $1,$2}'`

for i in $list
do
	UUID=`echo $i|awk -F '-' '{print $1}'`
	title=`echo $i|awk  '{print $1}'`
	echo "================$title==================" >> $logdir/analysi_time.log
	grep "GAME.*ReConn"  $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID"|awk -F '--'   '$1>"'$a'" && $1<"'$b'" {print $0}'|sort -t '-' -k1rn >> $logdir/analysi_time.log 
	grep "HALL.*First" $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID"  >>  $logdir/analysi_time.log
	grep "GAME.*First" $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID"  >>  $logdir/analysi_time.log
	#grep "GAME.*$UUID" $logdir/log.txt  >> $logdir/analysi_time.log
	echo "" >>  $logdir/analysi_time.log
done

