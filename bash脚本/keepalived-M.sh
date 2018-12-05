#!/bin/sh
Ip(){
if [ `ip  add|grep "192.168.140.25/24"|wc -l` -eq 0 ]
 then
	return 0
 else
	return 1 
fi
}
Process(){
FILENAME=`basename $0`
if [ `ps -ef|grep nginx|egrep -v "grep|^$|$FILENAME"|wc -l` -lt 2 ]
 then
        return 0
 else
	return 1
fi
}

while true
do
if Process;then
	Ip||{
	ip addr del 192.168.140.25/24 dev eth0
	}
else 
	Ip &&{		
	ip addr add 192.168.140.25/24 dev eth0
	}
fi

done 

