#!/bin/sh

mkdir -p /config
[ ! -d /config/z-push ] && find /usr/share/nginx/z-push/ -name 'config.php' -exec cp --parents {} /config/. \;
cp -rv /config/z-push/* /usr/share/nginx/z-push/.

php-fpm5
nginx
