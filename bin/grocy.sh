#!/bin/bash

# Info: https://hub.docker.com/r/linuxserver/grocy
# https://github.com/grocy/grocy
# https://grocy.info/

IMAGE="lscr.io/linuxserver/grocy:latest"
NAME="grocy"
SERVER_NAME="GrocyServer"
USER_ID=$(id -u)
GROUP_ID=$(id -g)
PORT_MAP="9283:80"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# TIME_ZONE="America/Chicago"
# GROCY_DATA_DIR="/docker/appdata/grocy" # Configs for Grocy

function docker_start () {
    docker run -d \
	    --name ${NAME} \
        --restart unless-stopped \
        -h ${SERVER_NAME} \
        -e TZ="${TIME_ZONE}" \
        -e PUID=${USER_ID} \
        -e PGID=${GROUP_ID} \
        -p ${PORT_MAP} \
        -v ${GROCY_DATA_DIR}:/config \
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
