#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

COS_ID=$1
EXPIRE_DATE=$2
USERUTIL=/home/coremail/bin/userutil
LOG_DATE=`date +"%Y-%m-%d-%s"`

[[ "$COS_ID" =~ "^[0-9]+$" ]] || echo Please input the correct cos id 1 or 4 || exit
[[ "$EXPIRE_DATE" =~ "^[0-9]+$" ]] || echo Please input the correct number of days || exit

${USERUTIL} --select-expire-user D$EXPIRE_DATE  >> /tmp/tmp1.txt

for i in `awk '{print $1}' < /tmp/tmp1.txt` ; do
  ${USERUTIL} --get-user-attr $i cos_id | grep "cos_id=${COS_ID}" | awk -F : '{print $1}' >> /tmp/tmp.txt
done

show_expire_user()
{
  for s in `cat /tmp/tmp.txt` ; do
    grep $s /tmp/tmp1.txt >>  show_exprire_user.${LOG_DATE}.log
  done
  [[ -f show_exprire_user.${LOG_DATE}.log ]] && cat show_exprire_user.${LOG_DATE}.log

}

del_expire_user()
{
  for s in `cat /tmp/tmp.txt` ; do
    grep $s /tmp/tmp1.txt >>  del_expire_user.${LOG_DATE}.log
    ${USERUTIL} --delete-user $s >> del_expire_user.${LOG_DATE}.log
  done
  [[ -f del_expire_user.${LOG_DATE}.log ]] && cat del_expire_user.${LOG_DATE}.log

}

case $3 in
del | -d )
    del_expire_user;;
show | -s )
    show_expire_user;;
*)
    echo "Usage: $0 1 300 -s show cos_id=1 300 day not login | 1 300 -d del cos_id=1 300 day not login users";;
esac

\rm /tmp/tmp*.txt
