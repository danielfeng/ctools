#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com



CM_FILE_BACKUP=${COREMAIL_HOME}/cm_file_bak_`date +%F`
NEW_CM_FILE=./cm_update_file
DIR=$(dirname `pwd`/$0)
COREMAIL_HOME=/home/coremail

restart_clean_tomcat(){
    rm -rf ${COREMAIL_HOME}/java/tomcat/work/*
    echo "Clean tomcat cache..."
    ${COREMAIL_HOME}/bin/coremail restart tomcat
}


backup_file(){
	if [[ ! -d ${NEW_CM_FILE} ]]; then
		echo "Not found ${NEW_CM_FILE},you need to create this directory " && exit 1
	elif [[ ! -d ${CM_FILE_BACKUP} ]]; then
		mkdir ${CM_FILE_BACKUP} && echo "Create ${CM_FILE_BACKUP} OK!"
		for i in `cd ${NEW_CM_FILE} && find . -name "*" -type f`; do
			cd ${COREMAIL_HOME} && cp --parents $i ${CM_FILE_BACKUP}
			echo "Backup coremail file ${COREMAIL_HOME}/$i to ${CM_FILE_BACKUP}/$i OK!"
		done
		
	else
		echo "Can not repeat backup coremail file file! If repeat backup file you need delete ${CM_FILE_BACKUP}" && exit 1
	fi

}

update_file(){
	cd ${DIR}
	if [[   -d ${NEW_CM_FILE} ]]; then
		for i in `cd ${NEW_CM_FILE} && find . -name "*" -type f`; do
			\cp ${NEW_CM_FILE}/$i ${COREMAIL_HOME}/$i
			chown coremail. ${COREMAIL_HOME}/$i
			echo "Update file ${NEW_CM_FILE}/$i to ${COREMAIL_HOME}/$i OK"
		done
		
	else
		echo "Not found need update coremail file!"
	fi
    restart_clean_tomcat
}

restore_file()
{
	if [[   -d ${CM_FILE_BACKUP} ]]; then
		for i in `cd ${CM_FILE_BACKUP} && find . -name "*" -type f`; do
			\cp ${CM_FILE_BACKUP}/$i ${COREMAIL_HOME}/$i
			chown coremail. ${COREMAIL_HOME}/$i
			echo "Restore file ${CM_FILE_BACKUP}/$i to ${COREMAIL_HOME}/$i ok "
		done
	else
		echo "Not found update coremail file backup!"
	fi
    restart_clean_tomcat
}



case $1 in
restore | -r )
    restore_file;;
change | -c )
    backup_file
    update_file;;
*)
    echo "Usage: $0 -r restore cm_file || -c change cm_file";;
esac

