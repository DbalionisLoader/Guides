#!/bin/bash

# ** Change the details to match your compose.yaml file **
CONTAINER="db"
DB_NAME="pivot_block"
DB_USER="test_exampleuser"
DB_PASS="test_examplepass"
DB_ROOT="rootexamplepass"

# Enable to dump db next to compose file
#DUMP_FILE="$(dirname "$0")/backups/db_dump.sql"

# Change file path is different wp dir or different theme name
DUMP_FILE="./wp-content/themes/pivotblocks/database/pivot_block.sql"
TMP_FILE="${DUMP_FILE}.tmp"

mkdir -p "$(dirname "$DUMP_FILE")"

# If tablespaces needed - user:root - pass: $DB_ROOT

docker compose exec -T "$CONTAINER" \
 mysqldump --no-tablespaces \
 -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$TMP_FILE"

 if [ $? -eq 0 ]; then
	mv "$TMP_FILE" "$DUMP_FILE"
	echo "Dump updated: $(date) $DUMP_FILE"
	exit 0
else
	rm -f "$TMP_FILE"
	echo "Dump Failed - check folder path, docker command, sql permissions or sql details match containers"
	exit 1
fi	
