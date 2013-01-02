#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CTOOLS=/home/ctools
ETC_NETWORK=/etc/sysconfig/network
OLD_HOSTNAME=`grep "^HOSTNAME=" ${ETC_NETWORK}`
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | egrep -v "127.0.0.1|^$"`
CM_HOSTNAME=`grep -B1 "${LOCAL_IP}" ${COREMAIL_HOME}/conf/hosts.cf | xargs -n2 | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'`
#CM_HOSTNAME=`grep -B1 "${LOCAL_IP}" ${CTOOLS}/cmconf/hosts.cf | xargs -n2 | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'`

[[ "${OLD_HOSTNAME}" == "HOSTNAME=mailsvr" ]] && exit
[[ "${OLD_HOSTNAME}" == "HOSTNAME=${CM_HOSTNAME}" ]]  && exit

if [[ -z ${CM_HOSTNAME} ]]; then
	sed -i "/^${OLD_HOSTNAME}/aHOSTNAME=mailsvr" ${ETC_NETWORK}
	sed -i "s/^${OLD_HOSTNAME}/#${OLD_HOSTNAME}/" ${ETC_NETWORK}
	hostname mailsvr
else
	sed -i "/^${OLD_HOSTNAME}/aHOSTNAME=${CM_HOSTNAME}" ${ETC_NETWORK}
	sed -i "s/^${OLD_HOSTNAME}/#${OLD_HOSTNAME}/" ${ETC_NETWORK}
	hostname ${CM_HOSTNAME}
fi
