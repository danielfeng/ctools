#!/usr/bin/env bash
# Author : danielfeng
# E-Mail : danielfancy@gmail.com

YEAR=$1
MONTH=$2
COREMAIL_HOME="/home/coremail/"
ARCH_INDEX=`grep "ArchiveIndexRoot" ${COREMAIL_HOME}/conf/hosts.cf | awk -F "\"" '{print $2}'`
ARCH_DATA=`grep "ArchiveDataRoot" ${COREMAIL_HOME}/conf/hosts.cf | awk -F "\"" '{print $2}'`
REINDEX_DATE="arch_in${YEAR}${MONTH}"
RUN_LOG="${REINDEX_DATE}_run.log"

[ -z ${YEAR} ] && echo "Usage: $0 Please input need reindex year" && exit
[ -z ${MONTH} ] && echo "Usage: $0 Please input need reindex month" && exit

# backup index
backup_index()
{
	mkdir -p /backup/index_00_${YEAR}_${MONTH}/
	find ${ARCH_INDEX}/00/${YEAR} -type f -name "${MONTH}*" | xargs -i mv {} /backup/index_00_${YEAR}_${MONTH}/
}

# reindex
for archfile in $(find ${ARCH_DATA} -name "${REINDEX_DATE}" -type f)
do
	echo "$(date "+%F (%T)"): process ${archfile}" >> ${RUN_LOG}
	echo "reindex ${archfile}" | nc 0 6202 >> ${RUN_LOG}
done


case $3 in
backup | -b )
	backup_index;;
*)
	;;
esac


