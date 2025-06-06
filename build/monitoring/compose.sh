#!/bin/bash

PROJECT="monitoring"
COMPOSE_FILE="docker-compose.yml" # The default

# Common vars for compose file and here
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# UNIFI_CONTROLLER=https://172.16.0.1:8443
# UNIFI_POLLER_USER=unifipoller
# UNIFI_POLLER_PASS=*****************
# UNIFI_POLLER_SAVE_DPI=true
# DATA_DIR=/docker/appdata/monitoring
# SERVER_DOMAIN=my-domain.com
# SERVER_ROOT_URL=https://grafana.my-domain.com
# SERVE_FROM_SUB_PATH=false
# ADMIN_USER=admin
# ADMIN_PASSWORD=*****************
# ANONYMOUS_ENABLED=true

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
