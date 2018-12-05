#!/bin/sh
RETVAL=0
main_menu(){
cat << EOF
----------------------------------------
|****Please Enter Your Choice:[0-3]****|
----------------------------------------
        1.[install server]
        0.[exit]
EOF
}

menu1(){
cat << EOF
----------------------------------------
|****Please Enter Your Choice:[0-4]****|
----------------------------------------
        1.[install lamp]
        2.[install lnmp]
        3.[back]
EOF
}

install_server(){
while true	
do
menu1
read -t 300 -p "pls input the you want:" number1
case $number1 in
    1)
        echo "start installing lamp" 
        echo '#####################'
        echo -e "\033[32m # lamp is installed # \033[0m"
        echo '#####################'
        sleep 2
        #clear
        ;;

    2)
        echo 'start installing lnmp'
        echo '#####################'
        echo -e "\033[32m # lnmp is installed # \033[0m"
        echo '#####################'
        sleep 2
        #clear
        ;;
    3)
        break
        ;;
    *)
        echo -e "\033[31m Please enter 1, 2 or 3 \033[0m"
        
esac
done
return $RETVAL
 
}

main(){
while true
do
	main_menu
	read -t 300 -p "pls input the you want:" number
	
	case $number in
	1)
	install_server	
	;;
	0)
	exit	
	;;
	*)
	echo -e "\033[31m Please enter 1, 2 or 3 \033[0m"
	esac	
done
	return $RETVAL
}

main

exit $RETVAL
