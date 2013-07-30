#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

export LC_CTYPE=en_US.UTF-8
LOGS=/home/ctools/logs/
PUBLIC=/var/doc/
URL=http://svn.mailtech.cn/cmdoc/public
DATE=`date +"%Y-%m-%d"`

[ -d $LOGS ] || mkdir -p $LOGS
cd $PUBLIC && /usr/bin/svn cleanup public && /usr/bin/svn co $URL > $LOGS/svnsync.$DATE.log &

for i in `find ${LOGS} -type f -mtime +6 -name 'svnsync.*.log'` ; do
    if [ ! -z $i ]; then
       rm -f $i
    fi  
done

