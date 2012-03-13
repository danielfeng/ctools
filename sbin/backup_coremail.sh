#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

COREMAIL=/home/coremail
DATE=`date +%y%m%d%H`

BACKUP_LIST="api bin conf java lib libexec web"

cd $COREMAIL
tar czvf /home/coremailbk$DATE.tgz $BAKCUP_LIST

