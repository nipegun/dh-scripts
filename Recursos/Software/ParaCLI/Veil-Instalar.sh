#!/bin/bash


# Instalar primero metasploit framework

sudo apt -y update
sudo apt -y upgrade
sudo apt -y install git curl python3 python3-pip python3-venv wine64 unzip mingw-w64 mono-devel
sudo $(which python3) -m pip install --force-reinstall pycryptodome --break-system-packages



# Instalar UPX
  curl -L https://github.com/upx/upx/releases/download/v5.0.0/upx-5.0.0-amd64_linux.tar.xz -o /tmp/upx.tar.xz
  cd /tmp/
  tar -xvf upx.tar.xz
  cd upx-*
  sudo mv -v upx /usr/local/bin/

# Configurar mingw-w64 para usar x86_64-w64-mingw32 como predeterminado
  sudo update-alternatives --config x86_64-w64-mingw32-gcc
  # Y marcar: /usr/bin/x86_64-w64-mingw32-gcc-win32

# Clonar veil
  cd ~/
  git clone https://github.com/Veil-Framework/Veil.git
  cd Veil/
  ./config/setup.sh --force --silent
# Indicar el directorio de msfvenom (normalmente /usr/bin/)
