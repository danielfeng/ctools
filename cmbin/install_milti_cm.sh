#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CMDIR=/home/ctools/cmconf
CMSBIN=/home/coremail/sbin
MYSQL=${COREMAIL_HOME}/mysql/bin/mysql
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'| sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`
CMHOSTS=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $2}'` 
CMMDIP=`grep -E "IP|MDID" ${CMDIR}/hosts.cf | grep -B 1 "MDID" | xargs -n2 | awk  '{print $1}' | awk -F "=" '{print $2}'`
CM_IH=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2":"$1}' | sed 's/IP=//;s/\[//;s/\]//'`
CMCONF_LIST=("/home/coremail/conf" "/home/coremail/var/mainconfig")
CMDATACF="/home/coremail/conf/datasources.cf"
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
DATE=`date +%Y%m%d`
NOMDIP=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}' | grep -v "${CMMDIP}"`
NOLOCALIP=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}' | grep -v "${LOCAL_IP}"`
CM_IH=`grep -E "\[|IP" ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2":"$1}' | sed 's/IP=//;s/\[//;s/\]//' | sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`

[[ ! -f ${CMDIR}/hosts.cf ]] && exit
[[ ! -f ${CMDIR}/iplimit.cf ]] && exit
[[ ! -f ${CMDIR}/.coremail.pub ]] && exit
[[ ! -f ${CMDIR}/.coremailrsa ]] && exit

for i in ${CMIP[@]} ; do
    echo "input ${i} root password"
    ssh-copy-id -i ${CMDIR}/.coremail.pub root@${i} &>/dev/null
done


change_cmconf(){
	HOSTNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep Server |awk -F\" '{print $2}')
	sed -i 's@${HOSTNAME}@${CMMDIP}@g' ${CMDATACF}
	for c in ${CMCONF_LIST[@]}; do
		\cp ${CMDIR}/hosts.cf ${c}
		\cp ${CMDIR}/iplimit.cf ${c}
	done
	chown -R coremail:coremail ${COREMAIL_HOME}
}


grants_mysql(){
	HOSTNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep Server |awk -F\" '{print $2}')
	USERNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep User|awk -F\" '{print $2}')
	PASSWORD=$(grep cm_logs_db ${CMDATACF} -5 | grep Password |awk -F\" '{print $2}')
	PORT=$(grep cm_logs_db ${CMDATACF} -5 | grep Port |awk -F\" '{print $2}')
	GPASSWORD=`mysql -e "show grants\G;" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME} | grep PRIVILEGES | awk '{print $14}'`
	for g in ${CMIP[@]} ; do
          GRANTS="GRANT ALL PRIVILEGES ON *.* TO 'coremail'@'${g}' IDENTIFIED BY PASSWORD ${GPASSWORD};"
          $MYSQL -e "$GRANTS" -uroot -p${PASSWORD} -P${PORT} -h${HOSTNAME}
	done

}

if [[ -d ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
        change_cmconf
        grants_mysql
    fi
else
	echo "Not install coremail" && exit
fi

${COREMAIL_HOME}/sbin/cmctrl.sh stop

remote_scp(){
	for t in ${NOLOCALIP[@]} ; do
		scp -i ${CMDIR}/.coremailrsa -r ${COREMAIL_HOME} root@${t}:/home/
	done
}
remote_scp

remote_change(){
	for h in ${CM_IH[@]}; do
		OLDHOSTID=`grep "Hostid=" ${COREMAIL_HOME}/conf/coremail.cf `
		NEWHOSTID="Hostid=\"${h##*:}\""
		ssh -i ${CMDIR}/.coremailrsa -t root@${h%%:*} "sed -i 's@${OLDHOSTID}@${NEWHOSTID}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null	
	done

	for mi in ${CMIP[@]}; do
		MASHIP=`grep "MainAdminSvrHost=" ${COREMAIL_HOME}/conf/coremail.cf`
    	NMASHIP="MainAdminSvrHost\=\"${CMMDIP}\""
		ssh -i ${CMDIR}/.coremailrsa -t root@${mi} "sed -i 's@${MASHIP}@${NMASHIP}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null
		ssh -i ${CMDIR}/.coremailrsa -t root@${mi} "sed -i 's@127.0.0.1@${CMMDIP}@g' ${COREMAIL_HOME}/bin/mysql_cm" &>/dev/null

	done

	for im in ${NOMDIP[@]}; do
		IMAS=`grep "IamMainAdminSvr=" ${COREMAIL_HOME}/conf/coremail.cf`
    	NIMAS="IamMainAdminSvr=\"0\""
		ssh -i ${CMDIR}/.coremailrsa -t root@${im} "sed -i 's@${IMAS}@${NIMAS}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null
	done
	
	for ci in ${CMIP[@]}; do
		ssh -i ${CMDIR}/.coremailrsa -t root@${ci} "chown -R coremail:coremail ${COREMAIL_HOME}" &>/dev/null
		ssh -i ${CMDIR}/.coremailrsa -t root@${ci} "${COREMAIL_HOME}/sbin/cmctrl.sh start"
        OLDKEYS="3NzaC1yc2EAAAABIwAAAQEAvBpCSChvbSl2BkYWZ"
        ssh -i ${CMDIR}/.coremailrsa -t root@${ci} "sed -i '/${OLDKEYS}/d' ~/.ssh/authorized_keys"  &>/dev/null
	done
}
remote_change




    
