FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions required by phpBB
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    intl \
    opcache

# Enable Apache modules
RUN a2enmod rewrite headers

# Set recommended PHP settings for phpBB
RUN { \
    echo 'upload_max_filesize = 10M'; \
    echo 'post_max_size = 10M'; \
    echo 'memory_limit = 256M'; \
    echo 'max_execution_time = 60'; \
    echo 'session.cookie_httponly = 1'; \
    } > /usr/local/etc/php/conf.d/phpbb.ini

# Download and extract phpBB
ENV PHPBB_VERSION=3.3.13
RUN curl -fsSL "https://download.phpbb.com/pub/release/3.3/${PHPBB_VERSION}/phpBB-${PHPBB_VERSION}.zip" -o /tmp/phpbb.zip \
    && unzip /tmp/phpbb.zip -d /tmp \
    && rm -rf /var/www/html/* \
    && mv /tmp/phpBB3/* /var/www/html/ \
    && rm -rf /tmp/phpbb.zip /tmp/phpBB3

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/cache \
    && chmod -R 777 /var/www/html/store \
    && chmod -R 777 /var/www/html/files \
    && chmod -R 777 /var/www/html/images/avatars/upload

# Copy custom Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port (Railway uses PORT env variable)
EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
