#!/bin/bash
set -e

# Railway provides PORT environment variable
if [ -n "$PORT" ]; then
    # Update Apache to listen on the Railway-provided port
    sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
    sed -i "s/:80/:$PORT/" /etc/apache2/sites-available/000-default.conf
fi

# Ensure proper permissions on writable directories
chown -R www-data:www-data /var/www/html/cache
chown -R www-data:www-data /var/www/html/store
chown -R www-data:www-data /var/www/html/files
chown -R www-data:www-data /var/www/html/images/avatars/upload

# Make config.php writable for installation
if [ ! -f /var/www/html/config.php ]; then
    touch /var/www/html/config.php
fi
chown www-data:www-data /var/www/html/config.php
chmod 666 /var/www/html/config.php

echo "phpBB is starting..."
echo "Database connection details should be configured via environment variables:"
echo "  MYSQL_HOST, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD"

exec "$@"
