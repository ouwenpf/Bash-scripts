#!/bin/bash
#

logdir='/application/data/mysql/mysql3308/logs/'

while true
do
if ls ${logdir}mysql-bin.[^a-z]* &> /dev/null;then
	lastfile=`ls -rt ${logdir}mysql-bin.[^a-z]*|tail -1`	
else
	lastfile=mysql-bin.000001
fi


if  nc -z -v -n 127.0.0.1 3306 &>/dev/null;then
#	if [ `ps axu|grep 'stop-never-slave-server-id=1'|grep -v grep|wc -l` -eq 0 ];then				
		mysqlbinlog -R --raw --host='127.0.0.1' --port=3306 --user='repl' --password='123456' --stop-never --stop-never-slave-server-id=1 $lastfile  -r $logdir &>/dev/null &
#	fi
fi 

sleep 2

done
