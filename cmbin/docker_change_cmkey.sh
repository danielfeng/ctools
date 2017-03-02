#!/usr/bin/env bash
# Author : danielfeng
# E-mail : danielfancy@gmail.com


cm_app_list=("100:cmxt500-x64-as6" \
"101:cmxt501-x64-as6" \
"102:cmxt501a-x64-as6" \
)

docker_change_cmkey()
{
  for i in ${cm_app_list[@]}; do
        docker exec ${i##*:} "/home/tools/./change_cmkey.sh" 
        docker commit ${i##*:} ${i##*:}
  done
          echo "ok"
}
docker_change_cmkey

