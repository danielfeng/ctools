#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

CM_HOME="/home/coremail"

PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
export PATH

echo "查找coremail安装包"
find /home/ /root/ -maxdepth 2 -name *.install.sh

echo "操作系统版本"
cat /etc/redhat-release

echo "检查coremail程序位数"
for x in `ls ${CM_HOME}/libexec/`; do file ${CM_HOME}/libexec/$x | awk -F "," '{print $1}';done

echo "检查coremail程序版本"
${CM_HOME}/bin/sautil --chkver --withC > /tmp/1 && for i in `ls ${CM_HOME}/libexec/`; do cat 1 | grep $i ; done && rm -f /tmp/1
