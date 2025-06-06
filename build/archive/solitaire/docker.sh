#!/bin/bash

# https://github.com/ConSol/docker-headless-vnc-container

BASE_IMAGE="debian:11"
IMAGE_NAME="jcom/solitaire"
CONTAINER_NAME="solitaire"
PORT_MAP="6902:6901"
MY_HOST="hyperion.lan" # localhost, etc.

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = build, start, stop, clean, update"
    exit 1
fi

function docker_build () {
    docker pull ${BASE_IMAGE}
    docker build \
        --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
        --tag=${IMAGE_NAME} \
        -f ./Dockerfile .
}

function docker_start () {
    docker run -d \
        --name=${CONTAINER_NAME} \
        --restart unless-stopped \
        --user $(id -u):$(id -g) \
        -p ${PORT_MAP} \
        -e VNC_RESOLUTION="1920x1080" \
        ${IMAGE_NAME}
    echo "connect via noVNC HTML5 lite client: http://${MY_HOST}:6902/?password=vncpassword"
}

function docker_stop () {
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE_NAME}
}

function docker_update () {
    docker_stop
    docker_build
    docker_start
}

case "$1" in
    build)
        docker_build ;;
    start)
        docker_start ;;
    stop)
        docker_stop ;;
    clean)
        docker_clean ;;
    update)
        docker_update ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac
