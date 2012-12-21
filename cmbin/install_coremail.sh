#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

PACKAGE=$1
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
DATE=`date +%Y%m%d`
TIME=`date +%H%M`
PACKAGENAME=`basename ${PACKAGE} | grep "install.sh"`
VER=`echo ${PACKAGENAME:2} | awk -F "_" '{print $1}' |sed 's/\.//g'`
BIT=`echo $PACKAGENAME | awk -F "_" '{print $6}' | sed 's/.install.sh//g'`

[[ -z ${PACKAGE} ]] || [[ -z ${PACKAGENAME} ]] && echo "Usage: $0 coremail install package name" && exit

if [[ -f ${COREMAIL_HOME}/libexec/udsvr ]] ; then
   CMVER=`${COREMAIL_HOME}/libexec/udsvr -v | head -1 | awk -F "(" '{print $1}' | awk '{print $3}' | sed 's/\.//g'`
fi

install_coremail(){
    sh ${PACKAGE}
    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    if [[ -d /home/coremail${VER}_x${BIT}_${DATE} ]] ; then
        mv /home/coremail${VER}_x${BIT}_${DATE}{,_bak_${TIME}}
    fi
    mv ${COREMAIL_HOME} /home/coremail${VER}_x${BIT}_${DATE}
    ln -nsf /home/coremail${VER}_x${BIT}_${DATE} ${COREMAIL_HOME}
    ${COREMAIL_HOME}/sbin/cmctrl.sh start
}

if [[ -L ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
	    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
	\rm ${COREMAIL_HOME}
    install_coremail
elif [[ -d ${COREMAIL_HOME} ]]; then
    if [[ ! -z ${CMPROC} ]] ; then
	    ${COREMAIL_HOME}/sbin/cmctrl.sh stop
    fi
	mv ${COREMAIL_HOME} /home/coremail${CMVER}_${DATE}_dn 
    install_coremail
else
    install_coremail
fi

install_url() {
    LOCAL_IP=`/sbin/ifconfig -a | awk '/inet/{print $2}' | awk -F: '{print $2}' | grep -v "127.0.0.1" | grep -v '^$' | sort`
    WEBINSTPATH="/webinst/"
    echo "Unpack OK! Browse the URL below to configure coremail:"
    echo "      http://${LOCAL_IP}${WEBINSTPATH}"
}
install_url