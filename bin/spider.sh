#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DEST=./URL_LIST
IMG_DIR="img"

echo "输入需要下载图片的网址"
read url 
curl ${url} | sed -n 's/.*src="\([^"]*[\.jpg|\.jpeg|\.gif|\.png]\)".*/\1/gp' > ${DEST}

[ -z ${DEST} ] && echo "该网址没有所需要图片" && exit

if [ ! -d ${IMG_DIR} ] ; then
    mkdir -p ${IMG_DIR}
fi

cd ${IMG_DIR}
while read line
do
    curl -O ${line}
done<../${DEST}
rm ../${DEST}

