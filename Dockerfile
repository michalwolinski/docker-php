FROM php:8-fpm-alpine AS haxmedia-docker-php

MAINTAINER Michal Wolinski www.haxmedia.pl

RUN apk update && apk add \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    nano \
    supervisor

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN rm -rf /tmp/* /var/cache/apk/*

ARG environment=development

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/supervisord-phpfpm.conf /etc/supervisor/conf.d/supervisord-phpfpm.conf
COPY config/php-custom.ini /usr/local/etc/php/conf.d/php-custom.ini
RUN mv "$PHP_INI_DIR/php.ini-$environment" "$PHP_INI_DIR/php.ini"

USER www-data

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
