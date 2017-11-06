#!/bin/bash

set -e

if [ ! -d "/tmp/firstrun" ]; then
    echo "CREATE DATABASE zabbix;" | psql -U "$POSTGRES_USER"
    echo "CREATE USER zabbix WITH PASSWORD '"$ZBXUSER_PWD"';" | psql -U "$POSTGRES_USER"
    echo "GRANT ALL ON DATABASE zabbix TO zabbix;" | psql -U "$POSTGRES_USER"
    psql -U "$POSTGRES_USER" zabbix < /tmp/schema.sql
    psql -U "$POSTGRES_USER" zabbix < /tmp/images.sql
    psql -U "$POSTGRES_USER" zabbix < /tmp/data.sql
    touch /tmp/firstrun
fi
