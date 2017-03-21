#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

VZ_ID=$2
HOSTNAME=$3
OS_ID=$4

[[ -z ${HOSTNAME} ]] && echo "Please input hostname"
[[ ${OS_ID} -gt 6 && ${OS_ID} -lt 5 ]] && echo "Please input OS_ID 5-6" && exit
[[ ${VZ_ID} -gt 100 && ${VZ_ID} -lt 50 ]] && echo "Please input VZ_ID 50-100" && exit

check_ip()
{
	ping -c 2 192.168.173.${VZ_ID} >/dev/null 2>&1
	status=$?
    if [ $status = 1 ];then
        continue 
    else
        echo "IP 192.168.173.${VZ_ID} exists" && exit
    fi
}

create_os()
{
	echo "Create 1${VZ_ID} OS..." && \
	vzctl create 1${VZ_ID} --ostemplate centos-${OS_ID}-x86_64 && \
	echo "Change 1${VZ_ID} config..." && \
	vzctl set 1${VZ_ID} --onboot yes --save && \
	vzctl set 1${VZ_ID} --ipadd 192.168.173.${VZ_ID} --save && \
	vzctl set 1${VZ_ID} --nameserver 192.168.173.1 --save && \
	vzctl set 1${VZ_ID} --hostname ${HOSTNAME}${OS_ID}-${VZ_ID} --save && \
	vzctl set 1${VZ_ID} --diskspace 60G:60G --save && \
	vzctl set 1${VZ_ID} --features nfs:on --save && \
	vzctl set 1${VZ_ID} --physpages 0:1024M --save && \
	vzctl set 1${VZ_ID} --diskinodes 400000000:400000000 --save && \
	echo "Wait start 1${VZ_ID} os..." && \
	vzctl start 1${VZ_ID} && \
	echo "Input ${HOSTNAME} password" && \
	vzctl exec 1${VZ_ID} passwd  
}

destroy_os()
{
	vzctl stop 1${VZ_ID}
	vzctl destroy 1${VZ_ID}
}

case $1 in
 -d )
    destroy_os ;;
 -dc )
    destroy_os && check_ip && create_os;;
 -c )
    check_ip && create_os;;
*)
    echo "Usage: -d destroy_os | -dc destroy_os and create_os | -c create_os";;
esac

