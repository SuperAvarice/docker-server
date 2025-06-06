#!/bin/bash

IMAGE="certbot/certbot"
NAME="certbot"

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, stage, clean, getcert, renew"
    exit 1
fi

case "$1" in
    pull)
        docker pull $IMAGE
    ;;
    stage)
        docker run -it --rm \
	-v /docker/appdata/letsencrypt/volumes/etc:/etc/letsencrypt \
	-v /docker/appdata/letsencrypt/volumes/lib:/var/lib/letsencrypt \
	-v /storage/www/letsencrypt:/data/letsencrypt \
	-v /docker/appdata/letsencrypt/volumes/log:/var/log/letsencrypt \
	$IMAGE \
	certonly --webroot \
	--register-unsafely-without-email --agree-tos \
	--webroot-path=/data/letsencrypt \
	--staging \
	-d schwan.us -d www.schwan.us -d code.schwan.us -d server.schwan.us
    ;;
    clean)
        sudo rm -rf /docker/appdata/letsencrypt/volumes/
    ;;
    getcert)
        docker run -it --rm \
        -v /docker/appdata/letsencrypt/volumes/etc:/etc/letsencrypt \
        -v /docker/appdata/letsencrypt/volumes/lib:/var/lib/letsencrypt \
        -v /storage/www/letsencrypt:/data/letsencrypt \
        -v /docker/appdata/letsencrypt/volumes/log:/var/log/letsencrypt \
        $IMAGE \
        certonly --webroot \
	--email james@schwan.us --agree-tos --no-eff-email \
	--webroot-path=/data/letsencrypt \
	-d schwan.us -d www.schwan.us -d code.schwan.us -d server.schwan.us
    ;;
    renew)
	# sudo crontab -e
	# 0 23 * * * certbot.sh renew
	docker run --rm -it \
	--name certbot \
	-v /docker/appdata/letsencrypt/volumes/etc:/etc/letsencrypt \
	-v /docker/appdata/letsencrypt/volumes/lib:/var/lib/letsencrypt \
	-v /storage/www/letsencrypt:/data/letsencrypt \
        -v /docker/appdata/letsencrypt/volumes/log:/var/log/letsencrypt \
	$IMAGE renew \
	--webroot -w /data/letsencrypt \
	#--quiet && docker kill --signal=HUP reverseProxy
	docker kill --signal=HUP reverseProxy
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac

