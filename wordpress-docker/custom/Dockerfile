FROM php:8.2-fpm-alpine

# Install dependencies
RUN apk add --no-cache nginx libpng-dev libjpeg-turbo-dev freetype-dev zip bash

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli opcache

# 1. Prepare WordPress in a temporary "source" folder
WORKDIR /usr/src/wordpress
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz \
    && chown -R www-data:www-data /usr/src/wordpress

# 2. Add Nginx config (the same 8080 config from before)
COPY nginx.conf /etc/nginx/http.d/default.conf

# 3. Add the entrypoint script
COPY entrypoint.sh /usr/local/bin/
COPY wp-config-cloudrun.php /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory to the final destination
WORKDIR /var/www/html

EXPOSE 8080

# Use the entrypoint script to manage the population logic
ENTRYPOINT ["entrypoint.sh"]