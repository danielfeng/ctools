#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com


#FINDGLOBAL=`find /home/coremail* -name "global.cf"`
FINDGLOBAL=`ls -1 /home/coremail*/conf/global.cf | grep -v "/home/coremail/conf/global.cf$"`
NLICENSE="License=\"$1\""

if [[ -z $1 ]] ; then
    echo "Usage: $0 ***== input new license"
    exit
fi

for i in $FINDGLOBAL ; do
    LICENSE=`grep "^License=" $i`
    sed -i "s#${LICENSE}#${NLICENSE}#g" $i
done

