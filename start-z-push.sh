#!/bin/sh

mkdir -p /config

cd /usr/share/z-push
[ ! -e /config/config.php ] && find . -name 'config.php' -exec cp --parents {} /config/. \;

cp -rv /config/* /usr/share/z-push/.

chown -R www-data:www-data /var/lib/z-push

php-fpm7.0
nginx
