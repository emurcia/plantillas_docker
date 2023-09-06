FROM php:5.6-apache-stretch
LABEL maintainer "ever.murcia@goes.gob.sv"

ADD run.sh /usr/local/bin/run.sh
RUN chmod 777 /usr/local/bin/run.sh

# Copiando mi version de php.ini
COPY php.ini /usr/local/etc/php/

# Se agregan los sources archive porque ya debian desecho los deb
RUN cp /dev/null /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian/ stretch-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "" >> /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list

EXPOSE 80
EXPOSE 8080
EXPOSE 22

#Instalando apc
#RUN printf "\n" | pecl install apcu \
#    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

# Instalando Paquetes faltantes
#RUN apt-get update \
#    && apt-get install -y nano zip libzip-dev libpq-dev zlib1g-dev libicu-dev g++ libxml2-dev memcached libmemcached-dev \
#    wkhtmltopdf freetds-bin freetds-common wget lsb-release gnupg libpng-dev git cron unzip openssh-server sudo \
#    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
#    && docker-php-ext-install pdo pdo_pgsql pgsql \
#    && docker-php-ext-install intl mbstring xml gd \
#    && docker-php-ext-configure zip --with-libzip \
#    && docker-php-ext-install zip

# Instalando Paquetes faltantes
RUN apt-get update \
    && apt-get install -y nano libpq-dev zlib1g-dev libicu-dev g++ libicu57 freetds-bin freetds-common wget libxml2-dev gnupg curl \
    libpng-dev xvfb fontconfig fontconfig-config fonts-dejavu-core libfontconfig1 libjpeg62-turbo libxrender1 xfonts-75dpi git cron unzip openssh-server sudo \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql intl zip mysqli pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-install gd

# Instalar php sybase para contectarse a sql server
RUN apt-get -y --force-yes --no-install-recommends install freetds-dev; \
        docker-php-ext-configure mssql --with-libdir=/lib/x86_64-linux-gnu/; \
        docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu/; \
        docker-php-ext-install -j$(nproc) mssql pdo_dblib;

# Instalando imagick
#RUN apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick

# Instalacion de WKHTMLTOPDF
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && dpkg --install wkhtmltox_0.12.5-1.stretch_amd64.deb

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
