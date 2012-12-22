#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CMDIR=/home/ctools/cmconf
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
REMOTE_CTRL="ssh -i ${CMDIR}/.coremailrsa -t root@"
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep -E "\[|IP" ${COREMAIL_HOME}/conf/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'| sed "s@${LOCAL_IP}@127.0.0.1@g" | sort -r`

[[ ! -f ${CMDIR}/.coremail.pub ]] && exit
[[ ! -f ${CMDIR}/.coremailrsa ]] && exit

for i in ${CMIP[@]} ; do
    echo "Input ${i} root password"
    ssh-copy-id -i ${CMDIR}/.coremail.pub root@${i} &>/dev/null
    ${REMOTE_CTRL}${i} ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    ${REMOTE_CTRL}${i} \rm -rf ${COREMAIL_HOME} &>/dev/null
    ${REMOTE_CTRL}${i} "cd /home/ctools && git pull"
done

