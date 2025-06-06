#!/bin/bash

# https://github.com/jlesage/docker-baseimage-gui
BASE_IMAGE="jlesage/baseimage-gui:debian-12-v4"
IMAGE_NAME="jcom/solitaire"
CONTAINER_NAME="solitaire"
VOLUME="solitaire-data"
HOST_PORT="5802"
PORT_MAP="${HOST_PORT}:5800"
DOCKER_FILE="./Dockerfile"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function docker_build () {
    docker pull ${BASE_IMAGE}
    echo "FROM ${BASE_IMAGE}" > ${DOCKER_FILE}
    echo "RUN add-pkg locales && sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen" >> ${DOCKER_FILE}
    echo "ENV LANG=en_US.UTF-8" >> ${DOCKER_FILE}
    echo "RUN add-pkg aisleriot gnome-cards-data" >> ${DOCKER_FILE}
    echo "RUN install_app_icon.sh \"/usr/share/icons/hicolor/256x256/apps/gnome-aisleriot.png\"" >> ${DOCKER_FILE}
    echo "RUN echo \"#!/bin/sh\" > /startapp.sh" >> ${DOCKER_FILE}
    echo "RUN echo \"exec /usr/games/sol --variation=freecell\" >> /startapp.sh" >> ${DOCKER_FILE}
    echo "RUN chmod +x /startapp.sh" >> ${DOCKER_FILE}
    echo "RUN set-cont-env APP_NAME \"Solitaire\"" >> ${DOCKER_FILE}
    echo "RUN set-cont-env APP_VERSION \"1.0\"" >> ${DOCKER_FILE}
    docker build --tag=${IMAGE_NAME} -f ${DOCKER_FILE} .
    rm -rf ${DOCKER_FILE}
    docker volume create ${VOLUME}
}

function docker_start () {
    docker run -d \
        --name=${CONTAINER_NAME} \
        --restart unless-stopped \
        -p ${PORT_MAP} \
        -v ${VOLUME}:/config \
        -e DARK_MODE=1 \
        -e KEEP_APP_RUNNING=1 \
        ${IMAGE_NAME}
    echo "connect: http://${MY_HOST}:${HOST_PORT}/"
}

function docker_stop () {
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE_NAME}
    docker volume rm ${VOLUME}
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
