#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


ENCODED_TEXT=`echo $1 | awk -F '?' '{print $4}'` 

echo ${ENCODED_TEXT} | base64 -d 

