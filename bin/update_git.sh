#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

DIR=$1
[[ ! -d ${DIR} ]] && echo "Usage: $0 input include .git dirpath " && exit

cd ${DIR}
for dir in `find . -name ".git" | sed -n "s/\.git//gp"`;do
    cd $dir
    git pull
    cd -
done
