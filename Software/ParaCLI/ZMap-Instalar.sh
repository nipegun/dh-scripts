#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar ZMap en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/ZMap-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/ZMap-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/ZMap-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/ZMap-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/ZMap-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    sudo apt -y update
    sudo apt -y install git
    sudo apt -y install build-essential
    sudo apt -y install cmake
    sudo apt -y install libgmp-dev
    sudo apt -y install gengetopt
    sudo apt -y install libpcap-dev
    sudo apt -y install flex
    sudo apt -y install bison
    sudo apt -y install libjudy-dev
    sudo apt -y install byacc
    sudo apt -y install libjson-c-dev
    sudo apt -y install libunistring-dev

    cd ~/
    rm -rf ~/
    git clone https://github.com/zmap/zmap.git
    cd zmap
    mkdir build
    cd build
    cmake ..
    make
    sudo make install

    echo ""
    echo "  Se han instalado los siguientes binarios:"
    echo ""
    echo "    /usr/local/sbin/zmap"
    echo "    /usr/local/sbin/zblocklist"
    echo "    /usr/local/sbin/ziterate"
    echo "    /usr/local/sbin/ztee"
    echo ""

    echo ""
    echo "  Para escanear, ejecuta:"
    echo ""
    echo "    sudo zmap -p 80 192.168.1.0/24"
    echo "    sudo zmap -p 80 192.168.1.0/24 -o results.txt"
    echo "    sudo zmap -p 22,80,443 -r 10000 192.168.1.0/24  # Escanear múltiples puertos y especificar el número de paquetes por segundo:"
    echo "    sudo zmap -p 80 192.168.1.0/24 -B 10M | sort -u # Filtrar y mostrar solo direcciones IP únicas"
    echo "    sudo zmap -p 80 192.168.1.0/24 -v 0             # Verbose 0, mostrar la menor información posible"
    echo ""

    echo ""
    echo "  Quitando las  IPs locales de la blocklist de /etc/zmap/blocklist.conf"
    echo ""
    sudo sed -i -e 's-10.0.0.0/8-#10.0.0.0/8-g'         /etc/zmap/blocklist.conf
    sudo sed -i -e 's-172.16.0.0/12-#172.16.0.0/12-g'   /etc/zmap/blocklist.conf
    sudo sed -i -e 's-192.168.0.0/16-#192.168.0.0/16-g' /etc/zmap/blocklist.conf


  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

