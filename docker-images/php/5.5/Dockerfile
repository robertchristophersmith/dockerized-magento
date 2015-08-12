FROM php:5.6.10-fpm

ENV MAGENTO_PHP_CONFIG_VERSION 1.0.0

# Configure PHP
RUN buildDeps=" \
        freetype* \        
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
    " \
    && set -x \
    && apt-get update \
    && apt-get install -y $buildDeps mysql-client --no-install-recommends \
    && docker-php-ext-configure \
        gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir \
    && docker-php-ext-install \
        gd \
        mbstring \
        mysqli \
        mcrypt \
        mysql \
        opcache \
        pdo_mysql \
        soap \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

COPY php.ini       /usr/local/etc/php/php.ini
COPY php-fpm.conf  /usr/local/etc/php-fpm.conf

WORKDIR /var/www/html

EXPOSE 9000
CMD ["php-fpm"]
