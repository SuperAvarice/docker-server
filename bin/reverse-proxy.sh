#!/bin/bash

cwd=$(pwd)
cd "/docker/build/reverse-proxy"
./compose.sh "$@"
cd $cwd
