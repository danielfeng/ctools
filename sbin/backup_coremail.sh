#!/bin/bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

BACKUP=/home/
DATE=`date +%y%m%d%H`

BACKUP_LIST=("/home/coremail/api" \ 
 	"/home/coremail/bin"  	\
	"/home/coremail/conf" 	\
   	"/home/coremail/java" 	\
	"/home/coremail/lib"  	\
	"/home/coremail/libexec" \
	"/home/coremail/web" 	\
)

for i in ${BACKUP_LIST[@]} ; do
   if [ -f ${i} ]; then
    	tar rvf $BACKUP/coremail$DATE.tar.gz ${i} 
   fi
done


