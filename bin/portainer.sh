#!/bin/bash

IMAGE="portainer/portainer-ce"
HTTPD_IMAGE="httpd:2.4-alpine"
NAME="portainer"
VOLUME="portainer-data"
HOST_PORT="9000"
PORT_MAP="${HOST_PORT}:9000"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function docker_start () {
    PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
    PASS_HASH=$(docker run --rm ${HTTPD_IMAGE} htpasswd -nbB admin "${PASS}" | cut -d ":" -f 2)
    docker volume create ${VOLUME}
    docker run -d \
        --name=${NAME} \
        --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ${VOLUME}:/data \
        -p ${PORT_MAP} \
        ${IMAGE} --admin-password "${PASS_HASH}" -H unix:///var/run/docker.sock
    echo "Go to -- http://${MY_HOST}:${HOST_PORT} | Admin Password: ${PASS}"
    echo "*** Note: Password is only used on a new volume (${VOLUME}) ***"
}

function docker_stop () {
    docker stop ${NAME}
    docker rm ${NAME}
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
