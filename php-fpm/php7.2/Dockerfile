FROM alpine:latest

# base libs
RUN apk add --no-cache \
        libpq postgresql-client \
        gettext expat libintl libgomp zlib \
        libjpeg-turbo libxml2 \
        geoip \
        zlib freetype libpng libjpeg-turbo \
        bzip2 libbz2 \
        libressl \
        libxslt \
        icu-libs \
        libmcrypt \
        libuuid \
        curl

#        openssl

#    XCACHE_VERSION=3.2.0 \
#    SUHOSIN_VERSION=0.9.38 \


ENV PHP_VERSION=7.2.4 \
    TIDY_VERSION=5.4.0 \
    ICONV_VERSION=1.15 \
    XDEBUG_VERSION=2.6.0 \
    PHP_INI_DIR=/usr/local/etc/php \
    GPG_KEYS="1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F" \
    PHP_SHA256=7916b1bd148ddfd46d7f8f9a517d4b09cd8a8ad9248734e7c8dd91ef17057a88 \
    PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"

ENV PHP_FILENAME=php-$PHP_VERSION.tar.xz


COPY docker-php-ext-* /usr/local/bin/

#        openssl-dev 

RUN apk add --no-cache --virtual .phpize-deps \
        autoconf \
        automake \
        bison \
        bzip2-dev \
        ca-certificates \
        libmaxminddb-dev \
        cmake \
        curl-dev \
        c-client \
        file \
        flex \
        freetype-dev \
        g++ \
        gawk \
        gcc \
        geoip-dev \
        gettext-dev \
        git \
        gnupg \
        gmp \
        gmp-dev \
        icu-dev libgcc \
        libc-dev \
        libedit-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        libressl-dev \
        make \
        musl-dev \
        pkgconf \
        postgresql-dev \
        re2c \
        sqlite-dev \
        util-linux-dev \
        zlib-dev \
  && set -x \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && mkdir -p /usr/local/src \
    && cd /usr/local/src \
#    && curl -q http://ftp.gnu.org/pub/gnu/libiconv/libiconv-$ICONV_VERSION.tar.gz | tar -xz \
#    && cd libiconv-$ICONV_VERSION/ \
#    && ./configure \
#        --prefix=/usr \
#        --mandir=/usr/share/man \
#        --disable-nls \
#        --disable-static \
#    && sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool \
#    && sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool \
#    && make \
#    && make install \
#    && rm /usr/lib/charset.alias \
#    && cd /usr/local/src \
    && curl -q https://codeload.github.com/htacg/tidy-html5/tar.gz/$TIDY_VERSION | tar -xz \
    && cd tidy-html5-$TIDY_VERSION/build/cmake \
    && cmake ../.. && make install \
    && ln -s tidybuffio.h ../../../../include/buffio.h \
    && cd /usr/local/src \
    && rm -rf /usr/local/src/tidy-html5-$TIDY_VERSION \
    && set -xe \
        && curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME" \
        && echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - \
        && curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc" \
        && export GNUPGHOME="$(mktemp -d)" \
        && for key in $GPG_KEYS; do \
                gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
        && gpg --batch --verify "$PHP_FILENAME.asc" "$PHP_FILENAME" \
        && rm -r "$GNUPGHOME" "$PHP_FILENAME.asc" \
        && mkdir -p /usr/src \
        && tar -Jxf "$PHP_FILENAME" -C /usr/src \
        && mv "/usr/src/php-$PHP_VERSION" /usr/src/php \
        && rm "$PHP_FILENAME" \
        && cd /usr/src/php \
        && ./configure --help \
        && ./configure \
                --with-config-file-path="$PHP_INI_DIR" \
                --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
                $PHP_EXTRA_CONFIGURE_ARGS \
                --disable-cgi \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
                --enable-mysqlnd \
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
                --enable-bcmath \
                --enable-calendar \
                --enable-exif \
                --enable-ftp \
                --enable-intl \
                --enable-mbstring \
                --enable-opcache \
                --enable-pcntl \
                --enable-shmop \
                --enable-soap \
                --enable-sockets \
                --enable-sysvmsg \
                --enable-sysvsem \
                --enable-sysvshm \
                --enable-wddx \
                --enable-zip \
#                --with-imap=/usr \
                --with-curl \
                --with-freetype-dir=/usr/include/ \
                --with-gd \
                --with-gettext \
                --with-gmp \
                --with-jpeg-dir=/usr/include/ \
                --with-libedit \
                --with-mcrypt \
                --with-mysqli \
                --with-openssl \
                --with-pdo-mysql \
                --with-pdo-pgsql \
                --with-pgsql \
                --with-png-dir=/usr/include/ \
                --with-tidy \
                --with-xsl \
                --with-zlib \
        && make -j4 \
        && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
    && cd /usr/src/php/ext \
    && curl https://codeload.github.com/xdebug/xdebug/tar.gz/$XDEBUG_VERSION | tar -xz \
#    && curl https://xcache.lighttpd.net/pub/Releases/$XCACHE_VERSION/xcache-$XCACHE_VERSION.tar.gz | tar -xz \
#    && git clone https://github.com/sektioneins/suhosin7 \
    && git clone https://github.com/phpredis/phpredis.git \
    && git clone -b NON_BLOCKING_IO_php7 https://github.com/websupport-sk/pecl-memcache.git memcache \
    && pecl install geoip-beta \
#    && pecl install rar \
    && echo | pecl install uuid \
    && docker-php-ext-configure xdebug-$XDEBUG_VERSION \
       --enable-xdebug \
#   && docker-php-ext-configure xcache-$XCACHE_VERSION \
#        --enable-xcache \
#        --enable-xcache-constant \
#        --enable-xcache-optimizer \
#        --enable-xcache-coverager \
#        --enable-xcache-assembler \
#        --enable-xcache-disassembler \
#        --enable-xcache-encoder \
#        --enable-xcache-decoder \
    && docker-php-ext-enable uuid geoip \
    && docker-php-ext-install memcache phpredis xdebug-$XDEBUG_VERSION \
    && rm -rf /usr/src/php \
    && rm -rf /usr/local/src \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.saved \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --no-cache --virtual .php-rundeps $runDeps \
    && apk del --no-cache .phpize-deps

WORKDIR /var/www/html

EXPOSE 9000

ENV MOD_XDEBUG="" \
    MOD_MEMCACHE="" \
    MOD_XCACHE="" \
    WORK_UID="" \
    WORK_GID="" \
    OPCACHE_ENABLE="" \
    FPMGOPTS="" \
    FPMOPTS=""

ADD etc /usr/local/etc/
ADD docker-entrypoint.sh /entrypoint.sh
ADD GeoIP.dat /usr/share/GeoIP/GeoIP.dat
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
