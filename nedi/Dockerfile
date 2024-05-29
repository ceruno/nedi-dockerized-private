FROM php:8.1-fpm

ENV NEDI_DB_HOST mysql
ENV NEDI_DB_NAME nedi
ENV NEDI_DB_USER root
ENV NEDI_DB_PASS N3diRox

ENV NEDI_SOURCE  https://www.nedi.ch/priv8
ENV NEDI_VERSION 2.4.024matt24
ENV NEDI_ZIP_PASSWORD RR4JC
ENV NEDI_SRC_FOLDER /tmp/nedi
ENV NEDI_FOLDER /var/nedi
ENV NEDI_LOG_FOLDER /var/log/nedi


#Install of dependency
RUN apt-get update && apt-get install -y --no-install-recommends \
     expect \
     curl \
     unzip \
     tar \
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
     rrdtool \
     nginx \
     openssl \
     fping \
     rcconf \
     iperf \
     net-tools \
     openssh-client \
     inetutils-ping \
     libsnmp-dev \
     libfreetype6-dev \
     libjpeg62-turbo-dev \
&& rm -rf /var/lib/apt/lists/*

 # Configure apache and required PHP modules
RUN set -ex; \
        \
        docker-php-ext-install -j "$(nproc)" \
                mysqli \
                gd \
                pdo \
                pdo_mysql \
                gettext \
                snmp \
                pcntl \
        ; \
        docker-php-ext-configure mysqli \
                --with-mysqli=mysqlnd \
        ; \
        docker-php-ext-configure gd

 
RUN cpanm \
    Net::SNMP \
    Net::Telnet \
    Algorithm::Diff \
    DBI \
    Socket6 \
    LWP::UserAgent \
    Net::DNS::Resolver \
    Net::NTP \
    Net::Telnet::Cisco \
    IO::Tty

RUN set -ex; \
        curl -o $NEDI_SRC_FOLDER-"$NEDI_VERSION".zip "$NEDI_SOURCE"/nedi-"$NEDI_VERSION".zip \
        ; \
        unzip -P "$NEDI_ZIP_PASSWORD" $NEDI_SRC_FOLDER-"$NEDI_VERSION".zip -d /tmp \
        ; \
        mkdir -p $NEDI_SRC_FOLDER \
        ; \
        tar zxf $NEDI_SRC_FOLDER-"$NEDI_VERSION".tgz --directory $NEDI_SRC_FOLDER \
        ; \
        rm -f $NEDI_SRC_FOLDER-"$NEDI_VERSION".zip \
        ; \
        mkdir -p $NEDI_LOG_FOLDER \
        ; \
        chown -R www-data:www-data $NEDI_LOG_FOLDER \
        ; \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
        ; \
        sed -i -e "s/^upload_max_filesize.*/upload_max_filesize = 32M/"  "$PHP_INI_DIR/php.ini" \
        ; \
        sed -i -e '/^dbhost/s/localhost/'"${NEDI_DB_HOST}"'/g' $NEDI_SRC_FOLDER/nedi.conf \
        ; \
        sed -i -e '/^dbuser/s/nedi/'"${NEDI_DB_USER}"'/g' $NEDI_SRC_FOLDER/nedi.conf \
        ; \
        sed -i -e '/^dbname/s/nedi/'"${NEDI_DB_NAME}"'/g' $NEDI_SRC_FOLDER/nedi.conf \
        ; \
        sed -i -e '/^dbpass/s/dbpa55/'"${NEDI_DB_PASS}"'/g' $NEDI_SRC_FOLDER/nedi.conf \
        ; \
        sed -i -e '/^nedipath/s|/var/nedi|'"${NEDI_FOLDER}"'|g' $NEDI_SRC_FOLDER/nedi.conf \
        ; \
        sed -i -e '/^use Math::BigInt();/ause Time::HiRes;' /usr/share/perl5/Net/SNMP/Message.pm \
        ; \
        sed -i -e "/^   DEBUG_INFO('transport/i\ \ \ \$this->{_transport}->{_send_time} = Time::HiRes::time;\n" /usr/share/perl5/Net/SNMP/Message.pm \
        ; \
        echo "    KexAlgorithms=+diffie-hellman-group1-sha1" >> /etc/ssh/ssh_config

COPY nedi/docker-entrypoint.sh /usr/local/bin/
COPY nedi/install.exp $NEDI_SRC_FOLDER

# Setting up syslog and monitoring startup scripts
COPY nedi/nedi-monitor /etc/init.d/
COPY nedi/nedi-syslog /etc/init.d/

RUN set -ex; \
        chmod 755 /etc/init.d/nedi-monitor \
        ; \
        update-rc.d nedi-monitor defaults \
        ; \
        chmod 755 /etc/init.d/nedi-syslog \
        ; \
        update-rc.d nedi-syslog defaults

RUN ln -s /usr/local/bin/docker-entrypoint.sh / &&\
    chmod +x /usr/local/bin/docker-entrypoint.sh &&\
    chmod +x $NEDI_SRC_FOLDER/install.exp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--no-daemonize"]

EXPOSE 1514 9000
