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



echo "start:`date +%Y%m%d%H%M%S`"
mysqldump --login-path=3306 --master-data=2 --single-transaction -A|gzip >game_all.`date +%Y%m%d`.sql.gz

backup(){
        dbname=`mysql --login-path=3306 -e 'show databases;'|egrep -v 'Database|information_schema|mysql|performance_schema'`
        for i in $dbname
        do
                mysqldump --login-path=3306 --master-data=2 --single-transaction -B $i|gzip > $i.`date +%Y%m%d`.sql.gz
        done
}

echo "stop:`date +%Y%m%d%H%M%S`"