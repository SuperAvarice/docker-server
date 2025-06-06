#!/bin/bash

# https://github.com/ConSol/docker-headless-vnc-container

IMAGE="consol/debian-xfce-vnc"
NAME="xfce-vnc"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function docker_start () {
    docker run -d \
        --name=${NAME} \
        --user $(id -u):$(id -g) \
        -p 5901:5901 \
        -p 6901:6901 \
        -e VNC_RESOLUTION="1920x1080" \
        ${IMAGE}
    echo "connect via VNC viewer host:5901"
    echo "connect via noVNC HTML5 full client: http://${MY_HOST}:6901/vnc.html?password=vncpassword"
    echo "connect via noVNC HTML5 lite client: http://${MY_HOST}:6901/?password=vncpassword"
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
