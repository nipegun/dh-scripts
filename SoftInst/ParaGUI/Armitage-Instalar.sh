#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Armitage en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/Armitage-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/Armitage-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/Armitage-Instalar.sh | nano -
# ----------

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios
      echo ""
      echo "  Instalando paquetes necesarios..."
      echo ""
      sudo apt-get -y update
      sudo apt -y install openjdk-11-jdk
      sudo apt -y install postgresql
      sudo systemctl enable postgresql --now

    # Clonar el repositorio
      echo ""
      echo "  Clonando el repositorio..."
      echo ""
      mkdir -p ~/repos
      # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install git
          echo ""
        fi
      cd ~/repos
      rm -rf ~/repos/armitage
      git clone https://github.com/r00t0v3rr1d3/armitage.git

    # Compilar
      echo ""
      echo "  Compilando..."
      echo ""
      sudo rm -rf /opt/armitage
      sudo mv armitage /opt/
      cd /opt/armitage
      ./package.sh

    # Comprimir
      echo ""
      echo "  Comprimiendo las releases..."
      echo ""

      echo ""
      echo "    Comprimiendo para GNU/Linux..."
      echo ""
      cd /opt/armitage/release/unix
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      rm -f /opt/armitage/release/unix/ArmitageLinux.tar.gz
      tar -czvf ArmitageLinux.tar.gz ./ 2> /dev/null

      echo ""
      echo "    Comprimiendo para Windows"
      echo ""
      cd /opt/armitage/release/windows
      # Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete zip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install zip
          echo ""
        fi
      rm -f /opt/armitage/release/windows/ArmitageWindows.zip
      zip -r ArmitageWindows.zip *

    # Crear el servidor web
      echo ""
      echo "  Creando el servidor web para que puedas descargar los archivos..."
      echo ""
      sudo mkdir /opt/armitage/web
      sudo rm -rf /opt/armitage/web/*
      sudo cp -vf /opt/armitage/release/unix/ArmitageLinux.tar.gz   /opt/armitage/web/
      sudo cp -vf /opt/armitage/release/windows/ArmitageWindows.zip /opt/armitage/web/
      cd /opt/armitage/web
      vHostIP=$(hostname -I | sed 's- --g')
      echo ""
      echo "    Para descargar los archivos comprimidos de armitage, conéctate al servidor web en la URL:"
      echo ""
      echo "      http://$vHostIP:8000"
      echo ""
      echo "    Recuerda iniciar el servidor msfrpcd para poder conectar armitage a Metasploit Framework:"
      echo ""
      echo "      msfrpcd -U msf -P P@ssw0rd"
      echo ""
      echo "      o, con SSL:"
      echo ""
      echo "      msfrpcd -U msf -P P@ssw0rd --ssl"
      echo ""
      python3 -m http.server

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  fi
