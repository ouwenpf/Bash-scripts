#########################################################################
# File Name: youhu.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2014年12月23日 星期五 13时51分08秒
#########################################################################
#!/bin/sh
. /etc/init.d/functions

function Msg(){
    if $1; then
        action "$1"  /bin/true
    else
	action "$1"  /bin/false   
    fi
}

function yum_repos(){
   #[ -f /etc/yum.repos.d/CentOS-Base.repo ]&& mv /etc/yum.repos.d/CentOS-Base.repo{,.ori}
   #wget -qO /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-6.repo
   #wget -qO /etc/yum.repos.d/epel.repo  http://mirrors.aliyun.com/repo/epel-6.repo 
   yum -y install lrzsz tree telnet dos2unix nmap htop sysstat openssl openssh bash  openssl-devel bind-utils iotop nc dstat yum-utils*  psacct &>/dev/null
}




function start(){
    Server_name="network sshd rsyslog crond sysstat"
    Server_list=`chkconfig --list|egrep -iv "^$"|awk '{print $1}'`
    for name in ${Server_list}
    do
	chkconfig  $name off 
    done 
    
    for start_name in ${Server_name}
    do
	chkconfig  $start_name on
    done
	
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
    #\cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    #echo 'ZONE="Asia/Shanghai"'>/etc/sysconfig/clock
    /usr/sbin/ntpdate -u asia.pool.ntp.org >/dev/null 2>&1 && hwclock -w
    echo "*/5 * * * * /usr/sbin/ntpdate  -u asia.pool.ntp.org >/dev/null 2>&1" >> /var/spool/cron/root
	
    
}



function limit(){
    echo "*                -       nofile          65535" >>/etc/security/limits.conf
}


function Sysctl(){
    cat >>/etc/sysctl.conf <<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000    65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_orphans = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_mem = 94500000 915000000 927000000
fs.file-max = 6553560
#一下参数是对iptables防火墙的优化，防火墙不开会有提示，可以忽略不理。
net.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120

EOF
sysctl -p &>/dev/null

}

function zh_cn(){
    #cp /etc/sysconfig/i18n  /etc/sysconfig/i18n.ori
    #sed  -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.UTF-8"#g' /etc/sysconfig/i18n
    echo -e "alias grep='grep --colour=auto'\nalias egrep='egrep --colour=auto'"  >> /root/.bashrc
    echo -e "alias grep='grep --colour=auto'\nalias egrep='egrep --colour=auto'"  >> /etc/skel/.bashrc
    #echo 'export LC_ALL=C'>> /etc/profile
    sed -i 's/exec/#exec/g'  /etc/init/control-alt-delete.conf
    echo -e  "HISTCONTROL=ignoreboth\nHISTTIMEFORMAT='%F %T '"  >> /etc/profile
    source /etc/sysconfig/i18n
    source /root/.bashrc
}


function stop_server(){
    sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop  &>/dev/null
}




function main(){
   Msg yum_repos
   Msg start
   Msg sshd
   Msg limit
   Msg Time
   Sysctl
   Msg zh_cn
   Msg stop_server
}

main 


