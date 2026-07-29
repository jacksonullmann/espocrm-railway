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

# 🔥 PERMISSÕES CORRETAS PARA TODAS AS PASTAS QUE O ESPOCRM USA
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html \
    && chmod -R 775 /var/www/html/data \
    && chmod -R 775 /var/www/html/data/logs \
    && chmod -R 775 /var/www/html/data/cache \
    && chmod -R 775 /var/www/html/application \
    && chmod -R 775 /var/www/html/custom

RUN a2enmod rewrite

COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
