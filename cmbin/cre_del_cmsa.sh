#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

USERUTIL=/home/coremail/bin/userutil
CSA=/home/coremail/bin/createsa
DN=`$USERUTIL --display admin | grep DN: | awk -F '=' '{print $3}' | awk -F ',' '{print $1}'`
ORG=`$USERUTIL --display admin | grep DN: | awk -F '=' '{print $6}' |  awk -F ';' '{print $1}'`
PRO=`$USERUTIL --display admin | grep DN: | awk -F ';' '{print $2}' | awk -F "=" '{print $2}' | awk -F ")" '{print $1}'`
ADMIN=coremail123
PASSWORD=core@mail
CMD=$1

if [ "$1" == "del" ]; then
    $USERUTIL --delete-user $ADMIN@$DN
else
    $CSA $PRO $ORG $DN $ADMIN $PASSWORD
fi

