#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

ctools=/home/ctools
git=/usr/local/bin/git
release=/var/share/release
logs=/home/ctools/logs

hctools ()
{
    cd $ctools 
    echo "`date +%y-%m-%d-%h`" >>$logs/hctools.log
    $git pull >>$logs/hctools.log 
}

rctools()
{
    cd $release
    echo "`date +%y-%m-%d-%h`" >>$logs/rctools.log
    $git pull >>$logs/rctools.log
}

zrctools()
{
    cd $release
    [[ -a ctools.tgz ]] && rm ctools.tgz
    tar zcf ctools.tgz ctools/
}

hctools
rctools
zrctools

