#!/bin/bash
set -e

# Railway provides PORT environment variable, default to 80 if not set
PORT="${PORT:-80}"

# Update Apache to listen on the correct port
sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
sed -i "s/\*:80/\*:$PORT/g" /etc/apache2/sites-available/000-default.conf

echo "Apache configured to listen on port $PORT"

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
