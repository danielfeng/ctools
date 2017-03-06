#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATA=`date +"%Y_%m_%d"`
CHECK_MTA=`grep "Result:Failed" /home/coremail/logs/mtasvr.log | awk -F "," '{print $4"  \t "$6}' | sort`
CHECK_POP=`grep "login fail" /home/coremail/logs/pop3svr.log | awk '{print $4"  "$5}' | sort`
CHECK_IMAP=`grep "password error" /home/coremail/logs/imapsvr.log | awk '{print $4"  "$6}' | sort `
TMP_USER=/tmp/user.txt

[[ -f ${TMP_USER} ]] && \rm ${TMP_USER}  
echo "MTA" >> ${TMP_USER}
echo "${CHECK_MTA}" >> ${TMP_USER}
echo "POP3" >> ${TMP_USER}
echo "${CHECK_POP}" >> ${TMP_USER}
echo "IMAP" >> ${TMP_USER}
echo "${CHECK_IMAP}" >> ${TMP_USER}
mail -s "Report Coremail mail system check password error user from `hostname` ${DATA}" danielfancy@gmail.com < ${TMP_USER} 

