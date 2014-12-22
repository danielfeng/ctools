#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

KEYWORD=$2

[[ -z ${KEYWORD} ]] && echo "Usage: $0 -la -lu list email_id keyword msginfo| -d del email_id keyword need msg " && exit

USERUTIL="/home/coremail/bin/userutil"
USER_LIST=`${USERUTIL} --select-user @`

list_unread_msginfo()
{
    for u in ${USER_LIST[@]} ; do 
        ${USERUTIL} --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | grep "\.\." | awk '{for(i=9;i<NF;i++)if($i~/'${KEYWORD}'/)print $0}'  | sort | uniq >> /tmp/unreadlog 
    done
    cat /tmp/unreadlog && \rm /tmp/unreadlog
}

list_all_msginfo()
{
    for u in ${USER_LIST[@]} ; do 
        ${USERUTIL} --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | awk '{for(i=9;i<NF;i++)if($i~/'${KEYWORD}'/)print $0}'  | sort | uniq >> /tmp/alllog 
    done
    cat /tmp/alllog && \rm /tmp/alllog
}

del_unread_msginfo()
{
    for u in ${USER_LIST[@]} ; do 
        ${USERUTIL} --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | grep "\.\." | awk '{for(i=9;i<NF;i++)if($i~/'${KEYWORD}'/)print $0}'  | sort | uniq >> /tmp/unreadlog 
    done
    for d in `cat /tmp/unreadlog | sort | uniq | awk '{print $1":"$3}'` ; do  
        ${USERUTIL} --delete-msg ${d%%:*} ${d##*:}
    done;
    \rm /tmp/unreadlog
}

del_all_msginfo()
{
    for u in ${USER_LIST[@]} ; do 
        ${USERUTIL} --list-msg ${u} | grep -v "MBoxID:\|----------" | sed "s/^/${u} /g" | awk '{for(i=9;i<NF;i++)if($i~/'${KEYWORD}'/)print $0}' | sort | uniq >> /tmp/alllog
    done
    for d in `cat /tmp/alllog  | sort | uniq | awk '{print $1":"$3}'` ; do  
        ${USERUTIL} --delete-msg ${d%%:*} ${d##*:}
    done;
    \rm /tmp/alllog
}



case $1 in
--list-all | -la )
    list_all_msginfo;;
--list-unread  | -lu )
    list_unread_msginfo;;
--del-all | -da )
    del_all_msginfo;;
--del-unread  | -du )
    del_unread_msginfo;;
*)
    echo "Usage: $0 -la or -lu list all or unread msg | -da or -du del all or unread msg && keyword need";;
esac

