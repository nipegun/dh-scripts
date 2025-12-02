#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Social Engineering Toolkit en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/SocialEngineerToolkit-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/SocialEngineerToolkit-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/SocialEngineerToolkit-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/SocialEngineerToolkit-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/SocialEngineerToolkit-Instalar.shx | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar dependencias del sistema
      sudo apt-get -y update
      sudo apt-get -y install build-essential
      sudo apt-get -y install python3-venv
      sudo apt-get -y install python3-dev
      sudo apt-get -y install curl
      sudo apt-get -y install wget
      sudo apt-get -y install gnupg2

    # Instalar metasploit
      # Descargar el script de instalación
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -o /tmp/msfinstall
      # Hacer el script ejecutable
        chmod +x /tmp/msfinstall
      # Instalar
        sudo apt-get -y update
        sudo /tmp/msfinstall
      # Crear la base de datos
        msfdb init

    # Descargar el repositorio
      mkdir $HOME/Git/ 2> /dev/null
      cd $HOME/Git/
      rm -rf $HOME/Git/social-engineer-toolkit/
      git clone --depth 1 https://github.com/trustedsec/social-engineer-toolkit.git

    # Crear la carpeta en home y copiar dentro
      mkdir $HOME/HackingTools/ 2> /dev/null
      rm -rf $HOME/HackingTools/SocialEngineerToolkit/
      cp -rv $HOME/Git/social-engineer-toolkit/ $HOME/HackingTools/
      mv $HOME/HackingTools/social-engineer-toolkit/ $HOME/HackingTools/SocialEngineerToolkit/

    # Crear el entorno virtual
      cd $HOME/HackingTools/SocialEngineerToolkit/
      python3 -m venv venv

    # Borrar carpetas de instalaciones anteriores
      rm -rf /usr/local/share/setoolkit/
      rm -rf /etc/setoolkit/

    # Entrar al entorno virtual e instalar dependencias
      source $HOME/HackingTools/SocialEngineerToolkit/venv/bin/activate
      pip install -r requirements.txt
      python3 setup.py

    # Notificar fin de ejecución del script
      echo ""
      echo "  Script de instalación de SocialEngineerToolkit, finalizado."
      echo ""
      echo "    Para lanzar SET, ejecuta:"
      echo ""
      echo "      setoolkit"
      echo ""
      #/etc/setoolkit/set.config

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar dependencias del sistema
      sudo apt-get -y update
      sudo apt-get -y install build-essential
      sudo apt-get -y install python3-venv
      sudo apt-get -y install python3-dev
      sudo apt-get -y install curl
      sudo apt-get -y install wget
      sudo apt-get -y install gnupg2

    # Instalar metasploit
      # Descargar el script de instalación
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -o /tmp/msfinstall
      # Hacer el script ejecutable
        chmod +x /tmp/msfinstall
      # Instalar
        sudo apt-get -y update
        sudo /tmp/msfinstall
      # Crear la base de datos
        msfdb init

    # Descargar el repositorio
      mkdir $HOME/Git/ 2> /dev/null
      cd $HOME/Git/
      rm -rf $HOME/Git/social-engineer-toolkit/
      git clone --depth 1 https://github.com/trustedsec/social-engineer-toolkit.git

    # Crear la carpeta en home y copiar dentro
      mkdir $HOME/HackingTools/ 2> /dev/null
      rm -rf $HOME/HackingTools/SocialEngineerToolkit/
      cp -rv $HOME/Git/social-engineer-toolkit/ $HOME/HackingTools/
      mv $HOME/HackingTools/social-engineer-toolkit/ $HOME/HackingTools/SocialEngineerToolkit/

    # Crear el entorno virtual
      cd $HOME/HackingTools/SocialEngineerToolkit/
      python3 -m venv venv

    # Borrar carpetas de instalaciones anteriores
      rm -rf /usr/local/share/setoolkit/
      rm -rf /etc/setoolkit/

    # Entrar al entorno virtual e instalar dependencias
      source $HOME/HackingTools/SocialEngineerToolkit/venv/bin/activate
      pip install -r requirements.txt
      python3 setup.py

    # Notificar fin de ejecución del script
      echo ""
      echo "  Script de instalación de SocialEngineerToolkit, finalizado."
      echo ""
      echo "    Para lanzar SET, ejecuta:"
      echo ""
      echo "      setoolkit"
      echo ""
      #/etc/setoolkit/set.config

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Social Engineering Toolkit para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
