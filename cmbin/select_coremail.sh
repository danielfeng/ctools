# !/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

#CMDIR=`find /home/ -name "coremail.cf" | grep "/home/coremail" | awk -F "/conf" '{print $1}' | grep -v "/coremail$" | grep -v "/var"`
#MLOCATEDB=`locate coremail.cf 2>/dev/null`
#[[ -z ${MLOCATEDB} ]] && updatedb

DATE=`date +%Y%m%d`
TIME=`date +%H%M`
CMPROC=`ps aux | grep coremail | grep "/home/coremail/bin/coremail" | grep -v grep`
LSCMDIR=`echo /home/coremail*/conf/coremail.cf | awk '{for(i=1;i<=NF;i++)print $i}' |  grep -v "coremail/conf" | awk -F "/conf/" '{print $1}'`
CM_LINK_DIR=`ls -l /home/coremail | awk '{print $8" "$9" "$NF}'`

#LSCMDIR=`ls -d1 /home/coremail*/conf/coremail.cf | grep -v "coremail/conf" | awk -F "/conf/" '{print $1}'`
#CLOCMDIR=`locate coremail.cf | grep "^/home/coremail" | grep -v ".tpl" | awk -F/ '{print "/"$2"/"$3 }' | sort -u | wc -l`
#LOCMDIR=`locate coremail.cf | grep "^/home/coremail" | grep -v ".tpl" | awk -F/ '{print "/"$2"/"$3 }' | sort -u`

#[[ ${LSCMDIR} > ${CLOCMDIR} ]] && updatedb

if [[ -f ${COREMAIL_HOME}/libexec/udsvr ]] ; then
   CMVER=`${COREMAIL_HOME}/libexec/udsvr -v | head -1 | awk -F "(" '{print $1}' | awk '{print $3}' | sed 's/\.//g'`
fi

if [[ -f ${COREMAIL_HOME}/bin/sautil ]] ; then
   CM_VER=`/home/coremail/bin/sautil chkver --withC | head -1`
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

if [[ -z ${CMPROC} ]]; then
    echo "Not Coremail Runing:"
    echo "========================================================================================================================="
else
    echo -e "<==   \e[1;33m${CM_LINK_DIR}\033[0m   ==>"
    echo -e "\033[34;1m${CM_VER}\033[0m";
    #echo -e "The current version of the run is: \033[34;1m${CM_VER}\033[0m";
    echo "========================================================================================================================="
fi

select s in ${LSCMDIR[@]}
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
