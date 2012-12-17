#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

service_stop_list="sendmail iptables cups nfslock bluetooth hidd gpm ip6tables pcscd xfs autofs avahi-daemon auditd rpcidmapd rpcgssd isdn httpd"

for list in ${service_stop_list}; do
    [[ ! -f /etc/init.d/${list} ]] && continue
    LANG=C service ${list} stop
    LANG=C chkconfig ${list} off
done

## portmap      	#NIS 和NFS 提供动态端口的分配
#  cups        		#Common UNIX Printing System
#  nfslock 			#NFS file lock
## apmd 			#Advanced Power Management
#  hidd 			#Bluetooth H.I.D service
#  gpm 				#General Purpose Mouse Daemon
#  pcscd 			#读卡器	
#  xfs 				#x font server
#  autofs 			#cd auto
#  avahi-daemon     #发现基于zeroconf协议的设备
#  auditd 			#审核守护进程
#  rpcidmapd 		#redhat update software
#  rpcgssd   		#redhat update software
#  isdn 			#isdn modem