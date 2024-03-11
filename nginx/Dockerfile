FROM nginx:latest

ENV NEDI_SOURCE http://www.nedi.ch/pub
ENV NEDI_VERSION 2.3C
ENV NEDI_ZIP_PASSWORD RR4JC

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
        chown -R www-data:www-data /var/log/nedi
#        ; \
#        ln -s /var/nedi/nedi.conf /etc/nedi.conf \
#        ; \

COPY nedi.conf /etc/nginx/conf.d