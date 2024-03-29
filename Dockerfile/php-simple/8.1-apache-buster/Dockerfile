FROM php:8.1-apache-buster
LABEL maintainer "ever.murcia@goes.gob.sv"

ADD run.sh /usr/local/bin/run.sh
RUN chmod 777 /usr/local/bin/run.sh

# Copiando mi version de php.ini
COPY php.ini /usr/local/etc/php/

#RUN cp /dev/null /etc/apt/sources.list \
#    && echo "deb http://debian.salud.gob.sv/debian/ buster main contrib non-free" >> /etc/apt/sources.list \
#    && echo "deb-src http://debian.salud.gob.sv/debian/ buster main contrib non-free" >> /etc/apt/sources.list \
#    && echo "" >> /etc/apt/sources.list \
#    && echo "deb http://debian.salud.gob.sv/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list \
#    && echo "deb-src http://debian.salud.gob.sv/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list \
#    && echo "" >> /etc/apt/sources.list \
#    && echo "deb http://debian.salud.gob.sv/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list \
#    && echo "deb-src http://debian.salud.gob.sv/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list


EXPOSE 80
EXPOSE 8080
EXPOSE 22

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
    && docker-php-ext-install xsl

# Instalando imagick
RUN apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick

# Instalando mysqli
RUN docker-php-ext-install mysqli pdo_mysql

#Instalando Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"


ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD 001-default.conf /etc/apache2/sites-available/001-default.conf

RUN a2ensite 001-default

WORKDIR /var/www/html/

RUN a2enmod rewrite
RUN a2enmod headers

#Ejecutando archivo run.sh al crear el contenedor para pasar las variables de entorno a env.
CMD /usr/local/bin/run.sh ; sleep infinity

#NOTA: el ; sleep infinity es necesario al final para que no se salga o se cierre el contenedor
