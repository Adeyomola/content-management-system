#! /bin/bash

mv wp-config-sample.php wp-config.php

sed -i "s|database_name_here|$DB_NAME|" wp-config.php
sed -i "s|username_here|$DB_USER|" wp-config.php
sed -i "s|password_here|$DB_PASSWORD|" wp-config.php
sed -i "s|localhost|$DB_HOST|" wp-config.php
