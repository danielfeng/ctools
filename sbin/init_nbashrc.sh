#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

BASHRC=~/.bashrc

PS1=`grep "PS1=" ${BASHRC}`
if [[ -z ${PS1} ]] ; then
    echo 'PS1="\[\e[01;33m\A \e[01;35m\u\e[01;30m@\e[01;32m\h\] \e[0m[\e[01;34m\W\e[0m] "' >> ${BASHRC}
fi

OLDRM="alias rm='rm -id'"
NEWRM="alias rm='rm -i --preserve-root'"
grep -q "${OLDRM}" ${BASHRC} && sed -i "s@${OLDRM}@${NEWRM}@g" ${BASHRC}

BASHRC_LIST=(
"alias grep='grep --color=auto'" \
"alias egrep='egrep --color=auto'" \
"alias ls='ls --color=auto'" \
"alias lt='ls -lt'" \
"alias la='ls -A'" \
"alias c='clear'" \
"export COREMAIL_HOME=/home/coremail" \
"export JAVA_HOME=/home/coremail/java/jre1.6.0_11" \
"export TOMCAT_HOME=/home/coremail/java/tomcat" \
"export LC_ALL=zh_CN.gbk" \
"export LANG=zh_CN.gbk" \
"export HISTTIMEFORMAT=\"%Y-%m-%d_%H:%M:%S \" " \
"export GROUPSEND_HOME=/home/groupsend" \
"export PATH=$PATH:/home/coremail/bin" \
"export CTOOLS=/home/ctools" \
)
#BASHRC_LIST=$IFS
IFS="\\"
for i in ${BASHRC_LIST[@]} ; do
    STRING=`grep $i ${BASHRC}`
    [[ -z ${STRING} ]] && echo "$i" >> ${BASHRC}
done
IFS=${BASHRC_LIST}

#source ~/.bashrc
