#!/bin/bash
#
logdir="/data/www/loginfo/Logs/$(date  +%Y%m%d -d '-1 day')"

[ ! -f ${logdir}/log.txt ] && exit || > $logdir/analysi.log

list=`grep 'GAME.*ReConn'  $logdir/log.txt|sort -t '-'  -k1rn|awk  -F '"' '{print $4}'|awk '{a[$1]++}END{for(i in a)print i,a[i]}'|sort -t " " -k2rn|awk   '{OFS="-";print $1,$2}'`
for i in $list
do
	UUID=`echo $i|awk -F '-' '{print $1}'`
	title=`echo $i|awk  '{print $1}'`
	echo "================$title==================" >> $logdir/analysi.log
	grep "GAME.*ReConn" $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID" >> $logdir/analysi.log 
	grep "HALL.*First" $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID"  >>  $logdir/analysi.log
	grep "GAME.*First" $logdir/log.txt|sort -t '-'  -k1rn|grep "$UUID"  >>  $logdir/analysi.log
	echo "" >>  $logdir/analysi.log
done

