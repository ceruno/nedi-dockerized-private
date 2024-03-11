FROM php:8.1-fpm

ENV NEDI_DB_HOST mysql
ENV NEDI_DB_NAME nedi
ENV NEDI_DB_USER root

ENV NEDI_SOURCE http://www.nedi.ch/pub
ENV NEDI_VERSION 2.3C
ENV NEDI_ZIP_PASSWORD RR4JC

#Install of dependency
RUN apt-get update && apt-get install -y --no-install-recommends \
     curl \
#    libdbd-mysql-perl \
#    libnet-snmp-perl \
#    libnet-telnet-perl \
#    libsocket6-perl \
#    librrds-perl \
#    libalgorithm-diff-perl \
#    libcrypt-rijndael-perl \
#    libcrypt-hcesha-perl \
#    libcrypt-des-perl \
#    libdigest-hmac-perl \
#    libio-pty-perl \
#    libwww-perl \
#    libnet-ntp-perl \
#    libnet-dns-perl \
#    perl-doc \
#    mariadb-client \
#    cron \
#    cpanminus \
#    php-mysql \
#    php-snmp \
#    php-gd \
#    php-ldap \
#    php-mcrypt \
#    rrdtool \
#    nginx \
#    openssl \
#    fping \
#    inetutils-ping \
#    libsnmp-dev \
#    libsnmp30 \
#    libfreetype6-dev \
#    libjpeg62-turbo-dev \
&& rm -rf /var/lib/apt/lists/*

 # Configure apache and required PHP modules
RUN set -ex; \
        \
        docker-php-ext-configure mysqli \
                --with-mysqli=mysqlnd \
        ; \
        docker-php-ext-configure gd \
                --with-freetype-dir=/usr/include/ \
                --with-jpeg-dir=/usr/include/ \
        ; \
        docker-php-ext-install -j "$(nproc)" \
                mysqli \
                gd \
                sockets \
                pdo_mysql \
                gettext \
                snmp \
                pcntl \
        ; \
        ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
        ; \
        echo ". /etc/environment" >> /etc/apache2/envvars \
        ; \
        a2enmod rewrite

 
RUN cpanm \
    Net::SNMP \
    Net::Telnet \
    Algorithm::Diff \
    DBI \
    Socket6 \
    LWP::UserAgent \
    Net::DNS::Resolver \
    Net::NTP \
    IO::Tty

RUN set -ex; \
        curl -o "$NEDI_SOURCE"/nedi-"$NEDI_VERSION".zip /tmp/ \
        ; \
        unizp -P "$NEDI_ZIP_PASSWORD" /tmp/nedi-"$NEDI_VERSION".zip -d /tmp \
        ; \
        tar zxf /tmp/nedi-"$NEDI_VERSION".zip --directory /tmp/nedi/ \
        ; \
        mv /tmp/nedi /var/nedi \
        ; \
        chown -R www-data:www-data /var/nedi \
        ; \
        mkdir -p /var/log/nedi \
        ; \
        chown -R www-data:www-data /var/log/nedi \
        ; \
        /var/nedi/nedi.pl -i "${NEDI_DB_USER} ${NEDI_DB_PASS} \
        ; \
        ln -s /var/nedi/nedi.conf /etc/nedi.conf \
        ; \
        sed -i -e "s/^upload_max_filesize.*/upload_max_filesize = 2G/"  "${PHP_INI_FILE}" \
        ; \
        sed -i -e "s/^post_max_size.*/post_max_size = 1G/"  "${PHP_INI_FILE}" \
        ; \
        sed -i '/dbhost/s/localhost/'"${NEDI_DB_HOST}"'/g' /var/local/nedi/nedi.conf \
        ; \
        sed -i '/dbuser/s/nedi/'"${NEDI_DB_USER}"'/g' /var/local/nedi/nedi.conf \
        ; \
        sed -i 's#/var/nedi#/var/local/nedi#g' /var/local/nedi/nedi.conf \
        ; \
        sed -i '/dbname/s/nedi/'"${NEDI_DB_NAME}"'/g' /var/local/nedi/nedi.conf

        #sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY docker-entrypoint.sh /usr/local/bin/
COPY install.exp /var/nedi/

RUN ln -s /usr/local/bin/docker-entrypoint.sh / &&\
     chmod +x /usr/local/bin/docker-entrypoint.sh &&\
     chmod +x /var/nedi/install.exp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--no-daemonize"]

WORKDIR /var/nedi/
EXPOSE 443 80 514