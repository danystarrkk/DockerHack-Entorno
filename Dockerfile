# 1. Imagen base: Arch Linux puro
FROM archlinux:latest

# 2. Actualizar el sistema e instalar dependencias base
# Incluimos lo necesario para clonar repos y ejecutar scripts de automatización
RUN pacman -Syu --noconfirm && \
  pacman -S --needed --noconfirm \
  base-devel \
  git \
  sudo \
  curl \
  wget \
  zsh \
  neovim \
  kitty \
  7zip \
  unzip \
  tar \
  iputils \
  iproute2 \
  dhclient \
  bind && \
  pacman -Scc --noconfirm

# 3. Creación del usuario 'stark' con privilegios
# -m: crea el directorio home, -s: shell, -G: grupos (wheel para sudo)
RUN useradd -m -s /bin/zsh -G wheel stark && \
  echo "stark:stark" | chpasswd && \
  # Permitir sudo sin contraseña para el grupo wheel
  echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel && \
  chmod 0440 /etc/sudoers.d/wheel

# 4. Establecer el directorio de trabajo en el home del usuario
WORKDIR /home/stark

# 5. Cambiar el usuario por defecto a 'stark'
USER stark

# 6. Definir zsh como shell interactiva al iniciar
CMD ["/bin/zsh"]
