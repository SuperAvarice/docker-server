FROM php:7.2-apache

# Install packages
RUN apt-get update && \
    apt-get install -y git unzip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove --purge

RUN cd /var/www && git clone https://github.com/rpieterick/autocross-live-results.git && chown -R www-data:www-data autocross-live-results/ && cd /var/www/autocross-live-results && php composer.phar install --no-dev
COPY timing.php /var/www/autocross-live-results/config/timing.php

COPY sites.conf /etc/apache2/sites-available/sites.conf
RUN a2ensite sites && \
    a2dissite 000-default && \
    a2dissite default-ssl

#VOLUME ["/var/www/autocross-live-results"]
