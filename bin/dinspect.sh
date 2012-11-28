#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


#HOSTS=`grep IP= /home/coremail/conf/hosts.cf | awk -F\" '{print $2}'`
HOSTS=`grep ^192.168.173.7 /etc/hosts | awk '{print $1}' | sort`

for ip in $HOSTS ; do
    echo "$ip\t"
   # echo -ne "$ip\t"
    ssh root@$ip "last | head -10 && fdisk -l && df -h &&  ps axo %cpu,%mem,pid,comm |sort -r |head -n 5 && w"  
done

