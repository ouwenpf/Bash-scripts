#!/bin/sh
MYUSER="root"
MYPASSWD="123456"
PORT=${1:-3306}
SOCK="/data/$PORT/mysql.sock"
MYCMD="mysql -u$MYUSER -p$MYPASSWD -S $SOCK -e"
MYDUMP="mysqldump -u$MYUSER -p$MYPASSWD -S $SOCK"
FILENAME=`basename $0`

PROCESS1=`ps -ef|egrep "${PORT}|^$"|egrep -v "grep|^$|$FILENAME"|wc -l`
[ $PROCESS1 -ne 2 ]&& exit

for dbname in `$MYCMD "show databases;"|egrep -v "Database|_schema"`
do
	for tabname in 	`$MYCMD "show tables from $dbname;"|egrep -v "Tables_in"`
	do	
		PATHBK="/data/backup/tables/${PORT}_$(date +%F -d -1day)/${dbname}"
		[ ! -d $PATHBK ]&& mkdir $PATHBK -p
		$MYDUMP   --events  -x $dbname $tabname|gzip >$PATHBK/${dbname}_${tabname}.sql.gz
		if [ $? -eq 0 ];then
		echo  "$tabname is ok" >>$PATHBK/${dbname}.log
		fi
	done
done


