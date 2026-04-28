1. Pull the site from Plesk

In Plesk:

Go to Websites & Domains
Open File Manager
Download the WordPress site files, usually from:
httpdocs/

You mainly need:

wp-content/
wp-config.php
.htaccess

Then export the database:

Go to Websites & Domains → Databases
Choose the site database
Click Export Dump
Download the .sql dump

Plesk officially supports exporting database dumps from the database tools panel.

2. Create local project structure
   my-site-local/
   docker-compose.yml
   db/
   live.sql
   wordpress/
   wp-content/
   .htaccess

Copy the live wp-content into wordpress/wp-content.

3. Add docker-compose.yml
   services:
   db:
   image: mysql:8.0
   container_name: local_wp_db
   restart: unless-stopped
   environment:
   MYSQL_DATABASE: wordpress
   MYSQL_USER: wordpress
   MYSQL_PASSWORD: wordpress
   MYSQL_ROOT_PASSWORD: root
   volumes: - db_data:/var/lib/mysql - ./db/live.sql:/docker-entrypoint-initdb.d/live.sql

wordpress:
image: wordpress:latest
container_name: local_wp
restart: unless-stopped
depends_on: - db
ports: - "8080:80"
environment:
WORDPRESS_DB_HOST: db:3306
WORDPRESS_DB_NAME: wordpress
WORDPRESS_DB_USER: wordpress
WORDPRESS_DB_PASSWORD: wordpress
volumes: - ./wordpress/wp-content:/var/www/html/wp-content - ./wordpress/.htaccess:/var/www/html/.htaccess

wpcli:
image: wordpress:cli
depends_on: - db - wordpress
volumes: - ./wordpress/wp-content:/var/www/html/wp-content
environment:
WORDPRESS_DB_HOST: db:3306
WORDPRESS_DB_NAME: wordpress
WORDPRESS_DB_USER: wordpress
WORDPRESS_DB_PASSWORD: wordpress

volumes:
db_data:

The official WordPress Docker image supports DB connection settings through environment variables.

4. Start containers
   docker compose up -d

Visit:

http://localhost:8080 5. Fix the site URL

Run a search-replace from the live domain to local:

docker compose run --rm wpcli wp search-replace 'https://example.com' 'http://localhost:8080' --all-tables

Use your real live domain instead of example.com.

WP-CLI’s search-replace handles WordPress database replacements, including serialized data, which is why it’s safer than manually editing SQL.

6. Check wp-config.php

If you copied the live wp-config.php, either remove it and let the Docker image generate one, or edit these values:

define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'db:3306'); 7. Common fixes

If the DB import did not run, reset the volume:

docker compose down -v
docker compose up -d

If uploads are missing, make sure you copied:

wp-content/uploads/

If plugins break locally, disable them:

docker compose run --rm wpcli wp plugin deactivate --all

Then reactivate one by one.

Final local URL:

ht
