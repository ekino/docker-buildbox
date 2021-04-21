#! /bin/sh
set -e

if [ -z "$PERCY_TOKEN" ]; then
    echo "[ERROR] Environment variable PERCY_TOKEN is not set."
    exit 1
fi

if [ $1 = 'sitemap' ] ; then

    if [ -z "$SITEMAP_URL" ]; then
        echo "[ERROR] Environment variable SITEMAP_URL is not set."
        exit 1
    fi

    percy exec -- node /sitemap.js
else
    exec "$@"
fi
