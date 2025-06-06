#!/bin/bash

IMAGE="jlesage/crashplan-pro"
NAME="crashplan-pro"
PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c8)

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
	    -e USER_ID=1000 -e GROUP_ID=1000 \
	    -e CRASHPLAN_SRV_MAX_MEM=1600M \
	    -e VNC_PASSWORD=${PASS} \
	    -p 5800:5800 \
	    -v /docker/appdata/crashplan-pro:/config:rw \
	    -v /storage:/storage:ro \
	    -v /media/pictures:/pictures:ro \
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

