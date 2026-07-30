FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=pentester
ARG PASSWORD=${USERNAME}
ARG USER_SHELL=/bin/bash

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  kali-linux-large \
  sudo \
  nano \
  iproute2 \
  net-tools \
  iputils-ping \
  zsh \
  kitty

RUN apt-get install -y --no-install-recommends \
  x11-apps \
  mesa-utils \
  libgl1-mesa-dri \
  libglx-mesa0 \
  dbus-x11

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s ${USER_SHELL} ${USERNAME} && \
  echo "${USERNAME}:${PASSWORD}" | chpasswd && \
  usermod -aG sudo ${USERNAME} && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV RUNTIME_USER=${USERNAME}
ENV RUNTIME_SHELL=${USER_SHELL}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD exec ${RUNTIME_SHELL}
