#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Spiderfoot en Debian
#
# Ejecución remota :
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ServWeb/Spiderfoot-Instalar.sh | bash (No debería ejecutarse con sudo. Aunque luego pida permisos sudo)
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ServWeb/Spiderfoot-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Clonar el repo
      mkdir -p ~/repos/python/
      cd ~/repos/python/
      # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update && sudo apt-get -y install git
          echo ""
        fi
      git clone https://github.com/smicallef/spiderfoot.git

    # Crear el virtual environment
      cd ~/repos/python/spiderfoot/
      # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update && sudo apt-get -y install python3-venv
          echo ""
        fi
      python3 -m venv venv
      # Crear el mensaje para mostrar cuando se entra al entorno virtual
        echo 'echo -e "\n  Activando el entorno virtual de Spiderfoot... \n"' >> ~/repos/python/spiderfoot/venv/bin/activate
      source ~/repos/python/spiderfoot/venv/bin/activate

      # Comprobar si el paquete python3-pip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s python3-pip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete python3-pip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update && sudo apt-get -y install python3-pip
          echo ""
        fi
      pip3 install -r requirements.txt

    # Desactivar el virtual environment
      deactivate

    # Crear el script de ejecución
      mkdir -p ~/scripts/
      echo '#!/bin/bash'                                                > ~/scripts/spiderfoot-iniciar.sh
      echo "source ~/repos/python/spiderfoot/venv/bin/activate"        >> ~/scripts/spiderfoot-iniciar.sh
      echo "python3 ~/repos/python/spiderfoot/sf.py -l 127.0.0.1:5001" >> ~/scripts/spiderfoot-iniciar.sh
      echo "deactivate"                                                >> ~/scripts/spiderfoot-iniciar.sh
      chmod +x                                                            ~/scripts/spiderfoot-iniciar.sh

    # Notificar fin de ejecución del script
      echo ""
      echo "  Ejecución del script, finalizada.  Para ejecutar spiderfoot:"
      echo ""
      echo "    ~/scripts/spiderfoot-iniciar.sh"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Spiderfoot para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

