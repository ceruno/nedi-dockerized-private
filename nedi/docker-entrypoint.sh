#!/bin/sh

# Wait until database is ready
while ! mysqladmin ping -h"$NEDI_DB_HOST" --silent; do sleep 1; done

# Create DB
NEDI_FOLDER="/var/nedi"
DB_INIT_FILE="$NEDI_FOLDER/mapped_files/db_initialized.pid"
NEDI_CONF="$NEDI_FOLDER/mapped_files/nedi.conf"
NEDI_CRON="$NEDI_FOLDER/mapped_files/crontab"

if [ ! -e $DB_INIT_FILE ]; then
    touch $DB_INIT_FILE
    echo "First container startup! Initialize new DB..."
    # YOUR_JUST_ONCE_LOGIC_HERE
    expect $NEDI_FOLDER/install.exp $NEDI_DB_USER $NEDI_DB_PASS
else
    echo "DB is already initialized."
fi

if [ ! -e $NEDI_CONF ]; then
    mv $NEDI_FOLDER/nedi.conf $NEDI_CONF
    ln -s NEDI_CONF $NEDI_FOLDER/nedi.conf
    chown -R www-data:www-data $NEDI_FOLDER
fi

if [ ! -e $NEDI_CRON ]; then
    mv $NEDI_FOLDER/inc/crontab $NEDI_CRON
    ln -s NEDI_CRON $NEDI_FOLDER/inc/crontab
    chown -R www-data:www-data $NEDI_FOLDER
fi

/usr/local/sbin/php-fpm