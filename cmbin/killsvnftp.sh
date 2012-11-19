#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

SVNPROC=`ps aux | grep svn | grep -v grep | awk '{print $2}'`
FTPPROC=`ps aux | grep wget | grep -v grep | awk '{print $2}'`

[ -n "${SVNPROC}" ] && kill -9 $SVNPROC
[ -n "${FTPPROC}" ] && kill -9 $FTPPROC
