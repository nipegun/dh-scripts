#!/bin/bash

# Ejecución remota únicamente como root:
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/InSandBox-Debian-Preparar-Base.sh | bash

# Corregir hostnames
  echo 'Sanbox'            | tee -a /etc/hostname
  echo '127.0.0.1 Sandbox' | tee -a /etc/hosts
  echo '127.0.1.1 Sandbox' | tee -a /etc/hosts

# Crear la carpeta termporal
  mkdir /mnt/host/tmp
  chmod 777 /mnt/host/tmp/

# locales
  apt-get -y install locales
  sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  sed -i 's/^# *es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
  echo 'export LANG=en_US.UTF-8'     >> /etc/profile
  echo 'export LC_ALL=en_US.UTF-8'   >> /etc/profile
  echo 'export LANGUAGE=en_US.UTF-8' >> /etc/profile
  locale-gen
  update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# Instalar programás básicos
  apt-get -y install sudo
  apt-get -y install nano
  apt-get -y install mc

# Entrar en la carpeta montada del host
  cd /mnt/host/


