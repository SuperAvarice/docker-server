#!/bin/bash

# Info: https://dockhand.pro/manual/
# Environment variables: https://dockhand.pro/manual/#environment-variables

IMAGE="fnsys/dockhand:latest"
NAME="dockhand"
HOST_PORT="8087"
PORT_MAP="${HOST_PORT}:3000"
_UID=$(id -u)
_GID=$(id -g)

if command -v podman &> /dev/null; then
    CONTAINER_ENGINE="podman"
    HOST_SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    echo "Using podman as the container engine."
else
    CONTAINER_ENGINE="docker"
    HOST_SOCKET="/var/run/docker.sock"
    echo "Using docker as the container engine."
fi

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# DOCKERHAND_DATA_DIR="/docker/appdata/dockerhand"
# DOCKERHAND_SOCKET_GID="1000"

function _init () {
    echo "Seed the ${DOCKERHAND_DATA_DIR}. Using this user ID: ${_UID} and group ID: ${_GID}"
    mkdir -p "${DOCKERHAND_DATA_DIR}"
    DOCKER_GID=$(stat -c '%g' ${HOST_SOCKET})
    echo "Docker group ID on the host socket: ${DOCKER_GID}"
    echo "Add this to the .env file as DOCKERHAND_SOCKET_GID=${DOCKER_GID}"
}

function _pull () {
    ${CONTAINER_ENGINE} pull ${IMAGE}
}

function _start () {
    ${CONTAINER_ENGINE} run -d \
	    --name=${NAME} \
        --restart unless-stopped \
        --group-add "${DOCKERHAND_SOCKET_GID}" \
        -p ${PORT_MAP} \
        -e PUID="${_UID}" \
        -e PGID="${_GID}" \
        -e DATA_DIR=/opt/dockhand \
        -v ${DOCKERHAND_DATA_DIR}:/opt/dockhand \
        -v ${HOST_SOCKET}:/var/run/docker.sock \
        ${IMAGE}
}

function _stop () {
    ${CONTAINER_ENGINE} stop ${NAME}
    ${CONTAINER_ENGINE} rm ${NAME}
}

function _clean () {
    ${CONTAINER_ENGINE} builder prune --all --force
    ${CONTAINER_ENGINE} image rm ${IMAGE}
}

function _update () {
    _stop
    ${CONTAINER_ENGINE} pull ${IMAGE}
    _start
}

case "$1" in
    init)   _init ;;
    pull)   _pull ;;
    start)  _start ;;
    stop)   _stop ;;
    clean)  _clean ;;
    update) _update ;;
    *)
        [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
        echo >&2 "Usage $0 <init, pull, start, stop, clean, update>"
    ;;
esac
