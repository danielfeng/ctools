#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com

export PATH="/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/coremail/bin:/home/ctools/cmbin:/root/bin"
docker stop `docker ps -q`
docker rm `docker ps -a -q`
docker run -p 81:3000 -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -i -t dn_ct_rails bash -c "cd /home/app/webapp/ && rails s"

#docker run -p 80:80 -d -i -t cm_nginx nginx -g 'daemon off;'
cm_app_list=("100:cmxt200-x32-as4" \
"101:cmxt201-x32-as4" \
"102:cmxt202-x32-as4" \
"104:cmxt210-x32-as4" \
"105:cmxt211-x32-as4" \
"106:cmxt212-x32-as4" \
"107:cmxt213-x32-as4" \
"108:cmxt214-x32-as4" \
"109:cmxt215-x32-as4" \
"110:cmxt216-x64-as5" \
"111:cmxt217-x64-as5" \
"112:cmxt217a-x64-as5" \
"113:cmxt218-x64-as5" \
"114:cmxt219-x64-as5" \
)


#"103:cmxt203-x32-as4" \
#"111:cm400x32as4" \
#"112:cm401x32as4" \
#"113:cm403x32as4" \
#"114:cm3512xt32as4" \
DATE=`date +"%Y-%m-%d"`

docker_start()
{
for i in ${cm_app_list[@]}; do
   docker run -p ${i%%:*}80:80 -p ${i%%:*}50:5000 -d -v /mnt/release/release/release/:/home/release -i -t --name=${i##*:} ${i##*:} bash -c "cd /root/web/ && npm start" && echo 192.168.209.9:${i%%:*}80 ${i##*:} OK >> /tmp/dn1${DATE}.log 
   sleep 1
   docker exec ${i##*:} /home/coremail/sbin/cmctrl.sh start 
done
echo "ok"
}
docker_start
