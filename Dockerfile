FROM kalilinux/kali-rolling

# 2. Actualizar el sistema e instalar dependencias base
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  git \
  sudo \
  curl \
  wget \
  zsh \
  neovim \
  kitty \
  p7zip-full \
  unzip \
  tar \
  iputils-ping \
  iproute2 \
  isc-dhcp-client \
  dnsutils \
  kali-linux-default && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh -G sudo stark && \
  echo "stark:stark" | chpasswd && \
  echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo-nopasswd && \
  chmod 0440 /etc/sudoers.d/sudo-nopasswd

WORKDIR /home/stark

USER stark

CMD ["/bin/zsh"]
