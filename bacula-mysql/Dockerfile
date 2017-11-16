FROM debian:8

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

ARG BACULA_VERSION=9.0.3

ENV DB_HOST=${DB_HOST}

ENV DB_PORT=${DB_PORT}

ENV DB_ROOT_USER=${DB_ROOT_USER}

ENV DB_ROOT_PASS=${DB_ROOT_PASS}

ENV DB_BACULA_USER=${DB_BACULA_USER}

ENV DB_BACULA_PASS=${DB_BACULA_PASS}

ENV DB_BACULA_DBNAME=${DB_BACULA_DBNAME}

RUN echo "postfix postfix/mailname string email@mail.com" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
       build-essential \
       libreadline6-dev \
       zlib1g-dev \
       liblzo2-dev \
       mt-st \
       mtx \
       postfix \
       libacl1-dev \
       libssl-dev \
       mysql-client \
       libmysql++-dev \
       wget \
       nano \
       supervisor && \
    wget -qO- http://www.bacula.com.br/atual | tar -xzvf - -C /usr/src && \
    cd /usr/src/bacula-${BACULA_VERSION} && \
    ./configure \
       --with-readline=/usr/include/readline \
       --disable-conio \
       --bindir=/usr/bin \
       --sbindir=/usr/sbin \
       --with-scriptdir=/etc/bacula/scripts \
       --with-working-dir=/var/spool/bacula \
       --with-logdir=/var/log/bacula \
       --enable-smartalloc \
       --with-mysql \
       --with-hostname=bacula-dir \
       --with-job-email=email@mail.com \
       --with-archivedir=/var/bacula-bkp \
       --with-dir-password=s3cr3t5 \
       --with-fd-password=s3cr3t5 \
       --with-sd-password=s3cr3t5 \
       --with-db-name=bacula \
       --with-db-user=bacula \
       --with-db-password=bacula \
       --with-db-port=3306 \
       --with-hostname=bacula-dir \
       --with-basename=bacula && \
    make -j8 && make install && \
    rm -rf /usr/src/bacula-${BACULA_VERSION} && \
    apt-get -y remove --purge \
    wget && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/bacula-bkp

EXPOSE 9101/tcp

ADD conf/etc/supervisor/ /etc/supervisor/

ADD run_bacula_component.sh /

ENTRYPOINT ["/bin/bash"]

CMD ["/run_bacula_component.sh", "mysql"]
