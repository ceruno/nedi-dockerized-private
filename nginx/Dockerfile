FROM nginx:latest

ENV NEDI_DB_HOST mysql
ENV NEDI_DB_NAME nedi
ENV NEDI_DB_USER root
ENV NEDI_DB_PASS N3diRox

ENV NEDI_SOURCE http://www.nedi.ch/pub
ENV NEDI_VERSION 2.3C
ENV NEDI_ZIP_PASSWORD RR4JC

#Install of dependency
RUN apt-get update && apt-get install -y --no-install-recommends \
     expect \
     curl \
     unzip \
     tar \
     openssl \
     libdbd-mysql-perl \
     libnet-snmp-perl \
     libnet-telnet-perl \
     libsocket6-perl \
     librrds-perl \
     libalgorithm-diff-perl \
     libcrypt-rijndael-perl \
     libcrypt-hcesha-perl \
     libcrypt-des-perl \
     libdigest-hmac-perl \
     libio-pty-perl \
     libwww-perl \
     libnet-ntp-perl \
     libnet-dns-perl \
     perl-doc \
     mariadb-client \
     cron \
     cpanminus \
     php-mysql \
     php-snmp \
     php-gd \
     php-ldap \
     php-mcrypt \
     rrdtool \
     nginx \
     openssl \
     fping \
     inetutils-ping \
     libsnmp-dev \
#    libsnmp30 \
     libfreetype6-dev \
     libjpeg62-turbo-dev \
&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
        curl -o /tmp/nedi-"$NEDI_VERSION".zip "$NEDI_SOURCE"/nedi-"$NEDI_VERSION".zip \
        ; \
        unzip -P "$NEDI_ZIP_PASSWORD" /tmp/nedi-"$NEDI_VERSION".zip -d /tmp \
        ; \
        mkdir -p /tmp/nedi \
        ; \
        tar zxf /tmp/nedi-"$NEDI_VERSION".tgz --directory /tmp/nedi/ \
        ; \
        mv /tmp/nedi /var/nedi \
        ; \
        chown -R www-data:www-data /var/nedi \
        ; \
        mkdir -p /var/log/nedi \
        ; \
        chown -R www-data:www-data /var/log/nedi \
        ; \
        openssl genrsa -out /etc/ssl/private/server.key 2048 \
        ; \
        openssl req -new -key /etc/ssl/private/server.key -out /etc/ssl/server.csr -subj "/C=CH/ST=ZH/L=Zurich/O=NeDi Consulting/OU=R&D" \
        ; \
        openssl x509 -req -days 1260 -in /etc/ssl/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/server.crt \
        ; \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
        ; \
        sed -i -e "s/^upload_max_filesize.*/upload_max_filesize = 32M/"  "$PHP_INI_DIR/php.ini" \
        ; \
#       sed -i -e "s/^post_max_size.*/post_max_size = 1G/"  "${PHP_INI_DIR\php.ini}" \
#       ; \
        sed -i -e '/^dbhost/s/localhost/'"${NEDI_DB_HOST}"'/g' /var/nedi/nedi.conf \
        ; \
        sed -i -e '/^dbuser/s/nedi/'"${NEDI_DB_USER}"'/g' /var/nedi/nedi.conf \
        ; \
        sed -i -e  '/^dbname/s/nedi/'"${NEDI_DB_NAME}"'/g' /var/nedi/nedi.conf \
        ; \
        sed -i -e  '/^dbpass/s/dbpa55/'"${NEDI_DB_PASS}"'/g' /var/nedi/nedi.conf
#        ; \
#        ln -s /var/nedi/nedi.conf /etc/nedi.conf \
#        ; \

COPY nginx/nedi.conf /etc/nginx/conf.d
COPY nedi/docker-entrypoint.sh /usr/local/bin/
COPY nedi/install.exp /var/nedi/

RUN ln -s /usr/local/bin/docker-entrypoint.sh / &&\
    chmod +x /usr/local/bin/docker-entrypoint.sh &&\
    chmod +x /var/nedi/install.exp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--no-daemonize"]

WORKDIR /var/nedi/
EXPOSE 80 443 514