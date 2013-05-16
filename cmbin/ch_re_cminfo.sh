#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

NEW_URL="www.daniel2.cn"
NEW_TITLE="main_title = daniel邮件系统"
NEW_COPYRIGHT="copyright\ =\ daniel.\ \&copy;\ Copyright 2000\ -\ 2013\ dn."


JSP_DIR=${COREMAIL_HOME}/web/webapp/common/index_cmxt30.jsp
CONF_DIR=${COREMAIL_HOME}/web/webapp/WEB-INF/lang/common/main_zh_CN.properties
OLD_URL="www.coremail.cn"
OLD_TITLE="main_title = Coremail邮件系统"
OLD_COPYRIGHT="copyright\ =\ Coremail.\ \&copy;\ Copyright\ 2000\ -\ 2013\ Mailtech."

backup_file()
{
    [ ! -f ${CONF_DIR}.bak`date +%F` ] && cp ${CONF_DIR}{,.bak`date +%F`}
    [ ! -f ${JSP_DIR}.bak`date +%F` ] && cp ${JSP_DIR}{,.bak`date +%F`}
}

change_cminfo()
{
    backup_file
    sed -i "s#${OLD_TITLE}#${NEW_TITLE}#g" ${CONF_DIR}
    sed -i "s#${OLD_COPYRIGHT}#${NEW_COPYRIGHT}#g" ${CONF_DIR}
    sed -i "s#${OLD_URL}#${NEW_URL}#g"  ${JSP_DIR}
}

restore_cminfo()
{
    if [[ ! -f ${CONF_DIR}.bak`date +%F` ]] && [[ ! -f ${JSP_DIR}.bak`date +%F` ]]; then
        echo "nothing backup file..."
        exit
    fi
    [ -f ${CONF_DIR}.bak`date +%F` ] && cp ${CONF_DIR}.bak`date +%F` ${CONF_DIR}
    [ -f ${JSP_DIR}.bak`date +%F` ] && cp ${JSP_DIR}.bak`date +%F` ${JSP_DIR}
}

case $1 in
restore | -r )
    restore_cminfo;;
change | -c )
    change_cminfo;;
*)
    echo "Usage: $0 -r restore cm_info || -c change cm_info";;
esac

