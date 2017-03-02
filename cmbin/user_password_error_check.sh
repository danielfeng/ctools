#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATA=`date +"%Y_%m_%d"`
CHECK_CMD=`grep "102(password error" /home/coremail/logs/udsvr.log | awk  '{print $7}' | sort | uniq -c | sort -rn | head -10`
TMP_USER=/tmp/user.txt

[[ -f ${TMP_USER} ]] && \rm ${TMP_USER}  
echo "${CHECK_CMD}" > ${TMP_USER}
mail -s "Report Coremail mail system check password error user from `hostname` ${DATA}" danielfancy@gmail.com < ${TMP_USER} 

