#!/bin/bash

# Espera o MySQL do Railway subir
echo "Aguardando MySQL..."
sleep 10

# Cria config do EspoCRM
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

# Cria admin automaticamente
php /var/www/html/command.php user:create admin "$(echo $ADMIN_EMAIL)" "$(echo $ADMIN_PASSWORD)" Admin

# Inicia Apache
apache2-foreground
