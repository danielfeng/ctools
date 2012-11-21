#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

killsvn ()
{
    SVNPROC=`ps aux | grep svn | grep -v grep | awk '{print $2}'`
    [ -n "${SVNPROC}" ] && kill -9 $SVNPROC
}

killftp()
{
    FTPPROC=`ps aux | grep wget | grep -v grep | awk '{print $2}'`
    [ -n "${FTPPROC}" ] && kill -9 $FTPPROC
}

killftp
killsvn

