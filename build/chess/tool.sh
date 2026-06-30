#!/bin/bash

# https://github.com/jlesage/docker-baseimage-gui
BASE_IMAGE="jlesage/baseimage-gui:debian-13-v4"
IMAGE_NAME="jcom/chess"
CONTAINER_NAME="chess"
VOLUME="chess-data"
HOST_PORT="5803"
PORT_MAP="${HOST_PORT}:5800"
DOCKER_FILE="./Dockerfile"

if command -v podman >/dev/null 2>&1; then
    BACKEND="podman"
else
    BACKEND="docker"
fi

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# MY_HOST="localhost"

function _build () {
    ${BACKEND} pull ${BASE_IMAGE}
    # Seed /run so buildah can place .containerenv (jlesage /run is a symlink to /tmp/run)
    mkdir -p run; : > run/.keep
    echo "FROM ${BASE_IMAGE}" > ${DOCKER_FILE}
    echo "COPY run/ /run/" >> ${DOCKER_FILE}
    echo "RUN rm /run && mkdir /run" >> ${DOCKER_FILE}
    echo "RUN add-pkg locales && sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen" >> ${DOCKER_FILE}
    echo "ENV LANG=en_US.UTF-8" >> ${DOCKER_FILE}
    echo "RUN add-pkg pychess gnuchess stockfish librsvg2-bin" >> ${DOCKER_FILE}
    echo "RUN ln -sf /usr/games/gnuchess /usr/local/bin/gnuchess" >> ${DOCKER_FILE}
    echo "RUN install_app_icon.sh \"/usr/share/icons/hicolor/scalable/apps/pychess.svg\" || \\
    install_app_icon.sh \"/usr/share/pixmaps/pychess.png\" || true" >> ${DOCKER_FILE}
    echo "COPY startapp.sh /startapp.sh" >> ${DOCKER_FILE}
    echo "RUN chmod +x /startapp.sh" >> ${DOCKER_FILE}
    echo "RUN set-cont-env APP_NAME \"Chess\"" >> ${DOCKER_FILE}
    echo "RUN set-cont-env APP_VERSION \"1.0\"" >> ${DOCKER_FILE}
    if [ -d "${SCRIPT_DIR}/pychess-config" ] && [ -n "$(ls -A ${SCRIPT_DIR}/pychess-config 2>/dev/null)" ]; then
        echo "Including baked pychess defaults..."
        echo "COPY pychess-config/ /defaults/pychess-config/" >> ${DOCKER_FILE}
        echo "COPY pychess-init.sh /etc/cont-init.d/50-pychess-defaults.sh" >> ${DOCKER_FILE}
        echo "RUN chmod +x /etc/cont-init.d/50-pychess-defaults.sh" >> ${DOCKER_FILE}
    fi
    ${BACKEND} build --tag=${IMAGE_NAME} -f ${DOCKER_FILE} .
    rm -rf ${DOCKER_FILE} run
    ${BACKEND} volume inspect ${VOLUME} >/dev/null 2>&1 || ${BACKEND} volume create ${VOLUME}
}

function _start () {
    ${BACKEND} run -d \
        --name=${CONTAINER_NAME} \
        --restart unless-stopped \
        -p ${PORT_MAP} \
        -v ${VOLUME}:/config \
        -e DARK_MODE=1 \
        -e KEEP_APP_RUNNING=1 \
        ${IMAGE_NAME}
    echo "connect: http://${MY_HOST}:${HOST_PORT}/"
}

function _config () {
    local CONFIG_DIR="${SCRIPT_DIR}/pychess-config"
    local SRC="/config/xdg/config/pychess"
    echo "Extracting pychess settings from running container..."
    if ! ${BACKEND} exec ${CONTAINER_NAME} sh -c "[ -d '${SRC}' ]" 2>/dev/null; then
        echo "Error: ${SRC} not found in container '${CONTAINER_NAME}'."
        echo "Ensure pychess is running and you have changed at least one setting through the web UI."
        exit 1
    fi
    rm -rf "${CONFIG_DIR}" && mkdir -p "${CONFIG_DIR}"
    ${BACKEND} cp "${CONTAINER_NAME}:${SRC}/." "${CONFIG_DIR}/"
    echo "Extracted:"
    ls "${CONFIG_DIR}"
    echo "Run ./tool.sh build to bake these settings into the image."
}

function _stop () {
    ${BACKEND} stop ${CONTAINER_NAME}
    ${BACKEND} rm ${CONTAINER_NAME}
}

function _clean () {
    ${BACKEND} builder prune --all --force
    ${BACKEND} image rm ${IMAGE_NAME}
    ${BACKEND} volume rm ${VOLUME}
}

function _update () {
    _stop
    _build
    _start
}

function _default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <build, start, stop, config, clean, update>"
}

case "$1" in
    build)  _build ;;
    start)  _start ;;
    stop)   _stop ;;
    config) _config ;;
    clean)  _clean ;;
    update) _update ;;
    *)      _default "$@" ;;
esac
