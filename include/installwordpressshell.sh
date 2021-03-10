#!/bin/bash

#
# shell установка WordPress на Debian/Ubuntu
#
if [ $VARIANTINSTALLWP == "shell_install" ]; then
# Скачивание, распаковка и настройка WordPress
#Get latest version wordpress
if [ $SELECTWPVER == "latest" ]; then
    #Wordpress version english
    if [ $LANGUAGE == "English" ]; then
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #tar.gz download file
    #wget --show-progress -q -O - "https://wordpress.org/latest.tar.gz" | tar -xzf - -C $PATHSITE --transform s/wordpress/$SITENAME/
    #zip download file
    WGETWPURL="https://wordpress.org/latest.zip"
    else
    #Wordpress localize version
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #tar.gz download file
    #wget --show-progress -q -O - "https://$LANG.wordpress.org/latest-$LANGARCHIVEWP.tar.gz" | tar -xzf - -C $PATHSITE --transform s/wordpress/$SITENAME/
    #zip download file
    WGETURLWP="https://$LANG.wordpress.org/latest-$LANGARCHIVEWP.zip"
    fi
fi
#Get version stable choise wordpress
if [ $SELECTWPVER == "choice" ]; then
    if [ $LANGUAGE == "English" ]; then
    #Wordpress version english
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #tar.gz download file
    #wget --show-progress -q -O - "https://wordpress.org/wordpress-$CHOICEVERWP.tar.gz" | tar -xzf - -C $PATHSITE --transform s/wordpress/$SITENAME/
    #zip download file
    WGETURLWP="https://wordpress.org/wordpress-$CHOICEVERWP.zip"
    else
    #Wordpress localize version
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #tar.gz download file
    #wget --show-progress -q -O - "https://$LANG.wordpress.org/wordpress-$CHOICEVERWP-$LANGARCHIVEWP.tar.gz" | tar -xzf - -C $PATHSITE --transform s/wordpress/$SITENAME/
    #zip download file
    WGETURLWP="https://$LANG.wordpress.org/wordpress-$CHOICEVERWP-$LANGARCHIVEWP.zip"
    fi
fi

#Get version beta wordpress
if [ $SELECTWPVER == "beta" ]; then
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #zip download file
    WGETURLWP="https://wordpress.org/wordpress-$CHOICEBETAVERWP-$BETAVERWP.zip"
fi


#Get version RC wordpress
if [ $SELECTWPVER == "RC" ]; then
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #zip download file
    WGETURLWP="https://wordpress.org/wordpress-$CHOICERCVERWP-$RCVERWP.zip"
fi

#Get version nigthly wordpress
if [ $SELECTWPVER == "nightly" ]; then
    echo -e "\e[31m$LANGSTRWPWGET\e[0m"
    #zip download file
    WGETURLWP="https://wordpress.org/nightly-builds/wordpress-latest.zip"
fi

mkdir -p $PATHSITE/$SITENAME/
#unzip wordpress
UNZIPWPPATH="$PATHSITE/$SITENAME/"
./lib/wpwgetunzip.sh $WGETURLWP $UNZIPWPPATH
mv -f $UNZIPWPPATH/wordpress/* $UNZIPWPPATH
rm -Rf $UNZIPWPPATH/wordpress
#chown directory
chown $CHOWNDIRSITEUSER: -R $PATHSITE/$SITENAME
cd $PATHSITE/$SITENAME
#rename wp-config
cp wp-config-sample.php wp-config.php
chmod 640 wp-config.php
#create uploads dir
cd $PATHSITE/$SITENAME/wp-content
mkdir -p uploads
#enter parametr to wp-config.php
cd $PATHSITE/$SITENAME
sed -i "s/database_name_here/$DBNAME/;s/username_here/$DBUSER/;s/password_here/$DBUSERPASS/" wp-config.php
#create auth key
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

chown $CHOWNDIRSITEUSER: -R $PATHSITE/$SITENAME

# Output
WPVER=$(grep "wp_version = " $PATHSITE/$SITENAME/wp-includes/version.php |awk -F\' '{print $2}')
echo -e "\nWordPress version $WPVER $LANGSTRWPINSTALLOK!"
echo -en "\a$LANGSTRWPINSTALLSITEURL http://$SITENAME $LANGSTRWPINSTALLSITEURL1\n"
fi
