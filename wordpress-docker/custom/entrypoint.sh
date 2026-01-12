#!/bin/bash
set -e

echo "1. Check if index.php exists; if not, the directory is empty/new"

# Check if index.php exists; if not, the directory is empty/new
if [ ! -e /var/www/html/index.php ]; then
    echo "Directory /var/www/html is empty. Populating with WordPress..."
    cp -p -R /usr/src/wordpress/. /var/www/html/
    echo "Changing permissions..."
    chown -R www-data:www-data /var/www/html
fi

echo "2. Inject our custom config (overwriting the default)"

# This ensures environment variables are always mapped correctly
cp /usr/local/bin/wp-config-cloudrun.php /var/www/html/wp-config.php

echo "3. Ensure permissions are correct"
chown -R www-data:www-data /var/www/html

echo "Start PHP-FPM in the background"

# Start PHP-FPM in the background
php-fpm -D

echo "Start Nginx in the foreground"

# Start Nginx in the foreground
exec nginx -g 'daemon off;'