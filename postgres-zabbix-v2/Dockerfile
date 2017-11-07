FROM postgres:10.0

ENV ZBXUSER_PWD=${ZBXUSER_PWD}

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

COPY zabbix-db-entrypoint.sh /docker-entrypoint-initdb.d/
