#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

. ${CTOOLS}/functions
i_need_yum ntp
cp ${CTOOLS}/etc/sysconfig/ntpd /etc/sysconfig/ntpd
srv_restart ntpd
