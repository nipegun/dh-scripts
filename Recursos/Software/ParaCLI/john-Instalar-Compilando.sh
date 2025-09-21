!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar john en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/john-Instalar-Compilando.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/john-Instalar-Compilando.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/john-Instalar-Compilando.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 13 (x)...${cFinColor}"
    echo ""

    vCarpetaDeUsuario="$HOME"

    # Instalar requisitos
      sudo apt -y update
      sudo apt -y install build-essential
      sudo apt -y install libssl-dev
      sudo apt -y install zlib1g-dev
      sudo apt -y install libbz2-dev
      sudo apt -y install libgmp-dev
      sudo apt -y install libpcap-dev
      sudo apt -y install yasm
      sudo apt -y install pkg-config
      sudo apt -y autoremove --purge john
    # Clonar el repo
      cd /tmp/
      sudo rm -rf /tmp/john/ 2> /dev/null
      git clone https://github.com/openwall/john.git
    # Compilar
      cd /tmp/john/src
      ./configure
      make -s clean
      make -sj$(nproc)
    # Mover a la carpeta de HackingTools
      vCarpetaDondeInstalar="$vCarpetaDeUsuario/HackingTools/john"
      mkdir -p $vCarpetaDondeInstalar 2> /dev/null
      cp -fv ../run/john                          $vCarpetaDondeInstalar/
      cp -fv ../run/john.conf                     $vCarpetaDondeInstalar/
      cp -fv ../run/rules-by-score.conf           $vCarpetaDondeInstalar/
      cp -fv ../run/rules-by-rate.conf            $vCarpetaDondeInstalar/
      mkdir -p $vCarpetaDondeInstalar/rules/ 2> /dev/null
      cp -fv ../run/rules/*   $vCarpetaDondeInstalar/rules/
      cp -fv ../run/unisubst.conf                 $vCarpetaDondeInstalar/
      cp -fv ../run/korelogic.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/hybrid.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/dumb16.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/dumb32.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/repeats16.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/repeats32.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/dynamic.conf                  $vCarpetaDondeInstalar/
      cp -fv ../run/dynamic_flat_sse_formats.conf $vCarpetaDondeInstalar/
      cp -fv ../run/regex_alphabets.conf          $vCarpetaDondeInstalar/
      #mkdir -p $vCarpetaDondeInstalar/lib/ 2> /dev/null
      #cp -fv ../run/lib/*   $vCarpetaDondeInstalar/lib/

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    vCarpetaDeUsuario="$HOME"

    # Instalar requisitos
      sudo apt -y update
      sudo apt -y install build-essential
      sudo apt -y install libssl-dev
      sudo apt -y install zlib1g-dev
      sudo apt -y install libbz2-dev
      sudo apt -y install libgmp-dev
      sudo apt -y install libpcap-dev
      sudo apt -y install yasm
      sudo apt -y install pkg-config
      sudo apt -y autoremove --purge john
    # Clonar el repo
      cd /tmp/
      sudo rm -rf /tmp/john/ 2> /dev/null
      git clone https://github.com/openwall/john.git
    # Compilar
      cd /tmp/john/src
      ./configure
      make -s clean
      make -sj$(nproc)
    # Mover a la carpeta de HackingTools
      vCarpetaDondeInstalar="$vCarpetaDeUsuario/HackingTools/john"
      mkdir -p $vCarpetaDondeInstalar 2> /dev/null
      cp -fv ../run/john                          $vCarpetaDondeInstalar/
      cp -fv ../run/john.conf                     $vCarpetaDondeInstalar/
      cp -fv ../run/rules-by-score.conf           $vCarpetaDondeInstalar/
      cp -fv ../run/rules-by-rate.conf            $vCarpetaDondeInstalar/
      mkdir -p $vCarpetaDondeInstalar/rules/ 2> /dev/null
      cp -fv ../run/rules/*   $vCarpetaDondeInstalar/rules/
      cp -fv ../run/unisubst.conf                 $vCarpetaDondeInstalar/
      cp -fv ../run/korelogic.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/hybrid.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/dumb16.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/dumb32.conf                   $vCarpetaDondeInstalar/
      cp -fv ../run/repeats16.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/repeats32.conf                $vCarpetaDondeInstalar/
      cp -fv ../run/dynamic.conf                  $vCarpetaDondeInstalar/
      cp -fv ../run/dynamic_flat_sse_formats.conf $vCarpetaDondeInstalar/
      cp -fv ../run/regex_alphabets.conf          $vCarpetaDondeInstalar/
      #mkdir -p $vCarpetaDondeInstalar/lib/ 2> /dev/null
      #cp -fv ../run/lib/*   $vCarpetaDondeInstalar/lib/

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de pdf2john para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

