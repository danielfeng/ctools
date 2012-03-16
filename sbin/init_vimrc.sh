#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CONF=/home/ctools/conf
ETC=/etc



if [ -f ${ETC}/vimrc ] ; then
    mv ${ETC}/vimrc ${ETC}/vimrc.original
    cp ${CONF}/vimrc ${ETC}
    chmod 644 ${ETC}/vimrc
    chown root:root ${ETC}/vimrc
else
    cp ${CONF}/vimrc ${ETC}
    chmod 644 ${ETC}/vimrc
    chown root:root ${ETC}/vimrc
fi
