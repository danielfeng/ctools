#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CTOOLS=/home/ctools
NTPDCONF=/etc/sysconfig/ntpd
. ${CTOOLS}/functions
#SYNC_HWCLOCK=no

i_need_yum ntp
srv_stop ntp
ntpdate time.windows.com && hwclock -w
grep -q "SYNC_HWCLOCK=no" ${NTPDCONF} || sed -i "s#SYNC_HWCLOCK=no#SYNC_HWCLOCK=yes#g" ${NTPDCONF}
srv_start ntpd
