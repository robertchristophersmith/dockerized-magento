FROM robertchristophersmith/docker-php-fpm

# Configure PHP
RUN buildDeps=" \
        freetype* \        
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
        mysql-client \
    " \
    && set -x \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
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
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./php-fpm.conf /usr/local/etc/php-fpm.conf

# Install magerun using new url as described at http://magerun.net/changed-download-urls-for-phar-version/
RUN curl -o magerun http://files.magerun.net/n98-magerun-latest.phar \
    && chmod +x ./magerun \
    && cp ./magerun /usr/local/bin/ \
    && rm -f ./magerun
