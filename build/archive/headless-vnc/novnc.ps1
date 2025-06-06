$IMAGE="jcom/no-vnc"
$VNC_HOST="172.16.0.1:5900"
$NO_VNC_PORT="6001"
$BUILD_DIR="G:\My Drive\Workspace\headless-vnc"

# http://localhost:6001/vnc.html
# OR
# http://localhost:6001/?password=********

$cmdOutput = docker images -q $IMAGE
if ($cmdOutput.length -lt 4) {
	docker build -t ${IMAGE} -f ${BUILD_DIR}\Dockerfile.novnc ${BUILD_DIR}
}

write-host ""
write-host "Ubuntu noVnc connector"
write-host ""

docker run -d --init --name=novnc `
-p ${NO_VNC_PORT}:6000 `
${IMAGE} --vnc ${VNC_HOST} --listen 6000
