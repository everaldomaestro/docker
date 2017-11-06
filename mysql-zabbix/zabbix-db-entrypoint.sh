#!/bin/bash

set -e

if [ ! -d "/tmp/firstrun" ]; then
    echo "CREATE DATABASE zabbix CHARACTER SET UTF8;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "GRANT ALL PRIVILEGES ON *.* TO zabbix@localhost IDENTIFIED BY '"$MYSQLZBX_PWD"' WITH GRANT OPTION;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "GRANT ALL PRIVILEGES ON *.* TO zabbix@'"$ZBX_SERVER"' IDENTIFIED BY '"$MYSQLZBX_PWD"' WITH GRANT OPTION;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "FLUSH PRIVILEGES;" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"
    cat /tmp/schema.sql | mysql -u zabbix zabbix -p"$MYSQLZBX_PWD"
    cat /tmp/images.sql | mysql -u zabbix zabbix -p"$MYSQLZBX_PWD"
    cat /tmp/data.sql | mysql -u zabbix zabbix -p"$MYSQLZBX_PWD"
    touch /tmp/firstrun
fi
