ARG PHP_VERSION_ARG

FROM ubuntu:noble

ARG PHP_VERSION_ARG

ENV PHP_VERSION=$PHP_VERSION_ARG
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y \
    sudo \
    software-properties-common \
    unzip

RUN add-apt-repository -y ppa:ondrej/php && apt-get update

RUN apt-get install -y --no-install-recommends \
    php${PHP_VERSION} \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-raphf \
    php${PHP_VERSION}-http \
    php${PHP_VERSION}-xml

RUN usermod -u 1001 ubuntu && usermod -u 1000 www-data
RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN apt-get -y autoremove && \
    mkdir /var/www && \
    chown -R www-data:www-data /var/www && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY composer /usr/bin

USER www-data

#ENTRYPOINT composer update && php artisan migrate
