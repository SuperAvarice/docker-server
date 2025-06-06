#!/bin/bash

IMAGE="jcom/auto-cross-live"
NAME="auto-cross"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = build, start, stop, rm, update"
    exit 1
fi

case "$1" in
    build)
        docker build -t $IMAGE /docker/build/auto-cross/
    ;;
    start)
        docker run \
	    -dit \
	    --name=$NAME \
	    --restart unless-stopped \
	    -p 8082:80 \
	    -v /docker/appdata/ntaxs/www:/var/www/ntaxs:ro \
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

