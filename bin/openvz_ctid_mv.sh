#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

# 实际测试中会出现负载过高导致部分虚拟机移动失败

CTID=`vzlist | awk '{print $1}' | grep '^\([0-9][0-9]\)$'`
FILE_LOG=/tmp/vzid_move.log

for i in $CTID; do
	vzctl chkpnt $i --dumpfile /tmp/Dump.$i >> $FILE_LOG
	mv /etc/vz/conf/$i.conf /etc/vz/conf/1$i.conf
	mv /vz/private/$i /vz/private/1$i
	mv /vz/root/$i /vz/root/1$i
	vzctl restore 1$i --dumpfile /tmp/Dump.$i >> $FILE_LOG
done

