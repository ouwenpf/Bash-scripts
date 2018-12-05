#!/bin/sh

password=`cat /root/.password.txt`
RETVAL=0

passwd(){
read -p "login:" user
read -s -p "passwd:" passwd

[ "$user" = "root" -a  "$passwd" = "$password" ]&&{
	echo "login successful"
}||{
	echo "Login failed"
exit
}
 return $RETVAL
}

menu(){
cat << EFO
===================
1.[install lamp]
2.[install lnmp]
3.[quit]
====================
EFO

read  -t 300 -p "number:" enter
 return $RETVAL
}

install(){

case $enter in
    1)
 	echo "start installing lamp" 
	echo '#####################'
	echo -e "\033[32m # lamp is installed # \033[0m"
	echo '#####################'
	sleep 2
	#clear
	menu
	install
	;;

    2)
	echo 'start installing lnmp'
	echo '#####################'
	echo -e "\033[32m # lnmp is installed # \033[0m"
	echo '#####################'
	sleep 2
	#clear
	menu
	install
	;;
    3)
	exit
	;;
    *)
	echo -e "\033[31m Please enter 1, 2 or 3 \033[0m"
	menu
	install
esac

return $RETVAL	
}

main(){
passwd
menu
install
}

main

exit $RETVAL 
