#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


CONF=/home/ctools/conf
YUM=/etc/yum.repos.d
OS=$(getconf LONG_BIT)


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

#rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm

if [ $OS -eq 64 ]; then
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm
else
    rpm -ivh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
fi



