#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

export LC_CTYPE=en_US.UTF-8 #svn update在crontab定时必须
LOGS=/home/ctools/logs/ #填写保存svn update日志目录
PUBLIC=/var/doc/public/ #需要svn更新项目的目录
SVN=/usr/bin/svn #svn程序所在路径
DATE=`date +"%Y-%m-%d"`

[ -d $LOGS ] || mkdir -p $LOGS
cd $PUBLIC && $SVN cleanup && $SVN update $PUBLIC > $LOGS/svnupdate.$DATE.log &

for i in `find ${LOGS} -type f -mtime +6 -name 'svnupdate.*.log'` ; do
  if [ ! -z $i ]; then
    rm -f $i
  fi  
done
                 
