# docker-php-fpm
Compact PHP-FPM with maximum preinstalled modules (including memcache and phpredis)
(based on official php dock, but not extendable, most extension exist "out of box" )

[![](https://badge.imagelayers.io/trurlmcbyte/phpdir:latest.svg)](https://imagelayers.io/?images=trurlmcbyte/phpdir:latest 'Get your own badge on imagelayers.io')

simple start:
```
docker run -it --restart=always -d --name {your ps name} \
    --log-driver=syslog \
    --log-opt syslog-address=udp://mysyslog.server:514 \
    --log-opt syslog-facility=daemon \
    --log-opt tag="$CON_NAME" \
    -p 9000:9000 \
    -h phpdir1.$HOST \
    -e WORK_UID=`id -u wwwrun` \
    -e WORK_GID=`id -g wwwrun` \
    -e TZ=America/Los_Angeles \
    -e OPCACHE_ENABLE=yes \
    -e MOD_MEMCACHE='
extension=memcache.so
' \
    -e FPMOPTS='
pm.status_path = /fpm-docker-status
ping.path = /fpm-docker-ping
request_terminate_timeout = 30s
' \
    -v /etc/timezone:/etc/timezone:ro \
    -v /srv/www/htdocs:/srv/www/htdocs:ro \
    trurlmcbyte/phpdir:5.6
```

for `--log*` see Docker logging
`-h phpdir1.$HOST` useful for detect working env
` WORK_UID` and ` WORK_UID` replacing internal uid, useful for shared folders write access
`-e OPCACHE_ENABLE=yes` enabling opcache zend module on start (opcache disabled by default)
`-e MOD_MEMCACHE` configure memcache module (useful for setup memcache sessions, disabled by default)
`-e FPMOPTS` configure "www" part of php-fpm config
`-e FPMGOPTS` configure global part of php-fpm config

internal php config directory is `/usr/local/etc/php/`
internal php-fpm config directory is `/usr/local/etc/php-fpm/`

Included modules:
```
[PHP Modules]
bcmath
calendar
Core
ctype
curl
date
dom
ereg
exif
fileinfo
filter
ftp
gd
geoip
gettext
hash
iconv
intl
json
libxml
mbstring
mcrypt
memcache
mysql
mysqli
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
rar
readline
redis
Reflection
session
shmop
SimpleXML
sockets
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tidy
tokenizer
uuid
wddx
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

