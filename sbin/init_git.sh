#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

rpm -q curl             ||  yum -y install curl
rpm -q crul-devel       ||  yum -y install curl-devel
rpm -q zlib-devel       ||  yum -y install zlib-devel
rpm -q openssl-devel    ||  yum -y install openssl-devel
rpm -q perl             ||  yum -y install perl
rpm -q cpio             ||  yum -y install cpio
rpm -q expat-devel      ||  yum -y install expat-devel
rpm -q gettext-devel    ||  yum -y install gettext-devel
rpm -q gcc              ||  yum -y install gcc
rpm -q autoconf         ||  yum -y install autoconf

URL=http://www.codemonkey.org.uk/projects/git-snapshots/git/git-2012-12-02.tar.gz
filename=`basename ${URL}`
dirname=`echo ${filename} | sed 's/.tar.gz//g'`

if [ -d /usr/local/src/${dirname} ]; then
   rm -rf /usr/local/src/${dirname} 
   mkdir -p /usr/local/src/${dirname}
else
   mkdir -p /usr/local/src/${dirname}
fi

wget -c -P /usr/local/src/ ${URL}
tar xzvf /usr/local/src/${filename} -C /usr/local/src/
cd /usr/local/src/${dirname}
autoconf
./configure --prefix=/usr/local/ || exit
make prefix=/usr/local all && make prefix=/usr/local install
