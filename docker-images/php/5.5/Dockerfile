FROM php:5.5-fpm

# Configure PHP
RUN buildDeps=" \
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
        freetype* \
        mysql-client \
    "; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure \
    gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir \
    && docker-php-ext-install \
    gd \
    mbstring \
    mysqli \
    mcrypt \
    mysql \
    pdo_mysql \
    soap \
    zip \
    opcache \
    && apt-get purge -y --auto-remove

COPY php.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

# Install magerun using new url as described at http://magerun.net/changed-download-urls-for-phar-version/
RUN curl -o magerun http://files.magerun.net/n98-magerun-latest.phar && \
    chmod +x ./magerun && \
    cp ./magerun /usr/local/bin/ && \
    rm -f ./magerun
