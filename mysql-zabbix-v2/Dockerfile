FROM mysql:5.7

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

ENV MYSQLZBX_PWD=${MYSQLZBX_PWD}

COPY zabbix-db-entrypoint.sh /docker-entrypoint-initdb.d/
