FROM php:5-apache-stretch
LABEL maintainer "evermurcia.la@gmail.com"

RUN cp /dev/null /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian/ stretch-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "" >> /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list

#Instalando Xdebug
RUN pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.overload_var_dump=On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#Instalando apc
RUN printf "\n" | pecl install apcu-4.0.11 \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

# Instalando Paquetes faltantes
RUN apt-get update \
    && apt-get install -y libpq-dev zlib1g-dev libicu-dev g++ libicu57 freetds-bin freetds-common wget libxml2-dev gnupg curl \
    libpng-dev xvfb fontconfig fontconfig-config fonts-dejavu-core libfontconfig1 libjpeg62-turbo libxrender1 xfonts-75dpi git cron \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql intl zip mysqli pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap \
    && docker-php-ext-install gd

# Instalar php sybase para contectarse a sql server
#RUN apt-get -y --force-yes --no-install-recommends install freetds-dev; \
#	docker-php-ext-configure mssql --with-libdir=/lib/x86_64-linux-gnu/; \
#	docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu/; \
#	docker-php-ext-install -j$(nproc) mssql pdo_dblib;

# Instalacion de WKHTMLTOPDF version arm64 (MAC)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.stretch_arm64.deb \
    && dpkg --install wkhtmltox_0.12.6-1.stretch_arm64.deb

COPY php.ini /usr/local/etc/php/

# Instalando Couchbase lib
#RUN wget http://packages.couchbase.com/ubuntu/couchbase.key \
#    && apt-key add couchbase.key \
#    && echo "deb http://packages.couchbase.com/ubuntu stretch stretch/main" > /etc/apt/sources.list.d/couchbase.list \
#    && apt update \
#    && apt-get install -y libcouchbase-dev libcouchbase2-bin build-essential \
#    && pecl install couchbase \
#    && docker-php-ext-enable couchbase

#Instalando Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite
RUN a2enmod headers
