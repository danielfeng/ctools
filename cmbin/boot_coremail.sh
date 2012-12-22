#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

COREMAIL_HOME=/home/coremail

chk_cmsvr(){
	/sbin/chkconfig --add mtcoremail || exit 1
	/sbin/chkconfig --list mtcoremail
}

if [[ ! -f /etc/init.d/mtcoremail ]]; then
	cp $COREMAIL_HOME/sbin/cmctrl.sh /etc/init.d/mtcoremail  || exit 1
	chmod a+x /etc/init.d/mtcoremail  || exit 1
	echo "Checking runlevel information for coremail services"
	chk_cmsvr
else
	chk_cmsvr
	echo "Added runlevel information for coremail services"
fi


