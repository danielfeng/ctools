#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CMDIR=`find /home/ -name "coremail.cf" | grep "/home/coremail" | awk -F "/conf" '{print $1}' | grep -v "/coremail$" | grep -v "/var"`
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`

select s in ${CMDIR[@]}
do
    if [[ -z ${CMPROC} ]] ; then
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


