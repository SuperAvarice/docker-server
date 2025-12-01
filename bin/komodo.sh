#!/bin/bash

cwd=$(pwd)
cd "/docker/build/komodo"
./compose.sh "$@"
cd $cwd
