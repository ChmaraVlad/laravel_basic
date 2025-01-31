ARG PHP_VERSION_ARG

FROM ubuntu:noble

ARG PHP_VERSION_ARG

ENV PHP_VERSION=$PHP_VERSION_ARG

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    sudo \
    software-properties-common

RUN apt-get -y install \
        php${PHP_VERSION} \
        apache2 \
        libapache2-mod-php${PHP_VERSION} \
        libapache2-mod-auth-openidc \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-sqlite \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-xml \
        unzip


#replace user user_id linux system inside docker, fix problems with rights user in docker to volumes that is binded
RUN usermod -u 1001 ubuntu && usermod -u 1000 www-data

#all next commands execute with sudo
RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN apt-get -y autoremove && \
    chown -R www-data:www-data /var/run/apache2 && \
    chown -R www-data:www-data /var/log/apache2 && \
    chown -R www-data:www-data /var/www/html && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite headers expires ext_filter && \
    a2enmod ssl && \
    a2enmod socache_shmcb && \
    a2enmod proxy_http && \
    a2enmod include && \
    a2ensite default-ssl

COPY server/composer /usr/bin

EXPOSE 80
EXPOSE 443

USER www-data

ENTRYPOINT composer update && php artisan migrate && apache2ctl -D FOREGROUND
