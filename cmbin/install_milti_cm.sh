#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CMDIR=/home/ctools/cmconf
LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
CMIP=`grep ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $1}'` 
CMHOSTS=`grep ${CMDIR}/hosts.cf | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' | awk '{print $2}'` 

for rsa in `grep -v ${LOCAL_IP} ${CMIP}; do
	ssh-copy-id -i ${CMDIR}/.coremail.pub root@${rsa}
done

echo "ok"