#!/bin/bash

cwd=$(pwd)
cd "/docker/build/httpd"
./docker.sh "$@"
cd $cwd
