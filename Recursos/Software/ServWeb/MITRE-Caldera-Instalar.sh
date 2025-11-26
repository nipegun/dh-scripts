#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Caldera en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/MITRE-Caldera-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/MITRE-Caldera-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/MITRE-Caldera-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 13 (Trixie)...${cFinColor}"
    echo ""

    # Definir la versión máxima de python que soporta caldera
      vVerMaxPython='3.11'

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados porque Caldera soporta, como máximo, Python $vVerMaxPython .${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios de Debian
      sudo apt-get -y update
      sudo apt-get -y install git
      sudo apt-get -y install libxml2-dev
      sudo apt-get -y install libxslt1-dev
      sudo apt-get -y install zlib1g-dev
      sudo apt-get -y install build-essential
      sudo apt-get -y install python3-dev
      sudo apt-get -y install npm
      # Instalar NodeJS 22
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get -y install nodejs
        # Para evitar módulos instalados con Node 18
          rm -rf plugins/magma/node_modules
      # Instalar Go
        sudo apt-get -y install golang
      # Descargar e instalar UPX
        cd /usr/local/bin
        wget https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-amd64_linux.tar.xz
        tar xf upx-4.2.4-amd64_linux.tar.xz
        mv upx-4.2.4-amd64_linux/upx .
        rm -r upx-4.2.4-amd64_linux*
        chmod +x upx
      # Donut
        #cd /opt
        #git clone https://github.com/TheWover/donut
        #cd donut
        #make
        #cp donut /usr/local/bin/
        #chmod +x /usr/local/bin/donut

    # Crear la carpeta HackingTools
      echo ""
      echo "    Creando la carpeta HackingTools..."
      echo ""
      cd ~
      mkdir -p $HOME/HackingTools/ 2> /dev//null
      rm -rf $HOME/HackingTools/Caldera/ 2> /dev/null

    # Clonar el repositorio de caldera
      echo ""
      echo "    Clonando el repositorio de caldera..."
      echo ""
      # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install git
          echo ""
        fi
      cd $HOME/HackingTools/
      git clone https://github.com/mitre/caldera.git --recursive
      mv caldera Caldera

    # Crear el entorno virtual de python
      echo ""
      echo "    Creando el entorno virtual de python..."
      echo ""
      # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install python3-venv
          echo ""
        fi
      cd $HOME/HackingTools/Caldera/
      python3 -m venv venv

    # Activar el entorno virtual e instalar dentro
      source $HOME/HackingTools/Caldera/venv/bin/activate

      # Instalar requerimientos
        pip install -r requirements.txt
        pip install docker
        pip install donut-shellcode
        #pip install sphinx
        #pip install sphinx-rtd-theme

      # Desinstalar paquetes innecesarios
        sudo apt-get -y autoremove
        sudo apt-get -y autoclean

      # Notificar fin de ejecución del script
        vDirIPLocal=$(hostname -I | cut -d' ' -f1)
        echo ""
        echo "    La instalación de caldera ha concluido. Se procederá a lanzar el servidor."
        echo "    Una vez que el servidor esté en ejecución, conéctate a la web de administración en:"
        echo ""
        echo "      http://localhost:8888"
        echo ""
        echo "        o"
        echo ""
        echo "      http://$vDirIPLocal:8888"
        echo ""
        echo "        Las credenciales por defecto son:"
        echo ""
        echo "          admin:admin"
        echo "          red:admin"
        echo "          blue:admin"
        echo ""

      # Lanzar servidor
        cd $HOME/HackingTools/Caldera/
        python3 server.py --insecure --build

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Caldera para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
