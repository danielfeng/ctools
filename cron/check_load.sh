#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATE=`date +"%Y-%m-%d"`
LOAD=$(awk '{print $1}' /proc/loadavg)
CPUNUM=$(grep -c processor /proc/cpuinfo)
TMP_LOAD=/tmp/loadavg.tmp

[[ -f ${TMP_LOAD} ]] && \rm ${TMP_LOAD}  

if [ $(echo "$LOAD > $CPUNUM" | bc) = 1 ]; then
    RESULT=$(ps -eo pcpu,pmem,user,args | awk '$1 > 0' | sort -nr)
    if [ -n "$RESULT" ]; then
        echo "$RESULT" >  ${TMP_LOAD}
        mail -s "Report Coremail mail system check loadavg from `hostname` ${DATA}" ddiao@mailtech.cn < ${TMP_LOAD}
    fi
fi
