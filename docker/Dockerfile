FROM php:8.1-apache-bullseye

HEALTHCHECK --retries=3 --timeout=60s CMD curl localhost
EXPOSE 80
EXPOSE 443

# copy wp-config editor and apache config to container.
COPY app.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./scripts/config_editor.sh /usr/local/bin/
RUN mkdir /var/www/html/wordpress
COPY wordpress /var/www/html/wordpress

# environment variables
ENV app=/var/www/html/wordpress

# Install wget, git, and other tools.
RUN ["/bin/bash", "-c", "apt update -y && apt install git wget zlib1g-dev libzip-dev libpng-dev -y \
&& echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf"]

# install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli bcmath zip gd

WORKDIR $app
RUN ["/bin/bash", "-c", "chmod 755 -R $app && chown www-data:www-data -R $app"]

ENTRYPOINT ["/bin/bash", "-c", "config_editor.sh && a2enmod headers && service apache2 restart && tail -f /dev/null"]
