#FROM alpine:3.3
FROM frolvlad/alpine-oraclejdk8

# influxdb-variables
ENV INFLUXDB_VERSION=0.13.0
    
# riemann-variables
ENV RIEMANN_VERSION=0.2.9  \
    RIEMANN_PATH_CONF=/opt/riemann  \
    RIEMANN_CONFIG=/opt/riemann/riemann.config

# supervisor-variables
ENV PYTHON_VERSION=2.7.11-r3 \
    PY_PIP_VERSION=6.1.1-r0 \
    SUPERVISOR_VERSION=3.2.0
    
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

RUN mkdir -p /etc/influxdb /usr/share/collectd
COPY types.db /usr/share/collectd/types.db

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

## influxdb-ports for admin-server/webui/http-api/collectd
## riemann-ports: 5555 - Riemann TCP and UDP - 5556 - Riemann WS
EXPOSE 8083 8086 25826/udp 5555 5555/udp 5556

# adding confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 /usr/local/bin/confd 
RUN chmod +x /usr/local/bin/confd

# adding confd-templates
ADD confd /etc/confd

# add influx-snmp
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go                                                              && \
    apk --update add bash go                                                                                  && \
    apk --update add --virtual build-dependencies bzr git mercurial subversion openssh-client ca-certificates && \
    cd /go/src && go get github.com/paulstuart/influxsnmp && go install github.com/paulstuart/influxsnmp      && \
    apk del build-dependencies                                                                                && \
    rm -rf /var/cache/apk/*

# riemann
RUN apk -U add bash

ADD https://aphyr.com/riemann/riemann-$RIEMANN_VERSION.tar.bz2 /riemann.tar.bz2
RUN chmod 777 /riemann.tar.bz2
RUN mkdir -p /opt/riemann

RUN cd /opt/riemann/ && tar -xj -f /riemann.tar.bz2 && rm -f /riemann.tar.bz2

# supervisor
RUN apk update && apk add -u python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION
RUN pip install supervisor==$SUPERVISOR_VERSION

VOLUME /var/lib/influxdb

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
