#!/bin/bash

#Choise install Wordpress
echo
echo -e "\e[1;31;42m$LANGSTRVARIANTINSTALLWP\e[0m"
echo
PS3="$LANGSTRVARIANTINSTALLWP"
echo
select VARIANTINSTALLWP in "shell_install" "php_web_install"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $VARIANTINSTALLWP\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$VARIANTINSTALLWP" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER VARIANTINSTALLWP\e[0m"
    exit 1
fi


#source ./include/installwordpressshell.sh

