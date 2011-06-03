#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

sed -i '/^HOSTNAME=localhost.localdomain/aHOSTNAME=webmail' /etc/sysconfig/network
sed -i 's/^HOSTNAME=localhost.localdomain/#HOSTNAME=localhost.localdomain/g' /etc/sysconfig/network
