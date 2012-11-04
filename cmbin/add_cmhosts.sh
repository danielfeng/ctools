#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


CMHOSTS=/home/home/coremail/conf/hosts.cf
HOSTS=/etc/hosts

grep -E "\[|IP" $CMHOSTS | xargs -n2 | awk '{print $2" "$1}' | sed 's/IP=//;s/\[//;s/\]//' >> $HOSTS


