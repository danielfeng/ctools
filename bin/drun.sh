#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

HOSTS=`grep ^192.168.3 /etc/hosts | awk '{print $3}' | sort `

for ip in $HOSTS ; do
    echo -ne "$ip\t"
    if [ "ok$1" != "ok" ] ; then
        ssh -t root@$ip $1
      else
        echo "Do what?"
    fi
done
