#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


CONF=/home/ctools/conf
YUM=/etc/yum.repos.d



if [ -f ${YUM}/CentOS-Base.repo ] ; then
    mv ${YUM}/CentOS-Base.repo ${YUM}/CentOS-Base.repo.original
    cp ${CONF}/CentOS-Base.repo ${YUM}
    chmod 644 ${YUM}/CentOS-Base.repo
    chown root:root ${YUM}/CentOS-Base.repo
else
    cp ${CONF}/CentOS-Base.repo ${YUM}
    chmod 644 ${YUM}/CentOS-Base.repo
    chown root:root ${YUM}/CentOS-Base.repo
fi
