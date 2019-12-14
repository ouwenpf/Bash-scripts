#########################################################################
# File Name: MySQL_Dir_Install.sh
# Author: tanyueyun
# mail: 3010079165@qq.com
# Created Time: 2017年4月6日 星期四 
#########################################################################

#!/bin/sh
. /etc/init.d/functions

Msg(){
    if $1; then
        action "$1"  /bin/true
    else
	action "$1"  /bin/false   
    fi
}


Load_Modules(){

    modprobe ip_tables
    modprobe iptable_filter
    modprobe iptable_nat
    modprobe ip_conntrack
    modprobe ip_conntrack_ftp
    modprobe ip_nat_ftp
    modprobe ipt_state
}

Clear_Rules(){

    iptables -F
    iptables -X
    iptables -Z
}


Set_Rules(){

    iptables  -A INPUT -m state --state ESTABLISHED,RELATED -j  ACCEPT
    iptables  -A INPUT -p tcp -m multiport --dport 2 -m state --state NEW -j  ACCEPT
    #iptables  -A INPUT -p udp -m multiport --dport 9334,9336  -m state --state NEW -j  ACCEPT
    #iptables  -A OUTPUT  -m state --state NEW,ESTABLISHED,RELATED -j  ACCEPT
    iptables  -A INPUT -p icmp  -j ACCEPT
    iptables -t filter -A INPUT -i lo -j ACCEPT
    iptables -t filter -A OUTPUT -o lo -j ACCEPT

    #Modify the default policy

    iptables -P INPUT DROP
   #iptables -P OUTPUT DROP
    iptables -P FORWARD DROP

}


Save_Rules(){

    /etc/init.d/iptables  save &>/dev/null
    /etc/init.d/iptables  restart &>/dev/null

}


main(){
    Msg Load_Modules
    Msg Clear_Rules
    Msg Set_Rules
    Msg Save_Rules

}

main

