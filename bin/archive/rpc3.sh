#!/bin/bash

cwd=$(pwd)
cd "/docker/build/rpc3"
./docker.sh "$@"
cd $cwd
