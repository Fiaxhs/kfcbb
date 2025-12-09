# phpBB on Railway

One-click deploy phpBB forum software on Railway.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/phpbb)

## Features

- phpBB 3.3.13 (latest stable)
- PHP 8.2 with Apache
- MySQL/MariaDB support
- Automatic port configuration for Railway
- Optimized PHP settings for forums

## Deployment

### Option 1: Deploy with Railway Button

1. Click the "Deploy on Railway" button above
2. Add a MySQL database service to your project
3. Set the required environment variables
4. Complete the phpBB installation wizard

### Option 2: Manual Deployment

1. Fork this repository
2. Create a new project on [Railway](https://railway.app)
3. Add a MySQL database service
4. Deploy from your GitHub repo
5. Set environment variables

## Environment Variables

Configure these in your Railway project settings:

| Variable | Description | Example |
|----------|-------------|---------|
| `MYSQL_HOST` | Database host | `mysql.railway.internal` |
| `MYSQL_DATABASE` | Database name | `railway` |
| `MYSQL_USER` | Database user | `root` |
| `MYSQL_PASSWORD` | Database password | (from Railway MySQL) |

## Post-Deployment Setup

1. Visit your Railway deployment URL
2. phpBB installation wizard will start automatically
3. Enter your database credentials from Railway's MySQL service:
   - Database server: Use `MYSQL_HOST` value (usually `mysql.railway.internal`)
   - Database name: Use `MYSQL_DATABASE` value
   - Database username: Use `MYSQL_USER` value
   - Database password: Use `MYSQL_PASSWORD` value
4. Complete the installation wizard
5. **Important**: After installation, delete the `/install` directory for security

## Security Notes

- After completing installation, remove the `install` directory
- Change default admin credentials immediately
- Consider enabling HTTPS through Railway's domain settings
- Regularly update phpBB and extensions

## Database Configuration

Railway's MySQL service provides connection details in the service's Variables tab. Use the internal hostname (`mysql.railway.internal`) for better performance within Railway's network.

## Persistent Storage

Railway deployments are ephemeral. For production use, consider:
- Using Railway's volume attachments for `/var/www/html/files` and `/var/www/html/store`
- External file storage (S3, etc.) for attachments
- Regular database backups

## Local Development

```bash
# Build the image
docker build -t phpbb-railway .

# Run with a local MySQL database
docker run -p 8080:80 \
  -e PORT=80 \
  phpbb-railway
```

## License

phpBB is licensed under the [GNU General Public License v2](https://www.phpbb.com/about/license/).
