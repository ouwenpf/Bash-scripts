#########################################################################
# File Name: check_ip.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月22日 星期二 10时43分10秒
#########################################################################
#!/bin/bash
. /etc/init.d/functions 
NET="192.168.140."
function check_ip(){
    ping -w 1 -c 1 ${NET}${ip} &>/dev/null
    return $?
}
for ip in {128..129}
do
        action "${NET}${ip}"   check_ip 
done
