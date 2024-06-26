FROM php:8.1-apache-buster
LABEL maintainer "evermurcia.la@gmail.com"

# Copiando mi version de php.ini
COPY php.ini /usr/local/etc/php/

EXPOSE 80

#Instalando Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.overload_var_dump=On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache \
    && echo "opcache.file_cache = /var/www/html/.opcache" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

#Instalando apc
RUN printf "\n" | pecl install apcu \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

# Instalando Paquetes faltantes
RUN apt-get update \
    && apt-get install -y nano zip libzip-dev libpq-dev zlib1g-dev libicu-dev g++ libxml2-dev memcached libmemcached-dev \
    wkhtmltopdf freetds-bin freetds-common wget lsb-release gnupg libxslt1-dev libpng-dev git cron openssh-server sudo \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-install intl xml gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap 

# Instalando imagick
RUN apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick

# Instalando mysqli
RUN docker-php-ext-install mysqli pdo_mysql

#Instalando Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html/

RUN a2enmod rewrite
RUN a2enmod headers
