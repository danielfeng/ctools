#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

service sendmail stop
service iptables stop

chkconfig sendmail off
chkconfig iptables off
