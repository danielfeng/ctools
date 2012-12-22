#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

#CMDIR=`find /home/ -name "coremail.cf" | grep "/home/coremail" | awk -F "/conf" '{print $1}' | grep -v "/coremail$" | grep -v "/var"`
MLOCATEDB=`locate coremail.cf 2>/dev/null`
[[ -z ${MLOCATEDB} ]] && updatedb

DATE=`date +%Y%m%d`
TIME=`date +%H%M`
LOCMDIR=`locate coremail.cf | grep "^/home/coremail" | grep -v ".tpl" | awk -F/ '{print "/"$2"/"$3 }' | sort -u`
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
LSCMDIR=`ls -d1 /home/coremail*/conf/coremail.cf | grep -cv "coremail/conf"`
CLOCMDIR=`locate coremail.cf | grep "^/home/coremail" | grep -v ".tpl" | awk -F/ '{print "/"$2"/"$3 }' | sort -u | wc -l`

[[ ${LSCMDIR} > ${CLOCMDIR} ]] && updatedb

if [[ -f ${COREMAIL_HOME}/libexec/udsvr ]] ; then
   CMVER=`${COREMAIL_HOME}/libexec/udsvr -v | head -1 | awk -F "(" '{print $1}' | awk '{print $3}' | sed 's/\.//g'`
fi

whether_cm_proc(){
    if [[ ! -z ${CMPROC} ]] ; then
            ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
}

ln_coremail_start(){
   ln -nsf ${s} /home/coremail
   ${COREMAIL_HOME}/sbin/cmctrl.sh start
   exit
}

select s in ${LOCMDIR[@]}
do
    if [[ -z ${s} ]] ; then  
        echo "input error" 
    elif [[ -L /home/coremail ]] ; then
        whether_cm_proc
        ln_coremail_start
    elif [[ -d /home/coremail ]] ; then
        whether_cm_proc
        mv ${COREMAIL_HOME} /home/coremail${CMVER}_${DATE}_dn_${TIME}
        ln_coremail_start
    else
        ln_coremail_start
    fi  
done
