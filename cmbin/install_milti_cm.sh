#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CTOOLS=/home/ctools
MYSQL=${COREMAIL_HOME}/mysql/bin/mysql
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'| sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`
CMHOSTS=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $2}'` 
CMMDIP=`grep -E "IP|MDID" ${CTOOLS}/cmconf/hosts.cf | grep -B 1 "MDID" | xargs -n2 | awk  '{print $1}' | awk -F "=" '{print $2}'`
CM_IH=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2":"$1}' | sed 's/IP=//;s/\[//;s/\]//'`
CMCONF_LIST=("${COREMAIL_HOME}/conf" "${COREMAIL_HOME}/var/mainconfig")
CMDATACF="${COREMAIL_HOME}/conf/datasources.cf"
HOSTNAME=$(grep cm_logs_db ${CMDATACF} -5 | grep Server |awk -F\" '{print $2}')
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
REMOTE_CTRL="ssh -i ${CTOOLS}/cmconf/.coremailrsa -t root@"
RSAPUB=`awk '{print $2}' ${CTOOLS}/cmconf/.coremail.pub`
NOMDIP=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}' | grep -v "${CMMDIP}"`
NOLOCALIP=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}' | grep -v "${LOCAL_IP}"`
CM_IH=`grep -E "\[|IP" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | awk '{print $2":"$1}' | sed 's/IP=//;s/\[//;s/\]//' | sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`

[[ ! -f ${CTOOLS}/cmconf/hosts.cf ]] && exit
[[ ! -f ${CTOOLS}/cmconf/iplimit.cf ]] && exit
[[ ! -f ${CTOOLS}/cmconf/.coremail.pub ]] && exit
[[ ! -f ${CTOOLS}/cmconf/.coremailrsa ]] && exit

for i in ${CMIP[@]} ; do
    echo "Input ${i} root password"
    ssh-copy-id -i ${CTOOLS}/cmconf/.coremail.pub root@${i} &>/dev/null
done

change_cmconf(){
	sed -i 's@${HOSTNAME}@${CMMDIP}@g' ${CMDATACF}
	for c in ${CMCONF_LIST[@]}; do
		\cp ${CTOOLS}/cmconf/hosts.cf ${c}
		\cp ${CTOOLS}/cmconf/iplimit.cf ${c}
	done
	chown -R coremail:coremail ${COREMAIL_HOME}
}

grants_mysql(){
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
		scp -i ${CTOOLS}/cmconf/.coremailrsa -r ${COREMAIL_HOME} root@${t}:/home/
	done
}
remote_scp

remote_change(){
	for h in ${CM_IH[@]}; do
		OLDHOSTID=`grep "Hostid=" ${COREMAIL_HOME}/conf/coremail.cf `
		NEWHOSTID="Hostid=\"${h##*:}\""
		${REMOTE_CTRL}${h%%:*} "sed -i 's@${OLDHOSTID}@${NEWHOSTID}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null	
	done

	for im in ${NOMDIP[@]}; do
		IMAS=`grep "IamMainAdminSvr=" ${COREMAIL_HOME}/conf/coremail.cf`
    	NIMAS="IamMainAdminSvr=\"0\""
		${REMOTE_CTRL}${im} "sed -i 's@${IMAS}@${NIMAS}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null
	done
	
	for ci in ${CMIP[@]}; do
		MASHIP=`grep "MainAdminSvrHost=" ${COREMAIL_HOME}/conf/coremail.cf`
    	NMASHIP="MainAdminSvrHost\=\"${CMMDIP}\""
		${REMOTE_CTRL}${ci} "sed -i 's@${MASHIP}@${NMASHIP}@g' ${COREMAIL_HOME}/conf/coremail.cf" &>/dev/null
		${REMOTE_CTRL}${ci} "sed -i 's@127.0.0.1@${CMMDIP}@g' ${COREMAIL_HOME}/bin/mysql_cm" &>/dev/null
		${REMOTE_CTRL}${ci} "chown -R coremail:coremail ${COREMAIL_HOME}" &>/dev/null
		echo "This is ${ci} Mail Server"
		${REMOTE_CTRL}${ci} "sh ${CTOOLS}/cmbin/boot_coremail.sh" &>/dev/null
		${REMOTE_CTRL}${ci} "sh ${CTOOLS}/cmbin/add_cmhosts.sh" &>/dev/null
		${REMOTE_CTRL}${ci} "${COREMAIL_HOME}/sbin/cmctrl.sh start"
        ${REMOTE_CTRL}${ci} "sed -i '/${RSAPUB:1:50}/d' ~/.ssh/authorized_keys"  &>/dev/null
	done
}
remote_change
