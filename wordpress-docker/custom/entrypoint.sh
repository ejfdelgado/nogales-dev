#!/bin/bash
set -e

# Check if index.php exists; if not, the directory is empty/new
if [ ! -e /var/www/html/index.php ]; then
    echo "Directory /var/www/html is empty. Populating with WordPress..."
    cp -p -R /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# 2. Inject our custom config (overwriting the default)
# This ensures environment variables are always mapped correctly
cp /usr/local/bin/wp-config-cloudrun.php /var/www/html/wp-config.php

# 3. Ensure permissions are correct
chown -R www-data:www-data /var/www/html

# Start PHP-FPM in the background
php-fpm -D

# Start Nginx in the foreground
echo "Starting Nginx on port 8080..."
exec nginx -g 'daemon off;'