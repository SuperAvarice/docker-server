#!/bin/bash

BASE_IMAGE="ubuntu:latest"
IMAGE_NAME="myImageName"
CONTAINER_NAME="myContainerName"
#VOLUME="" # -v ${VOLUME}:/data \
#DATA_DIR="" # -v ${DATA_DIR}:/data \
#PORT_MAP="80:80" # -p ${PORT_MAP} \

# Prefer podman if available, otherwise use docker
if command -v podman >/dev/null 2>&1; then BACKEND="podman"; else BACKEND="docker"; fi

# Override variables in custom file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# Or uncomment and use below variables instead of .env file.
# MY_HOST="localhost"

function _build () {
    ${BACKEND} pull ${BASE_IMAGE}
    ${BACKEND} build \
        --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
        --tag=${IMAGE_NAME} \
        -f ./Dockerfile .
    #docker volume create ${VOLUME}
}

function _start () {
    ${BACKEND} run -d \
        --name=${CONTAINER_NAME} \
        --restart unless-stopped \
        ${IMAGE_NAME}
}

function _stop () {
    ${BACKEND} stop ${CONTAINER_NAME}
    #${BACKEND} rm ${CONTAINER_NAME}
}

function _clean () {
    ${BACKEND} builder prune --all --force
    ${BACKEND} image rm ${IMAGE_NAME}
    #${BACKEND} volume rm ${VOLUME}
}

function _update () {
    _stop
    _build
    _start
}

function _default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <build, start, stop, clean, update>"
}

case "$1" in
    build)  _build ;;
    start)  _start ;;
    stop)   _stop ;;
    clean)  _clean ;;
    update) _update ;;
    *)      _default "$@" ;;
esac
