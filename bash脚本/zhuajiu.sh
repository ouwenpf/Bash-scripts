#########################################################################
# File Name: shijian.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月22日 星期二 06时18分53秒
#########################################################################
#!/bin/sh 
Path="/tmp/rand.txt"
cat << EFO
企业面试题17：老男孩教育天津项目学生实践抓阄题目：
EFO
[ -f $Path ] || touch /tmp/rand.txt 

function rand(){
    [ $# -eq 0 ]&& exit
    expr $1 + $2 &>/dev/null
    [ $? -ne 0 ]&& exit 
        min=$1   
        max=$(($2-$min+1))
        num=`openssl rand -base64 8|cksum|cut -d " " -f1`
        rand=$(($num%$max+$min))
}


while true
do
read  -t  500 -p "please input name spell:" name 
    while true 
    do 
    rand 1 4
    if [ `cat  $Path|wc -l` -eq 4 ]
    then
        echo "随机数已经用完"
        exit
    elif [  `grep "\b$name\b" $Path|awk -F ":" '{print $1}'|wc -l` -ne 0 ] 
    then
        echo "请重新输入名字拼音"    
        break 
    elif [ `grep "\b$rand\b" $Path|awk -F ":" '{print $2}'|wc -l` -eq 0  ]
    then
        echo  "你的随机数是:$rand，请注意保存哦"
        echo  "$name:$rand" >>$Path
        break
    else
        continue 
    fi 
    done 
    
done 
