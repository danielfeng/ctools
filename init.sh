#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

# Init danielfeng's Linux System

TOOLS_DIR=/home/ctools/sbin

if [ `id -u` -eq 0 ] ; then
	:
   else 
       	echo You must be root.
	exit
fi

$TOOLS_DIR/init_rc.sh
$TOOLS_DIR/init_selinux.sh
$TOOLS_DIR/init_bashrc.sh
$TOOLS_DIR/init_user.sh
$TOOLS_DIR/init_vi.sh
$TOOLS_DIR/init_yum.sh
#$TOOLS_DIR/init_rsync.sh
#$TOOLS_DIR/init_hostname.sh
#$TOOLS_DIR/init_vimrc.sh


exit
