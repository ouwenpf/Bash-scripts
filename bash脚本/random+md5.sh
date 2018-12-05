#########################################################################
# File Name: md5.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月21日 星期一 03时00分31秒
#########################################################################
#!/bin/bash 
CONUT=0
[ $# -eq 0 ] && exit 
for n in `seq 0 32767`
do
    for md in "$@"
    do 
            md5="`echo $n|md5sum|awk '{print $1}'`"
            if [ "$md" == "$md5" ]
            then
            echo $n  
            ((CONUT++))
            [ $# -eq $CONUT ]&& exit
            fi 
    done 
done

