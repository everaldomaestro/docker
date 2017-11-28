FROM debian:8

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

ENV NETWORK=${NETWORK}

ENV GATEWAY_ADDRESS=${GATEWAY_ADDRESS}

ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bind9 \
    bind9-doc \
    dnsutils \
    nano \
    supervisor && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/named && \
    chown bind:bind /var/run/named

EXPOSE 53/udp

ADD conf/etc/supervisor/ /etc/supervisor/

ADD bind/ /etc/bind/

ADD run_dns.sh /

ENTRYPOINT ["/bin/bash"]

CMD ["/run_dns.sh"]
