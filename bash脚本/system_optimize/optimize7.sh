#########################################################################
# File Name: youhu.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2014年12月23日 星期五 13时51分08秒
#########################################################################
#!/bin/bash


#Configuration yum_repos
echo  'Configuration yum_repos'  

   [ -f /etc/yum.repos.d/CentOS-Base.repo ]&& mv /etc/yum.repos.d/CentOS-Base.repo{,.ori}
   wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo   
   wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  
   yum -y install bash-completion man-pages-zh-CN.noarch iptables-services lrzsz tree screen telnet dos2unix nmap htop openssl openssh openssl-devel bind-utils iotop nc dstat yum-utils*  psacct 



#Configuration start_server
echo 'Configuration start_server'
    Server_name="sshd.service crond.service rsyslog.service sysstat.service"
    Server_list=`systemctl list-unit-files --type=service|grep enabled|awk '{print $1}'`
    for name in ${Server_list}
    do
	systemctl disable $name  &> /dev/null
    done 
    
    for start_name in ${Server_name}
    do
	systemctl enable  $start_name &> /dev/null
    done
	


#Configuration sshd
#echo 'Configuration sshd'
  
    #[ -f /etc/ssh/sshd_config ] && \cp /etc/ssh/sshd_config{,.ori}
    #sed -i 's%#Port 22%Port 52553%g'  /etc/ssh/sshd_config 
    #sed -i 's%#PermitRootLogin yes%PermitRootLogin no%g'  /etc/ssh/sshd_config
    #sed -i 's%#UseDNS yes%UseDNS no%g'  /etc/ssh/sshd_config
    #sed -i 's%GSSAPIAuthentication yes%GSSAPIAuthentication no%g'  /etc/ssh/sshd_config



#Configuration Time
echo 'Configuration Time'
	timedatectl set-timezone   Asia/Shanghai
    /usr/sbin/ntpdate -u asia.pool.ntp.org &> /dev/null && hwclock -w
    echo "*/5 * * * * /usr/sbin/ntpdate  -u asia.pool.ntp.org &> /dev/null " >> /var/spool/cron/root
	echo "0 0 * * * /usr/bin/rm -f /run/systemd/system/*.scope &> /dev/null"  >> /var/spool/cron/root



#Configuration nofile 
echo 'Configuration nofile '
    echo "*                -       nofile          65535" >>/etc/security/limits.conf



#Configuration sysctl
echo 'Configuration sysctl'
cat >/etc/sysctl.conf <<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
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
net.ipv4.tcp_timestamps = 1
net.core.somaxconn = 32767
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


#Configuration character 
#echo 'Configuration character'
	#localectl set-locale LANG="zh_CN.UTF-8
    #sed  -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.UTF-8"#g' /etc/locale.conf
 



#Configuration iptables and selinux
echo 'Configuration iptables and selinux'
    sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
	
#Configuration rc.local
echo 'Configuration rc.local'
	chmod +x /etc/rc.d/rc.local

#Configuration hostname
	hostnamectl   set-hostname  zabbix_proxy
	


#Configuration vim
#echo 'Configuration vim'
	#cat > /etc/skel/.vimrc <<-EOF
		#set number
		#set ai
		#set hlsearch
		#syntax on
		#set ic
		#set ts=4		
#EOF

	cat > /etc/profile.d/oneinstack.sh <<EOF
		HISTSIZE=10000
		#red
		PS1="\[\e[37;40m\][\[\e[31;40m\]\u\[\e[31;40m\]@\h \[\e[31;40m\]\W\[\e[0m\]]\\\\$ "
		#green
		PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[32;40m\]@\h \[\e[32;40m\]\W\[\e[0m\]]\\\\$ "
		HISTTIMEFORMAT="%F %T $(whoami) "
		HISTCONTROL="ignoreboth"
		alias ll='ls -hltr --time-style=long-iso'
		alias lh='l | head'
		alias vi='vim'		
EOF

#Configuration reboot
reboot



