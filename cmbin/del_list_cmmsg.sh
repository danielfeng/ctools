#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

KEYWORD=$3
CM_USER=$2

[[ -z ${KEYWORD} ]] && echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg " && exit
[[ -z ${CM_USER} ]] && echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg " && exit


list_need_msginfo()
{
   ${COREMAIL_HOME}/bin/userutil --list-msg ${CM_USER} | grep "${KEYWORD}"
}

del_need_msg()
{
    KW_MID=`${COREMAIL_HOME}/bin/userutil --list-msg ${CM_USER} | grep "${KEYWORD}" | awk '{print $2}'`
	for mid in ${KW_MID} ; do
		${COREMAIL_HOME}/bin/userutil --delete-msg ${CM_USER} ${mid}
	done
}

case $1 in
--list | -l )
    list_need_msginfo;;
--del  | -d )
    del_need_msg;;
*)
    echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg ";;
esac