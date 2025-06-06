#!/bin/bash

PROJECT="npm"
COMPOSE_CMD="docker-compose" # "docker compose" for new versions of docker
DEBUG_CONTAINER=""
DEBUG_SHELL="/bin/sh"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, up, down, clean, logs, debug, restart"
    exit 1
fi

case "$1" in
    pull)
        ${COMPOSE_CMD} -p "${PROJECT}" pull
    ;;
    up)
        ${COMPOSE_CMD} -p "${PROJECT}" up -d
    ;;
    down)
        ${COMPOSE_CMD} -p "${PROJECT}" down
    ;;
    clean)
        ${COMPOSE_CMD} -p "${PROJECT}" down -v
    ;;
    logs)
        ${COMPOSE_CMD} -p "${PROJECT}" logs $2
    ;;
    debug)
        docker exec -it ${PROJECT}_${DEBUG_CONTAINER}_1 ${DEBUG_SHELL}
    ;;
    restart)
        ${COMPOSE_CMD} -p "${PROJECT}" down
        ${COMPOSE_CMD} -p "${PROJECT}" up -d
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac
