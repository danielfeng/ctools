#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CMHOSTS="${COREMAIL_HOME}/conf/hosts.cf"
HOSTS=/etc/hosts
HOSTS_IP=`grep -E "\[|IP" $CMHOSTS | xargs -n2 | awk '{print $2":"$1}' | sed 's/IP=//;s/\[//;s/\]//'`

for i in ${HOSTS_IP[@]} ; do
    _HOSTSIP_=`grep "${i##*:}" ${HOSTS}`
    [[ -z ${_HOSTSIP_} ]] && echo "${i%%:*} ${i##*:}" >> ${HOSTS}
done
