#!/bin/bash

# Ejecución remota únicamente como root:
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/InSystemdSandbox-Debian-Preparar-Base.sh | bash

# Corregir hostnames
  echo 'SystemdSandbox'           | tee -a /etc/hostname
  echo '127.0.0.1 SystemdSandbox' | tee -a /etc/hosts
  echo '127.0.1.1 SystemdSandbox' | tee -a /etc/hosts

# Poner todos los repositorios
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/Repositorios-Todos-Poner.sh | sed 's-sudo--g' | bash

# x
  apt-get -y update
  apt-get -y install libterm-readline-perl-perl
  apt-get -y install dialog

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

# Pasar idioma a todo español
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/CLI/Idioma-CambiarTodoAes-es.sh | sed 's-sudo--g' | bash

# Entrar en la carpeta montada del host
  cd /mnt/host/
