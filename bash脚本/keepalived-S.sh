#!/bin/sh
Check(){
if [ `nmap  192.168.140.50  -p 80|grep open|wc -l` -eq 0 ]
then
	return 0
else
	return 1
fi
}
Ip(){
if [ `ip  add|grep "192.168.140.25/24"|wc -l` -eq 0 ]
 then   
        return 0
 else   
        return 1
fi
}

while true
do
if Check;then
	Ip &&{
        ip addr add 192.168.140.25/24 dev eth0
        } 
else
        Ip||{
        ip addr del 192.168.140.25/24 dev eth0
        }
	
fi

done 




