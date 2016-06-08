FROM alpine:3.3

ENV INFLUXDB_VERSION 0.13.0

RUN apk add --no-cache --virtual .build-deps wget gnupg tar ca-certificates && \
    update-ca-certificates && \
    gpg --keyserver hkp://ha.pool.sks-keyservers.net \
        --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5 && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    gpg --batch --verify influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src && \
    tar -C /usr/src -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    rm -f /usr/src/influxdb-*/influxdb.conf && \
    chmod +x /usr/src/influxdb-*/* && \
    cp -a /usr/src/influxdb-*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
    apk del .build-deps

COPY influxdb.conf /etc/influxdb/influxdb.conf

RUN mkdir -p /usr/share/collectd
COPY types.db /usr/share/collectd/types.db

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ports for admin-server/webui/http-api/collectd
EXPOSE 8083 8086 25826/udp

VOLUME /var/lib/influxdb
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
