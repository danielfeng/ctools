#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATA=`date +"%Y_%m_%d"`
DIR_MTA=/home/coremail/logs/mtatrans/mta${DATA}
CHECK_CMD=`grep 'DATA' ${DIR_MTA}/mta_*.log | grep 'Local:1' | awk -F',Sender:|,SenderEmail:|,subject:|,SubjectCnt' '{print $2}' | sort | uniq -c | sort -nr | head -50 `
TMP_JUNK=/tmp/junk.txt

[[ -f ${TMP_JUNK} ]] && \rm ${TMP_JUNK}  
echo "${CHECK_CMD}" > ${TMP_JUNK}
mail -s "Report Coremail mail system check spam from `hostname` ${DATA}" danielfancy@gmail.com < ${TMP_JUNK} 

