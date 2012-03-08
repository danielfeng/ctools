#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

COREMAIL_HOME=/home/coremail

cp $COREMAIL_HOME/sbin/cmctrl.sh /etc/init.d/coremail  || exit 1
chmod a+x /etc/init.d/coremail  || exit 1
echo "Checking runlevel information for coremail services"
/sbin/chkconfig --add coremail  || exit 1
/sbin/chkconfig --list coremail

