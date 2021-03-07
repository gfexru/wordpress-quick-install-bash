#!/bin/bash


#
# shell установка WordPress на Debian/Ubuntu
#
if [ $VARIANTINSTALLWP == "shell_install" ]; then
# Скачивание, распаковка и настройка WordPress
#Wordpress version english
if [ $LANGUAGE == "English" ]; then
echo -e "\e[31m$LANGSTRWPWGET\e[0m"
wget --show-progress -q -O - "https://wordpress.org/latest.tar.gz" | tar -xzf - -C /var/www --transform s/wordpress/$SITENAME/
else
#Wordpress localize version
echo -e "\e[31m$LANGSTRWPWGET\e[0m"
wget --show-progress -q -O - "https://$LANG.wordpress.org/latest-$LANGTARBALLWP.tar.gz" | tar -xzf - -C /var/www --transform s/wordpress/$SITENAME/
fi
#create directory
chown $CHOWNDIRSITEUSER: -R /var/www/$SITENAME
cd /var/www/$SITENAME
#rename wp-config
cp wp-config-sample.php wp-config.php
chmod 640 wp-config.php
#create uploads dir
cd /var/www/$SITENAME/wp-content
mkdir -p uploads
#enter parametr to wp-config.php
cd /var/www/$SITENAME
sed -i "s/database_name_here/$DBNAME/;s/username_here/$DBUSER/;s/password_here/$DBUSERPASS/" wp-config.php
#create auth key
chown $CHOWNDIRSITEUSER: -R /var/www/$SITENAME
wget -O authwp.php https://api.wordpress.org/secret-key/1.1/salt/
#add string <?php to authwp.php
sed -i '1s/^/<?php\n/' authwp.php
#replace AUTH_KEY and more to wp-config.php
sed -i -e "/NONCE_SALT/a\
require_once(__DIR__ . \""/authwp.php"\");
/AUTH_KEY/,/NONCE_SALT/d" wp-config.php
#replace table prefix
sed -i "s/wp\_/$DBTABLEPREFIX\_/" wp-config.php
#create .htaccess
echo "
# BEGIN WordPress

RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]

# END WordPress
" > .htaccess

# Output
WPVER=$(grep "wp_version = " /var/www/$SITENAME/wp-includes/version.php |awk -F\' '{print $2}')
echo -e "\nWordPress version $WPVER $LANGSTRWPINSTALLOK!"
echo -en "\a$LANGSTRWPINSTALLSITEURL http://$SITENAME $LANGSTRWPINSTALLSITEURL1\n"
fi
