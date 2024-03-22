FROM php:7.4-apache-buster
LABEL maintainer "evermurcia.la@gmail.com"

#RUN cp /dev/null /etc/apt/sources.list \
#    && echo "deb http://archive.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list \
#    && echo "deb http://archive.debian.org/debian/ buster-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
#    && echo "" >> /etc/apt/sources.list \
#    && echo "deb http://archive.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

#Instalando apc
RUN printf "\n" | pecl install apcu \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

# Instalando Paquetes faltantes
RUN apt-get update \
    && apt-get install -y nano zip libzip-dev libpq-dev zlib1g-dev libicu-dev g++ libxml2-dev memcached libmemcached-dev \
    wkhtmltopdf freetds-bin freetds-common wget lsb-release gnupg libxslt1-dev libpng-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-install intl xml gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap 

# Instalando mysqli
RUN docker-php-ext-install mysqli pdo_mysql

COPY php.ini /usr/local/etc/php/

# Instalando memcached
RUN pecl install memcached \
    && docker-php-ext-enable memcached

#Instalando Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"


ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite
RUN a2enmod headers