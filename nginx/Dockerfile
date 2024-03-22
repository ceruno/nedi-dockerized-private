FROM nginx:1.25

ENV NEDI_FOLDER /var/nedi
ENV NEDI_LOG_FOLDER /var/log/nedi

#Install of dependency
RUN apt-get update && apt-get install -y --no-install-recommends \
     openssl \
     curl \
     unzip \
     tar \
&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
        mkdir -p $NEDI_FOLDER \
        ; \
        chown -R www-data:www-data $NEDI_FOLDER \
        ; \
        mkdir -p $NEDI_LOG_FOLDER \
        ; \
        chown -R www-data:www-data $NEDI_LOG_FOLDER \
        ; \
        openssl genrsa -out /etc/ssl/private/server.key 2048 \
        ; \
        openssl req -new -key /etc/ssl/private/server.key -out /etc/ssl/server.csr -subj "/C=CH/ST=ZH/L=Zurich/O=NeDi Consulting/OU=R&D" \
        ; \
        openssl x509 -req -days 1260 -in /etc/ssl/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/server.crt

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nedi.conf /etc/nginx/conf.d/nedi.conf
COPY nginx/phpmyadmin.conf /etc/nginx/conf.d/phpmyadmin.conf