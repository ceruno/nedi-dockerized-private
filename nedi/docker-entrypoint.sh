#!/bin/sh

# Create user
# sed -i 's#dbpa55#'${NEDI_DB_PASS}'#g' /var/nedi/nedi.conf
CONTAINER_ALREADY_STARTED="/var/nedi/use_existing_database.pid"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    # YOUR_JUST_ONCE_LOGIC_HERE
    expect /var/nedi/install.exp $NEDI_DB_USER $NEDI_DB_PASS
else
    echo "DB is already initialized."
fi

/usr/local/sbin/php-fpm.sh