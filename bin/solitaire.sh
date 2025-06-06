#!/bin/bash

cwd=$(pwd)
cd "/docker/build/solitaire"
./docker.sh "$@"
cd $cwd
