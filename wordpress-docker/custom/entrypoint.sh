#!/bin/bash
set -e

# Check if index.php exists; if not, the directory is empty/new
if [ ! -e /var/www/html/index.php ]; then
    echo "Directory /var/www/html is empty. Populating with WordPress..."
    cp -p -R /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Start PHP-FPM in the background
php-fpm -D

# Start Nginx in the foreground
echo "Starting Nginx on port 8080..."
exec nginx -g 'daemon off;'