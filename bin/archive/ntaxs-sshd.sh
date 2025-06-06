#!/bin/bash

IMAGE="linuxserver/openssh-server"
NAME="ntaxs-sshd"
PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = start, stop, update"
    exit 1
fi

case "$1" in
    start)
        docker run -d \
	    --name=$NAME \
            --restart unless-stopped \
            -e PUID=1000 \
            -e PGID=1000 \
            -e TZ=America/Chicago \
            -e SUDO_ACCESS=true \
            -e PASSWORD_ACCESS=true \
            -e USER_PASSWORD=${PASS} \
            -e USER_NAME=ntaxsupload \
            -p 22022:2222 \
            -v /docker/appdata/ntaxs/config:/config \
            -v /docker/appdata/ntaxs/www:/www \
	    $IMAGE
    ;;
    stop)
        docker stop $NAME
    ;;
    update)
        ./$0 stop
        docker rm $NAME
        docker pull $IMAGE
        ./$0 start
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac

