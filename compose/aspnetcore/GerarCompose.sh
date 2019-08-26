#!/bin/bash

DATA_DB='datadb_'$1
DATA_MNG='datamng_'$1
DATA_APP='dataapp_'$1

NW_DB='nwdb_'$1
NW_APP='nwapp_'$1

DB_NAME='db_'$1
APP_NAME='app_'$1
IMG_NAME='api:'$1
MNG_NAME='pgadmin_'$1

APP_PORT=$2
MNG_PORT=$3

EMAIL=$4
PASS=$5

echo -e "version: '3'" > /root/projeto/docker-compose.yml
echo "volumes:" >> /root/projeto/docker-compose.yml
echo "  $DATA_DB:" >> /root/projeto/docker-compose.yml
echo "  $DATA_MNG:" >> /root/projeto/docker-compose.yml
echo "  $DATA_APP:" >> /root/projeto/docker-compose.yml
echo "networks:" >> /root/projeto/docker-compose.yml
echo "  $NW_DB:" >> /root/projeto/docker-compose.yml
echo "  $NW_APP:" >> /root/projeto/docker-compose.yml
echo "services:" >> /root/projeto/docker-compose.yml
echo "  $DB_NAME:" >> /root/projeto/docker-compose.yml
echo "    image: postgres:9.6" >> /root/projeto/docker-compose.yml
echo "    volumes:" >> /root/projeto/docker-compose.yml
echo "      - $DATA_DB:/var/lib/postgresql/data" >> /root/projeto/docker-compose.yml
echo "    networks:" >> /root/projeto/docker-compose.yml
echo "      - $NW_DB" >> /root/projeto/docker-compose.yml
echo "  $APP_NAME:" >> /root/projeto/docker-compose.yml
echo "    image: $IMG_NAME" >> /root/projeto/docker-compose.yml
echo "    volumes:" >> /root/projeto/docker-compose.yml
echo "      - $DATA_APP:/app" >> /root/projeto/docker-compose.yml
echo "    ports:" >> /root/projeto/docker-compose.yml
echo "      - $APP_PORT:80" >> /root/projeto/docker-compose.yml
echo "    networks:" >> /root/projeto/docker-compose.yml
echo "      - $NW_DB" >> /root/projeto/docker-compose.yml
echo "      - $NW_APP" >> /root/projeto/docker-compose.yml
echo "    depends_on:" >> /root/projeto/docker-compose.yml
echo "      - $DB_NAME" >> /root/projeto/docker-compose.yml
echo "  $MNG_NAME:" >> /root/projeto/docker-compose.yml
echo "    image: dpage/pgadmin4:4.12" >> /root/projeto/docker-compose.yml
echo "    volumes:" >> /root/projeto/docker-compose.yml
echo "      - $DATA_MNG:/var/lib/pgadmin" >> /root/projeto/docker-compose.yml
echo "    ports:" >> /root/projeto/docker-compose.yml
echo "      - $MNG_PORT:80" >> /root/projeto/docker-compose.yml
echo "    networks:" >> /root/projeto/docker-compose.yml
echo "      - $NW_DB" >> /root/projeto/docker-compose.yml
echo "      - $NW_APP" >> /root/projeto/docker-compose.yml
echo "    environment:" >> /root/projeto/docker-compose.yml
echo "      - PGADMIN_DEFAULT_EMAIL=$EMAIL" >> /root/projeto/docker-compose.yml
echo "      - PGADMIN_DEFAULT_PASSWORD=$PASS" >> /root/projeto/docker-compose.yml
echo "    depends_on:" >> /root/projeto/docker-compose.yml
echo "      - $DB_NAME" >> /root/projeto/docker-compose.yml
