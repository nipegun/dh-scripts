#!/bin/bash

# Actualizar lista de paquetes disponibles en los repositorios
  sudo apt-get -y update

# Esteganografía
  sudo apt-get -y install stegseek

# Web
  sudo apt-get -y install nikto
  sudo apt-get -y install sqlmap
  sudo apt-get -y install gobuster

