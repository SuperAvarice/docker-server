#!/bin/bash

PROJECT="reverse"
COMPOSE_CMD="docker-compose"
DEBUG_CONTAINER="nginx"
DEBUG_SHELL="/bin/ash"
DATA_DIR=/docker/appdata/reverse
ENV_ARGS="DATA_DIR=${DATA_DIR}"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = pull, up, down, copy, genpass, clean, logs, debug, restart"
    exit 1
fi

case "$1" in
    pull)
       env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" pull
    ;;
    up)
        env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" ${ENV} up -d
    ;;
    down)
       env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" down
    ;;
    copy)
        sudo cp -R ./conf/ ${DATA_DIR}/
        sudo cp -R ./security/ ${DATA_DIR}/
    ;;
    genpass)
        if [[ $# -lt 3 ]]; then
            echo >&2 "Usage: $0 genpass <USER> <PASS> >> ./security/htpasswd"
            exit 2
        fi
        USER=$2
        PASS=$3
        # sudo apt install apache2-utils; htpasswd -Bbn ${USER} ${PASS} >> htpasswd
        #docker run --rm httpd:2.4-alpine htpasswd -nbB "${USER}" "${PASS}"
        #docker run --rm nginx:alpine printf "${USER}:$(openssl passwd -5 ${PASS})\n"
        printf "${USER}:$(openssl passwd -5 ${PASS})\n"
    ;;
    clean)
        env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" down -v
    ;;
    logs)
        env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" logs $2
    ;;
    debug)
        docker exec -it -e ${ENV_ARGS} ${PROJECT}_${DEBUG_CONTAINER}_1 ${DEBUG_SHELL}
    ;;
    restart)
        env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" down
        env ${ENV_ARGS} ${COMPOSE_CMD} -p "${PROJECT}" ${ENV} up -d
    ;;
    *)
        echo "$0: Error: Invalid option: $1"
        exit 1
    ;;
esac
