#!/bin/bash

# https://komo.do/docs/setup/mongo

PROJECT="komodo"
COMPOSE_FILE="mongo.compose.yaml"
ENV_FILE="compose.env"

function compose_pull () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} --env-file ${ENV_FILE} pull
}

function compose_up () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} --env-file ${ENV_FILE} up -d
}

function compose_down () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} --env-file ${ENV_FILE} down
}

function compose_init () {
    wget https://raw.githubusercontent.com/moghtech/komodo/main/compose/mongo.compose.yaml
    wget https://raw.githubusercontent.com/moghtech/komodo/main/compose/compose.env
}

function compose_clean () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} --env-file ${ENV_FILE} down -v
}

function compose_logs () { local SERVICE="$2"
    if [[ $# -lt 2 ]]; then
        echo >&2 "Usage: $0 logs <Service>"
    else
       docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} --env-file ${ENV_FILE} logs ${SERVICE}
    fi
}

function compose_restart () {
    compose_down
    compose_pull
    compose_up
}

function compose_default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <pull, up, down, init, clean, logs, restart>"
}

case "$1" in
    pull)    compose_pull ;;
    up)      compose_up ;;
    down)    compose_down ;;
    init)    compose_init ;;
    clean)   compose_clean ;;
    logs)    compose_logs "$@" ;;
    restart) compose_restart ;;
    *)       compose_default "$@" ;;
esac
