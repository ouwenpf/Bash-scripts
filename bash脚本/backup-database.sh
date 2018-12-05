#!/bin/sh
MYUSER="root"
MYPASSWD="123456"
PORT=${1:-3306}
SOCK="/data/$PORT/mysql.sock"
MYCMD="mysql -u$MYUSER -p$MYPASSWD -S $SOCK -e"
MYDUMP="mysqldump -u$MYUSER -p$MYPASSWD -S $SOCK"
PATHBK="/data/backup/$(date +%F -d -1day)/$PORT"
FILENAME=`basename $0`

PROCESS1=`ps -ef|egrep "${PORT}|^$"|egrep -v "grep|^$|$FILENAME"|wc -l`
[ $PROCESS1 -ne 2 ]&& exit
[ ! -d $PATHBK ]&& mkdir $PATHBK -p

for dbname in `$MYCMD "show databases;"|egrep -v "Database|_schema"`
do
	$MYDUMP -B -F --events -R -x $dbname|gzip >$PATHBK/${dbname}_$(date +%F -d -1day).sql.gz
	if [ $? -eq 0 ];then
		echo  "$dbname is ok" >>$PATHBK/${dbname}_$(date +%F -d -1day).log
	fi
done

