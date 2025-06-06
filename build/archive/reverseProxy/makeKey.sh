#!/bin/bash

#sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout default.key -out default.crt
#sudo openssl dhparam -out dhparam-2048.pem 2048
sudo openssl dhparam -dsaparam -out dhparam.pem 4096

