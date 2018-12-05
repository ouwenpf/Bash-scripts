#!/bin/sh
. /etc/init.d/functions
PORT=$1
FILENAME=`basename $0`
PROCESS1=`ps -ef|egrep "${PORT:-3306}|^$"|egrep -v "grep|^$|$FILENAME"|wc -l`
USAGE(){
	echo "USAGE:$0 {3306|3307|3308-}"
	exit
}


check_server(){
	if [ $PROCESS1 -ne 2 ] 
	then
		action "MySQL is not Running ${PORT:-3306}"  /bin/false
	else
		action "MySQL is  Running ${PORT:-3306}"  /bin/true
	fi	

}


case ${PORT:-3306} in

 3306)
	check_server
	;;
 3307)
        check_server
        ;;
 3308)
        check_server
        ;;
    *)
	USAGE

esac

