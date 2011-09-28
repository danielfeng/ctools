#!/bin/bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

grep -q "set nu" /etc/virc || sed -i '4iset nu' /etc/virc
grep -q "set nu" /etc/vimrc || sed -i '4iset nu' /etc/vimrc
