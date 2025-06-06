#!/bin/bash

cwd=$(pwd)
cd "/docker/build/links"
./compose.sh "$@"
cd $cwd
