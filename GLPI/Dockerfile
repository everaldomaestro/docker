FROM debian:8

MAINTAINER Everaldo Almeida <everaldo.maestro@gmail.com>

ARG GLPI_VERSION=9.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    apache2 \
    libapache2-mod-php5 \
    php5-cli \
    php5 \
    php5-gd \
    php5-imap \
    php5-ldap \
    php5-mysql \
    php-soap \
    php5-xmlrpc \
    zip \
    unzip \
    bzip2 \
    unrar-free \
    php5-snmp \
    php5-curl \
    php5-apcu \
    wget \
    nano \
    mysql-client && \
    cd /tmp && \
    wget https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz && \
    tar -xvzf glpi-${GLPI_VERSION}.tgz && \
    cp -Rf glpi /var/www/html && \
    echo '<Directory "/var/www/html/glpi">' > /etc/apache2/conf-available/glpi.conf && \
    echo '   AllowOverride All' >> /etc/apache2/conf-available/glpi.conf && \
    echo '</Directory>' >> /etc/apache2/conf-available/glpi.conf && \
    a2enconf glpi.conf && \
    service apache2 restart && \
    chmod 775 /var/www/html -Rf && \
    chown www-data. /var/www/html -Rf && \
    rm -rf glpi* && \
    apt-get -y remove --purge \
    wget && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80/tcp

CMD ["apachectl", "-D", "FOREGROUND"]
