# This Dockerfile is used to build an headless vnc image based on Ubuntu

ARG BASEIMAGE=ubuntu
ARG BASETAG=20.04
ARG DEBIAN_FRONTEND=noninteractive

### stage_build
FROM ${BASEIMAGE}:${BASETAG} as stage_build

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update \
    && apt-get install -yq lsb-release net-tools locales sudo unzip zip wget vim openssh-client expect \
    && locale-gen en_US.UTF-8 \
    && apt-get install -yq xfce4 xfce4-goodies xfce4-terminal tigervnc-standalone-server firefox \
	&& apt-get purge -yq pm-utils pavucontrol pulseaudio xscreensaver* \
	&& apt-get autoremove -yq \
	&& apt-get clean -yq \
	&& rm -rf /var/lib/apt/lists/*

### stage_final
FROM stage_build as stage_final

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    HOME=/home/headless \
    USER=headless \
    TERM=xterm \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=headless \
    VNC_VIEW_ONLY=false

### Setup user
RUN useradd -rm -d $HOME -s /bin/bash -g root -G sudo -u 1000 $USER -p "$(openssl passwd -1 $VNC_PW)"
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER $USER
WORKDIR $HOME
RUN touch $HOME/.Xauthority
RUN touch $HOME/.Xresources
RUN mkdir -p $HOME/.vnc

### Set VNC Password
RUN expect -c 'set timeout 3;spawn /usr/bin/vncpasswd;expect "*?assword:*";send -- "$env(VNC_PW)\r";expect "*?erify:*";send -- "$env(VNC_PW)\r";expect "*?view-only password*";send -- "n\r";send -- "\r";expect eof'

# Setup the xstartup
ENV SCRIPT="$HOME/.vnc/xstartup"
RUN echo "#!/bin/sh" >> ${SCRIPT}
RUN echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources" >> ${SCRIPT}
RUN echo "vncconfig -iconic &" >> ${SCRIPT}
RUN echo "startxfce4" >> ${SCRIPT}
RUN chmod a+x ${SCRIPT}

CMD exec bash -c "vncserver -localhost no $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION && tail -F $HOME/.vnc/*.log"
#CMD exec bash -c "sleep infinity"
