ARG PHP_VERSION_ARG

FROM ubuntu:noble

ARG PHP_VERSION_ARG

ENV PHP_VERSION=$PHP_VERSION_ARG
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y \
    sudo \
    software-properties-common

RUN add-apt-repository -y ppa:ondrej/php && apt-get update

RUN apt-get install -y --no-install-recommends \
    php${PHP_VERSION} \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-sqlite \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-xml \
    unzip

#replace user user_id linux system inside docker, fix problems with rights user in docker to volumes that is binded
RUN usermod -u 1001 ubuntu && usermod -u 1000 www-data

#all next commands execute with sudo
RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN mkdir -p /var/www/html

# Cleanup and prepare
RUN apt-get -y autoremove && \
    chown -R www-data:www-data /var/www/html && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy composer
COPY server/composer /usr/bin

#USER www-data
USER $SYSTEM_USER_ARG

RUN composer require laravel/breeze

ENTRYPOINT composer update && php artisan config:clear && php artisan migrate && php artisan serve
#ENTRYPOINT composer update && composer require laravel/breeze --dev && php artisan breeze:install && php artisan migrate && npm install && npm run dev
