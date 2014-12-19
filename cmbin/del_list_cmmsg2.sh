#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

KEYWORD=$3
SEND_USER=$2

[[ -z ${KEYWORD} ]] && echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg " && exit
[[ -z ${SEND_USER} ]] && echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg " && exit


USER_LIST=`/home/coremail/bin/userutil --select-user @`

list_unread_msginfo()
{
	for u in ${USER_LIST[@]} ; do 
    	/home/coremail/bin/userutil --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | grep "\.\." | grep ${KEYWORD} |  awk '{if($9="'${SEND_USER}'")print $0}'  >> /tmp/unreadlog 
	done
	tail /tmp/unreadlog
}

list_need_msginfo()
{
	for u in ${USER_LIST[@]} ; do 
    	/home/coremail/bin/userutil --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | grep ${KEYWORD} | awk '{if($9="'${SEND_USER}'")print $0}' >> /tmp/alllog 
	done
	tail /tmp/alllog
}

case $1 in
--list-all | -la )
    list_unread_msginfo;;
--list-unread  | -lu )
    list_need_msginfo;;
*)
    echo "Usage: $0 -l list email_id keyword msginfo| -d del email_id keyword need msg ";;
esac

