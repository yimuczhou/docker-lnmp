#!/bin/bash

# PAHCLON_VERSION=3.4.1

# Install mcrypt extension,
# Mcrypt was DEPRECATED in PHP 7.1.0, and REMOVED in PHP 7.2.0.
if $SUPPORT_MCRYPT; then
    apt-get install -y libmcrypt-dev \
    && docker-php-ext-install mcrypt
fi

# Install phalcon extension
if [ "$PAHCLON_VERSION" != "" ]; then
    cd /tmp/exts
    mkdir phalcon
    phalconPackageName=cphalcon-${PAHCLON_VERSION}.tar.gz
    if [ ! -f "$phalconPackageName" ]; then
    	wget https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PAHCLON_VERSION} -O ${phalconPackageName}
    fi
    tar -xf cphalcon-${PAHCLON_VERSION}.tar.gz -C phalcon --strip-components=1 \
    && ( cd phalcon/build && ./install ) \
    && docker-php-ext-enable phalcon
fi


# Install redis extension
if [ "$REDIS_VERSION" != "" ]; then
    cd /tmp/exts \
    && mkdir redis \
    && tar -xf redis-${REDIS_VERSION}.tgz -C redis --strip-components=1 \
    && ( cd redis && phpize && ./configure && make && make install ) \
    && docker-php-ext-enable redis
fi

# Install swoole extension
# swoole require PHP version 5.5 or later.
if [ "$SWOOLE_VERSION" != "" ]; then
    cd /tmp/exts \
    && mkdir swoole \
    && tar -xf swoole-${SWOOLE_VERSION}.tgz -C swoole --strip-components=1 \
    && ( cd swoole && phpize && ./configure && make && make install ) \
    && docker-php-ext-enable swoole
fi

# Install xdebug extension
if [ "$XDEBUG_VERSION" != "" ]; then
    cd /tmp/exts \
    && mkdir xdebug \
    && tar -xf xdebug-${XDEBUG_VERSION}.tgz -C xdebug --strip-components=1 \
    && ( cd xdebug && phpize && ./configure && make && make install ) \
    && docker-php-ext-enable xdebug
fi
