FROM php:7-apache

RUN apt-get update && \
    apt-get -y install \
    unzip \
    git \
    libxml2-dev \
    libcurl4-openssl-dev \
    sqlite3 \
    libsqlite3-dev \
    cron \
    supervisor
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN docker-php-ext-configure \
    pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-install \
    xml \
    pdo_mysql \
    pdo_sqlite \
    mbstring \
    curl \
    pcntl

RUN a2enmod headers rewrite

WORKDIR /var/www/411
RUN curl -L https://github.com/etsy/411/releases/download/v1.4.0/release.tgz | tar xz
RUN composer install --no-dev --optimize-autoloader

RUN mkdir /data
COPY 411.conf /data/000-default.conf
RUN ln -sf /data/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN sqlite3 /data/data.db < db.sql
RUN ln -sf /data/data.db data.db
COPY config.php /data/config.php
RUN ln -sf /data/config.php config.php

COPY init.php .
RUN ./init.php
RUN rm init.php

RUN chmod ugo+rx -R /data
RUN chown www-data:www-data -R /data

VOLUME /data

COPY supervisord.conf /root/supervisord.conf
COPY mail.ini /usr/local/etc/php/conf.d/
COPY 411_cron /etc/cron.d/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/root/supervisord.conf"]
