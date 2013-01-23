#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DATA=`date +"%Y_%m_%d"`
MAIL_CNT=$1
EMAIL=$2

[[ -z ${MAIL_CNT} ]] && echo "Usage: $0 <MAIL_CNT> <EMAIL>" && exit
[[ -z ${EMAIL} ]] && echo "Usage: $0 <MAIL_CNT> <EMAIL>" && exit
#[[ "${MAIL_CNT}" != *[!0-9]* ]] && echo "Usage: $0 <MAIL_CNT> <EMAIL>" && exit

for i in `seq ${MAIL_CNT}`; do
    mail -s "test $i ${DATA}" ${EMAIL}<<EOF
    hello, this is auto send test $i mail 
EOF
done

