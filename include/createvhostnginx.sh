#!/bin/bash

#Create Nginx Vhost
if [ $VARIANTVHOST == "nginx_vhost" ]; then
# Use https or not
echo
echo -e "\e[1;31;42m$LANGSTRNGINXHTTPSVARIANT\e[0m"
echo
PS3="$LANGSTRACHEHTTPSVARIANT"
echo
select ACHEHTTPSVARIANT in "nginx_http_port_redirect_https_port" "nginx_not_https_port" "nginx_80_and_443_port"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $NGINXHTTPSVARIANT\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$NGINXHTTPSVARIANT" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER NGINXHTTPSVARIANT\e[0m"
    exit 1
fi

#Create NGINX Vhost 80 and 443 ports
if [ $NGINXHTTPSVARIANT == "nginx_80_and_443_port" ]; then
# Upstream to abstract backend connection(s) for php
echo "
upstream php {
        server unix:/tmp/php-cgi.socket;
        server 127.0.0.1:9000;
}

server {
	#port
	listen 80;
        ## Your website name goes here.
        server_name $SITENAME www.$SITENAME;
        ## Your only path reference.
        root $PATHSITE/$SITENAME;
        ## This should be in your http block and if it is, it's not needed here.
        index index.php;

        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }

        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
        }

        location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_pass php;
                #The following parameter can be also included in fastcgi_params file
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }

server {
	#port
	listen 443 ssl http2;
        ## Your website name goes here.
        server_name $SITENAME www.$SITENAME;
	ssl on;
        ## Your only path reference.
        root $PATHSITE/$SITENAME;
        ## This should be in your http block and if it is, it's not needed here.
        index index.php;

        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }

        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
        }

        location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_pass php;
                #The following parameter can be also included in fastcgi_params file
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }

}
" > /etc/nginx/sites-available/$SITENAME
fi

#Create NGINX Vhost http 80 port and not https 443 port
if [ $NGINXHTTPSVARIANT == "nginx_not_https_port" ]; then
# Upstream to abstract backend connection(s) for php
echo "
upstream php {
        server unix:/tmp/php-cgi.socket;
        server 127.0.0.1:9000;
}

server {
	#port
	listen 80;
        ## Your website name goes here.
        server_name $SITENAME www.$SITENAME;
        ## Your only path reference.
        root $PATHSITE/$SITENAME;
        ## This should be in your http block and if it is, it's not needed here.
        index index.php;

        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }

        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
        }

        location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_pass php;
                #The following parameter can be also included in fastcgi_params file
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }

}
" > /etc/nginx/sites-available/$SITENAME
fi

#Create NGINX Vhost port http 80 redirect to https 443 port
if [ $NGINXHTTPSVARIANT == "nginx_http_port_redirect_https_port" ]; then
# Upstream to abstract backend connection(s) for php
echo "
upstream php {
        server unix:/tmp/php-cgi.socket;
        server 127.0.0.1:9000;
}

server {
	#port
	listen 80;
        ## Your website name goes here.
        server_name $SITENAME www.$SITENAME;
	return 301 https://$SITENAME$request_uri;
        }

server {
	#port
	listen 443 ssl http2;
	ssl on;
        ## Your website name goes here.
        server_name www.$SITENAME;
	return 301 https://$SITENAME$request_uri;
        }

server {
	#port
	listen 443 ssl http2;
        ## Your website name goes here.
        server_name $SITENAME;
	ssl on;
        ## Your only path reference.
        root $PATHSITE/$SITENAME;
        ## This should be in your http block and if it is, it's not needed here.
        index index.php;

        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }

        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
        }

        location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_pass php;
                #The following parameter can be also included in fastcgi_params file
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }

}
" > /etc/nginx/sites-available/$SITENAME
fi

# Включить сайт
#a2ensite $SITENAME
ln -s /etc/nginx/sites-available/$SITENAME /etc/nginx/sites-enabled/$SITENAME
service nginx restart

echo "Nginx Vhost create $SITENAME"
fi

#Create Nginx Vhost
if [ $VARIANTVHOST == "not_create" ]; then
echo "Not Vhost create $SITENAME"
fi
