#!/bin/sh
set -e

write_configs() {

    mkdir -p /data/log

    test -d /usr/local/etc/php-fpm.d || mkdir -p /usr/local/etc/php-fpm.d
    test -f /usr/local/etc/php-fpm.conf.default && sed 's!=NONE/!=!g' /usr/local/etc/php-fpm.conf.default | sed 's!127.0.0.1:9000!9000!g' > /usr/local/etc/php-fpm.d/www.conf

    curl -s http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz > /tmp/GeoIP.dat.gz \
         && gunzip /tmp/GeoIP.dat.gz && mkdir -p /usr/share/GeoIP && mv /tmp/GeoIP.dat /usr/share/GeoIP/

    touch /usr/local/etc/php.configured
}

test -e /usr/local/etc/php.configured || write_configs
test "${OPCACHE_ENABLE}" && test "${OPCACHE_ENABLE}" == "yes"  && echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
test "${OPCACHE_DISABLE}" && rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

cp -f /usr/local/etc/php-fpm.d/zz-docker_global.conf.default /usr/local/etc/php-fpm.d/zz-docker_global.conf

test "${FPMGOPTS}" && { \
    echo \
    && echo "${FPMGOPTS}"
     } >> /usr/local/etc/php-fpm.d/zz-docker_global.conf

cp -f /usr/local/etc/php-fpm.d/zz-docker_www.conf.default /usr/local/etc/php-fpm.d/zz-docker_www.conf

test "${FPMOPTS}" && { \
    echo \
    && echo "${FPMOPTS}"
     } >> /usr/local/etc/php-fpm.d/zz-docker_www.conf

export ORIGPASSWD=$(cat /etc/passwd | grep www-data)
export ORIG_UID=$(echo $ORIGPASSWD | cut -f3 -d:)
export ORIG_GID=$(echo $ORIGPASSWD | cut -f4 -d:)
export WORK_UID=${WORK_UID:=$ORIG_UID}
export WORK_GID=${WORK_GID:=$ORIG_GID}
ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)

sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$WORK_UID:$WORK_GID:/" /etc/passwd
sed -i -e "s/www-data:x:$ORIG_GID:/www-data:x:$WORK_GID:/" /etc/group

chown -R ${WORK_UID}:${WORK_GID} ${ORIG_HOME}

test "${MOD_MEMCACHE}" && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-memcache.ini \
 && test "${MOD_MEMCACHE}" = "yes" || echo "${MOD_MEMCACHE}" >> /usr/local/etc/php/conf.d/docker-php-ext-memcache.ini

test "${MOD_XDEBUG}" && cat /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.saved > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && test "${MOD_XDEBUG}" = "yes" || echo "${MOD_XDEBUG}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

test "${MOD_XCACHE}" && cat /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini.saved > /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini \
 && test "${MOD_XCACHE}" = "yes" || echo "${MOD_XCACHE}" >> /usr/local/etc/php/conf.d/docker-php-ext-xcache.ini


if [ $# -eq 0 ]; then
    /usr/local/sbin/php-fpm
fi

exec "$@"
