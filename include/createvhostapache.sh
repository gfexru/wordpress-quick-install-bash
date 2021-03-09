#!bin/bash

#Create Apache Vhost
if [ $VARIANTVHOST == "apache_vhost" ]; then
# Use https or not
echo
echo -e "\e[1;31;42m$LANGSTRAPACHEHTTPSVARIANT\e[0m"
echo
PS3="$LANGSTRACHEHTTPSVARIANT"
echo
select ACHEHTTPSVARIANT in "apache_http_port_redirect_https_port" "apache_not_https_port" "apache_80_and_443_port"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $ACHEHTTPSVARIANT\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$ACHEHTTPSVARIANT" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER ACHEHTTPSVARIANT\e[0m"
    exit 1
fi

#Create Apache Vhost 80 and 443 ports
if [ $ACHEHTTPSVARIANT == "apache_80_and_443_port" ]; then
echo "
<VirtualHost *:80>
    UseCanonicalName Off
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    ServerAdmin  webmaster@$SITENAME
    DocumentRoot $PATHSITE/$SITENAME
</VirtualHost>

<VirtualHost *:443>
    SSLEngine on
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    ServerAdmin  webmaster@$SITENAME
    DocumentRoot $PATHSITE/$SITENAME
</VirtualHost>

<Directory $PATHSITE/$SITENAME>
    Options +FollowSymLinks
    Options -Indexes
    AllowOverride All
    order allow,deny
    allow from all
</Directory>
" > /etc/apache2/sites-available/$SITENAME.conf
fi
#Create Apache Vhost not https 443 port
if [ $ACHEHTTPSVARIANT == "apache_not_https_port" ]; then
echo "
<VirtualHost *:80>
    UseCanonicalName Off
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    ServerAdmin  webmaster@$SITENAME
    DocumentRoot $PATHSITE/$SITENAME
</VirtualHost>

<Directory $PATHSITE/$SITENAME>
    Options +FollowSymLinks
    Options -Indexes
    AllowOverride All
    order allow,deny
    allow from all
</Directory>
" > /etc/apache2/sites-available/$SITENAME.conf
fi
#Create Apache Vhost redirect http 80 port to https 443 port
if [ $ACHEHTTPSVARIANT == "apache_http_port_redirect_https_port" ]; then
echo "
<VirtualHost *:80>
    UseCanonicalName Off
    ServerName $SITENAME
    ServerAdmin  webmaster@$SITENAME
    Redirect permanent / https://$SITENAME/
</VirtualHost>

<VirtualHost *:80>
    UseCanonicalName Off
    ServerName www.$SITENAME
    ServerAdmin  webmaster@$SITENAME
    Redirect permanent / https://wwww.$SITENAME/
</VirtualHost>


<VirtualHost *:443>
    SSLEngine on
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    ServerAdmin  webmaster@$SITENAME
    DocumentRoot $PATHSITE/$SITENAME
</VirtualHost>

<Directory $PATHSITE/$SITENAME>
    Options +FollowSymLinks
    Options -Indexes
    AllowOverride All
    order allow,deny
    allow from all
</Directory>
" > /etc/apache2/sites-available/$SITENAME.conf
fi


# Включить сайт
#a2ensite $SITENAME
ln -s /etc/apache2/sites-available/$SITENAME.conf /etc/apache2/sites-enabled/$SITENAME.conf
service apache2 restart

echo "Apache Vhost create $SITENAME"
fi
