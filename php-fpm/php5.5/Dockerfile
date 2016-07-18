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
    XDEBUG_VERSION=XDEBUG_2_4_0 \
    XCACHE_VERSION=3.2.0 \
    SUHOSIN_VERSION=0.9.38 \
    PHP_INI_DIR=/usr/local/etc/php \
    GPG_KEYS="0BD78B5F97500D450838F95DFE857D9A90D90EC1 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3" \
    PHP_VERSION=5.5.37 \
    PHP_FILENAME=php-5.5.37.tar.xz \
    PHP_SHA256=c322444fdf6d3ba26aa67d67ee32d1e815a877f35831351c83763431a80e3612 \
    PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"

COPY docker-php-ext-* /usr/local/bin/

RUN apk add --no-cache --virtual .phpize-deps \
        autoconf \
        automake \
        bison \
        bzip2-dev \
        ca-certificates \
        cmake \
        curl-dev \
        file \
        flex \
        g++ \
        gawk \
        gcc \
        geoip-dev \
        gettext-dev \
        gnupg \
        icu-dev libgcc \
        libc-dev \
        libedit-dev \
        libmcrypt-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        make \
        musl-dev \
        openssl-dev \
        pkgconf \
        postgresql-dev \
        re2c \
        sqlite-dev \
        util-linux-dev \
        zlib-dev freetype-dev libjpeg-turbo-dev libpng-dev \
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
                --enable-shmop \
                --enable-sockets \
                --enable-sysvmsg \
                --enable-sysvsem \
                --enable-sysvshm \
                --enable-wddx \
                --enable-zip \
                --with-curl \
                --with-freetype-dir=/usr/include/ \
                --with-gd \
                --with-gettext \
                --with-jpeg-dir=/usr/include/ \
                --with-libedit \
                --with-mcrypt \
                --with-mysql \
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
    && curl -q https://codeload.github.com/phpredis/phpredis/tar.gz/$PHPREDIS_VERSION | tar -xz \
    && curl -q https://codeload.github.com/xdebug/xdebug/tar.gz/$XDEBUG_VERSION | tar -xz \
    && curl -q https://xcache.lighttpd.net/pub/Releases/$XCACHE_VERSION/xcache-$XCACHE_VERSION.tar.gz | tar -xz \
#    && curl -q https://download.suhosin.org/suhosin-$SUHOSIN_VERSION.tar.gz | tar -xz \
    && pecl install geoip \
    && pecl install memcache \
    && pecl install rar \
    && echo | pecl install uuid \
    && docker-php-ext-configure xdebug-$XDEBUG_VERSION \
       --enable-xdebug \
   && docker-php-ext-configure xcache-$XCACHE_VERSION \
        --enable-xcache \
        --enable-xcache-constant \
        --enable-xcache-optimizer \
        --enable-xcache-coverager \
        --enable-xcache-assembler \
        --enable-xcache-disassembler \
        --enable-xcache-encoder \
        --enable-xcache-decoder \
    && docker-php-ext-enable geoip memcache rar uuid \
    && docker-php-ext-install phpredis-$PHPREDIS_VERSION xdebug-$XDEBUG_VERSION \
        xcache-$XCACHE_VERSION \
#        suhosin-$SUHOSIN_VERSION \
    && rm -rf /usr/src/php \
    && rm -rf /usr/local/src \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.saved \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini.saved \
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
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
