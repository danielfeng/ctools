#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


CONF=/home/ctools/conf
RSYNC=/etc/



if [ -f ${YUM}/rsyncd.conf ] ; then
    mv ${YUM}/rsyncd.conf ${YUM}/rsyncd.conf.original
    cp ${CONF}/rsyncd.conf ${YUM}
    chmod 644 ${YUM}/rsyncd.conf
    chown root:root ${YUM}/rsyncd.conf
else
    cp ${CONF}/rsyncd.conf ${YUM}
    chmod 644 ${YUM}/rsyncd.conf
    chown root:root ${YUM}/rsyncd.conf
fi

/usr/bin/rsync --daemon
