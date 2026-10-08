#!/bin/bash

# Info: https://docs.speedtest-tracker.dev/getting-started/installation/using-docker
# Environment variables: https://docs.speedtest-tracker.dev/getting-started/environment-variables
# Server IDs: https://www.speedtest.net/api/js/servers
# Schedule configuration help: https://crontab.guru/

IMAGE="lscr.io/linuxserver/speedtest-tracker:latest"
NAME="speedtest-tracker"
HOST_PORT="8085"
PORT_MAP="${HOST_PORT}:80"
_UID=$(id -u)
_GID=$(id -g)
SPEEDTEST_SCHEDULE="*/15 * * * *"
SPEEDTEST_SERVERS="26650,72771,2409,71915,75867,22288,69099,69553,72712"
PRUNE_RESULTS_OLDER_THAN="30"

# Override variables in custom file or uncomment and use below ones.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# TIME_ZONE="America/Chicago"
# SPEEDTEST_DATA_DIR="/docker/appdata/speedtest-tracker"
# SPEEDTEST_APP_KEY="base64:**************="
# SPEEDTEST_APP_URL="https://speedtest.example.net"

function _start () {
    docker run -d \
	    --name=${NAME} \
        --restart unless-stopped \
        -p ${PORT_MAP} \
        -e PUID="${_UID}" \
        -e PGID="${_GID}" \
        -e DISPLAY_TIMEZONE="${TIME_ZONE}" \
        -e APP_KEY="${SPEEDTEST_APP_KEY}" \
        -e APP_URL="${SPEEDTEST_APP_URL}" \
        -e DB_CONNECTION=sqlite \
        -e SPEEDTEST_SCHEDULE="${SPEEDTEST_SCHEDULE}" \
        -e SPEEDTEST_SERVERS="${SPEEDTEST_SERVERS}" \
        -e SPEEDTEST_EXTERNAL_IP_URL="http://ifconfig.me/ip" \
        -e PRUNE_RESULTS_OLDER_THAN="${PRUNE_RESULTS_OLDER_THAN}" \
        -e PUBLIC_DASHBOARD=true \
        -v ${SPEEDTEST_DATA_DIR}/config:/config \
        -v ${SPEEDTEST_DATA_DIR}/keys:/config/keys \
        ${IMAGE}
}

function _init () {
    echo "Seed the ${SPEEDTEST_DATA_DIR}."
    mkdir -p "${SPEEDTEST_DATA_DIR}/config" "${SPEEDTEST_DATA_DIR}/keys"
    echo "Copy this key including the base64: prefix and paste it as your SPEEDTEST_APP_KEY in the .env file."
    echo "base64:$(openssl rand -base64 32 2>/dev/null)"
}

function _stop () {
    docker stop ${NAME}
    docker rm ${NAME}
}

function _clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE}
}

function _update () {
    _stop
    docker pull ${IMAGE}
    _start
}

case "$1" in
    init)   _init ;;
    start)  _start ;;
    stop)   _stop ;;
    clean)  _clean ;;
    update) _update ;;
    *)
        [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
        echo >&2 "Usage $0 <init, start, stop, clean, update>"
    ;;
esac
