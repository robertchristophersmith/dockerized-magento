FROM php:5.5-fpm

# Configure PHP
RUN buildDeps=" \
        freetype* \
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
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
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps \

COPY php/php.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.conf

ENV INSTALLER_VERSION 1.0.0

# Install Tools
RUN apt-get update && apt-get install -y \
        vim \
        telnet \
        mysql-client \
        netcat \
        git-core \
        zip \
    && rm -rf /var/lib/apt/lists/*
    
# Install magerun using new url as described at http://magerun.net/changed-download-urls-for-phar-version/
RUN curl -o magerun http://files.magerun.net/n98-magerun-latest.phar && \
    && chmod +x ./magerun \
    && cp ./magerun /usr/local/bin/ \
    && rm -f ./magerun

# Add a custom magerun configuration
COPY magerun/n98-magerun.yaml.tmpl /etc/n98-magerun.yaml.tmpl

# Add utility scripts
COPY bin/substitute-env-vars.sh /bin/substitute-env-vars.sh
RUN chmod +x /bin/substitute-env-vars.sh

# Add custom Magento configuration files
COPY magento/local.xml.tmpl /etc/local.xml.tmpl
COPY magento/fpc.xml.tmpl /etc/fpc.xml.tmpl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=bin

# Add the Installer
COPY bin/install.sh /bin/install.sh
RUN chmod +x /bin/install.sh

ENTRYPOINT ["/bin/install.sh"]
