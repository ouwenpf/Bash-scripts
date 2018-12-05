#########################################################################
# File Name: check.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月21日 星期一 10时22分29秒
#########################################################################
#!/bin/bash
. /etc/init.d/functions 
 array=("$@")
 for ((i=0;i<${#array[@]};i++))
do
    if [ "${array[i]:0:4}" != "http" -o $# -eq 0 ]
    then
       exit 
    fi
    CHECK=`curl -o /dev/null -s --connect-timeout 5 -w "%{http_code}\n" ${array[i]}` 
    if [ "$CHECK" = "200" -o "$CHECK" = "301" ]
    then  
        action  "${array[i]}" /bin/true 
    else
        action  "${array[i]}" /bin/false 
    fi 
done 

