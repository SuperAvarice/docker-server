# This Dockerfile is used to build an headless vnc image based on Ubuntu and noVNC

FROM ubuntu:latest

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    NO_VNC_HOME=/usr/share/novnc \
    HOME=/home/headless \
    TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=headless \
    VNC_VIEW_ONLY=false

RUN apt-get update && apt-get install -yq \
	vim net-tools locales sudo supervisor lsb-release expect \
	vnc4server \
	chromium-browser \
	novnc websockify python-numpy \
	xfce4 xfce4-terminal xterm && \
	locale-gen en_US.UTF-8 && \
	apt-get purge -yq pm-utils pulseaudio xscreensaver* && \
	apt-get autoremove -yq && \
	apt-get clean -yq && \
	rm -rf /var/lib/apt/lists/*

### Setup user
RUN useradd -rm -d /home/headless -s /bin/bash -g root -G sudo -u 1000 headless -p "$(openssl passwd -1 headless)"

### Setup symbolic links
RUN ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
RUN ln -s $NO_VNC_HOME/vnc_auto.html $NO_VNC_HOME/index.html

### Add all files to home dir
COPY [ "./src", "${HOME}/" ]

### Fix user permissions
RUN find $HOME -name '*.sh' -exec chmod a+x {} +
RUN find $HOME -name '*.desktop' -exec chmod a+x {} +
RUN chgrp -R 0 $HOME && chmod -R a+rw $HOME && find $HOME -type d -exec chmod a+x {} +
RUN chown -R headless:root $HOME/

USER headless
WORKDIR $HOME

### fix to start chromium in a Docker container, see https://github.com/ConSol/docker-headless-vnc-container/issues/2
RUN echo "CHROMIUM_FLAGS='--no-sandbox --disable-setuid-sandbox --disable-gpu --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init

EXPOSE $NO_VNC_PORT

ENTRYPOINT ["./bin/vnc_startup.sh"]
CMD [ "--wait" ]
