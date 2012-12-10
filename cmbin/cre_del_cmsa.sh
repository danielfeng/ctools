#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

HOSTNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Server |awk -F\" '{print $2}')
USERNAME=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep User|awk -F\" '{print $2}')
PASSWORD=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Password |awk -F\" '{print $2}')
PORT=$(grep cm_logs_db /home/coremail/conf/datasources.cf -5 | grep Port |awk -F\" '{print $2}')
USERUTIL=/home/coremail/bin/userutil
CSA=/home/coremail/bin/createsa
MYSQL=/home/coremail/mysql/bin/mysql
ADMIN=coremail123
SAPASSWORD=core@mail
SA="select td_site_admin.provider_id,org_id,domain_name from td_site_admin,td_domain where admin_type=\"SA\" and domain_id="1" into outfile '/tmp/a.txt';"

existsa()
{
    USER=`/home/coremail/bin/userutil --display $ADMIN | head -1 | awk '{print $1}'`
    [ "$USER" == "User:" ] && echo "User Exist $ADMIN, Usage: $0 -d or del $ADMIN" && exit 1

}

createsa()
{
    existsa
    $MYSQL cmxt -e "$SA" -u${USERNAME} -p$PASSWORD -P${PORT} -h${HOSTNAME}
    ATTR=`head -1 /tmp/a.txt`
    $CSA $ATTR $ADMIN $SAPASSWORD
    RMTMP=`\rm /tmp/a.txt`
}

delsa()
{
    $MYSQL cmxt -e "$SA" -u${USERNAME} -p$PASSWORD -P${PORT} -h${HOSTNAME}
    DN=`head -1 /tmp/a.txt | awk '{print $3}'`
    $USERUTIL --delete-user $ADMIN@$DN
    RMTMP=`\rm /tmp/a.txt`
}

case $1 in
del | -d )
    delsa;;
add | -a )
    createsa;;
*)
    echo "Usage: $0 -a add $ADMIN sa -d del $ADMIN sa";;
esac
