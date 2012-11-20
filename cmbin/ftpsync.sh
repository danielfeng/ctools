#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

USER=用户名
PASSWORD=密码
IP=地址
RELEASE=/var/share/
LOGS=/home/ctools/logs
DATE=`date +"%Y-%m-%d"`

[ -d $LOGS ] || mkdir -p $LOGS
wget -nH -m -c -b ftp://$USER:$PASSWORD@$IP/release/ -P $RELEASE -o $LOGS/release.$DATE.log 

##wget -r -b ftp://$USER:$PASSWORD@$IP/release/ -P $RELEASE -nH --cut-dirs=2 -o $LOGS/release.$DATE.log 

for i in `find ${LOGS} -type f -mtime +6 -name 'release.*.log'` ; do
    if [ ! -z $i ]; then
      rm -f $i
    fi  
done
