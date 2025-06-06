#!/bin/bash

IMAGE="shaarli/shaarli:latest"
NAME="bookmarks2"
HOST_PORT=6005
DATA_DIR="/docker/appdata/bookmarks2"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, start, stop, rm, update"
    exit 1
fi

case "$1" in
    pull)
        docker pull $IMAGE
    ;;
    start)
        docker run -d \
	--name=$NAME \
	-p ${HOST_PORT}:80 \
	-v ${DATA_DIR}/data:/var/www/shaarli/data \
        -v ${DATA_DIR}/cache:/var/www/shaarli/cache \
	--restart unless-stopped \
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
        ./$0 pull
        ./$0 start
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac

