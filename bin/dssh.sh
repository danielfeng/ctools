#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

HOSTS=$(grep IP= /home/coremail/conf/hosts.cf | awk -F\" '{print $2}')
#TT=`grep "\[" /home/hosts.cf`

select ip in $HOSTS ; do
    if [ -n "$ip" ] ; then
        ssh $ip 
    fi
done
