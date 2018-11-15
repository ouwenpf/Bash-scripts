#!/bin/bash
#
logfile="/home/data/logs/nginx/WR_pay.log"
paylog="pay.log"
paylist="paylist.log"
>$paylist

for id in `egrep  'GET /Pay/Notice/jinbi.php\?order_code'  $logfile|awk  -F '='  '{print $2}'|awk '{print $1}'`
do
	for i in `seq 1 10`
	do
	if [ `egrep -B $i "$id"  $logfile|egrep 'GET /pay/v1.alipay/index.html'|wc -l` -eq `egrep "$id"  $logfile|wc -l` ];then
		egrep -B $i "$id"  $logfile|egrep 'GET /pay/v1.alipay/index.html' >> $paylog
		egrep   "$id"  $logfile >> $paylog
	break
	fi

	done

done


if [ -f $paylog ];then
	a=(`egrep  'GET /Pay/Notice/jinbi.php\?order_code'  $paylog|awk  -F '='  '{print $2}'|awk '{print $1}'`)	
	b=(`egrep 'GET /pay/v1.alipay/index.html' $paylog|egrep  -o  '(%2522uid%2522:.*7D)|(%22uid%22:.*})|(psub=1&uid=.*&version)'|sed 's/psub=/%/g'|sed 's/=/%/g'|awk -F '[%:}&]' '{print $4}'`)
	c=(`egrep 'GET /pay/v1.alipay/index.html' $paylog|grep -o  '(.*)'|awk -F 'AppleWebKit' '{print $1}'|sed  's/ u;//gi'|sed 's/zh-cn;//g'|sed 's/cpu//gi'|sed 's/like//gi'|sed 's/;//g'|awk -F 'Build' '{print $1}'|awk  -F '[ ]+' 'OFS="-" {print $2,$3,$4,$5}'`)

else
	exit
fi

echo -e "支付成功$[${#a[*]}]笔\n========支付ID===========用户ID=========================移动设备端============"  >> $paylist

for i in `seq 0 $[${#a[*]}-1]`
do
	echo -e "${a[$i]} ${b[$i]} ${c[$i]}"|awk '{printf "%-25s%-25s%-25s\n",$1,$2,$3}' >> $paylist
	/bin/rm -f $paylog 
done




