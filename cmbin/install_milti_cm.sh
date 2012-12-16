#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CMDIR=/home/ctools/cmconf
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'`
CMHOSTS=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $2}'` 
CMMDIP=`grep -E "IP|MDID" ${CMDIR}/hosts.cf | grep -B 1 "MDID" | xargs -n2 | awk  '{print $1}' | awk -F "=" '{print $2}'`
PACKAGE=$1
PACKAGENAME=`grep "install.sh" ${PACKAGE}`
CMSBIN=/home/coremail/sbin
CMCONF=/home/coremail/conf
CMMAINCONF=/home/coremail/var/mainconfig
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
MYSQL=/home/coremail/mysql/bin/mysql
DATE=`date +%Y%m%d`


[[ -z ${PACKAGE} ]] || [[ -z ${PACKAGENAME} ]] && echo "Usage: $0 coremail install package name" && exit


if [[ -d ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
	    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
	mv ${COREMAIL_HOME} coremail_${DATE}_dn 
	sh ${PACKAGE}
fi

change_cmconf(){
	HOSTNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server |awk -F\" '{print $2}')
	USERNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep User|awk -F\" '{print $2}')
	PASSWORD=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Password |awk -F\" '{print $2}')
	PORT=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Port |awk -F\" '{print $2}')
	GPASSWORD=`mysql -e "show grants\G;" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME} | grep PRIVILEGES | awk '{print $14}'`
	for g in ${CMIP} ; do
          GRANTS="GRANT ALL PRIVILEGES ON *.* TO 'coremail'@'${g}' IDENTIFIED BY PASSWORD ${GPASSWORD};"
          #echo "$GRANTS"
          $MYSQL -e "$GRANTS" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME}
	done

}


for i in ${CMIP[@]} ; do
    echo "input $i root password"
    ssh-copy-id -i ${CMDIR}/.coremail.pub root@${i} 
done



for t in ${CMIP} ; do
    ssh -t root@$t "${CMSBIN}/cmctrl.sh restart"
done