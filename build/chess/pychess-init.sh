#!/bin/sh
# Copy pychess defaults on first run if the config dir is missing or empty
DEST="/config/xdg/config/pychess"
if [ ! -d "${DEST}" ] || [ -z "$(ls -A ${DEST} 2>/dev/null)" ]; then
    mkdir -p "${DEST}"
    cp -r /defaults/pychess-config/. "${DEST}/"
fi
