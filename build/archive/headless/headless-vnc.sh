#!/bin/bash

IMAGE="jcom/headless"
BUILD_DIR="/docker/build/headless"

# http://localhost:6901/

cd $BUILD_DIR || exit

if [[ "$(docker images -q $IMAGE 2> /dev/null)" == "" ]]; then
  docker build -t $IMAGE -f DockerFile .
fi

echo ""
echo "Ubuntu headless vnc"
echo ""

docker run -d --init \
  --name=headless-vnc \
  --shm-size=2gb \
  -p 6901:6901 \
  -e VNC_RESOLUTION="1920x1080" \
  $IMAGE
