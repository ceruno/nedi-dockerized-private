FROM nginx:1.25

ENV NEDI_SOURCE http://www.nedi.ch/pub
ENV NEDI_VERSION 2.3C
ENV NEDI_ZIP_PASSWORD RR4JC

#Install of dependency
RUN apt-get update && apt-get install -y --no-install-recommends \
     openssl \
     curl \
     unzip \
     tar \
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
        openssl x509 -req -days 1260 -in /etc/ssl/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/server.crt


COPY nginx/nedi.conf /etc/nginx/conf.d/nedi.conf
COPY nginx/phpmyadmin.conf /etc/nginx/conf.d/phpmyadmin.conf