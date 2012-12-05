#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

rpm -q fuse-sshfs  ||  yum -y install fuse-sshfs

echo "Usage: sshfs root@远程挂载主机IP地址:/目录 /目标目录"
echo "Usage: 卸载 fusermount -u 目标目录"
