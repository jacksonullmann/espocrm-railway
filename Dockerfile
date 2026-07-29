ARG REBUILD=1
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    mariadb-client \
    && docker-php-ext-install pdo pdo_mysql mbstring gd xml

WORKDIR /var/www/html

RUN curl -L https://www.espocrm.com/downloads/EspoCRM-8.2.0.zip -o espocrm.zip \
    && unzip espocrm.zip \
    && rm espocrm.zip \
    && mv EspoCRM-8.2.0/* . \
    && rm -rf EspoCRM-8.2.0

# 🔥 CRIA DIRETÓRIO DE DADOS FORA DO /var/www/html
RUN mkdir -p /data/logs \
    && mkdir -p /data/cache \
    && mkdir -p /data/upload \
    && mkdir -p /data/files

RUN chown -R www-data:www-data /data \
    && chmod -R 775 /data

RUN a2enmod rewrite

COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
