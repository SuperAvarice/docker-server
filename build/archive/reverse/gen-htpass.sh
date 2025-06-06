#!/bin/bash

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <USER> <PASS> >> ./security/htpasswd"
    exit 1
fi

USER=$1
PASS=$2

# sudo apt install apache2-utils; htpasswd -Bbn ${USER} ${PASS} >> htpasswd
#docker run --rm httpd:2.4-alpine htpasswd -nbB "${USER}" "${PASS}"
#docker run --rm nginx:alpine printf "${USER}:$(openssl passwd -5 ${PASS})\n"
printf "${USER}:$(openssl passwd -5 ${PASS})\n"
