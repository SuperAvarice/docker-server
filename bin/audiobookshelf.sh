#!/bin/bash

# Info: https://github.com/advplyr/audiobookshelf
# https://www.audiobookshelf.org/

IMAGE="ghcr.io/advplyr/audiobookshelf"
NAME="audiobookshelf"
HOST_PORT="13378"
PORT_MAP="${HOST_PORT}:80"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# TIME_ZONE="America/Chicago"
# ABS_DATA_DIR="/docker/appdata/audiobookshelf" # Configs
# ABS_MEDIA_DIR="/media" # Mounts for content on NAS

function docker_start () {
    docker run -d \
	    --name=${NAME} \
        --restart unless-stopped \
        -p ${PORT_MAP} \
        -e TZ="${TIME_ZONE}" \
        -v ${ABS_MEDIA_DIR}/audiobooks:/audiobooks \
        -v ${ABS_MEDIA_DIR}/podcasts:/podcasts \
        -v ${ABS_DATA_DIR}/metadata:/metadata \
        -v ${ABS_DATA_DIR}/config:/config \
        ${IMAGE}
}

function docker_stop () {
    docker stop ${NAME}
    docker rm ${NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE}
}

function docker_update () {
    docker_stop
    docker pull ${IMAGE}
    docker_start
}

case "$1" in
    start)  docker_start ;;
    stop)   docker_stop ;;
    clean)  docker_clean ;;
    update) docker_update ;;
    *)
        [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
        echo >&2 "Usage $0 <start, stop, clean, update>"
    ;;
esac
