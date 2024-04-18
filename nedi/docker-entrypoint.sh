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
    echo "Copy NeDi files from original sources to $NEDI_FOLDER..."
    cp -v -r /tmp/nedi/* $NEDI_FOLDER/
    chown -R www-data:www-data $NEDI_FOLDER
fi

# Set timezone
if [ -n "$TZ" ]; then
    echo "Set time zone to $TZ"
    echo $TZ > /etc/timezone
fi

# Update MAC vendor database
curl -L -o $NEDI_FOLDER/inc/oui.csv https://standards.ieee.org/develop/regauth/oui/oui.csv
curl -L -o $NEDI_FOLDER/inc/mam.csv https://standards.ieee.org/develop/regauth/oui28/mam.csv
curl -L -o $NEDI_FOLDER/inc/oui36.csv https://standards.ieee.org/develop/regauth/oui36/oui36.csv
curl -L -o $NEDI_FOLDER/inc/iab.csv https://standards.ieee.org/develop/regauth/iab/iab.csv
curl -L -o $NEDI_FOLDER/inc/cid.csv https://standards.ieee.org/develop/regauth/cid/cid.csv

/usr/sbin/cron

cd $NEDI_FOLDER

/usr/local/sbin/php-fpm