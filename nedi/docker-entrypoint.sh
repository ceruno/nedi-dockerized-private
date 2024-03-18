#!/bin/sh

# Wait until database is ready
while ! mysqladmin ping -h"$NEDI_DB_HOST" --silent; do sleep 1; done

# Create DB
NEDI_FOLDER="/var/nedi"
DB_INIT_FILE="$NEDI_FOLDER/db_initialized.pid"

if [ ! -e $DB_INIT_FILE ]; then
    touch $DB_INIT_FILE
    echo "First container startup! Initialize new DB..."
    # YOUR_JUST_ONCE_LOGIC_HERE
    expect $NEDI_FOLDER/install.exp $NEDI_DB_USER $NEDI_DB_PASS
else
    echo "DB is already initialized."
fi

# Move Nedi app files to volume
if [ ! -e $NEDI_FOLDER/nedi.conf ]; then
    cp -v -r /tmp/nedi/* $NEDI_FOLDER/
    chown -R www-data:www-data $NEDI_FOLDER
fi

/usr/local/sbin/php-fpm