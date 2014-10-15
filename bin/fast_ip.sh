#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

IP_LIST=(
"107.170.212.37" \
"198.199.93.163" \
"173.230.146.18" \
"199.15.115.235" \
"173.224.223.119" \
"173.224.210.84" \
"27.120.105.156" \
"192.210.58.131" \
"23.239.116.123" \
"198.13.107.85" \
"173.208.232.4" \
"198.13.105.187" \
"74.117.61.150" \
"23.239.107.126" \
"96.44.135.85" \
"162.250.190.238" \
"178.62.29.177" \
"37.235.54.143" \
"82.211.34.41" \
"62.113.205.98" \
"151.236.23.216" \
"37.59.65.63" \
"108.61.209.155" \
"158.255.0.66" \
"146.0.79.217" \
"78.109.30.239" \
"151.236.26.50" \
"149.154.157.167" \
"60.249.122.70" \
"125.227.248.20" \
"203.69.59.208" \
"119.81.168.178" \
"124.248.205.115" \
"27.122.15.92" \
"106.185.41.112" \
"157.7.236.200" \
"157.7.204.210" \
"153.121.59.108" \
"106.185.27.124" \
"103.233.80.21" \
"110.34.191.130" \
"116.251.217.85" \
"128.199.149.111" \
"103.1.154.72" \
"49.143.205.24" \
"101.55.33.86" \
"103.25.58.60" \
)

for i in ${IP_LIST[@]}; do ping -c 1 $i | grep "bytes from"; done 
