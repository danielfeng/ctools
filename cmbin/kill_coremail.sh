#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


for i in `ps aux | grep coremail | grep -v grep | awk '{print $2}'` ; do
   if [ ! -z $i ]; then
     kill -9 $i
   fi  
done

