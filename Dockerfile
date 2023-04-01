# This file is part of ianseo-docker, which is distributed under
# the terms of the General Public License (GPL), version 3. See
# LICENSE.txt for details.
#
# Copyright (C) 2020 Allan Young
FROM php:8.1-apache

# Update package lists and install required packages
RUN apt-get update && apt-get -y install \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libzip-dev \
    mariadb-client \
    vim \
    unzip \
    zip

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set recommended PHP.ini settings
COPY php.ini /usr/local/etc/php/

# Set Apache document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set up a volume for the application code
VOLUME /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

#COPY web/ianseo.conf /etc/apache2/conf-available/
#COPY web/php.ini /usr/local/etc/php/
#COPY web/web_prep.sh /tmp
#COPY web/phpinfo.php /tmp
#COPY Ianseo_20190701.zip /tmp

#RUN /tmp/web_prep.sh
