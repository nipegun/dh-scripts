#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Armitage en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-Instalar.sh | bash -s IPDeDescarga
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-Instalar.sh | sed 's-sudo--g' | bash -s IPDeDescarga
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaGUI/Armitage-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantParamEsperados=2

# Comprobar que se hayan pasado la cantidad de parámetros correctos. Abortar el script si no.
  if [ $# -ne $cCantParamEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo "    $0 [Parámetro1] [Parámetro2]"
      echo ""
      echo "  Ejemplo:"
      echo "    $0 'Hola' 'Mundo'"
      echo ""
      exit
  fi

# Guardar el primer parámetro como URL
  vURLArchivo="$1"

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
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Descargar el archivo .tar.gz
      echo ""
      echo "    Descargando el archivo .tar.gz"
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      curl -L "$vURLArchivo" -o /tmp/armitage.tar.gz

    # Descomprimir arhivo
      echo ""
      echo "    Descomprimiendo archivo..."
      echo ""
      cd /tmp
      sudo rm -rf /tmp/armitage/*
      sudo rm -f /tmp/armitage
      mkdir /tmp/armitage/
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      tar -xvzf /tmp/armitage.tar.gz -C /tmp/armitage
      rm -f /tmp/armitage/ArmitageLinux.tar.gz 2> /dev/null

    # Instalar en la carpeta aconsejada
      echo ""
      echo "  Instalando en la carpeta aconsejada"
      echo ""
      sudo rm -rf /opt/armitage
      sudo mv /tmp/armitage/ /opt/
      sudo chown $USER:$USER /opt/armitage -R
      mv /opt/armitage/armitage /opt/armitage/armitage.sh

    # Crear el icono para lanzar la aplicación desde el menú gráfico
      echo ""
      echo "    Creando el lanzador gráfico..."
      echo ""
      mkdir -p ~/.local/share/applications
      echo '[Desktop Entry]'                      | sudo tee    ~/.local/share/applications/Armitage.desktop
      echo 'Name=Armitage'                        | sudo tee -a ~/.local/share/applications/Armitage.desktop
      echo 'Categories=Development'               | sudo tee -a ~/.local/share/applications/Armitage.desktop
      echo "Exec=/opt/armitage/armitage.sh"       | sudo tee -a ~/.local/share/applications/Armitage.desktop
      echo "Icon=/opt/armitage/armitage-logo.png" | sudo tee -a ~/.local/share/applications/Armitage.desktop
      echo 'Type=Application'                     | sudo tee -a ~/.local/share/applications/Armitage.desktop
      echo 'Terminal=false'                       | sudo tee -a ~/.local/share/applications/Armitage.desktop
      sudo chown $USER:$USER ~/.local/share/applications/Armitage.desktop

    # Modificar las variables de entorno
      # Determinar si la base de datos de metasploit existe
        if [ -f $HOME/.msf4/database.yml ]; then
          echo "  El archivo de base de datos de Metasplot Framework existe."
          echo "  Agregándolo como variable de entorno al script..."
          sudo sed -i -e "s|cd /opt/armitage/|cd /opt/armitage/\nexport MSF_DATABASE_CONFIG=$HOME/.msf4/database.yml|g" /opt/armitage/armitage
        else
          echo "  El archivo de base de datos de Metasplot Framework no existe."
          echo "  No se agregará una variable de entorno al script."
        fi

    # Notificar fin de ejecución del script
      echo ""
      echo "  El script de instalación de armitage ha finalizado."
      echo ""
      echo "    Para iniciar el servidor msfrpcd desde bash (siempre que metasploit esté instalado):"
      echo ""
      echo "      msfrpcd -U msf -P P@ssw0rd -f -S -a 127.0.0.1 &"
      echo ""
      echo "      Luego lanza la aplicación gráfica de Armitage y conectate al servidor local:"
      echo ""
      echo "    También puedes iniciar el servidor rpc desde la propia consola de metasploit:"
      echo ""
      echo "      msfconsole"
      echo ""
      echo "        load msgrpc Pass=P@ssw0rd"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Armitage para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
