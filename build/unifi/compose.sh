#!/bin/bash

# https://docs.linuxserver.io/images/docker-unifi-network-application/
# https://hub.docker.com/r/linuxserver/unifi-network-application

PROJECT="unifi"
COMPOSE_FILE="docker-compose.yml" # The default

# Common vars for compose file and here
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# UNIFI_MONGO_USER=unifi
# UNIFI_MONGO_PASSWORD=
# UNIFI_MONGO_DB=unifi
# UNIFI_USER_ID=1000
# UNIFI_GROUP_ID=1000
# UNIFI_TIME_ZONE=America/Chicago
# UNIFI_DATA_DIR=/docker/appdata/unifi
# UNIFI_NETWORK_IMAGE=lscr.io/linuxserver/unifi-network-application:latest
# UNIFI_MONGO_IMAGE=docker.io/mongo:7

function compose_pull () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} pull
}

function compose_up () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} up -d
}

function compose_down () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} down
}

function compose_clean () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} down -v
}

function compose_logs () { local SERVICE="$2"
    if [[ $# -lt 2 ]]; then
        echo >&2 "Usage: $0 logs <Service>"
    else
       docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} logs ${SERVICE}
    fi
}

function compose_restart () {
    compose_down
    compose_pull
    compose_up
}

function compose_default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <pull, up, down, clean, logs, restart>"
}

case "$1" in
    pull)    compose_pull ;;
    up)      compose_up ;;
    down)    compose_down ;;
    clean)   compose_clean ;;
    logs)    compose_logs "$@" ;;
    restart) compose_restart ;;
    *)       compose_default "$@" ;;
esac
