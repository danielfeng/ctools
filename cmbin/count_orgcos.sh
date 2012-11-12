#!/usr/bin/env bash

TJ=/home/TJ

if [ ! -d $TJ ]; then
        mkdir -p ${TJ}
fi

/home/coremail/bin/userutil --display @ > ${TJ}/display.txt
cat ${TJ}/display.txt | grep -A 4 "un=" | grep -v "UDID:\|Status:\|Group:" | awk '{print $2}'> ${TJ}/ds.txt

echo "统计不同组织下的用户数"
   sed '/^$/d' ${TJ}/ds.txt | xargs -n2 | awk -F 'org=' '{print $2}' | awk -F ';' '{print $1}' | sort| uniq -c

echo "统计不同服务等级下的用户数"
   sed '/^$/d' ${TJ}/ds.txt | xargs -n2 | awk '{print $2}' | sort| uniq -c

rm -rf ${TJ}

