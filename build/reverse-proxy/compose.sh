#!/bin/bash

PROJECT="reverse"
COMPOSE_FILE="docker-compose.yml" # The default
CERTBOT_OPTIONS="https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs"

# Common vars for compose file and here
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE=".env"; source ${SCRIPT_DIR}/${ENV_FILE}
# DATA_DIR=/docker/appdata/reverse-proxy
# DOMAINS=(my-host.com *.my-host.com)
# NGINX_IMAGE=nginx:alpine
# CERTBOT_IMAGE=certbot/dns-cloudflare
# HTTP_PORT=80
# HTTPS_PORT=443

function compose_pull () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} pull
}

function compose_up () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} up -d
}

function compose_down () {
    docker compose -p "${PROJECT}" -f ${COMPOSE_FILE} down
}

function compose_copy () {
    echo "Copy configs and check \"conf\" file"
    sudo mkdir -p ${DATA_DIR}/certbot
    sudo cp -R ./conf/ ${DATA_DIR}/
    sudo cp .secrets/auth_basic/* ${DATA_DIR}/security/
    sudo curl -s ${CERTBOT_OPTIONS}/options-ssl-nginx.conf > "${DATA_DIR}/certbot/options-ssl-nginx.conf"
    sudo cp .secrets/certbot/cloudflare.ini ${DATA_DIR}/certbot/

    docker run --rm \
        -v ${DATA_DIR}/conf:/etc/nginx/conf.d \
        -v ${DATA_DIR}/certbot:/etc/letsencrypt \
        yandex/gixy /etc/nginx/conf.d/server.conf
}

function compose_init () {
    echo "### Requesting Let's Encrypt certificate for $DOMAINS ..."
    # DOMAINS=(mydomain.tld *.mydomain.tld)
    domain_args=""
    for domain in "${DOMAINS[@]}"; do #Join $DOMAINS to -d args
        domain_args="$domain_args -d \"$domain\""
    done

    # Go here to generate the .secrets/certbot/cloudflare.ini file
    # https://certbot-dns-cloudflare.readthedocs.io/en/stable/
    ${COMPOSE_CMD} -p "${PROJECT}" run --rm \
        --entrypoint "certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60 $domain_args" \
        certbot
    echo
}

function compose_genpass () { local USER="$2"; local PASS="$3" # Args
    if [[ $# -lt 3 ]]; then
        echo >&2 "Usage: $0 genpass <USER> <PASS> >> ./secrets/auth_basic/htpasswd"
    else
        # sudo apt install apache2-utils; htpasswd -Bbn ${USER} ${PASS} >> htpasswd
        #docker run --rm httpd:2.4-alpine htpasswd -nbB "${USER}" "${PASS}"
        #docker run --rm nginx:alpine printf "${USER}:$(openssl passwd -5 ${PASS})\n"
        printf "${USER}:$(openssl passwd -5 ${PASS})\n"
    fi
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
    echo >&2 "Usage $0 <pull, up, down, copy, init, genpass, clean, logs, restart>"
}

case "$1" in
    pull)    compose_pull ;;
    up)      compose_up ;;
    down)    compose_down ;;
    copy)    compose_copy ;;
    init)    compose_init ;;
    genpass) compose_genpass "$@" ;;
    clean)   compose_clean ;;
    logs)    compose_logs "$@" ;;
    restart) compose_restart ;;
    *)       compose_default "$@" ;;
esac
