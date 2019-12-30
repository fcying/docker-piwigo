#!/bin/bash

PUID=${PUID:-33}
PGID=${PGID:-33}
groupmod -o -g "$PGID" www-data
usermod -o -u "$PUID" www-data

for d in $(ls /template); do
  [ "$(ls -A /data/${d})" ] || cp -Rv /template/${d} /data/
  if [ "${d}" != "cache" ]; then
      ln -svf /data/${d} /var/www
  fi
done
mkdir -p /data/cache
ln -svf /data/cache /var/www/_data/i

if [ ! -f "/var/www/galleries/index.php" ]; then
    cp -vf /config/index.php /var/www/galleries/
    chown www-data:www-data /var/www/galleries/index.php
fi

mkdir -pv /data/config/php/apache2.d
find /data/config/php/apache2.d -type f | while read file; do
	ln -svf "${file}" "/etc/php/7.3/apache2/conf.d/$(basename "${file}")";
done;

chown -R www-data:www-data /data
cd /var/www
ls | grep -v galleries | xargs chown -R www-data:www-data

source /etc/apache2/envvars
apache2ctl -D FOREGROUND

