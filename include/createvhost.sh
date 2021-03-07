#!/bin/bash

# Создание виртуального хоста
echo
echo -e "\e[1;31;42m$LANGSTRVARIANTVHOST\e[0m"
echo
PS3="$LANGSTRVARIANTVHOST : "
echo
select VARIANTVHOST in "apache_vhost" "nginx_vhost" "not_create"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $VARIANTVHOST\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$VARIANTVHOST" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER VARIANTVHOST\e[0m"
    exit 1
fi


#source ./include/createvhostapache.sh
#source ./include/createvhostnginx.sh
