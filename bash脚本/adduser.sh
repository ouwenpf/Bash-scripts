#########################################################################
# File Name: user.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月21日 星期一 00时45分04秒
#########################################################################
#!/bin/bash
for user in $@
do 
    [ -z "$user" ] && exit 
    PASSWD=`echo $RANDOM|md5sum|cut -c 5-10`
    id $user &>/dev/null 
    [ $? -ne 0 ] &&{
                useradd $user
    }||{
                echo "$user is exist" && continue
        }
    echo "$PASSWD"|passwd --stdin $user
    echo "$(date +%F\ %T) $user:$PASSWD" >> passwd.log

done

