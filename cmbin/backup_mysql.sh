#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

HOSTNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server |awk -F\" '{print $2}')
USERNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep User|awk -F\" '{print $2}')
PASSWORD=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Password |awk -F\" '{print $2}')
PORT=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Port |awk -F\" '{print $2}')

MYSQLBAK_LOG="/home/coremail/logs/backup_mysql.log"
MYSQLDUMP="/home/coremail/mysql/bin/mysqldump"

BAK_DIR=/home/cmbackup

if [ ! -d ${BAK_DIR} ] ; then
    mkdir -p ${BAK_DIR}
fi


$MYSQLDUMP -A -u${USERNAME} -p${PASSWORD} -h${HOSTNAME} -P${PORT} > ${BAK_DIR}/all_database.sql #>> ${MYSQLBAK_LOG}
