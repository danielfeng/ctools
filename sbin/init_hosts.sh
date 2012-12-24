#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

OLOCALHOST=`grep "127.0.0.1" /etc/hosts | awk '{print $2" "$3}'`
NLOCALHOST="localhost.localdomain localhost"
COUNT=`grep -c "127.0.0.1" /etc/hosts`

if [[ ${COUNT} -ge 2 ]] ; then
    exit 
elif [[ "${OLOCALHOST}" != "${NLOCALHOST}" ]] ; then
	sed -i 's/^127/#127/g' /etc/hosts
    sed -i '/^#127/a\127.0.0.1 localhost.localdomain localhost' /etc/hosts
fi