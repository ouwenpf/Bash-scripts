#########################################################################
# File Name: youhu.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2014年12月23日 星期五 13时51分08秒
#/iims/conf/application.ini  后台网站配置
#/iims/int/apps/configs/server.ini  数据接口的配置
#########################################################################
#!/bin/sh
. /etc/init.d/functions
OLD_PASSWD="$1"
PASSWD="root@bswifi_shenzhenwutong"

if [ $# -ne 1 ] ;then
    echo "Please enter the original password"
    exit
fi

Clean_MySQL(){

    if [ "${OLD_PASSWD}" != "$PASSWD" ];then

        mysqladmin -uroot -p"${OLD_PASSWD}"  password $PASSWD  2>/dev/null
        mysql -uroot -p"$PASSWD"  -e  'drop database test;'  2>/dev/null
        mysql -uroot -p"$PASSWD"  -e  "delete  from   mysql.user where user='' or  host='"$HOSTNAME"' or host='::1';"   2>/dev/null

    fi 

}

function Msg(){
    if $1; then
        action "$1"  /bin/true
    else
	action "$1"  /bin/false   
    fi
}



function yum_repos(){
   [ -f /etc/yum.repos.d/CentOS-Base.repo ]&& mv /etc/yum.repos.d/CentOS-Base.repo{,.ori}
   wget -qO /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-6.repo
   wget -qO /etc/yum.repos.d/epel.repo  http://mirrors.aliyun.com/repo/epel-6.repo 
   yum -y install lrzsz tree telnet dos2unix nmap htop sysstat openssl openssh bash  openssl-devel bind-utils iotop nc  dstat yum-utils*  &>/dev/null
}


function user(){
    id bswifi &>/dev/null
    if [ $? -ne 0 ];then
        useradd bswifi &>/dev/null &&\
        echo 'bswifiProgBK0016CH'|passwd --stdin bswifi &>/dev/null &&\
        sed -i '98a\bswifi    ALL=(ALL)       NOPASSWD: ALL'  /etc/sudoers
    fi
}



function sshd(){
    Dir_config=/etc/ssh/sshd_config
    [ -f ${Dir_config} ]&&{
    \cp ${Dir_config}{,.$(date +%F).ori}
    #sed -i 's%#Port 22%Port 52553%g'  ${Dir_config} 
    #sed -i 's%#PermitRootLogin yes%PermitRootLogin no%g'  ${Dir_config} 
    sed -i 's%#UseDNS yes%UseDNS no%g'  ${Dir_config} 
    sed -i 's%GSSAPIAuthentication yes%GSSAPIAuthentication no%g'  ${Dir_config} 
    /etc/init.d/sshd reload &>/dev/null
    }	
}

function Time(){
    \cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
    echo 'ZONE="Asia/Shanghai"'>/etc/sysconfig/clock
    /usr/sbin/ntpdate asia.pool.ntp.org >/dev/null 2>&1 && hwclock -w
    echo "*/5 * * * * /usr/sbin/ntpdate -u asia.pool.ntp.org >/dev/null 2>&1" >> /var/spool/cron/root
    echo "00 00 * * * /bin/sh /bswifi/scripts/backup.sh &>/dev/null" >> /var/spool/cron/root
    
}



function zh_cn(){
    cp /etc/sysconfig/i18n  /etc/sysconfig/i18n.ori
    echo 'export LC_ALL=C'>> /etc/profile
    sed -i 's/exec/#exec/g'  /etc/init/control-alt-delete.conf
    sed  -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.UTF-8"#g' /etc/sysconfig/i18n
    echo -e "alias grep='grep --colour=auto'\nalias egrep='egrep --colour=auto'"  >> /root/.bashrc
    echo -e "alias grep='grep --colour=auto'\nalias egrep='egrep --colour=auto'"  >> /etc/skel/.bashrc
    echo -e  "HISTCONTROL=ignoreboth\nHISTTIMEFORMAT='%F %T '"  >> /etc/profile
    source /etc/sysconfig/i18n
    source /root/.bashrc
}

maildrop(){
    
    /bin/find  /var/spool/postfix/maildrop/ -type f -mtime +1|xargs rm -f  &>/dev/null
}



function main(){
   Msg Clean_MySQL 
   Msg yum_repos
   Msg user
   Msg sshd
   Msg Time
   Msg zh_cn
   Msg maildrop
}




main 


