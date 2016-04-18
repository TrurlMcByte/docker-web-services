FROM alpine:3.3

ENV WEBDIS_REPO https://github.com/nicolasff/webdis.git

RUN apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        libevent-dev \
        bsd-compat-headers \
        git patch \
    && set -xe \
    && mkdir -p /usr/local/src \
    && git clone --depth 1 $WEBDIS_REPO /usr/local/src/webdis \
    && cd /usr/local/src/webdis \
    && make clean all \
    && sed -i '/redis_host/s/"127.*"/"redis"/g' webdis.json \
    && cp webdis /usr/local/bin/ \
    && cp webdis.json /etc/ \
    && mkdir -p /usr/share/doc/webdis \
    && cp README.markdown /usr/share/doc/webdis/README \
    && rm -rf /usr/local/src \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --no-cache --virtual .rundeps $runDeps \
    && apk del --no-cache .build-deps

ADD docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 7379

