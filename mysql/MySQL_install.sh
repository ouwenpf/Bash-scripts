#########################################################################
# File Name: MySQL_Install.sh
# Author: Owen
# mail: 
# Created Time: 2019-11-07 wed 
# package：mysql-5.7.24-linux-glibc2.12-x86_64
# Discription: mkdir /application  tar
#########################################################################

#!/bin/sh
#
if [ $# -eq 0 ];then
	 echo "Usage: $0  {3306|3307|...}"
	 exit 
fi

if [ ! -d /application ];then
	 echo "First create the application directory, MySQL package storage location"
	 exit
fi

if [ ! -f /application/my.cnf ];then
	echo 'file my.cnf not exist'
	exit
fi

# 
if [ `ping 8.8.8.8 -c 5 | grep "min/avg/max" -c` = '1' ]; then

    	if [ `rpm  -qa numactl-libs libaio man|wc -l` -ne 2 ];then
        	yum install -y numactl-libs libaio man &> /dev/null
	fi 
else
    	echo "The network connection failed and the installation was terminated!"
    	exit
fi

# 
if ! id mysql &> /dev/null ;then
	useradd -r -M -s /sbin/nologin mysql
fi

# 
if [ ! -d /data/mysql/mysql$1 ];then
	mkdir -p /data/mysql/mysql$1/{data,logs,tmp}
	chown -R mysql.mysql /data/mysql/mysql$1
fi


# 
if [ ! -d /usr/local/mysql ];then
   	cd /usr/local && ln -s /application/mysql-5.7.24-linux-glibc2.12-x86_64 mysql 
fi

   	chown -R mysql.mysql /usr/local/mysql/      &&\
   	cp  /application/my.cnf /data/mysql/mysql$1 &&\
	sed -ri  's/3306/'$1'/g'  /data/mysql/mysql$1/my.cnf

#PATH_file
if [ ! -f /etc/profile.d/mysql.sh ];then
	echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile.d/mysql.sh
fi

#lib64_file
if [ ! -f /etc/ld.so.conf.d/mysql.conf ];then
	echo '/usr/local/mysql/lib' > /etc/ld.so.conf.d/mysql.conf
fi

#include_file
if [ ! -d /usr/include/mysql ];then
	ln -s /usr/local/mysql/include/ /usr/include/mysql 
fi

#man_file
if [ ! -f /etc/man_db.conf ];then
	sed -ri '22a \MANDATORY_MANPATH                       /usr/local/mysql/man'  /etc/man_db.conf

fi
# 
/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/mysql$1/my.cnf  --initialize-insecure 
if [ $? -eq 0 ];then
	echo "MySQL initialization succeeded"
else
	echo "MySQL initialization failed"
	exit
fi

# 
/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/mysql$1/my.cnf & &> /dev/null
if [ $? -eq 0 ];then
	sleep 5
	echo "MySQL started successfully"
else
	echo "MySQL startup failed"
fi

if [ $? -eq 0 ];then
	/usr/local/mysql/bin/mysql  -S /tmp/mysql$1.sock  -e  'set global super_read_only=0;alter user user() identified by "123456";'
	if [ $? -eq 0 ];then
		echo "MySQL Password setting is successful"
	fi

fi
