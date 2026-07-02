#!/bin/bash

cwd=$(pwd)
cd "/docker/build/solitaire"
./tool.sh "$@"
cd $cwd
