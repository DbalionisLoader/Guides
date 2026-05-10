## Best Docker Compose for WP install (10/05/2026)

# Import checklist

- [ ] Database is empty before import
- [ ] Old DB dump imported successfully
- [ ] wp-config.php points to the correct database ( !! IMPORTANT !! if migrating from live website as not using the same DB name)
- [ ] $table_prefix matches imported tables in wp_config
- [ ] siteurl and home updated to local URL in wp_options table
- [ ] Log in using old admin user
- [ ] Reset password in users table if needed

# Docker Compose file changes between projects

When creating a new site from the same Compose file, change:

- [ ] Create unique named folder to each local website
- [ ] WordPress host port, e.g. 8081:80 to 8082:80
- [ ] phpMyAdmin host port, e.g. 8082:80 to 8083:80, if running multiple phpMyAdmin containers
- [ ] WORDPRESS_DB_NAME, MYSQL_DATABASE to unique database name per project (as match the db name from live site)
- [ ]Optional: Compose project name using docker compose -p unique_name up -d (prefix with unique name incase folder have the same names)

Do not change:

WORDPRESS_DB_HOST: db:3306
PMA_HOST: db
Internal MySQL port 3306
wp_html:/var/www/html
./wp-content:/var/www/html/wp-content
db:/var/lib/mysql
./backups:/backups

These can stay same or be changed:

- [ ] `WORDPRESS_DB_USER
- [ ] `MYSQL_USER
- [ ] `WORDPRESS_DB_PASSWORD
- [ ] `MYSQL_PASSWORD
- [ ] `MYSQL_ROOT_PASSWORD

# Future Additions

Look into Traefik, Caddy, or Nginx Proxy Manager to replace localhost:8080 with local domains

# Docker Commands

Start:
docker compose up -d
End:
docker compose down

Reset and delete everything:
docker compose down -v

Show running containers:
docker compose ps

Show all docker containers:
docker ps

## SQL Import/Export commands

# Dump a database:

(create backup first folder) (remove <> from names)
No space between -p and the password

Linux and macOS:

docker exec <mysql container name> mysqldump \
 -u root -prootpassword \
 --single-transaction \
 --quick \
 --lock-tables=false \
 <database name> > backups/wordpress.sql

Windows:

docker exec databasetest-db-1 mysqldump -u root -prootexamplepass --single-transaction --quick --lock-tables=false testexampledata > backups/wordpress.sql

# Import a database

docker exec -i <mysql container name> mysql \
 -u root -prootpassword \
 <new database name> < backups/wordpress.sql

# Test database exist

docker compose exec db mysql \
 -u test_exampleuser \
 -ptest_examplepass \
 -e "SHOW DATABASES;"

## Troubleshooting Commands

Check database logs:
docker compose logs db

## WP-CLI Commands

# Search replace command

docker compose run --rm wpcli search-replace \
 'http://localhost:OLDPORT' \
 'http://localhost:8081' \
 --all-tables

Flush cache:
docker compose run --rm wpcli cache flush

Update home url:
docker compose run --rm wpcli option update home 'http://localhost:8081'

update site url:
docker compose run --rm wpcli option update siteurl 'http://localhost:8081'

Check if wp-cli running:
docker compose run --rm wpcli --info

Get siteurl:
docker compose run --rm wpcli option get siteurl

Get homeurl:
docker compose run --rm wpcli option get home

Test db connect: (needs fixing )
docker compose run --rm wpcli option get home

Check db connection with ssl disabled: (Try if above gives SSL error)
docker compose run --rm wpcli db check -- --ssl=0

or

docker compose run --rm wpcli db check -- --ssl-mode=DISABLED

Show databse tables:
docker compose run --rm wpcli db tables

Show plugin list:
docker compose run --rm wpcli plugin list

Show themes list:
docker compose run --rm wpcli theme list

## Fixing Permission
