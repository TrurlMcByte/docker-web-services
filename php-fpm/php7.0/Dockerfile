FROM alpine:3.3

# base libs
RUN apk add --no-cache \
        libpq postgresql-client \
        gettext expat libintl libgomp zlib \
        libjpeg-turbo libxml2 \
        geoip \
        zlib freetype libpng libjpeg-turbo \
        bzip2 libbz2 \
        libxslt \
        icu-libs \
        libmcrypt \
        libuuid \
        curl

ENV TIDY_VERSION=5.1.25 \
    PHPREDIS_VERSION=2.2.7 \
    XCACHE_VERSION=3.2.0 \
    SUHOSIN_VERSION=0.9.38 \
    PHP_INI_DIR=/usr/local/etc/php \
    GPG_KEYS="1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763" \
    PHP_VERSION=7.0.5 \
    PHP_FILENAME=php-7.0.5.tar.xz \
    PHP_SHA256=c41f1a03c24119c0dd9b741cdb67880486e64349fc33527767f6dc28d3803abb \
    PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"

COPY docker-php-ext-* /usr/local/bin/


RUN apk add --no-cache --virtual .phpize-deps \
        git \
        autoconf \
        libtool \
        automake \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        ca-certificates \
        musl-dev \
        zlib-dev freetype-dev libjpeg-turbo-dev libpng-dev \
        libmcrypt-dev \
        geoip-dev \
        postgresql-dev \
        libxml2-dev \
        icu-dev libgcc \
        gettext-dev \
        bzip2-dev \
        util-linux-dev \
        cmake \
	curl-dev \
	gnupg \
	libedit-dev \
	libxml2-dev \
	openssl-dev \
	sqlite-dev \
        libmemcached-dev \
  && set -x \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && mkdir -p /usr/local/src \
    && cd /usr/local/src \
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
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done \
	&& gpg --batch --verify "$PHP_FILENAME.asc" "$PHP_FILENAME" \
	&& rm -r "$GNUPGHOME" "$PHP_FILENAME.asc" \
	&& mkdir -p /usr/src \
	&& tar -Jxf "$PHP_FILENAME" -C /usr/src \
	&& mv "/usr/src/php-$PHP_VERSION" /usr/src/php \
	&& rm "$PHP_FILENAME" \
        && cd /usr/src/php \
#	&& ./configure --help \
	&& ./configure \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		$PHP_EXTRA_CONFIGURE_ARGS \
		--disable-cgi \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
		--enable-mysqlnd \
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
		--enable-mbstring \
                --enable-exif \
		--with-curl \
		--with-libedit \
		--with-openssl \
		--with-zlib \
                --enable-calendar \
                --enable-ftp \
                --with-tidy \
                --with-png-dir=/usr/include/ \
                --with-freetype-dir=/usr/include/ \
                --with-jpeg-dir=/usr/include/ \
                --with-gd \
                --enable-intl \
                --with-mcrypt \
                --enable-opcache \
                --with-pdo-mysql \
                --with-mysqli \
                --with-mysql \
                --with-pdo-pgsql \
                --with-pgsql \
                --enable-wddx \
                --enable-sysvmsg \
                --enable-sysvsem \
                --enable-sysvshm \
                --enable-zip \
                --with-gettext \
                --enable-shmop \
                --enable-sockets \
                --enable-bcmath \
	&& make -j4 \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
	&& make clean \
    && cd /usr/src/php/ext \
     && git clone -b php7 https://github.com/phpredis/phpredis.git \
     && docker-php-ext-install phpredis \
     && git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git \
     && docker-php-ext-configure php-memcached --disable-memcached-sasl \
#    && curl -q https://xcache.lighttpd.net/pub/Releases/$XCACHE_VERSION/xcache-$XCACHE_VERSION.tar.gz | tar -xz \
#    && curl -q https://download.suhosin.org/suhosin-$SUHOSIN_VERSION.tar.gz | tar -xz \
#    && pecl install geoip \
#    && pecl install rar \
    && echo | pecl install uuid \
#    && docker-php-ext-configure xcache-$XCACHE_VERSION \
#        --enable-xcache \
#        --enable-xcache-constant \
#        --enable-xcache-optimizer \
#        --enable-xcache-coverager \
#        --enable-xcache-assembler \
#        --enable-xcache-disassembler \
#        --enable-xcache-encoder \
#        --enable-xcache-decoder \
#    && docker-php-ext-enable geoip \
#    && docker-php-ext-enable rar \
#    && docker-php-ext-enable memcache \
    && docker-php-ext-enable uuid \
# xcache-$XCACHE_VERSION \
# suhosin-$SUHOSIN_VERSION \
    && rm -rf /usr/src/php \
    && rm -rf /usr/local/src \
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

ADD etc /usr/local/etc/
ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
