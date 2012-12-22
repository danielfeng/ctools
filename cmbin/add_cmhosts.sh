#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CMHOSTS=${COREMAIL_HOME}/conf/hosts.cf
HOSTS=/etc/hosts

grep -E "\[|IP" $CMHOSTS | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' >> $HOSTS


