#!/bin/bash

set -e

if [ ! -d "/tmp/firstrun" ]; then
    echo "GRANT ALL PRIVILEGES ON *.* TO zabbix@'%' IDENTIFIED BY '"$MYSQLZBX_PWD"' WITH GRANT OPTION;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "FLUSH PRIVILEGES;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    touch /tmp/firstrun
fi
