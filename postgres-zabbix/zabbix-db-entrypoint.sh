#!/bin/bash

set -e 

if [ ! -d "/tmp/firstrun" ]; then
    echo "CREATE DATABASE zabbix;" | psql -U postgres
    echo "CREATE USER zabbix WITH PASSWORD 'zabbix';" | psql -U postgres
    echo "GRANT ALL ON DATABASE zabbix TO zabbix;" | psql -U postgres
    echo "Importing Schema.sql"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" zabbix < /tmp/schema.sql 1> /dev/null
    echo "Importing Images.Sql"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" zabbix < /tmp/images.sql 1> /dev/null
    echo "Importing Data.Sql"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" zabbix < /tmp/data.sql 1> /dev/null
    touch /tmp/firstrun
fi
