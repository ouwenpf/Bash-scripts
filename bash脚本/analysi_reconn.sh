#!/bin/bash
#
#logfile="/home/data/www/WR_game_api/code/framework/Cache/routertwo/$(date +%F  -d '-1 day').log"
#analysi_log="/home/data/www/WR_game_api/code/framework/Cache/routertwo/analysi-$(date +%F  -d '-1 day').log"
logfile="/data/www/loginfo/Logs/$(date  +%Y%m%d)"	

if [ -f $logfile/log.txt ];then
	> $logfile/analysi_reconn.log
	echo '===============重连============================下发===========================用户登录============' >> $logfile/analysi_reconn.log
	a=(`egrep '(GAME|HALL).*(ReConn|First)' $logfile/log.txt|egrep  -v '(GAME|HALL)@119.188.197.89'|awk -F '"' '{a[$2]++}END{for(i in a)print a[i],i}'|awk 'OFS="-"{print $1,$2}'|sort -rn|head -20`)
	c=(`curl -s  https://yy.nb100g.com/Logs/$(date +%Y%m%d  -d '-1 day')/ip.html |awk -F '[ ,]'  '{print $3}'|awk '{a[$1]++}END{for(i in a)print a[i],i}'|awk 'OFS="-"{print $1,$2}'|sort -rn|head -20`)
	b=(`curl -s  https://yy.nb100g.com/Logs/$(date +%Y%m%d  -d '-1 day')/ip.html|awk -F ',' 'NF==3{print $2}'|awk '{a[$1]++}END{for(i in a)print a[i],i}'|awk 'OFS="-"{print $1,$2}'|grep -v 'ip:119.188.197.89'|sort -rn|head -20`)
else 
	echo "分析的文件不存在"
	exit 
fi



for i in `seq 0 $[${#a[*]}-1]` 
do
	echo -e "${a[$i]} ${b[$i]} ${c[$i]}"|awk '{printf "%-40s%-30s%-10s\n",$1,$2,$3}' >> $logfile/analysi_reconn.log
	

done
