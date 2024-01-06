FROM php:8.1-apache-bullseye

HEALTHCHECK --retries=3 --timeout=60s CMD curl localhost
EXPOSE 80
EXPOSE 443

# copy wp-config editor and apache config to container.
COPY app.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./scripts/config_editor.sh /usr/local/bin/ 
#COPY wordpress /var/www/html/wordpress

# buildtime arguments
ARG app=/var/www/html/wordpress
ARG webroot=/var/www/html/
ARG url=http://wordpress.org/latest.tar.gz

# Install wget, git, and other tools.
RUN ["/bin/bash", "-c", "apt update -y && apt install git wget tar zlib1g-dev libzip-dev libpng-dev -y \
    && wget -P $webroot $url \
    && echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf && chmod u+x /usr/local/bin/config_editor.sh"]

# install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli bcmath zip gd

WORKDIR $webroot
RUN ["/bin/bash", "-c", "tar -xzvf latest.tar.gz && chmod 755 -R $webroot && chown www-data:www-data -R $webroot"]

WORKDIR $app
RUN ["/bin/bash", "-c", "chmod 755 -R $app && chown www-data:www-data -R $app"]

ENTRYPOINT ["/bin/bash", "-c", "config_editor.sh && a2enmod headers && service apache2 restart && tail -f /dev/null"]
