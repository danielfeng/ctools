#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CONF_NAME=`ls -l /home/coremail/conf/$1.cf 2>/dev/null | awk '{print $NF}' `
TAG_NAME=`echo "$2" | sed 's@/@\\\/@g'`

if [[ -f ${CONF_NAME} ]] ; then
    KEY_NAME=`awk -F "=" '/\['"${TAG_NAME}"'\]/{a=1}a==1&&$1~/'"$3"'/{print $2;exit}' ${CONF_NAME}`
    if [[ -z ${KEY_NAME} ]] ; then
        echo "Input $2 or $3 not right key"
        exit
    else
        echo $2 $3"=${KEY_NAME}"
    fi
else
    echo "Input $1.cf is not true coremail configuration file"
    exit
fi

