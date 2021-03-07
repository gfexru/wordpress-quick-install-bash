#!/bin/bash

#Choise create db or use the existing
echo
echo -e "\e[1;31;42m$LANGSTRCREATEDBVARIANT\e[0m"
echo
PS3="$LANGSTRCREATEDBVARIANT : "
echo
select CREATEDBVARIANT in "Yes_create_DB" "Use_the_existing" "Not_create_DB"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $CREATEDBVARIANT\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$CREATEDBVARIANT" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER CREATEDBVARIANT\e[0m"
    exit 1
fi
#

# Создание базы данных MySQL
#enter db name
read -p "$LANGSTRDBNAME" DBNAME
#Проверка выбора
if [[ -z "$DBNAME" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER DBNAME\e[0m"
    exit 1
fi

#enter db user
read -p "$LANGSTRDBUSER" DBUSER
#Проверка выбора
if [[ -z "$DBUSER" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER DBUSER\e[0m"
    exit 1
fi
#enter db user pass
read -p "$LANGSTRDBUSERPASS $DBUSER"": " DBUSERPASS
#Проверка выбора
if [[ -z "$DBUSERPASS" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER DBUSERPASS\e[0m"
    exit 1
fi

if [ $CREATEDBVARIANT == "Yes_create_DB" ]; then
#enter root user db
read -p "$LANGSTRROOTUSERMYSQL" ROOTUSERMYSQL
#Проверка выбора
if [[ -z "$ROOTUSERMYSQL" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER ROOTUSERMYSQL\e[0m"
    exit 1
fi
#enter root pass db
read -p "$LANGSTRROOTPASSMYSQL" ROOTPASSMYSQL
#Проверка выбора
if [[ -z "$ROOTPASSMYSQL" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER ROOTPASSMYSQL\e[0m"
    exit 1
fi

echo "CREATE DATABASE $DBNAME;" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL
echo "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBUSERPASS';" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL
echo "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL
echo "FLUSH PRIVILEGES;" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL
echo $LANGSTRNEWCREATEDBYES
fi

#use the existing использовать сущуствующую
if [ $CREATEDBVARIANT == "Use_the_existing" ]; then
echo $LANGSTRWARNINGDROPBASE
#Choise drop or not
echo
echo -e "\e[1;31;42m$LANGSTRVARIANTYESNOTDROPDB\e[0m"
echo
PS3="$LANGSTRVARIANTYESNOTDROPDB : "
echo
select VARIANTYESNOTDROPDB in "Yes_drop_DB" "Exit_drop_DB"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $VARIANTYESNOTDROPDB\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$VARIANTYESNOTDROPDB" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER VARIANTYESNOTDROPDB\e[0m"
    exit 1
fi

if [ $VARIANTYESNOTDROPDB == "Yes_drop_DB" ]; then
mysqldump -u$DBUSER -p$DBUSERPASS --add-drop-table --no-data $DBNAME | grep ^DROP | mysql -u$DBUSER -p$DBUSERPASS $DBNAME
echo $LANGSTRNEWCREATEDBNOT
fi

if [ $VARIANTYESNOTDROPDB == "Exit_drop_DB" ]; then
echo "Bye!"
exit 1
fi

if [ $CREATEDBVARIANT == "Not_create_DB" ]; then
echo "Not create DB!"
fi

fi
