#!/bin/bash

# https://github.com/ConSol/docker-headless-vnc-container

IMAGE="jcom/headless-vnc"
NAME="headless-vnc"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = build, start, stop, rm, update"
    exit 1
fi

case "$1" in
    build)
        docker build -t $IMAGE /docker/build/headless-vnc/
    ;;
    start)
	docker run -d \
	--name=$NAME \
        -p 6901:6901 \
	-e VNC_RESOLUTION="1920x1080" \
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

