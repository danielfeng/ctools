#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

change_logos_list=("/home/ctools/cmconf/cm_logos/cmxt3/1.gif:/home/coremail/web/webapp/common/index_cmxt30/logo.gif" \
"/home/ctools/cmconf/cm_logos/cmxt3/2.jpg:/home/coremail/web/webapp/common/index_cmxt30/mainBg1.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/3.jpg:/home/coremail/web/webapp/common/index_cmxt30/mainBg.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/4.gif:/home/coremail/web/webapp/XT3/assets/21389/images/logo.gif" \
"/home/ctools/cmconf/cm_logos/cmxt3/5.jpg:/home/coremail/web/webapp/XT3/assets/21389/images/t_tr_blue.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/6.jpg:/home/coremail/web/webapp/common/assets/21389/help/images/help_logo.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/7.jpg:/home/coremail/web/webapp/common/assets/21389/help/images/helplogo_zh.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/8.gif:/home/coremail/web/webapp/ipad/assets/logo/logo.gif" \
"/home/ctools/cmconf/cm_logos/cmxt3/9.jpg:/home/coremail/web/webapp/ipad/assets/xm_index/mainBg.jpg" \
"/home/ctools/cmconf/cm_logos/cmxt3/10.png:/home/coremail/web/webapp/ipad/assets/xm_index/mainBg_1.png" \
"/home/ctools/cmconf/cm_logos/cmxt3/11.png:/home/coremail/web/webapp/ipad/assets/xm_index/mainBg_2.png" \
"/home/ctools/cmconf/cm_logos/cmxt3/12.png:/home/coremail/web/webapp/ipad/assets/xm_index/mainBg_3.png" \
"/home/ctools/cmconf/cm_logos/cmxt3/13.gif:/home/coremail/web/webapp/ipad/assets/logo/logo-s.gif" \
"/home/ctools/cmconf/cm_logos/cmxt3/14.png:/home/coremail/web/webapp/xphone/assets/logo/logo.png" \
"/home/ctools/cmconf/cm_logos/cmxt3/15.ico:/home/coremail/web/html/favicon.ico" \
)

restart_clean_tomcat()
{
  rm -rf /home/coremail/java/tomcat/work/*
  /home/coremail/bin/coremail restart tomcat
}

change_logos()
{
  for list in ${change_logos_list[@]} ; do
     [ -f ${list##*:} ] && mv ${list##*:}{,.bak`date +%F`}
     [ -f ${list%%:*} ] && cp ${list%%:*} ${list##*:} 
     [ -f ${list##*:} ] && chown coremail:coremail ${list##*:}
 #  echo "${list%%:*}" "${list##*:}"  
  done
  restart_clean_tomcat
}

restore_logos()
{
   for list in ${change_logos_list[@]} ; do
    [ -f ${list##*:}.bak`date +%F` ] && mv ${list##*:}.bak`date +%F` ${list##*:} 
    [ -f ${list##*:} ] && chown coremail:coremail ${list##*:}
   done
   restart_clean_tomcat
}


case $1 in
restore | -r )
    restore_logos;;
change | -c )
    change_logos;;
*)
    echo "Usage: $0 -r restore cm logos || -c change cm_logos";;
esac

