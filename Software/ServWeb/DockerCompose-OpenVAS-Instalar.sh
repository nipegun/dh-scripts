#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar OpenVAS en modo Docker en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/DockerCompose-OpenVAS-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/DockerCompose-OpenVAS-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/DockerCompose-OpenVAS-Instalar.sh | nano -
#
# Más info: https://greenbone.github.io/docs/latest/
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo "  Desinstalando paquetes conflictivos:"
    echo ""
    for vPaquete in docker.io docker-doc docker-compose podman-docker containerd runc;
      do
        sudo apt -y remove $vPaquete
      done

    echo ""
    echo "  Instalando paquetes necesarios..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install wget
    sudo apt-get -y install apt-transport-https
    sudo apt-get -y install ca-certificates
    sudo apt-get -y install curl
    sudo apt-get -y install gnupg2
    sudo apt-get -y install software-properties-common

    echo ""
    echo "  Descargando la clave PGP del KeyRing..."
    echo ""
    wget -O- https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo ""
    echo "  Agregando el repositorio..."
    echo ""
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get -y update

    echo ""
    echo "  Instalando docker-ce..."
    echo ""
    sudo apt-get -y install docker-ce
    sudo apt-get -y install docker-ce-cli
    sudo apt-get -y install containerd.io
    sudo apt-get -y install docker-compose-plugin

    echo ""
    echo "  Creando el usuario OpenVAS..."
    echo ""
    echo -e "openvas:openvas" | sudo adduser openvas

    echo ""
    echo "  Creando la carpeta..."
    echo ""
    sudo mkdir -p /opt/greenbone

    echo ""
    echo "  Descargando el docker compose..."
    echo ""
    cd /opt/greenbone
    sudo curl -f -O -L https://greenbone.github.io/docs/latest/_static/docker-compose.yml --output-dir /opt/greenbone
    sudo chown openvas:openvas /opt/greenbone -R

    echo ""
    echo "  Permitiendo al usuario usar docker..."
    echo ""
    sudo usermod -aG docker openvas

    echo ""
    echo "  Lanzando el stack..."
    echo ""
    sudo su openvas -c "docker compose -f /opt/greenbone/docker-compose.yml up -d"

    #echo ""
    #echo "  Cambiando el password del admin..."
    #echo ""
    #sudo su openvas -c "docker compose -f /opt/greenbone/docker-compose.yml exec -u gvmd gvmd gvmd --user=admin --new-password='<password>'"

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en modo Docker para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
