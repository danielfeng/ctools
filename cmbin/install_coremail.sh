#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

PACKAGE=$1
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
VER=`echo ${PACKAGE:2} | awk -F "_" '{print $1}' |sed 's/\.//g'`
BIT=`echo $PACKAGE | awk -F "_" '{print $6}' | sed 's/.install.sh//g'`
DATE=`date +%Y%m%d`

[[ -z ${PACKAGE} ]] && echo "Usage: $0 coremail install package name" && exit

if [[ -f ${COREMAIL_HOME}/libexec/udsvr ]] ; then
   CMVER=`${COREMAIL_HOME}/libexec/udsvr -v | head -1 | awk -F "(" '{print $1}' | awk '{print $3}' | sed 's/\.//g'`
fi

if [[ -L ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
	    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
	\rm ${COREMAIL_HOME}
	sh ${PACKAGE}
	${COREMAIL_HOME}/sbin/cmctrl.sh stop
	mv ${COREMAIL_HOME} coremail${VER}_x${BIT}_${DATE}
	ln -nsf coremail${VER}_x${BIT}_${DATE} ${COREMAIL_HOME}
	${COREMAIL_HOME}/sbin/cmctrl.sh start
elif [[ -d ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
	    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
	mv ${COREMAIL_HOME} coremail${CMVER}_${DATE}_dn 
	sh ${PACKAGE}
	${COREMAIL_HOME}/sbin/cmctrl.sh stop
	mv ${COREMAIL_HOME} coremail${VER}_x${BIT}_${DATE}
	ln -nsf coremail${VER}_x${BIT}_${DATE} ${COREMAIL_HOME}
	${COREMAIL_HOME}/sbin/cmctrl.sh start
else
	sh ${PACKAGE}
	${COREMAIL_HOME}/sbin/cmctrl.sh stop
	mv ${COREMAIL_HOME} coremail${VER}_x${BIT}_${DATE}
	ln -nsf coremail${VER}_x${BIT}_${DATE} ${COREMAIL_HOME}
	${COREMAIL_HOME}/sbin/cmctrl.sh start
fi