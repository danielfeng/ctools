#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATE=`date +%F`
USER_LOG="${COREMAIL_HOME}/logs/USER_LOGS"
UDSVR_LIST=`ls ${COREMAIL_HOME}/logs/udsvr.log.* | grep -v ${DATE} | awk -F '.' '{print $3}'`

if [ ! -d ${USER_LOG} ] ; then
    mkdir -p ${USER_LOG}
fi

for i in  ${UDSVR_LIST}; do
   if [[ -f ${USER_LOG}/user_change.log.${i} ]] ; then
     continue
   else
     grep 'cmd:1001\|cmd:1002\|cmd:1004' ${COREMAIL_HOME}/logs/udsvr.log.${i} > ${USER_LOG}/user_change.log.${i}
   fi
done

