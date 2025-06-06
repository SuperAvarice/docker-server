#!/bin/bash

IMAGE="jcom/reverse-proxy"
NAME="reverseProxy"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = build, start, stop, rm, update"
    exit 1
fi

case "$1" in
    build)
        docker build -t $IMAGE /docker/build/reverseProxy/
    ;;
    start)
        docker run \
	    -dit \
	    --name=$NAME \
	    --restart always \
	    -p 80:80 \
	    -p 443:443 \
	    -v /storage/www:/var/www \
	    -v /storage/www/letsencrypt:/data/letsencrypt \
	    -v /docker/appdata/letsencrypt/volumes/etc:/etc/letsencrypt:ro \
	    $IMAGE
    ;;
    stop)
        docker stop $NAME
    ;;
    rm)
        docker rm $NAME
    ;;
    update)
	./$0 stop
	./$0 rm
	./$0 build
	./$0 start
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac

