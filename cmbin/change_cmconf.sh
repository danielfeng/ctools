#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CMCONF_DIR=${COREMAIL_HOME}/conf
CMCONF_MAIN_DIR=${COREMAIL_HOME}/var/mainconfig
CMCONF_BACKUP=${COREMAIL_HOME}/conf_bak_`date +%F`
NEW_CONF=./cm_change_conf
CM_CONFUNTIL=./confutil 
DIR=$(dirname `pwd`/$0)


backup_conf(){
	if [[ ! -d ${NEW_CONF} ]]; then
  		echo "Not found ${NEW_CONF}" && exit 8
	elif [[ ! -d ${CMCONF_BACKUP} ]]; then
		mkdir ${CMCONF_BACKUP}
		for i in `cd ${NEW_CONF} && ls *.cf`; do
			cp ${CMCONF_DIR}/$i ${CMCONF_BACKUP} 
            echo "Backup ${CMCONF_DIR}/$i to ${CMCONF_BACKUP} ok!"
		done
	else
		echo "Can not repeat backup coremail conf file! If repeat backup conf you need delete ${CMCONF_BACKUP}" && exit 1
	fi

}

change_conf(){
	grep "IamMainAdminSvr=\"1\"" ${CMCONF_DIR}/coremail.cf ||  echo "This is not main adminsvr, Cannot run this machine." || exit 1
	if [[  -d ${NEW_CONF} ]]; then
		for i in `cd ${NEW_CONF} && ls *.cf`; do
			\cp ${NEW_CONF}/$i ${CMCONF_DIR}
            echo "Change ${NEW_CONF}/$i to ${CMCONF_DIR} ok!"
			\cp ${NEW_CONF}/$i ${CMCONF_MAIN_DIR}
            echo "Change ${NEW_CONF}/$i to ${CMCONF_MAIN_DIR} ok!"
		done
		$CM_CONFUNTIL --flushall
	else
		echo "Not found new coremail conf file!"
	fi
}

restore_conf(){
	if [[  -d ${CMCONF_BACKUP} ]]; then
		for i in `cd ${CMCONF_BACKUP} && ls *.cf`; do
			\cp ${CMCONF_BACKUP}/$i ${CMCONF_DIR}
   			echo "Restore ${CMCONF_BACKUP}/$i to ${CMCONF_DIR} ok!"
			\cp ${CMCONF_BACKUP}/$i ${CMCONF_MAIN_DIR}
   			echo "Restore ${CMCONF_BACKUP}/$i to ${CMCONF_MAIN_DIR} ok!"
		done
		$CM_CONFUNTIL --flushall
	else
		echo "Not found coremail conf backup!"
	fi

}


case $1 in
restore | -r )
    restore_conf;;
change | -c )
    backup_conf
    change_conf;;
*)
    echo "Usage: $0 -r restore restore_conf || -c change change_conf";;
esac

