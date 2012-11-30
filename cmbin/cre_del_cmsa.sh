##!/usr/bin/env bash
## Author : danielfeng
## E-Mail : danielfancy@gmail.com
#
#USERUTIL=/home/coremail/bin/userutil
#CSA=/home/coremail/bin/createsa
#DN=`$USERUTIL --display admin | grep DN: | awk -F '=' '{print $3}' | awk -F ',' '{print $1}'`
#ORG=`$USERUTIL --display admin | grep DN: | awk -F '=' '{print $6}' |  awk -F ';' '{print $1}'`
#PRO=`$USERUTIL --display admin | grep DN: | awk -F ';' '{print $2}' | awk -F "=" '{print $2}' | awk -F ")" '{print $1}'`
#ADMIN=coremail123
#PASSWORD=core@mail
#CMD=$1
#
#if [ "$1" == "del" ]; then
#    $USERUTIL --delete-user $ADMIN@$DN
#else
#    $CSA $PRO $ORG $DN $ADMIN $PASSWORD
#fi
#------------------------------------------

#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

HOSTNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server |awk -F\" '{print $2}')
USERNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep User|awk -F\" '{print $2}')
PASSWORD=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Password |awk -F\" '{print $2}')
PORT=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Port |awk -F\" '{print $2}')
IP=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server | awk -F\" '{print $2}')
USERUTIL=/home/coremail/bin/userutil
CSA=/home/coremail/bin/createsa

CMD=$1
MYSQL=/home/coremail/mysql/bin/mysql
ADMIN=coremail123
SAPASSWORD=core@mail

SA="select td_site_admin.provider_id,org_id,domain_name from td_site_admin,td_domain where admin_type=\"SA\" and domain_id="1" into outfile '/tmp/a.txt';"
TMP="show tables;"

$MYSQL cmxt -e "$SA" -u$USERNAME -p$PASSWORD -P${PORT} -h${IP}

ATTR=`head -1 /tmp/a.txt`
DN=`head -1 /tmp/a.txt | awk '{print $3}'`

if [ "$1" == "del" ]; then
    $USERUTIL --delete-user $ADMIN@$DN
else
    $CSA $ATTR $ADMIN $SAPASSWORD
fi

