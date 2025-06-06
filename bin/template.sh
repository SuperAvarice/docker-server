#!/bin/bash

IMAGE="hello-world"
NAME="hello-world"
#VOLUME="" -v ${VOLUME}:/data \
#DATA_DIR="" -v ${DATA_DIR}:/data \
#PORT_MAP="80:80" -p ${PORT_MAP} \

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function start_docker () {
    #docker volume create ${VOLUME}
    docker run \
	    --name=${NAME} \
        ${IMAGE}
}

function docker_stop () {
    docker stop ${NAME}
    docker rm ${NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE}
    #docker volume rm ${VOLUME}
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
