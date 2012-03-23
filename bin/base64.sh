#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com


cat $1 | while read i
do 
  echo -en "$i\n" | base64 -d
  echo
done >>nbase64
