#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CMDIR=/home/ctools/cmconf
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'| sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`
CMDATACF="/home/coremail/conf/datasources.cf"
MYSQL=${COREMAIL_HOME}/mysql/bin/mysql
HOSTNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep Server |awk -F\" '{print $2}')
USERNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep User|awk -F\" '{print $2}')
PASSWORD=$(grep cm_logs_db ${CMDATACF} -5 | grep Password |awk -F\" '{print $2}')
PORT=$(grep cm_logs_db ${CMDATACF} -5 | grep Port |awk -F\" '{print $2}')
GPASSWORD=`mysql -e "show grants\G;" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME} | grep PRIVILEGES | awk '{print $14}'`
	
for g in ${CMIP[@]} ; do
    GRANTS="GRANT ALL PRIVILEGES ON *.* TO 'coremail'@'${g}' IDENTIFIED BY PASSWORD ${GPASSWORD};"
    $MYSQL -e "$GRANTS" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME}
done