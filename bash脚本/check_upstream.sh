#!/bin/sh
File=`ls /application/nginx/conf/extra/upstream`
FileList=($File)
cd /application/nginx/conf/extra/upstream
[ -d $File ] && exit

for((i=0;i<${#FileList[*]};i++))
do
	iplist=`egrep "server"  ${FileList[i]}|awk -F "[ ;]+" '{print $3}'`
	for ip in  ${iplist}
	do
		stat=`curl -s $ip/status.html`
		if [ "$stat" == "OK" ]
		then	

			echo  -e "\E[32m${FileList[i]} $ip  up\E[0m"
		else
			echo  -e "\E[31;5m${FileList[i]} $ip down\E[0m"
		fi
	done
	

done
