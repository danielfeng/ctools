#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

service sendmail stop
service iptables stop

chkconfig sendmail off
chkconfig iptables off


chkconfig portmap off     	#NIS 和NFS 提供动态端口的分配
chkconfig cups off       	#Common UNIX Printing System
chkconfig nfslock off		#NFS file lock
#chkconfig apmd off		#Advanced Power Management
chkconfig bluetooth off		
chkconfig hidd off		#Bluetooth H.I.D service
chkconfig gpm off		#General Purpose Mouse Daemon
chkconfig ip6tables off		
chkconfig pcscd off		#读卡器	
chkconfig xfs off		#x font server
#chkconfig netfs off			
chkconfig autofs off		#cd auto
chkconfig avahi-daemon off      #发现基于zeroconf协议的设备
chkconfig auditd off		#审核守护进程
#chkconfig haldaemon off
chkconfig rpcidmapd off		#redhat update software
chkconfig rpcgssd   off		#redhat update software
chkconfig isdn off		#isdn modem
chkconfig httpd off


service httpd stop
service portmap stop
service cups stop 
service nfslock stop
#service apmd stop
service bluetooth stop
service hidd stop
service gpm stop
service ip6tables stop
service pcscd stop
service xfs stop
#service netfs stop
service autofs stop
service avahi-daemon stop
service auditd stop
#service haldaemon stop
service rpcidmapd stop
service rpcgssd stop
service isdn stop
