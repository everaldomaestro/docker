FROM postgres:10.0

MAINTAINER Everaldo Jose Costa de Almeida <everaldo.maestro@gmail.com>

ARG DB_TYPE=postgresql

ARG ZBX_VERSION=3.4.3

ARG ZBX_SOURCE=https://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.3/zabbix-${ZBX_VERSION}.tar.gz

RUN apt-get update && \
    apt-get install wget -y && \
    cd /tmp && \
    wget ${ZBX_SOURCE} && \
    tar -zxvf zabbix-${ZBX_VERSION}.tar.gz && \
    cp /tmp/zabbix-${ZBX_VERSION}/database/${DB_TYPE}/images.sql /tmp && \
    cp /tmp/zabbix-${ZBX_VERSION}/database/${DB_TYPE}/schema.sql /tmp && \
    cp /tmp/zabbix-${ZBX_VERSION}/database/${DB_TYPE}/data.sql /tmp && \
    rm -rf /tmp/zabbix-${ZBX_VERSION} && \
    rm -rf /tmp/zabbix-${ZBX_VERSION}.tar.gz

COPY zabbix-db-entrypoint.sh /docker-entrypoint-initdb.d/
