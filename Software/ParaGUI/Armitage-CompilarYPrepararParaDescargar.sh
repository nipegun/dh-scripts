#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para compilar Armitage en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-CompilarYPrepararParaDescargar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-CompilarYPrepararParaDescargar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-CompilarYPrepararParaDescargar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de compilación de Armitage para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de compilación de Armitage para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Ejecútalo en Debian 11. Se compilará y podrás descargarlo para otros Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de compilación de Armitage para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Instalar paquetes necesarios
      echo ""
      echo "  Instalando paquetes necesarios..."
      echo ""

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
      sudo apt-get -y update
      sudo apt -y install openjdk-11-jdk
      ./package.sh

    # Borrar archivos inútiles
      rm -f /opt/armitage/release/unix/build.txt
      rm -f /opt/armitage/release/unix/license.txt
      rm -f /opt/armitage/release/unix/whatsnew.txt
      rm -f /opt/armitage/release/windows/build.txt
      rm -f /opt/armitage/release/windows/license.txt
      rm -f /opt/armitage/release/windows/whatsnew.txt

    # Modificar archivos
      sed -i -e 's|#!/bin/sh|#!/bin/sh\ncd /opt/armitage/|g'                        /opt/armitage/release/unix/armitage
      sed -i -e 's|#!/bin/bash|#!/bin/bash\n\npkill -f msfrpcd\nsleep 5\n|g'        /opt/armitage/release/unix/teamserver
      sed -i -e 's|# start everything up|# start everything up\ncd /opt/armitage|g' /opt/armitage/release/unix/teamserver

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
      sudo rm -f /opt/armitage/release/unix/ArmitageLinux.tar.gz 2> /dev/null
      sudo tar -czvf ArmitageLinux.tar.gz .

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
      sudo rm -f /opt/armitage/release/windows/ArmitageWindows.zip 2> /dev/null
      sudo zip -r ArmitageWindows.zip *

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
      echo "      ...y te aparecerán en el navegador."
      echo ""
      echo "    Si quieres descargarlos desde la terminal, ejecuta:"
      echo ""
      echo "      En la CLI de bash en Linux:"
      echo ""
      echo "        curl -L http://$vHostIP:8000/ArmitageLinux.tar.gz -o ~/ArmitageLinux.tar.gz"
      echo ""
      echo "      En la CLI de Powershell en Windows:"
      echo ""
      echo "        Invoke-WebRequest -Uri "http://$vHostIP:8000/ArmitageWindows.zip" -OutFile "ArmitageWindows.zip""
      echo ""
      echo "    Si quieres instalarlo directamente en Debian, abre tu debian y ejecuta:"
      echo ""
      echo "      curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/Armitage-Instalar.sh | bash -s "'"'http://$vHostIP:8000/ArmitageLinux.tar.gz'"'""
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
