#!/bin/bash

cwd=$(pwd)
cd "/docker/build/chess"
./tool.sh "$@"
cd $cwd
