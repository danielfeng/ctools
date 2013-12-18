#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

i   =`df | grep /home | awk ‘{sub(“%”,””,$5);print $5 }’`
if [ “$i” -gt “90” ];then
	str =”`hostname` File System at $i”
	echo $str | mail -s “`hostname` Alert” danielfancy@gmail.com
fi