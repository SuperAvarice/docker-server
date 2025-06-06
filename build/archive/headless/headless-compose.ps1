$BUILD_DIR="G:\My Drive\Workspace\headless"

# http://localhost:6901/

#$VNC_IMAGE="jcom/novnc"
#$cmdOutput = docker images -q $VNC_IMAGE
#if ($cmdOutput.length -lt 4) {
#	docker build -t ${VNC_IMAGE} -f ${BUILD_DIR}\Dockerfile.novnc ${BUILD_DIR}
#}
#
#$BASE_IMAGE="jcom/headless"
#$cmdOutput = docker images -q $BASE_IMAGE
#if ($cmdOutput.length -lt 4) {
#	docker build -t ${BASE_IMAGE} -f ${BUILD_DIR}\Dockerfile.headless ${BUILD_DIR}
#}

write-host ""
write-host "Ubuntu headless vnc - compose"
write-host ""

$oldDir = (Get-Location).Path
cd ${BUILD_DIR}
docker-compose up -d
cd $oldDir
