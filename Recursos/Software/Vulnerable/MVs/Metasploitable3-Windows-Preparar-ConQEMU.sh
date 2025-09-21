#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar la máquina de Metasploitable3-Windows usando QEMU en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/MV/Metasploitable3-Windows-Preparar-ConQEMU.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/MV/Metasploitable3-Windows-Preparar-ConQEMU.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/MV/Metasploitable3-Windows-Preparar-ConQEMU.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar dependencias
      sudo apt -y update
      sudo apt -y install git
      sudo apt -y install curl
      sudo apt -y install unzip
      sudo apt -y install vagrant
      sudo apt -y install packer
      sudo apt -y install vagrant-libvirt
      sudo apt -y install libvirt0

    # Clonar el repositorio oficial
      cd $HOME
      rm -rf $HOME/metasploitable3
      echo ""
      echo "    Clonando el repositorio de metasploitable3..."
      echo ""
      git clone https://github.com/rapid7/metasploitable3.git

    # Motificar el script oficial para forzar QEMU
      cd metasploitable3
      sed -i -e 's-providers=""-providers="qemu"-g' build.sh
      sed -i 's/providers="qemu \$providers"/providers="qemu"/' build.sh

    # Modificar el script para indicar una nueva URL con la ISO de Windows Server
      vURL="https://dn720502.ca.archive.org/0/items/Windows_Server_2008_R2_x64.iso_reupload/Windows_Server_2008_R2_x64.iso"
      vNombreISO="windows2008.iso"
      vDirISO="$HOME/metasploitable3/iso"
      vArchivoJSON="$HOME/metasploitable3/packer/templates/windows_2008_r2.json"
      # Crear el directorio iso si no existe
        mkdir -p "$vDirISO"
      # Descargar ISO con curl -L
        curl -L "$vURL" -o "$vDirISO/$vNombreISO"
      # Calcular el hash MD5
        vMD5=$(md5sum "$vDirISO/$vNombreISO" | awk '{print $1}')
      # Modificar el JSON con nueva ruta y hash
        sed -i "s|\"iso_url\": \".*\"|\"iso_url\": \"iso/$vNombreISO\"|g" "$vArchivoJSON"
        sed -i "s|\"iso_checksum\": \".*\"|\"iso_checksum\": \"md5:$vMD5\"|g" "$vArchivoJSON"

    # Construir
      echo ""
      echo "    Construyendo la máquina virtual. No interactúes con ella hasta que termine. Deja que vagrant la controle..."
      echo ""
      # vagrant destroy -f
      ./build.sh windows2008

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de preparación de la máquina de metasploitable3-Windows usando QEMU en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
