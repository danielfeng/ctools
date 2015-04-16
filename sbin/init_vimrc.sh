#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

CONF=/home/ctools/conf
VIM=/home/ctools/conf/vim
ETC=/etc

if [ -d ~/.vim ]; then
    cp -r ${VIM}/* ~/.vim
else
    mkdir ~/.vim
    cp -r ${VIM}/* ~/.vim
fi

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
