#!/bin/bash

BASE_IMAGE="ubuntu:18.04"
IMAGE_NAME="jcom/apache2"
CONTAINER_NAME="httpd"
DATA_DIR="/docker/appdata/httpd"
PORT_MAP="8081:80"

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
        -p ${PORT_MAP} \
        -v ${DATA_DIR}/www:/var/www \
        ${IMAGE_NAME}
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

function docker_default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <build, start, stop, clean, update>"
}

case "$1" in
    build)  docker_build ;;
    start)  docker_start ;;
    stop)   docker_stop ;;
    clean)  docker_clean ;;
    update) docker_update ;;
    *)      docker_default "$@" ;;
esac
