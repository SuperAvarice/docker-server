#!/bin/bash

NAME="powerpanel"
IMAGE="powerpanel"
#IMAGE="ghcr.io/nathanvaughn/powerpanel-business:local-latest"
BASE_DIR="/docker/appdata/ppb"

if [[ -z "$@" ]]; then
  echo >&2 "Usage: $0 <command>"
  echo >&2 "command = build, start, stop, rm, update"
  exit 1
fi

case "$1" in
  build)
    docker build -t $IMAGE /docker/build/ppb/
  ;;
  start)
    docker run -d \
    --name=$NAME \
    --restart unless-stopped \
    -p 8083:3052 \
    -v "${BASE_DIR}:/usr/local/ppbe/db_local" \
    -v "/etc/timezone:/etc/timezone:ro" \
    -v "/etc/localtime:/etc/localtime:ro" \
    --privileged \
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

