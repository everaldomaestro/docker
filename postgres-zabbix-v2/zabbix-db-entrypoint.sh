#!/bin/bash

set -e

if [ ! -d "/tmp/firstrun" ]; then
    echo "CREATE DATABASE zabbix;" | psql -U "$POSTGRES_USER"
    echo "CREATE USER zabbix WITH PASSWORD '"$ZBXUSER_PWD"';" | psql -U "$POSTGRES_USER"
    echo "GRANT ALL ON DATABASE zabbix TO zabbix;" | psql -U "$POSTGRES_USER"
    touch /tmp/firstrun
fi
