#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Ciphey en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/Ciphey-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/Ciphey-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca como quieres instalar la herramienta:" 22 70 16)
        opciones=(
          1 "Clonar el repo de Ciphey"                                           on
          2 "  Crear el entorno virtual de python e instalar dentro"             on
          3 "    Compilar e instalar en /home/$USER/bin/ (Todavía no funcional)" off
          4 "  Instalar en /home/$USER/.local/bin/"                              off
          5 "    Agregar /home/$USER/.local/bin/ al path"                        off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema"    off
          7 "Instalar a nivel de sistema"                                        off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo..."
              echo ""

              # Clonar el repo
                mkdir -p ~/repos/python/
                cd ~/repos/python/
                rm -rf ~/repos/python/Ciphey/
                # Comprobar si el paquete git está instalado. Si no lo está,#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Ciphey en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca como quieres instalar la herramienta:" 22 70 16)
        opciones=(
          1 "Clonar el repo de Ciphey"                                           on
          2 "  Crear el entorno virtual de python e instalar dentro"             on
          3 "    Compilar e instalar en /home/$USER/bin/ (Todavía no funcional)" off
          4 "  Instalar en /home/$USER/.local/bin/"                              off
          5 "    Agregar /home/$USER/.local/bin/ al path"                        off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema"    off
          7 "Instalar a nivel de sistema"                                        off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo..."
              echo ""

              # Clonar el repo
                mkdir -p ~/repos/python/
                cd ~/repos/python/
                rm -rf ~/repos/python/Ciphey/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/bee-san/Ciphey.git

            ;;

            2)

              echo ""
              echo "    Creando el entorno virtual de python e instalando dentro..."
              echo ""

              cd ~/repos/python/Ciphey/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
              python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo 'echo -e "\n  Activando el entorno virtual de Ciphey... \n"' >> ~/repos/python/Ciphey/venv/bin/activate
              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  pip3 install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
              # Instalar Ciphey
                pip3 install .
              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. Ciphey se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/Ciphey/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "      Compilando y guardando en /home/$USER/bin/..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install python3-pip
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-wheel
              sudo apt-get -y install python3-setuptools

              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
                cd ~/repos/python/Ciphey/

              # Instalar el instalador
                python3 -m pip install pyinstaller

              # Compilar
               #pyinstaller --onefile --name ciphey --collect-all=ciphey ciphey/__main__.py
               #pyinstaller --onefile --name ciphey --collect-all ciphey -m ciphey
               pyinstaller --onefile --name ciphey --collect-all ciphey ciphey

              # Copiar el binario a /usr/bin
                mkdir ~/bin/
                cp -fv ~/repos/python/Ciphey/dist/ciphey ~/bin/

              # Desactivar el entorno virtual
                deactivate

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. Ciphey se ha descargado, compilado e instalado."
                echo ""
                echo "    Puedes encontrar el binario en ~/bin/ciphey"
                echo ""

            ;;

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/Ciphey/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar Ciphey instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Instalar paquetes necesarios
                echo ""
                echo "    Instalando paquetes necesarios..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-setuptools
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-venv
                sudo apt-get -y install build-essential
                sudo apt-get -y install liblzma-dev

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                cd /tmp/PythonVirtualEnvironments/
                rm -rf /tmp/PythonVirtualEnvironments/Ciphey/
                python3 -m venv Ciphey

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/Ciphey/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/Ciphey/
                git clone https://github.com/rowingdude/Ciphey.git#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Ciphey en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca como quieres instalar la herramienta:" 22 70 16)
        opciones=(
          1 "Clonar el repo de Ciphey"                                           on
          2 "  Crear el entorno virtual de python e instalar dentro"             on
          3 "    Compilar e instalar en /home/$USER/bin/ (Todavía no funcional)" off
          4 "  Instalar en /home/$USER/.local/bin/"                              off
          5 "    Agregar /home/$USER/.local/bin/ al path"                        off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema"    off
          7 "Instalar a nivel de sistema"                                        off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo..."
              echo ""

              # Clonar el repo
                mkdir -p ~/repos/python/
                cd ~/repos/python/
                rm -rf ~/repos/python/Ciphey/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/bee-san/Ciphey.git

            ;;

            2)

              echo ""
              echo "    Creando el entorno virtual de python e instalando dentro..."
              echo ""

              cd ~/repos/python/Ciphey/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
              python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo 'echo -e "\n  Activando el entorno virtual de Ciphey... \n"' >> ~/repos/python/Ciphey/venv/bin/activate
              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  pip3 install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
              # Instalar Ciphey
                pip3 install .
              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. Ciphey se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/Ciphey/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "      Compilando y guardando en /home/$USER/bin/..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install python3-pip
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-wheel
              sudo apt-get -y install python3-setuptools

              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
                cd ~/repos/python/Ciphey/

              # Instalar el instalador
                python3 -m pip install pyinstaller

              # Compilar
               #pyinstaller --onefile --name ciphey --collect-all=ciphey ciphey/__main__.py
               #pyinstaller --onefile --name ciphey --collect-all ciphey -m ciphey
               pyinstaller --onefile --name ciphey --collect-all ciphey ciphey

              # Copiar el binario a /usr/bin
                mkdir ~/bin/
                cp -fv ~/repos/python/Ciphey/dist/ciphey ~/bin/

              # Desactivar el entorno virtual
                deactivate

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. Ciphey se ha descargado, compilado e instalado."
                echo ""
                echo "    Puedes encontrar el binario en ~/bin/ciphey"
                echo ""

            ;;

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/Ciphey/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar Ciphey instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Instalar paquetes necesarios
                echo ""
                echo "    Instalando paquetes necesarios..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-setuptools
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-venv
                sudo apt-get -y install build-essential
                sudo apt-get -y install liblzma-dev

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                cd /tmp/PythonVirtualEnvironments/
                rm -rf /tmp/PythonVirtualEnvironments/Ciphey/
                python3 -m venv Ciphey

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/Ciphey/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/Ciphey/
                git clone https://github.com/rowingdude/Ciphey.git
                mv Ciphey code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                cd code
                python3 -m pip install -r requirements.txt
                python3 -m pip install -r requirements-dev.txt
                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=Ciphey Ciphey.py

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/Ciphey
                sudo cp -vf /tmp/PythonVirtualEnvironments/Ciphey/code/dist/Ciphey /usr/bin/Ciphey
                cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "  Instalando a nivel de sistema (Pruebas)..."
              echo ""

              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  python3 -m pip install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl

sudo apt install build-essential python3-dev cython3

python3 -m pip install appdirs base58 base91 cipheydists click flake8 loguru mock pybase62 pylint pywhat --break-system-packages
python3 -m pip install ciphey --no-deps --break-system-packages


            ;;


        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
                mv Ciphey code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                cd code
                python3 -m pip install -r requirements.txt
                python3 -m pip install -r requirements-dev.txt
                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=Ciphey Ciphey.py

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/Ciphey
                sudo cp -vf /tmp/PythonVirtualEnvironments/Ciphey/code/dist/Ciphey /usr/bin/Ciphey
                cd ~#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Ciphey en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/Ciphey-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca como quieres instalar la herramienta:" 22 70 16)
        opciones=(
          1 "Clonar el repo de Ciphey"                                           on
          2 "  Crear el entorno virtual de python e instalar dentro"             on
          3 "    Compilar e instalar en /home/$USER/bin/ (Todavía no funcional)" off
          4 "  Instalar en /home/$USER/.local/bin/"                              off
          5 "    Agregar /home/$USER/.local/bin/ al path"                        off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema"    off
          7 "Instalar a nivel de sistema"                                        off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo..."
              echo ""

              # Clonar el repo
                mkdir -p ~/repos/python/
                cd ~/repos/python/
                rm -rf ~/repos/python/Ciphey/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/bee-san/Ciphey.git

            ;;

            2)

              echo ""
              echo "    Creando el entorno virtual de python e instalando dentro..."
              echo ""

              cd ~/repos/python/Ciphey/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
              python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo 'echo -e "\n  Activando el entorno virtual de Ciphey... \n"' >> ~/repos/python/Ciphey/venv/bin/activate
              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  pip3 install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
              # Instalar Ciphey
                pip3 install .
              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. Ciphey se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/Ciphey/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "      Compilando y guardando en /home/$USER/bin/..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install python3-pip
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-wheel
              sudo apt-get -y install python3-setuptools

              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
                cd ~/repos/python/Ciphey/

              # Instalar el instalador
                python3 -m pip install pyinstaller

              # Compilar
               #pyinstaller --onefile --name ciphey --collect-all=ciphey ciphey/__main__.py
               #pyinstaller --onefile --name ciphey --collect-all ciphey -m ciphey
               pyinstaller --onefile --name ciphey --collect-all ciphey ciphey

              # Copiar el binario a /usr/bin
                mkdir ~/bin/
                cp -fv ~/repos/python/Ciphey/dist/ciphey ~/bin/

              # Desactivar el entorno virtual
                deactivate

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. Ciphey se ha descargado, compilado e instalado."
                echo ""
                echo "    Puedes encontrar el binario en ~/bin/ciphey"
                echo ""

            ;;

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/Ciphey/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar Ciphey instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Instalar paquetes necesarios
                echo ""
                echo "    Instalando paquetes necesarios..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-setuptools
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-venv
                sudo apt-get -y install build-essential
                sudo apt-get -y install liblzma-dev

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                cd /tmp/PythonVirtualEnvironments/
                rm -rf /tmp/PythonVirtualEnvironments/Ciphey/
                python3 -m venv Ciphey

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/Ciphey/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/Ciphey/
                git clone https://github.com/rowingdude/Ciphey.git
                mv Ciphey code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                cd code
                python3 -m pip install -r requirements.txt
                python3 -m pip install -r requirements-dev.txt
                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=Ciphey Ciphey.py

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/Ciphey
                sudo cp -vf /tmp/PythonVirtualEnvironments/Ciphey/code/dist/Ciphey /usr/bin/Ciphey
                cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "  Instalando a nivel de sistema (Pruebas)..."
              echo ""

              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  python3 -m pip install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl

sudo apt install build-essential python3-dev cython3

python3 -m pip install appdirs base58 base91 cipheydists click flake8 loguru mock pybase62 pylint pywhat --break-system-packages
python3 -m pip install ciphey --no-deps --break-system-packages


            ;;


        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "  Instalando a nivel de sistema (Pruebas)..."
              echo ""

              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  python3 -m pip install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl

sudo apt install build-essential python3-dev cython3

python3 -m pip install appdirs base58 base91 cipheydists click flake8 loguru mock pybase62 pylint pywhat --break-system-packages
python3 -m pip install ciphey --no-deps --break-system-packages


            ;;


        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/bee-san/Ciphey.git

            ;;

            2)

              echo ""
              echo "    Creando el entorno virtual de python e instalando dentro..."
              echo ""

              cd ~/repos/python/Ciphey/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
              python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo 'echo -e "\n  Activando el entorno virtual de Ciphey... \n"' >> ~/repos/python/Ciphey/venv/bin/activate
              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  pip3 install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
              # Instalar Ciphey
                pip3 install .
              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. Ciphey se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/Ciphey/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "      Compilando y guardando en /home/$USER/bin/..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install python3-pip
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-wheel
              sudo apt-get -y install python3-setuptools

              # Entrar al entorno virtual
                source ~/repos/python/Ciphey/venv/bin/activate
                cd ~/repos/python/Ciphey/

              # Instalar el instalador
                python3 -m pip install pyinstaller

              # Compilar
               #pyinstaller --onefile --name ciphey --collect-all=ciphey ciphey/__main__.py
               #pyinstaller --onefile --name ciphey --collect-all ciphey -m ciphey
               pyinstaller --onefile --name ciphey --collect-all ciphey ciphey

              # Copiar el binario a /usr/bin
                mkdir ~/bin/
                cp -fv ~/repos/python/Ciphey/dist/ciphey ~/bin/

              # Desactivar el entorno virtual
                deactivate

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. Ciphey se ha descargado, compilado e instalado."
                echo ""
                echo "    Puedes encontrar el binario en ~/bin/ciphey"
                echo ""

            ;;

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/Ciphey/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar Ciphey instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        Ciphey [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Instalar paquetes necesarios
                echo ""
                echo "    Instalando paquetes necesarios..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-setuptools
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-venv
                sudo apt-get -y install build-essential
                sudo apt-get -y install liblzma-dev

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                cd /tmp/PythonVirtualEnvironments/
                rm -rf /tmp/PythonVirtualEnvironments/Ciphey/
                python3 -m venv Ciphey

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/Ciphey/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/Ciphey/
                git clone https://github.com/rowingdude/Ciphey.git
                mv Ciphey code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                cd code
                python3 -m pip install -r requirements.txt
                python3 -m pip install -r requirements-dev.txt
                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=Ciphey Ciphey.py

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/Ciphey
                sudo cp -vf /tmp/PythonVirtualEnvironments/Ciphey/code/dist/Ciphey /usr/bin/Ciphey
                cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Ciphey [Parámetros]${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "  Instalando a nivel de sistema (Pruebas)..."
              echo ""

              # Descargar e instalar CipheyCore
                # Determinar cual es la versión más reciente de CipheyCore
                  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install curl
                      echo ""
                    fi
                  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install jq
                      echo ""
                    fi
                    vUltVersCipheyCore=$(curl -sL https://api.github.com/repos/liudonghua123/CipheyCore/releases/latest | jq -r '.tag_name')
                    echo ""
                    echo "      El número de la última versión de CipheyCore es $vUltVersCipheyCore"
                    echo ""
                # Descargar  CipheyCore
                  curl -L https://github.com/liudonghua123/CipheyCore/releases/download/"$vUltVersCipheyCore"/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl  -o /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl
                # Instalar CipheyCore
                  python3 -m pip install /tmp/cipheycore-"$vUltVersCipheyCore"-cp311-cp311-manylinux_2_31_x86_64.whl

sudo apt install build-essential python3-dev cython3

python3 -m pip install appdirs base58 base91 cipheydists click flake8 loguru mock pybase62 pylint pywhat --break-system-packages
python3 -m pip install ciphey --no-deps --break-system-packages


            ;;


        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Ciphey para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
