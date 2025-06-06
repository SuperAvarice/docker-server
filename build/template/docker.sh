#!/bin/bash

BASE_IMAGE="ubuntu:latest"
IMAGE_NAME="myImageName"
CONTAINER_NAME="myContainerName"
#VOLUME="" # -v ${VOLUME}:/data \
#DATA_DIR="" # -v ${DATA_DIR}:/data \
#PORT_MAP="80:80" # -p ${PORT_MAP} \f

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function docker_build () {
    docker pull ${BASE_IMAGE}
    docker build \
        --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
        --tag=${IMAGE_NAME} \
        -f ./Dockerfile .
    #docker volume create ${VOLUME}
}

function docker_start () {
    docker run -d \
        --name=${CONTAINER_NAME} \
        --restart unless-stopped \
        ${IMAGE_NAME}
}

function docker_stop () {
    docker stop ${CONTAINER_NAME}
    #docker rm ${CONTAINER_NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE_NAME}
    #docker volume rm ${VOLUME}
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
