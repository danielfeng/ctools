#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

PACKAGE=$1
DATA=`date +"%Y_%m_%d"`
PA_LIST=`tar -tf ${PACKAGE} | egrep -v "/$"`
CM_MOD=`tar -tf ${PACKAGE} | egrep -v "/$" | grep "libexec" | awk -F/ '{print $2}'`
[ -z ${PACKAGE} ] && echo "Usage: $0 <PACKAGE NAME>" && exit

backup_app()
{
	for i in ${PA_LIST[@]} ; do
		cp ${COREMAIL_HOME}/${i}{,.bk_${DATA}}
	done
	tar -xvzf ${PACKAGE} -C ${COREMAIL_HOME}
	for c in ${PA_LIST[@]} ; do
		chmod -R coremail:coremail ${COREMAIL_HOME}/${c}
	done
	for m in ${CM_MOD[@]}; do
		${COREMAIL_HOME}/bin/coremail restart ${m}
	done 
}


restore_bk()
{
	for i in ${PA_LIST[@]} ; do
		cp ${COREMAIL_HOME}/${i}.bk_${DATA} ${COREMAIL_HOME}/${i}
	done
}
