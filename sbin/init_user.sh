#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CMUSER=`grep ^coremail /etc/passwd`

if [[ -z ${CMUSER} ]]; then
    useradd coremail
else
    exit
fi
