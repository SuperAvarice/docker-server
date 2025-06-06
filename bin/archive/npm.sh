#!/bin/bash

cwd=$(pwd)
cd "/docker/build/npm"
./compose.sh "$@"
cd $cwd
