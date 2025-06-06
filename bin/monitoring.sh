#!/bin/bash

cwd=$(pwd)
cd "/docker/build/monitoring"
./compose.sh "$@"
cd $cwd
