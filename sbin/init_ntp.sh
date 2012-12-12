#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

. ${CTOOLS}/functions
NTPDCONF=/etc/sysconfig/ntpd
SYNC_HWCLOCK=no

i_need_yum ntp
grep -q "SYNC_HWCLOCK=no" ${NTPDCONF} || sed -i "s#SYNC_HWCLOCK=no#SYNC_HWCLOCK=yes#g" ${NTPDCONF}
srv_restart ntpd
