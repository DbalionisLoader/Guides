## Best Docker Compose for WP install (10/05/2026)

# Import checklist

[ ] Database is empty before import
[ ] Old DB dump imported successfully
[ ] wp-config.php points to the correct database ( !! IMPORTANT !! if migrating from live website as not using the same DB name)
[ ] $table_prefix matches imported tables in wp_config
[ ] siteurl and home updated to local URL in wp_options table
[ ] Log in using old admin user
[ ] Reset password in users table if needed

# Docker Compose file changes between projects

When creating a new site from the same Compose file, change:

[ ] Create unique named folder to each local website
[ ] WordPress host port, e.g. 8081:80 to 8082:80
[ ] phpMyAdmin host port, e.g. 8082:80 to 8083:80, if running multiple phpMyAdmin containers
[ ] WORDPRESS_DB_NAME, MYSQL_DATABASE to unique database name per project (as match the db name from live site)
[ ]Optional: Compose project name using docker compose -p unique_name up -d (prefix with unique name incase folder have the same names)

Do not change:

WORDPRESS_DB_HOST: db:3306
PMA_HOST: db
Internal MySQL port 3306
wp_html:/var/www/html
./wp-content:/var/www/html/wp-content
db:/var/lib/mysql
./backups:/backups

These can stay same or be changed:

[ ] WORDPRESS_DB_USER
[ ] MYSQL_USER
[ ] WORDPRESS_DB_PASSWORD
[ ] MYSQL_PASSWORD
[ ] MYSQL_ROOT_PASSWORD

# Future Additions

Look into Traefik, Caddy, or Nginx Proxy Manager to replace localhost:8080 with local domains

# The docker compose file:

services:
wordpress:
image: wordpress:php8.2-apache
platform: linux/amd64
restart: always
ports: - "8081:80"
environment:
WORDPRESS_DB_HOST: db:3306
WORDPRESS_DB_USER: test_exampleuser
WORDPRESS_DB_PASSWORD: test_examplepass
WORDPRESS_DB_NAME: testexampledata
volumes: - wp_html:/var/www/html - ./wp-content:/var/www/html/wp-content
depends_on: - db

db:
image: mysql:8.0
platform: linux/amd64
restart: always
environment:
MYSQL_DATABASE: testexampledata
MYSQL_USER: test_exampleuser
MYSQL_PASSWORD: test_examplepass
MYSQL_ROOT_PASSWORD: rootexamplepass
volumes: - db:/var/lib/mysql - ./backups:/backups

wpcli:
image: wordpress:cli-php8.2
platform: linux/amd64
user: "33:33"
environment:
WORDPRESS_DB_HOST: db:3306
WORDPRESS_DB_NAME: testexampledata
WORDPRESS_DB_USER: test_exampleuser
WORDPRESS_DB_PASSWORD: test_examplepass
volumes: - wp_html:/var/www/html - ./wp-content:/var/www/html/wp-content - ./backups:/backups
depends_on: - db - wordpress
entrypoint: ["wp"]

phpmyadmin:
image: phpmyadmin:latest
platform: linux/amd64
restart: always
ports: - "8082:80"
environment:
PMA_HOST: db
PMA_PORT: 3306
depends_on: - db

volumes:
wp_html:
db:
