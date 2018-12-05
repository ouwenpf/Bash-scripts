#########################################################################
# File Name: rand.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月22日 星期二 06时00分45秒
#########################################################################
#!/bin/bash
function rand(){
    [ $# -eq 0 ]&& exit
    expr $1 + $2 &>/dev/null
    [ $? -ne 0 ]&& exit 
    min=$1
    max=$(($2-$min+1))
    num=`openssl rand -base64 8|cksum|cut -d " " -f1`
    echo $(($num%$max+$min))
   
}

rand $1 $2 
