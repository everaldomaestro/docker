FROM debian:8

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

ARG OPENFIRE_VERSION=4.1.6

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    supervisor \
    wget \
    default-jdk && \
    wget https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${OPENFIRE_VERSION}_all.deb -O openfire_${OPENFIRE_VERSION}_all.deb && \
    dpkg -i openfire_${OPENFIRE_VERSION}_all.deb && \
    rm -rf openfire_${OPENFIRE_VERSION}_all.deb && \
    apt-get -y remove --purge \
    wget && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 9090/tcp 9091/tcp 5222/tcp 5223/tcp 5269/tcp 5262/tcp 5263/tcp 5275/tcp 5276/tcp 7777/tcp

ADD conf/etc/supervisor/ /etc/supervisor/

ADD run_openfire.sh /

ENTRYPOINT ["/bin/bash"]

CMD ["/run_openfire.sh"]
