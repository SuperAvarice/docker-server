$IMAGE="jcom/headless-vnc"
$BUILD_DIR="C:\Workspace\headless-vnc"

# http://localhost:6901/

$cmdOutput = docker images -q $IMAGE
if ($cmdOutput.length -lt 4) {
    docker build -t ${IMAGE} -f ${BUILD_DIR}\Dockerfile ${BUILD_DIR}
}

write-host ""
write-host "Ubuntu headless vnc"
write-host ""

docker run -d --init `
  --name=headless-vnc `
  --shm-size=2gb `
  -p 6901:6901 `
  -e VNC_RESOLUTION="1900x960" `
  ${IMAGE}
