#!/bin/bash

cwd=$(pwd)
cd "/docker/build/unifi"
./compose.sh "$@"
cd $cwd
