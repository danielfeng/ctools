#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CONF=/home/ctools/conf
YUM=/etc/yum.repos.d/

rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm

cp $CONF/CentOS-Base.repo $YUM
