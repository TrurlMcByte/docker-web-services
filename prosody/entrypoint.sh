#!/bin/sh
set -e

#if [[ "$1" != "prosody" ]]; then
#    exec prosodyctl $*
#    exit 0;
#fi

if [ "$LOCAL" -a  "$PASSWORD" -a "$DOMAIN" ] ; then
#    sed -i "s/VirtualHost \"example.com\"/VirtualHost \"$DOMAIN\"/" /etc/prosody/prosody.cfg.lua
    prosodyctl register $LOCAL $DOMAIN $PASSWORD
fi

exec "$@"
