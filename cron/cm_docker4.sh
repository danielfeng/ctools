#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

export PATH="/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/coremail/bin:/home/ctools/cmbin:/root/bin"
docker stop `docker ps -q`
docker rm `docker ps -a -q`

#docker run -v /var/log/squid3:/var/log/squid3 -v /etc/squid3:/etc/squid3 -p 3128:3128 -d sameersbn/squid
docker run -p 81:3000 -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -i -t --name=dn_ct_rails dn_ct_rails bash -c "cd /home/app/webapp/ && rails s"

#docker run -p 80:80 -d -i -t cm_nginx nginx -g 'daemon off;'
cm_app_list=("100:cmxt300-x64-as6" \
"101:cmxt301-x64-as6" \
"102:cmxt303-x64-as6-arch11abas" \
"103:cmxt304-x64-as6-arch11apro" \
"104:cmxt304a-x64-as6-arch20bas" \
"105:cmxt305-x64-as6-arch20pro" \
"106:cmxt305a-x64-as6-arch201bas" \
"107:cmxt305b-x64-as6-arch201pro" \
"108:cmxt306-x64-as6-arch202bas" \
"109:cmxt306a-x64-as6-arch202pro" \
"110:cm500-x64-as6" \
"111:cm501a-x64-as6" \
"112:cm501b-x64-as6" \
"113:cm502a-x64-as6" \
"114:cm503-x64-as6" \
)
DATE=`date +"%Y-%m-%d"`

docker_start()
{
for i in ${cm_app_list[@]}; do
   docker run --cap-add ALL -p ${i%%:*}80:80 -p ${i%%:*}50:5000 -d -v /mnt/release/release/release/:/home/release -i -t --name=${i##*:} ${i##*:} bash -c "cd /root/web/ && npm start" && echo 192.168.209.27:${i%%:*}80 ${i##*:} OK >> /tmp/dn1${DATE}.log 
   sleep 1
   docker exec ${i##*:} /home/coremail/sbin/cmctrl.sh start 
done
echo "ok"
}
docker_start
