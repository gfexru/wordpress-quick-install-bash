#!/bin/bash

#Enter language
echo
echo -e "\e[1;31;42mEnter language\e[0m"
echo -e "\e[1;31;42mВыбор языка\e[0m"
echo
PS3='Select language (enter 1 or 2): '
echo
select LANGUAGE in "English" "Russian"
do
  echo
  echo -e "\e[1;34;4mYou choosed $LANGUAGE language\e[0m"
  echo -e "\e[1;34;4mВы выбрали $LANGUAGE язык\e[0m"
  echo
  break
done
#
#Проверка выбора языка
if [[ -z "$LANGUAGE" ]];then
    echo  -e "\e[31mYou have not chosen language\e[0m"
    echo  -e "\e[31mВы не выбрали язык\e[0m"
    exit 1
fi
#

#Русский язык - строки
if [ $LANGUAGE == "Russian" ]; then
#include russian language
source ./languages/russian
fi

#English language
if [ $LANGUAGE == "English" ]; then
#include english language
source ./languages/english
fi



#Enter Site Name
read -r -p "$LANGSTRYOUURLWP" SITENAME
#Проверка выбора
if [[ -z "$SITENAME" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER SITENAME\e[0m"
    exit 1
fi

#Enter Path Site
read -r -p "$LANGSTRPATHSITE" PATHSITE
PATHSITE=${PATHSITE:-/var/www}
echo $PATHSITE
#Проверка выбора
if [[ -z "$PATHSITE" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER PATHSITE\e[0m"
    exit 1
fi

#Enter Path Site Chown
read -r -p "$LANGSTRCHOWNDIRSITEUSER :" CHOWNDIRSITEUSER
CHOWNDIRSITEUSER=${CHOWNDIRSITEUSER:-www-data}
echo $CHOWNDIRSITEUSER
#Проверка выбора
if [[ -z "$CHOWNDIRSITEUSER" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER CHOWNDIRSITEUSER\e[0m"
    exit 1
fi

#enter TABLE PREFIX wp_
read -p "$LANGSTRDBTABLEPREFIX: " DBTABLEPREFIX
DBTABLEPREFIX=${DBTABLEPREFIX:-wp_}
echo $DBTABLEPREFIX
#Проверка выбора
if [[ -z "$DBTABLEPREFIX" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER DBTABLEPREFIX\e[0m"
    exit 1
fi

#Create db MySQL
source ./include/createdbmysql.sh


#Create Vhost
source ./include/createvhost.sh
source ./include/createvhostapache.sh
source ./include/createvhostnginx.sh


#Install Wordpress
source ./include/installwordpress.sh
source ./include/installwordpressshell.sh

echo "
You create
DBNAME        |  $DBNAME
DBUSER        |  $DBUSER
DBPASS        |  $DBUSERPASS
SITE NAME     |  $SITENAME
SITE DIR      |  $PATHSITE/$SITENAME
CHOWN DIR     |  $CHOWNDIRSITEUSER
TABLE PREFIX  |  $DBTABLEPREFIX
"