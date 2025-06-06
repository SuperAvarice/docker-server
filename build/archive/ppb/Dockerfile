FROM ubuntu:latest

# Source: https://github.com/NathanVaughn/powerpanel-business-docker

ENV POWERPANEL_VERSION=470

RUN apt-get update \
    && apt-get install -y \
      curl ca-certificates libgusb2 libusb-1.0-0 usb.ids usbutils expect \
      --no-install-recommends \
    && apt-get autoremove -yq \
    && apt-get clean -yq \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s -L https://dl4jz3rbrsfum.cloudfront.net/software/ppb${POWERPANEL_VERSION}-linux-x86_x64.sh -o ppb-linux-x86_64.sh \
 && chmod +x ppb-linux-x86_64.sh

COPY install-${POWERPANEL_VERSION}.exp install.exp
RUN chmod +x install.exp && expect ./install.exp && rm ppb-linux-x86_64.sh && rm install.exp

EXPOSE 3052
EXPOSE 53568
VOLUME ["/usr/local/ppbe/db_local/"]

HEALTHCHECK CMD curl -vs --fail http://127.0.0.1:3052/ || exit 1
ENTRYPOINT ["/usr/local/ppbe/ppbed", "run"]

