#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

USER_CNT=$2
USERUTIL=/home/coremail/bin/userutil
MYSQL=/home/coremail/mysql/bin/mysql
HOSTNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server |awk -F\" '{print $2}')
USERNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep User|awk -F\" '{print $2}')
PASSWORD=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Password |awk -F\" '{print $2}')
PORT=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Port |awk -F\" '{print $2}')
SA="select td_site_admin.provider_id,org_id,domain_name from td_site_admin,td_domain where admin_type=\"SA\" and domain_id="1" into outfile '/tmp/1a.txt';"

[[ -z ${USER_CNT} ]] && echo "Usage: $0 -a add 100 | -d Delete 100 Create/Delete one hundred coremail users" && exit

$MYSQL cmxt -e "$SA" -u${USERNAME} -p$PASSWORD -P${PORT} -h${HOSTNAME}
PRO=`awk '{print $1}' /tmp/1a.txt`
ORG=`awk '{print $2}' /tmp/1a.txt`
DOMAIN=`awk '{print $3}' /tmp/1a.txt`

create_user()
{
	for i in `seq ${USER_CNT}`; do
		${USERUTIL} --fast-create-user auto_${i}@${DOMAIN} 123 p=${PRO}\&o=${ORG}\&c=1
	done
	\rm /tmp/1a.txt
}

delete_user()
{
	for i in `seq ${USER_CNT}`; do
		${USERUTIL} --delete-user auto_${i}@${DOMAIN} 
	done
	\rm /tmp/1a.txt
}

case $1 in
del | -d )
    delete_user;;
add | -a )
    create_user;;
*)
    echo "Usage: $0 -a add 100 | -d Delete 100 Create/Delete one hundred coremail users";;
esac
