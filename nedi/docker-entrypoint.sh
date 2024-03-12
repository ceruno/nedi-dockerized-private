#!/bin/sh

# Create user
# sed -i 's#dbpa55#'${NEDI_DB_PASS}'#g' /var/nedi/nedi.conf
DB_ALREADY_INITIALIZED="/var/nedi/db-status/use_existing_database.pid"
if [ ! -e $DB_ALREADY_INITIALIZED ]; then
    touch $DB_ALREADY_INITIALIZED
    echo "-- First container startup --"
    # YOUR_JUST_ONCE_LOGIC_HERE
    expect /var/nedi/install.exp $NEDI_DB_USER $NEDI_DB_PASS
else
    echo "DB is already initialized."
fi

/usr/local/sbin/php-fpm