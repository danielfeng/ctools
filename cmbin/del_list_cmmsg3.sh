#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

FILE=$2

[[ -z ${FILE} ]] && echo "Usage: $0 -da del all msg | -du del del unread msg " && exit

USERUTIL="/home/coremail/bin/userutil"

del_all_msg()
{ 
  cat ${FILE} | awk -F "," '{print $2" "$9}' | awk -F "=|=<" '{print $2":"$3}' | sed 's/> mid//g' > /tmp/alllog
  for d in `cat /tmp/alllog | sort | uniq ` ; do  
        ${USERUTIL} --delete-msg ${d%%:*} ${d##*:}
  done;
  rm /tmp/alllog
}

del_unread_msg()
{
  cat ${FILE} | awk -F "," '{print $2" "$9}' | awk -F "=|=<" '{print $2":"$3}' | sed 's/> mid//g' > /tmp/alllog
  for d in `cat /tmp/alllog  | sort | uniq ` ; do  
        ${USERUTIL} --list-msg ${d%%:*} | grep ${d##*:} | grep " \.\. " | sed 's/^1 /'${d%%:*}':/g' | awk '{print $1}' >> /tmp/unread.log
        #${USERUTIL} --list-msg ${d%%:*} | grep ${d##*:} | grep " .. " | sed 's/^1 /'${d%%:*}':/g' | awk '{print $1}' >> /tmp/unread.log
  done;
  for i in `cat /tmp/unread.log` ; do
  	 ${USERUTIL} --delete-msg ${i%%:*} ${i##*:}
  done;
#  rm /tmp/unread.log && rm /tmp/alllog
}  


case $1 in
--del-all | -da )
    del_all_msg;;
--del-unread  | -du )
    del_unread_msg;;
*)
    echo "Usage: $0 -da del all msg | -du del del unread msg. Please da need del log";;
esac

