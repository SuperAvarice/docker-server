#!/bin/bash

IMAGE="jlesage/firefox"
NAME="firefox"
VOLUME="firefox-data"
HOST_PORT="5801"
PORT_MAP="${HOST_PORT}:5800"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function docker_start () {
    docker volume create ${VOLUME}
    docker run -d --rm \
        --name=${NAME} \
        -p ${PORT_MAP} \
        -v ${VOLUME}:/config \
        -e DARK_MODE=1 \
        -e KEEP_APP_RUNNING=1 \
        ${IMAGE}
    echo "connect: http://${MY_HOST}:${HOST_PORT}/"
}

function docker_stop () {
    docker stop ${NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE}
    docker volume rm ${VOLUME}
}

function docker_update () {
    docker_stop
    docker pull ${IMAGE}
    docker_start
}

function docker_default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <start, stop, clean, update>"
}

case "$1" in
    start)  docker_start ;;
    stop)   docker_stop ;;
    clean)  docker_clean ;;
    update) docker_update ;;
    *)      docker_default "$@" ;;
esac
