#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

LOGS=/home/ctools/logs/
DATE=`date +"%Y-%m-%d"`
LOAD=$(awk '{print $1}' /proc/loadavg)
CPUNUM=$(grep -c processor /proc/cpuinfo)

[ -d $LOGS ] || mkdir -p $LOGS

if [ $(echo "$LOAD > $CPUNUM" | bc) = 1 ]; then
    RESULT=$(ps -eo pcpu,pmem,user,args | awk '$1 > 0' | sort -nr)
    if [ -n "$RESULT" ]; then
        echo "$RESULT" > ${LOGS}/ps.log.${DATE}
    fi
fi
