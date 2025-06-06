#!/bin/bash

# Info: https://github.com/sissbruecker/linkding

IMAGE="sissbruecker/linkding:latest"
NAME="linkding"
HOST_PORT=6060
DATA_DIR="/docker/appdata/linkding"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, start, stop, rm, update"
    echo >&2 "For initial user: $0 createuser username email"
    exit 1
fi

case "$1" in
    pull)
        docker pull $IMAGE
    ;;
    start)
        docker run -d \
	--name=$NAME \
	-p ${HOST_PORT}:9090 \
	-v ${DATA_DIR}/data:/etc/linkding/data \
        -e LD_CSRF_TRUSTED_ORIGINS=https://links.my-host.com \
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
    createuser)
        docker exec -it $NAME python manage.py createsuperuser --username=$2 --email=$3
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac

