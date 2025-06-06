FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
#COPY default.crt /etc/nginx/ssl/default.crt
#COPY default.key /etc/nginx/ssl/default.key
COPY dhparam.pem /etc/nginx/dhparam.pem
COPY ssl-params.inc /etc/nginx/conf.d/ssl-params.inc
COPY proxy-params.inc /etc/nginx/conf.d/proxy-params.inc

RUN apk --update --no-cache add curl

HEALTHCHECK --interval=5m --timeout=3s CMD curl --fail http://test.schwan.us || exit 1

