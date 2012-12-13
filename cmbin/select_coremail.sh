#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

#CMDIR=`find /home/ -name "coremail.cf" | grep "/home/coremail" | awk -F "/conf" '{print $1}' | grep -v "/coremail$" | grep -v "/var"`
MLOCATEDB=`locate coremail.cf 2>/dev/null`
[[ -z ${MLOCATEDB} ]] && updatedb

CMDIR=`locate coremail.cf | grep "^/home/coremail" | grep -v ".tpl" | awk -F/ '{print "/"$2"/"$3 }' | sort | uniq `
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`

select s in ${CMDIR[@]}
do
    [[ -z ${s} ]] && echo "input error" && exit
    if [[ -z ${CMPROC} ]] ; then
        ln -nsf ${s} /home/coremail
        ${COREMAIL_HOME}/sbin/cmctrl.sh start
        exit
    elif [[ ! -e ${COREMAIL_HOME}/sbin/cmctrl.sh ]] ; then
        ln -nsf ${s} /home/coremail
        ${COREMAIL_HOME}/sbin/cmctrl.sh start
        exit
    else
        ${COREMAIL_HOME}/sbin/cmctrl.sh stop
        ln -nsf ${s} /home/coremail
        ${COREMAIL_HOME}/sbin/cmctrl.sh start
        exit
    fi  
done
