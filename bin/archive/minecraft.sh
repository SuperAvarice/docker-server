#!/bin/bash

# https://github.com/itzg/docker-minecraft-server

NAME="minecraft"
IMAGE="itzg/minecraft-server"

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
        docker run -d -it \
        --name=$NAME \
        -h $NAME \
        -p 25565:25565 \
        -e EULA="TRUE" \
        -v /docker/appdata/minecraft:/data \
        -v /etc/timezone:/etc/timezone:ro \
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

