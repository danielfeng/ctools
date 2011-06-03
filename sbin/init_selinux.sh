#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

#关闭selinux

grep -q SELINUX=disabled /etc/selinux/config || sed -i '/^SELINUX=enforcing/aSELINUX=disabled' /etc/selinux/config 
sed -i 's/^SELINUX=enforcing/#SELINUX=enforcing/g' /etc/selinux/config 

setenforce 0
