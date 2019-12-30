FROM debian:buster-slim

MAINTAINER fcying <fcyingmk2@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ARG PIWIGO_VERSION="2.10.1"

RUN apt-get update -y \
    && apt-get install -yy --no-install-recommends \
    vim \
    apache2 \
    libapache2-mod-php \
    php-gd \
    php-curl \
    php-mysql \
    php-mbstring \
    php-xml \
    php-imagick \
    dcraw \
    ffmpeg\
    imagemagick \
    wget \
    unzip \            
    mediainfo \
    exiftool \
    && wget -q -O piwigo.zip http://piwigo.org/download/dlcounter.php?code=$PIWIGO_VERSION \
    && unzip piwigo.zip \
    && rm /var/www/* -rf \
    && mv piwigo/* /var/www/ \
    && rm -r piwigo* \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cp -vf /var/www/include/config_default.inc.php /var/www/local/config/config.inc.php \
    && mkdir /template /data /config \
    && mv /var/www/galleries/index.php /config/ \
    && mv /var/www/themes /template/ \
    && mv /var/www/plugins /template/ \
    && mv /var/www/local /template/ \
    && sed -i "s/\/var\/www\/html/\/var\/www/g" /etc/apache2/sites-enabled/000-default.conf \
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 300/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php/7.3/apache2/php.ini

VOLUME ["/data"]

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
