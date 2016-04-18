FROM alpine:3.3

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

ENV NGINX_VERSION 1.9.14

ENV GPG_KEYS B0F4253373F8F6F510D42178520A9993A1C052F8

ENV NGINX_CONFIG "\
    --prefix=/usr/ \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/lib/nginx/tmp/ \
    --http-proxy-temp-path=/var/lib/nginx/proxy/ \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi/ \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi/ \
    --http-scgi-temp-path=/var/lib/nginx/scgi/ \
    --user=nginx \
    --group=nginx \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_xslt_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_sub_module \
    --with-http_degradation_module \
    --with-mail=dynamic \
    --with-mail_ssl_module \
    --with-pcre \
    --with-pcre-jit \
    --with-threads \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-select_module \
    --with-poll_module \
    --with-ipv6 \
    --with-file-aio \
    --with-ld-opt=-lluajit-5.1 \
    --add-module=/usr/src/ngx_devel_kit \
    --add-module=/usr/src/ngx_cache_purge \
    --add-module=/usr/src/echo-nginx-module \
    --add-module=/usr/src/iconv-nginx-module \
    --add-module=/usr/src/set-misc-nginx-module \
    --add-module=/usr/src/redis2-nginx-module \
    --add-module=/usr/src/nginx-eval-module \
    --add-module=/usr/src/nginx-let-module \
    --add-module=/usr/src/form-input-nginx-module \
    --add-module=/usr/src/headers-more-nginx-module \
    --add-module=/usr/src/lua-nginx-module \
    --add-module=/usr/src/nginx-upload-module \
    --add-module=/usr/src/nginx-upload-progress-module \
    --add-module=/usr/src/nginx-module-vts \
    --add-module=/usr/src/nginx-rtmp-module \
    --add-dynamic-module=/usr/src/nginx-push-stream-module \
    --with-libatomic \
    --with-md5=/usr \
    --with-sha1=/usr \
    "

#  --add-module=/usr/src/ngx_postgres  \
#  --add-module=/usr/src/rds-json-nginx-module \
#  --add-module=/usr/src/ngx_pagespeed \
#  --with-http_dav_module \
# '--with-cc-opt=-O2 -g -m64 -fmessage-length=0 -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -fstack-protector'
# passenger

RUN \
    addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && apk add --no-cache --virtual .build-deps \
        git \
        patch \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        luajit-dev \
        libatomic_ops-dev \
    && mkdir -p /usr/src \
    && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o /usr/src/nginx.tar.gz \
    && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o /usr/src/nginx.tar.gz.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEYS" \
    && gpg --batch --verify /usr/src/nginx.tar.gz.asc /usr/src/nginx.tar.gz \
    && rm -r "$GNUPGHOME" /usr/src/nginx.tar.gz.asc \
    && tar -zxC /usr/src -f /usr/src/nginx.tar.gz \
    && rm /usr/src/nginx.tar.gz \
    && cd /usr/src \
    && git clone https://github.com/simpl/ngx_devel_kit.git ngx_devel_kit \
    && git clone https://github.com/FRiCKLE/ngx_cache_purge.git \
    && git clone https://github.com/agentzh/echo-nginx-module.git \
    && git clone https://github.com/calio/iconv-nginx-module.git \
    && git clone https://github.com/agentzh/set-misc-nginx-module.git \
    && git clone https://github.com/agentzh/redis2-nginx-module.git \
    && git clone https://github.com/agentzh/nginx-eval-module.git \
    && git clone https://github.com/arut/nginx-let-module.git \
    && git clone https://github.com/calio/form-input-nginx-module.git \
    && git clone https://github.com/openresty/headers-more-nginx-module.git \
    && git clone https://github.com/chaoslawful/lua-nginx-module.git \
    && git clone -b 2.2 https://github.com/vkholodkov/nginx-upload-module.git \
    && git clone https://github.com/masterzen/nginx-upload-progress-module.git \
    && git clone https://github.com/arut/nginx-rtmp-module.git \
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    && git clone https://github.com/wandenberg/nginx-push-stream-module.git \
    && git clone https://github.com/vdvm/nginx-watermark.git \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && patch -p0 < /usr/src/nginx-watermark/nginx-watermark.patch \
    && ./configure $NGINX_CONFIG --with-debug '--with-cc-opt=-O2 -g -m64 -fmessage-length=0 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -fstack-protector' \
    && make -j2 \
    && mv objs/nginx objs/nginx-debug \
    && ls -l objs/*.so \
    && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
    && mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
    && mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
    && mv objs/ngx_mail_module.so objs/ngx_mail_module-debug.so \
#    && mv objs/ngx_rtmp_module.so objs/ngx_rtmp_module-debug.so \
    && mv objs/ngx_stream_module.so objs/ngx_stream_module-debug.so \
    && mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so \
    && ./configure $NGINX_CONFIG '--with-cc-opt=-O2 -g -m64 -fmessage-length=0 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -fstack-protector' \
    && make -j2 \
    && make install \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && mkdir -p /usr/modules/debug/ \
    && install -o nginx -g nginx -d /var/lib/nginx \
    && install -m644 html/index.html /usr/share/nginx/html/ \
    && install -m644 html/50x.html /usr/share/nginx/html/ \
    && install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
    && install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/modules/debug/ngx_http_xslt_filter_module-debug.so \
    && install -m755 objs/ngx_http_image_filter_module-debug.so /usr/modules/debug/ngx_http_image_filter_module-debug.so \
    && install -m755 objs/ngx_http_geoip_module-debug.so /usr/modules/debug/ngx_http_geoip_module-debug.so \
    && install -m755 objs/ngx_mail_module-debug.so /usr/modules/debug/ngx_mail_module-debug.so \
#    && install -m755 objs/ngx_rtmp_module-debug.so /usr/modules/debug/ngx_rtmp_module-debug.so \
    && install -m755 objs/ngx_stream_module-debug.so /usr/modules/debug/ngx_stream_module-debug.so \
    && install -m755 objs/ngx_http_perl_module-debug.so /usr/modules/debug/ngx_http_perl_module-debug.so \
    && strip /usr/sbin/nginx* \
    && strip /usr/modules/debug/*.so \
    && strip /usr/modules/*.so \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/sbin/nginx /usr/modules/*.so /usr/modules/debug/*.so \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && rm -rf /usr/src/* \
    && apk add --no-cache gettext \
    \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
