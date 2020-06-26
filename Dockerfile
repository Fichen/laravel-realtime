FROM composer as vendor

RUN mkdir ~/.composer && mkdir -p /var/www/html

WORKDIR /var/www/html

# Fresh installation
# RUN composer create-project --prefer-dist laravel/laravel .


FROM php:7.2-apache as app-server

LABEL maintainer="David Fichtenbaum"

COPY --from=vendor /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    g++ \
    make \
    git \
    unzip \
    zip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libreadline-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libzip-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    pdo_mysql \
    zip \
    curl \
    && a2enmod rewrite

COPY ./docker-configs/php/php.ini $PHP_INI_DIR/custom.ini
COPY ./docker-configs/httpd/app.site.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN composer global require hirak/prestissimo

COPY database/ database/
COPY composer.json .

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

EXPOSE 8081

#COPY . /var/www/html




