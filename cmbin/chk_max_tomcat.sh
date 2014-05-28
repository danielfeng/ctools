#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

MAX_PROC=`top -n 1 -b | grep jdaemon | awk '{print $1" "$9}' | sort -k2 -u | head -1 | awk '{printf("%.f\n", $2)}'`
PID_PROC=`top -n 1 -b | grep jdaemon | awk '{print $1" "$9}' | sort -k2 -u | head -1 | awk '{print $1}'`
LOG_TOMCAT="/home/chk_tomcat.log.`date -I`"


if [[ $MAX_PROC -gt 100 ]]; then
  tail -f /home/coremail/logs/tomcat.stdout >> ${LOG_TOMCAT} &
  kill -3 ${PID_PROC}
  echo "---------------------" >> ${LOG_TOMCAT}
  echo `date` >> ${LOG_TOMCAT}
  echo "---------------------" >> ${LOG_TOMCAT}
  pstack ${PID_PROC} >> ${LOG_TOMCAT}
	echo 0
  pkill tail >/dev/null 2>&1 
else
	echo 1
fi
