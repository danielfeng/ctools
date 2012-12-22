#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CTOOLS=/home/ctools
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
REMOTE_CTRL="ssh -i ${CTOOLS}/cmconf/.coremailrsa -t root@"
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${COREMAIL_HOME}/conf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'| sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`
RSAPUB=`awk '{print $2}' ${CTOOLS}/cmconf/.coremail.pub`


[[ ! -f ${CTOOLS}/cmconf/.coremail.pub ]] && exit
[[ ! -f ${CTOOLS}/cmconf/.coremailrsa ]] && exit

for i in ${CMIP[@]} ; do
    echo "Input ${i} root password"
    ssh-copy-id -i ${CTOOLS}/cmconf/.coremail.pub root@${i} &>/dev/null
    ${REMOTE_CTRL}${i} ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    ${REMOTE_CTRL}${i} \rm -rf ${COREMAIL_HOME} &>/dev/null
    ${REMOTE_CTRL}${i} "cd /home/ctools && git pull"
    ${REMOTE_CTRL}${i} "sed -i '/${RSAPUB:1:50}/d' ~/.ssh/authorized_keys"  &>/dev/null
done

