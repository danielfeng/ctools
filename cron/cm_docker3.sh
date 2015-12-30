#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

export PATH="/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/coremail/bin:/home/ctools/cmbin:/root/bin"
docker stop `docker ps -q`
docker rm `docker ps -a -q`
/etc/init.d/docker restart

docker run -p 81:3000 -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -i -t --name=dn_ct_rails dn_ct_rails bash -c "cd /home/app/webapp/ && rails s"
docker run -p 82:3000 -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -i -t --name=dn_ct_rails6 dn_ct_rails6 bash -c "cd /home/app/webapp/ && rails s"

docker run -d -p 80:80 -v /etc/nginx/:/etc/nginx/ -v /var/log/nginx:/var/log/nginx -v /etc/localtime:/etc/localtime nginx

#docker run -p 80:80 -d -i -t cm_nginx nginx -g 'daemon off;'
cm_app_list=("100:cm400-x32-as4" \
"101:cm401-x32-as4" \
"102:cm403-x64-as5" \
"103:cm405-x64-as6" \
"104:cm405a-x64-as6" \
"105:cm407-x64-as6" \
"106:cm3512-x32-as4" \
)

#cm_app_list=("100:cm400x32as4" \
#"101:cm401x32as4" \
#"102:cm403x32as4" \
#"103:cm405x32as4" \
#"104:cm407-x64-as6" \
#"105:cm3512xt32as4" \
#)

DATE=`date +"%Y-%m-%d"`

docker_start()
{
for i in ${cm_app_list[@]}; do
   docker run -p ${i%%:*}80:80 -p ${i%%:*}50:5000 -d -v /mnt/release/release/release/:/home/release -i -t --name=${i##*:} ${i##*:} bash -c "cd /root/web/ && npm start" && echo 192.168.209.11:${i%%:*}80 ${i##*:} OK >> /tmp/dn1${DATE}.log 
   sleep 1
   docker exec ${i##*:} /home/coremail/sbin/cmctrl.sh start 
done
echo "ok"
}
docker_start
