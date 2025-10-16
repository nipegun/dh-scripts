#!/bin/bash

# Actualizar lista de paquetes disponibles en los repositorios
  sudo apt-get -y update

# Esteganografía
  sudo apt-get -y install stegseek

# Web
  sudo apt-get -y install nikto
  sudo apt-get -y install sqlmap
  sudo apt-get -y install gobuster

# Descompresión
  sudo apt-get -y install qpdf # zlib-deflate
  
# Herramientas para el registro de windows
  sudo apt-get -y install regripper
  sudo apt-get -y install reglookup
  # RegiPy
    sudo apt-get -y install python3-click
    sudo apt-get -y install python3-tabulate
    sudo python3 -m pip install regipy --break-system-packages
    # regipy-dump /home/usuario/Descargas/NTUSER.DAT

