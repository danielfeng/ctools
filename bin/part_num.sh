#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

PART=$1
NUM=$2
FILE=$3

[ -z ${PART} ] && echo "Usage: $0 段落号 行号 数据文件" && exit
[ -z ${NUM} ] && echo "Usage: $0 段落号 行号 数据文件" && exit
[ ! -f ${FILE} ] && echo "Usage: $0 段落号 行号 数据文件" && exit

sed -n '/*/!{h;:1 n;/^$/!{H;$!b1};z;x;s/\n/ /g;p}' ${FILE} | sed -n ${PART},${PART}p | awk '{print $'${NUM}'}'
