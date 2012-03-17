#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


HOSTS=`grep IP= /home/coremail/conf/hosts.cf | awk -F\" '{print $2}'`

for ip in $HOSTS ; do
    echo -ne "$ip\t"
    ssh $ip "last | head -10 && fdisk -l && df -h &&  ps axo %cpu,%mem,pid,comm |sort -r |head -n 5 && w"  
done

