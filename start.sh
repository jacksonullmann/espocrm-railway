#!/bin/bash

echo "Waiting for database..."
sleep 10

cat <<EOF > /var/www/html/data/config.php
<?php
return [
    'database' => [
        'driver' => 'pdo_mysql',
        'host' => getenv('DB_HOST'),
        'port' => getenv('DB_PORT'),
        'dbname' => getenv('DB_NAME'),
        'user' => getenv('DB_USER'),
        'password' => getenv('DB_PASSWORD'),
    ],
    'siteUrl' => getenv('SITE_URL'),
];
EOF

php /var/www/html/command.php user:create admin "$(echo $ADMIN_EMAIL)" "$(echo $ADMIN_PASSWORD)" Admin

apache2-foreground
