#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

LOGS=/home/ctools/logs/
PUBLIC=/var/doc/
URL=http://svn.mailtech.cn/cmdoc/public
DATE=`date +"%Y-%m-%d"`

[ -d $LOGS ] || mkdir -p $LOGS
cd $PUBLIC
svn co $URL > $LOGS/svnsync.$DATE.log &
