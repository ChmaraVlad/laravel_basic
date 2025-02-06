ARG PHP_VERSION_ARG

FROM php:${PHP_VERSION_ARG}-fpm

ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_VERSION_ARG

ENV PHP_VERSION=$PHP_VERSION_ARG
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install build-essential locales curl sudo bash -y
RUN docker-php-ext-install pdo pdo_mysql mysqli

RUN usermod -u 1000 www-data
RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN apt autoremove

ARG DEBIAN_FRONTEND=interactive

USER www-data

EXPOSE 9000

CMD ["php-fpm"]