#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATE=`date +%Y_%m_%d`
MTA_LOGS="/home/coremail/logs/mtatrans/mta$DATE/"
MTA_BK_LOGS="/home/coremail/logs/backup/mta"
DATE_LIST=`cd /home/coremail/logs/backup/ && ls mta*.tar.gz | awk -F . '{print $1}' | sed 's/mta//g' | sort | uniq`


if [[ $1 = ${DATE} ]] ; then
	grep 'cmd:DATA' ${MTA_LOGS}/* | grep 'Local:1' | grep 'Result:Deliver' | awk -F'Sender:|,SenderEmail:|subject:|,SubjectCnt' '{print $2" "$4}' |head -50| sort | uniq -c | sort -nr
fi

for i in ${DATE_LIST} ; do 
    if [[ $1 = ${i} ]] ; then
		zgrep -a  'cmd:DATA' ${MTA_BK_LOGS}$i.tar.gz | grep 'Local:1' | grep 'Result:Deliver' | awk -F'Sender:|,SenderEmail:|subject:|,SubjectCnt' '{print $2" "$4}' |head -50| sort | uniq -c | sort -nr
	fi
done
