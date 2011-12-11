#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

echo 'PS1="\[\e[01;33m\A \e[01;35m\u\e[01;30m@\e[01;32m\h\] \e[0m[\e[01;34m\W\e[0m] "' >> /root/.bashrc
echo "alias grep='grep --color=auto'" >> /root/.bashrc
echo "alias egrep='egrep --color=auto'" >> /root/.bashrc
echo "alias fgrep='fgrep --color=auto'" >> /root/.bashrc
echo "alias ls='ls --color=auto'" >> /root/.bashrc
echo "alias lt='ls -lt'" >> /root/.bashrc

echo "export COREMAIL_HOME=/home/coremail" >> /root/.bashrc
echo "export JAVA_HOME=/home/coremail/java/jre1.6.0_11" >> /root/.bashrc
echo "export TOMCAT_HOME=/home/coremail/java/tomcat" >> /root/.bashrc
echo "export LC_ALL=zh_CN.gbk" >> /root/.bashrc
echo "export LANG=zh_CN.gbk" >> /root/.bashrc
echo "export HISTTIMEFORMAT=\"%Y-%m-%d_%H:%M:%S \" " >> /root/.bashrc


source /root/.bashrc
