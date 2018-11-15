#!/bin/bash
#

logfile="/home/data/logs/nginx"

if [ -f $logfile/WR_pay.log ];then
	>$logfile/log_tj/complex.log
	echo '====支付请求IP============支付ID====================体现请求IP=================登录请求IP==================移动设备端==============='>> $logfile/log_tj/complex.log


a=(`egrep 'GET /pay/v1.alipay/index.html' $logfile/WR_pay.log|awk -F  '["]'  '{print $8}'|awk -F ',' '{print $1}'|awk 'OFS="-" {a[$1]++}END{for(i in a)print a[i],i}'|sort -rn|head -20`)


b=(`egrep 'GET /pay/v1.alipay/index.html' $logfile/WR_pay.log|egrep  -o  '(%2522uid%2522:.*7D)|(%22uid%22:.*})|(psub=1&uid=.*&version)'|sed 's/psub=/%/g'|sed 's/=/%/g'|awk -F '[%:}&]' '{print $4}'|awk 'OFS="-" {a[$1]++}END{for(i in a)print a[i],i}'|sort -rn|head -20`)

c=(`egrep -v 'GET /test.html' $logfile/WR_tx.log|awk -F '"' '{print $8}'|awk -F ',' '{print $1}'|awk 'OFS="-" {a[$1]++}END{for(i in a)print a[i],i}'|sort -rn|head -20`)

d=(`egrep  'GET /routertwo/serverlist2' $logfile/WR_game_api.log|awk -F '"' '{print $8}'|awk -F ',' '{print $1}'|awk 'OFS="-" {a[$1]++}END{for(i in a)print a[i],i}'|sort -rn|head -20`)

e=(`egrep 'GET /pay/v1.alipay/index.html' $logfile/WR_pay.log|grep -o  '(.*)'|awk -F 'AppleWebKit' '{print $1}'|sed  's/ u;//gi'|sed 's/zh-cn;//g'|sed 's/cpu//gi'|sed 's/like//gi'|sed 's/;//g'|awk -F 'Build' '{print $1}'|awk  -F '[ ]+' 'OFS="-" {print $2,$3,$4,$5}'|awk 'OFS="-" {a[$0]++}END{for(i in a)print a[i],i}'|sort -rn|head -20`)

for i in `seq 0 $[${#a[*]}-1]` 
do
        echo -e "${a[$i]} ${b[$i]} ${c[$i]} ${d[$i]} ${e[$i]}" |awk '{printf "%-25s%-25s%-25s%-25s%-25s\n",$1,$2,$3,$4,$5}' >> $logfile/log_tj/complex.log
        

done

less $logfile/log_tj/complex.log
else 
	echo "分析的文件不存在"
    exit

fi
