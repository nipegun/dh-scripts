#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar DVWA en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/DVWA-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/DVWA-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/DVWA-Instalar.sh | nano -
# ----------
# enlace 1: https://keepcoding.io/blog/como-instalar-dvwa-en-kali-linux/
# enlace 2: https://github.com/digininja/DVWA/blob/master/README.es.md

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada
  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 13 (x)...${cFinColor}"
    echo ""

    # Crear la base de datos
      sudo apt-get -y update
      sudo apt-get -y install mariadb-server
      sudo systemctl enable mariadb --now

      sudo mariadb -u root -e "
        ALTER USER 'root'@'localhost' IDENTIFIED VIA unix_socket;
        FLUSH PRIVILEGES;
      "
      
      sudo mariadb -e "
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        FLUSH PRIVILEGES;
      "

      # Crear el usuario y la base de datos
        sudo mariadb -e "
          CREATE DATABASE IF NOT EXISTS dvwa;
          CREATE USER IF NOT EXISTS 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd';
          GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost';
          FLUSH PRIVILEGES;
        "

    # Instalar apache2 y php
      sudo apt-get -y install apache2
      sudo apt-get -y install php
      sudo apt-get -y install libapache2-mod-php
      sudo apt-get -y install php-mysqli
      sudo apt-get -y install php-gd
      sudo apt-get -y install php-mbstring
      sudo apt-get -y install php-xml
      sudo apt-get -y install php-curl
      sudo apt-get -y install php-zip
      sudo apt-get -y install php-bcmath

      # Determinar la versión de php instalada y modificar php.ini
        vVersPHP=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
        sudo sed -i -e 's|allow_url_include = Off|allow_url_include = On|g'           /etc/php/"$vVersPHP"/apache2/php.ini
        sudo sed -i -e 's|display_errors = Off|display_errors = On|g'                 /etc/php/"$vVersPHP"/apache2/php.ini
        sudo sed -i -e 's|display_startup_errors = Off|display_startup_errors = On|g' /etc/php/"$vVersPHP"/apache2/php.ini

    # Clonar el repo
      # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install git
          echo ""
        fi
      cd /tmp/
      git clone https://github.com/digininja/DVWA.git

    # Mover archivos a /var/www/html/
      sudo rm -rf /var/www/html/*
      sudo cp -R /tmp/DVWA/* /var/www/html/

    # Configurar usuario
      sudo cp /var/www/html/config/config.inc.php.dist /var/www/html/config/config.inc.php
      sudo sed -i 's/127.0.0.1/localhost/g' /var/www/html/config/config.inc.php

    # Instalar composer y dependencias
      sudo apt-get -y install composer
      cd /var/www/html/vulnerabilities/api
      sudo -u www-data composer install --no-interaction

    # Reparar permisos
      sudo chown www-data:www-data /var/www/html/* -R
      sudo chmod -R 755 /var/www/html
      sudo chmod -R 777 /var/www/html/config
      sudo chmod -R 777 /var/www/html/hackable/uploads

    # Iniciar apache
      sudo systemctl enable apache2 --now
      sudo a2enmod rewrite
      sudo systemctl restart apache2

    # Notificar fin de ejecución del script
      echo ""
      echo "  Script de instalación de DVWA, finalizado."
      echo ""
      echo "    La configuración de seguridad se ha configurado como low."
      echo "    Si la quieres cambiar, modifica el archivo /var/www/html/config/config.inc.php"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "    Puedes ingresar en la web de DVWA entrando en http://$vIPLocal "
      echo ""
      echo "    El nombre de usuario por defecto es admin y la contraseña es password"
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de DVWA para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
