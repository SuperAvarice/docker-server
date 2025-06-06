#!/bin/bash

IMAGE="jacobalberty/unifi:latest"
NAME="unifi"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, start, stop, rm, update"
    exit 1
fi

# -p 8880:8880/tcp \
# -p 8843:8843/tcp \

case "$1" in
    pull)
        docker pull $IMAGE
    ;;
    start)
	docker run --init -d \
	--restart unless-stopped \
	--name=$NAME \
	-p 8080:8080/tcp \
	-p 8443:8443/tcp \
	-p 3478:3478/udp \
	-p 10001:10001/udp \
	-e TZ='America/Chicago' \
	-v /docker/appdata/unifi:/unifi \
	-v /docker/appdata/unifi/run:/unifi/run \
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

