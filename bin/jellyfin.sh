#!/bin/bash

# Info: https://jellyfin.org/docs/general/installation/container

##### Setup
# sudo chown -R 1000:1000 ${JF_DATA_DIR}
# sudo chmod +x bin/jellyfin.sh
# getent group render | cut -d: -f3

IMAGE="jellyfin/jellyfin:latest"
NAME="jellyfin"
SERVER_NAME="JellyfinServer"
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# TIME_ZONE="America/Chicago"
# MEDIA_DIR="/media" # Mounts for content on NAS (RO)
# JF_DATA_DIR="/docker/appdata/jellyfin" # Configs for JellyFin

function docker_start () {
    docker run -d \
	    --name ${NAME} \
        --user ${USER_ID}:${GROUP_ID} \
        --device /dev/dri/renderD128:/dev/dri/renderD128 \
        --group-add 993 \
        --restart unless-stopped \
        --network=host \
        -h ${SERVER_NAME} \
        -e TZ="${TIME_ZONE}" \
        -v ${MEDIA_DIR}/tv:/media/tv:ro \
        -v ${MEDIA_DIR}/movies:/media/movies:ro \
        -v ${JF_DATA_DIR}/config:/config \
        -v ${JF_DATA_DIR}/cache:/cache \
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
