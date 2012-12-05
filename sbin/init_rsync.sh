#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

rpm -q rsync || yum -y install rsync

CONF=/home/ctools/conf
ETC=/etc/

if [ -f ${ETC}/rsyncd.conf ] ; then
    mv ${ETC}/rsyncd.conf ${ETC}/rsyncd.conf.original
    cp ${CONF}/rsyncd.conf ${ETC}
    chmod 644 ${ETC}/rsyncd.conf
    chown root:root ${ETC}/rsyncd.conf
else
    cp ${CONF}/rsyncd.conf ${ETC}
    chmod 644 ${ETC}/rsyncd.conf
    chown root:root ${ETC}/rsyncd.conf
fi

/usr/bin/rsync --daemon

echo "Usage:数据源执行 rsync -aSvh --delete /home/coremail root@IP地址::coremail"
