# This Dockerfile is used to build a novnc image based on Ubuntu

ARG BASEIMAGE=ubuntu
ARG BASETAG=22.04
FROM ${BASEIMAGE}:${BASETAG}

ENV NO_VNC_HOME=/usr/share/novnc
ENV TZ=Etc/UTC
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update \
    && apt-get install -yq --no-install-recommends novnc websockify \
	&& apt-get autoremove -yq \
	&& apt-get clean -yq \
	&& rm -rf /var/lib/apt/lists/*

RUN ln -s $NO_VNC_HOME/vnc_auto.html $NO_VNC_HOME/index.html

EXPOSE 6000

ENTRYPOINT [ "bash", "/usr/share/novnc/utils/launch.sh" ]
