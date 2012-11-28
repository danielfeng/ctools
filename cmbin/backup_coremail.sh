#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

COREMAIL=/home/coremail
DATE=`date +%y%m%d%H`

BACKUP_LIST="api bin conf java lib libexec web"
BAK_DIR=/home/cmbackup

if [ ! -d ${BAK_DIR} ] ; then
    mkdir -p ${BAK_DIR}
fi

cd $COREMAIL
tar czvf ${BAK_DIR}/coremailbk$DATE.tgz $BACKUP_LIST

