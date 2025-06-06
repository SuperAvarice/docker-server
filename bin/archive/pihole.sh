#!/bin/bash

NAME="pihole"
IMAGE="pihole/pihole:latest"
DATA="/docker/appdata/pihole"
TIME_ZONE="America/Chicago"
SERVER_IP="172.16.0.100"
ROUTER="172.16.0.1"
NETWORK="172.16.0.0/24"
DOMAIN="lan"
THEME="lcars"
TEMP_UNIT="f"

function docker_start () {
    docker run -d \
        --name=${NAME} \
        --hostname ${NAME} \
        -p 53:53/tcp -p 53:53/udp \
        -p 80:80/tcp \
        -e TZ="${TIME_ZONE}" \
        -e REV_SERVER="true" \
        -e FTLCONF_LOCAL_IPV4="${SERVER_IP}" \
        -e REV_SERVER_TARGET="${ROUTER}" \
        -e REV_SERVER_CIDR="${NETWORK}" \
        -e REV_SERVER_DOMAIN="${DOMAIN}" \
        -e WEBTHEME="${THEME}" \
        -e TEMPERATUREUNIT="${TEMP_UNIT}" \
        -v "${DATA}/etc/:/etc/pihole/" \
        -v "${DATA}/dnsmasqd/:/etc/dnsmasq.d/" \
        -v "/etc/timezone:/etc/timezone:ro" \
        -v "/etc/localtime:/etc/localtime:ro" \
        --dns=127.0.0.1 --dns=1.1.1.1 \
        --cap-add=NET_ADMIN \
        --restart unless-stopped \
        ${IMAGE}
}

function docker_stop () {
    docker stop ${NAME}
    docker rm ${NAME}
}

function docker_setpass () {
    docker exec -it ${NAME} pihole -a -p
}

function docker_clean () {
    docker builder prune --all --force
    docker image rm ${IMAGE}
    docker volume rm ${VOLUME}
}

function docker_update () {
    docker_stop
    docker pull ${IMAGE}
    docker_start
}

function docker_default () {
    [ $# -eq 1 ] && echo "$0: Error: Invalid option: $1"
    echo >&2 "Usage $0 <start, stop, setpass, clean, update>"
}

case "$1" in
    start)   docker_start ;;
    stop)    docker_stop ;;
    setpass) docker_setpass ;;
    clean)   docker_clean ;;
    update)  docker_update ;;
    *)       docker_default "$@" ;;
esac
