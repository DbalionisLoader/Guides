## Creating a WP CRON Script and adding the CRON job to server

1. Create/find cron folder inside domain director

This example was place on mydomain.com/httpdoc/cron folder

2. Write the WP script to perform wanted action

### Example refresh permalink script:

```php
<?php

// Need to fetch wordpress so flush funnction is found
require_once '../wp-load.php';

// False for soft flush_rewrite_rules: True for hard refresh (READ MORE)
flush_rewrite_rules(false);

//Loggin and server message
error_log('PermaLinks Refreshed: ' . date('Y-m-d H:i:s'));

echo "Permalinks refreshed succesfully.\n";

?>
```

3. Upload the script file to 'mydomain.com/httpdoc/cron' folder using ftp, plesk files.

4. Check the php version and local file path. As the wp-load.php needs php to run.

5. Test the script on the server shh terminal, using following command:

```bash
/opt/plesk/php/8.3/bin/php /var/www/vhosts/<mydomain.com>/httpdocs/cron/refresh-permalinks.php
```

Since the command is using a absolute path name, it can be run anywhere.

Expect concole output should be: "Permalinks refreshed succesfully."

If you see a HTML formatted error: it most likely caused by the wp-load.php not finding correct version or folder php.

6. Run command:

```bash
crontab -e
```

It should open a text editor where you add the CRON job command

7. Add following command to run the CRON at particular interval.

```bash
0 3 * * * /opt/plesk/php/8.3/bin/php /var/www/vhosts/boommachinerysales.com/httpdocs/cron/refresh-permalinks.php >/dev/null 2>&1
```

the \* \* \* \* \* denotes the timing the CORN job will run. Google the exact meaning and how to use it.

8. Save the file and close it down. Check if CRON job is registed using:

```bash
crontab -l
```
