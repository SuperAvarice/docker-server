#!/bin/bash

# Info: https://github.com/plexinc/pms-docker

#IMAGE="plexinc/pms-docker:plexpass" -- This tag is really old, do not use.
IMAGE="plexinc/pms-docker:latest"
NAME="plex"
SERVER_NAME="PlexServer"
PLEX_UID=$(id -u)
PLEX_GID=$(id -g)

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# TIME_ZONE="America/Chicago"
# PLEX_DATA_DIR="/docker/appdata/plex" # Configs for Plex
# PLEX_MEDIA_DIR="/media" # Mounts for content on NAS (RO) and mounts for dvr and transcode (RW)
# PLEX_CLAIM="claim-****************"
# PLEX_ADVERTISE_IP="http://172.16.0.1:32400/"

function docker_start () {
    docker run -d \
	    --name=${NAME} \
        --network=host \
        --device /dev/dri:/dev/dri \
        --restart unless-stopped \
        -h ${SERVER_NAME} \
        -e TZ="${TIME_ZONE}" \
        -e PLEX_CLAIM="${PLEX_CLAIM}" \
        -e ADVERTISE_IP="${PLEX_ADVERTISE_IP}" \
        -e PLEX_UID="${PLEX_UID}" \
        -e PLEX_GID="${PLEX_GID}" \
        -v ${PLEX_MEDIA_DIR}/tv:/data/tv:ro \
        -v ${PLEX_MEDIA_DIR}/movies:/data/movies:ro \
        -v ${PLEX_MEDIA_DIR}/dvr:/data/dvr \
        -v ${PLEX_MEDIA_DIR}/transcode:/transcode \
        -v ${PLEX_DATA_DIR}/config:/config \
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
