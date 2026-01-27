#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Volatility2 en Debian
#
# Ejecución remota  (No debería pipearse con sudo, aunque luego pida permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/Software/ParaCLI/Volatility2-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/Software/ParaCLI/Volatility2-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 13 (x)...${cFinColor}"
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
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Clonar el repo de volatility2 para python 2.x"          on
          2 "  Crear el entorno virtual de python e instalar dentro" on
          3 "    Compilar y guardar en /home/$USER/bin/"             off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo de volatility2 para python 2.x..."
              echo ""

              mkdir -p $HOME/HackingTools/Forensics/ 2> /dev/null
              cd $HOME/HackingTools/Forensics/
              rm -rf $HOME/HackingTools/Forensics/volatility/ 2> /dev/null
              rm -rf $HOME/HackingTools/Forensics/volatility2/ 2> /dev/null
              # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install git
                  echo ""
                fi
              git clone --depth=1 https://github.com/volatilityfoundation/volatility.git
              mv $HOME/HackingTools/Forensics/volatility/ $HOME/HackingTools/Forensics/volatility2/

            ;;

            2)

              echo ""
              echo "  Creando el entorno virtual de python e instalando dentro..."
              echo ""

              # Comprobar si python 2.7 está instalado y, si no lo está, instalarlo
                if [ ! -f /opt/python2/bin/python2.7 ]; then
                  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install git
                      echo ""
                    fi
                  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python2-Instalar.sh | sed 's/--enable-optimizations/--without-ssl/g' | sudo bash
                fi
              cd $HOME/HackingTools/Forensics/volatility2/
              # Eliminar el virtualenv actualmente instalado
                sudo apt-get -y autoremove virtualenv
              # Instalar el virtualenv de python2
                curl -L https://bootstrap.pypa.io/pip/2.7/get-pip.py | sudo /opt/python2/bin/python2.7
                sudo /opt/python2/bin/python2.7 -m pip install virtualenv
              # Crear el entorno virtual
                /opt/python2/bin/virtualenv -p /opt/python2/bin/python2.7 venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo ''                                                                                                                                 >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "\n  Activando el entorno virtual de Volatility2... \n"'                                                                  >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "    Forma de uso:\n"'                                                                                                    >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      $HOME/HackingTools/Forensics/volatility2/vol.py -f [RutaAlArchivoDeDump] [Plugin]\n"'                              >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "    Comandos rápidos:\n"'                                                                                                >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      Obtener info de la imagen:\n"'                                                                                     >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "        $HOME/HackingTools/Forensics/volatility2/vol.py -f $HOME/Descargas/Evidencia.raw imageinfo\n"'                   >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      Aplicar un perfil y un plugin:\n"'                                                                                 >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "        $HOME/HackingTools/Forensics/volatility2/vol.py -f $HOME/Descargas/Evidencia.raw --profile=Win7SP1x86 pslist\n"' >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate

              # Entrar al entorno virtual
                source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate

              # Instalar dependencias
                pip2 install -U wheel
                pip2 install -U setuptools
                pip2 install -U distorm3
                pip2 install -U pycrypto
                pip2 install -U pillow
                pip2 install -U openpyxl
                pip2 install -U ujson
                pip2 install -U pytz
                pip2 install -U ipython
                pip2 install -U capstone
                pip2 install -U yara-python
                cd $HOME/HackingTools/Forensics/volatility2/
                pip2 install .
                #sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
                #sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/local/lib/libyara.so

              # Desactivar el entorno virtual
                deactivate

              # Asignar permisos de ejecucción
                find $HOME/HackingTools/Forensics/volatility2/ -type f -name "*.py" -exec chmod +x {} \;

              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. volatility2 se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        $HOME/HackingTools/Forensics/volatility2/vol.py [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "  Compilando y guardando en /home/$USER/bin/..."
              echo ""

              # Entrar en el entorno virtual
                source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                cd $HOME/HackingTools/Forensics/volatility2/

              # Compilar
                pip2 install -U pyinstaller==3.6
                pyinstaller --onefile vol.py

             # Desactivar el entorno virtual
                deactivate

              # Mover el binario a la carpeta de binarios del usuario
                mkdir -p $HOME/bin/
                cp $HOME/HackingTools/Forensics/volatility2/dist/vol      $HOME/bin/volatility2

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    El script compilado se ha copiado a:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      $HOME/bin/volatility2${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      El binario debe ser ejecutado con precaución. Es mejor correr el script dentro del entorno virtual:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}          vol.py [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        deactivate${cFinColor}"
                echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 12 (Bookworm)...${cFinColor}"
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
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Clonar el repo de volatility2 para python 2.x"          on
          2 "  Crear el entorno virtual de python e instalar dentro" on
          3 "    Compilar y guardar en /home/$USER/bin/"             off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo de volatility2 para python 2.x..."
              echo ""

              mkdir -p $HOME/HackingTools/Forensics/ 2> /dev/null
              cd $HOME/HackingTools/Forensics/
              rm -rf $HOME/HackingTools/Forensics/volatility/ 2> /dev/null
              rm -rf $HOME/HackingTools/Forensics/volatility2/ 2> /dev/null
              # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install git
                  echo ""
                fi
              git clone --depth=1 https://github.com/volatilityfoundation/volatility.git
              mv $HOME/HackingTools/Forensics/volatility/ $HOME/HackingTools/Forensics/volatility2/

            ;;

            2)

              echo ""
              echo "  Creando el entorno virtual de python e instalando dentro..."
              echo ""

              # Comprobar si python 2.7 está instalado y, si no lo está, instalarlo
                if [ ! -f /opt/python2/bin/python2.7 ]; then
                  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                    if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                      echo ""
                      echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                      echo ""
                      sudo apt-get -y update
                      sudo apt-get -y install git
                      echo ""
                    fi
                  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python2-Instalar.sh | sed 's/--enable-optimizations/--without-ssl/g' | sudo bash
                fi
              cd $HOME/HackingTools/Forensics/volatility2/
              # Eliminar el virtualenv actualmente instalado
                sudo apt-get -y autoremove virtualenv
              # Instalar el virtualenv de python2
                curl -L https://bootstrap.pypa.io/pip/2.7/get-pip.py | sudo /opt/python2/bin/python2.7
                sudo /opt/python2/bin/python2.7 -m pip install virtualenv
              # Crear el entorno virtual
                /opt/python2/bin/virtualenv -p /opt/python2/bin/python2.7 venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo ''                                                                                                                                 >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "\n  Activando el entorno virtual de Volatility2... \n"'                                                                  >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "    Forma de uso:\n"'                                                                                                    >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      $HOME/HackingTools/Forensics/volatility2/vol.py -f [RutaAlArchivoDeDump] [Plugin]\n"'                              >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "    Comandos rápidos:\n"'                                                                                                >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      Obtener info de la imagen:\n"'                                                                                     >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "        $HOME/HackingTools/Forensics/volatility2/vol.py -f $HOME/Descargas/Evidencia.raw imageinfo\n"'                   >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "      Aplicar un perfil y un plugin:\n"'                                                                                 >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                echo 'echo -e "        $HOME/HackingTools/Forensics/volatility2/vol.py -f $HOME/Descargas/Evidencia.raw --profile=Win7SP1x86 pslist\n"' >> $HOME/HackingTools/Forensics/volatility2/venv/bin/activate

              # Entrar al entorno virtual
                source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate

              # Instalar dependencias
                pip2 install -U wheel
                pip2 install -U setuptools
                pip2 install -U distorm3
                pip2 install -U pycrypto
                pip2 install -U pillow
                pip2 install -U openpyxl
                pip2 install -U ujson
                pip2 install -U pytz
                pip2 install -U ipython
                pip2 install -U capstone
                pip2 install -U yara-python
                cd $HOME/HackingTools/Forensics/volatility2/
                pip2 install .
                #sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
                #sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/local/lib/libyara.so

              # Desactivar el entorno virtual
                deactivate

              # Asignar permisos de ejecucción
                find $HOME/HackingTools/Forensics/volatility2/ -type f -name "*.py" -exec chmod +x {} \;

              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. volatility2 se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        $HOME/HackingTools/Forensics/volatility2/vol.py [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "  Compilando y guardando en /home/$USER/bin/..."
              echo ""

              # Entrar en el entorno virtual
                source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate
                cd $HOME/HackingTools/Forensics/volatility2/

              # Compilar
                pip2 install -U pyinstaller==3.6
                pyinstaller --onefile vol.py

             # Desactivar el entorno virtual
                deactivate

              # Mover el binario a la carpeta de binarios del usuario
                mkdir -p $HOME/bin/
                cp $HOME/HackingTools/Forensics/volatility2/dist/vol      $HOME/bin/volatility2

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    El script compilado se ha copiado a:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      $HOME/bin/volatility2${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      El binario debe ser ejecutado con precaución. Es mejor correr el script dentro del entorno virtual:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        source $HOME/HackingTools/Forensics/volatility2/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}          vol.py [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        deactivate${cFinColor}"
                echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install dialog
        echo ""
      fi

    # Crear el menú
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Instalar version para python 2.x" off
          2 "Instalar version para python 3.x" on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando versión 2.x..."
              echo ""

              # Instalar paquetes necesarios
                sudo apt-get -y install build-essential
                sudo apt-get -y install git
                sudo apt-get -y install libdistorm3-dev
                sudo apt-get -y install yara
                sudo apt-get -y install libraw1394-11
                sudo apt-get -y install libcapstone-dev
                sudo apt-get -y install capstone-tool
                sudo apt-get -y install tzdata
                sudo apt-get -y install python2
                sudo apt-get -y install python2.7-dev
                sudo apt-get -y install libpython2-dev
                sudo apt-get -y install upx
                sudo apt-get -y install binutils
                sudo apt-get -y install curl
              curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
              sudo python2 get-pip.py
              sudo python2 -m pip install -U setuptools wheel
              python2 -m pip install -U distorm3 yara pycrypto pillow openpyxl ujson pytz ipython capstone yara-python
              sudo python2 -m pip install yara
              sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
              python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
              echo 'export PATH=/home/nipegun/.local/bin:$PATH' >> $HOME/.bashrc
              echo ""
              echo "  Volatility2 instalado. Cierra la sesión de terminal, vuélvela a abrir y, para usarlo, simplemente ejecuta:"
              echo "    vol.py -f [ArchivoDump] [Script]"
              echo ""

              # Preparando el ambiente para compilarlo
                python2 -m pip install virtualenv
                mkdir -p $HOME/PythonVirtualEnvironments/ 2> /dev/null
                cd $HOME/PythonVirtualEnvironments/
                rm -rf $HOME/PythonVirtualEnvironments/volatility/*
                python2 -m virtualenv volatility2
                source $HOME/PythonVirtualEnvironments/volatility2/bin/activate
                pip2 install pyinstaller==3.6

                # Descargar el repo
                  mkdir -p $HOME/scripts/python/ 2> /dev/null
                  cd $HOME/scripts/python/
                  rm -rf $HOME/scripts/python/volatility/
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update
                    apt-get -y install git
                    echo ""
                  fi
                  git clone https://github.com/volatilityfoundation/volatility.git
                  mv $HOME/scripts/python/volatility/ $HOME/scripts/python/volatility2/

              # Compilar
                cd $HOME/scripts/python/volatility2/
                # pyinstaller --onefile vol.py --hidden-import=modulo1
                pyinstaller --onefile vol.py
                  

              # Mover el binario a la carpeta de binarios del usuario
                mkdir -p $HOME/bin/
                cp $HOME/scripts/python/volatility2/dist/vol $HOME/bin/volatility2

              # Desactivar el entorno virtual
                deactivate

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. El script compilado se ha copiado a:"
                echo ""
                echo "    $HOME/bin/volatility2"
                echo ""
                echo "  El binario debe ser usado con precaución. Es mejor correr directamente el script, como se indicó arriba:"
                echo ""
                echo "    Simplemente ejecutando vol.py. Pero recuerda, primero debes cerrar la sesión de terminal y volverla a abrir."
                echo ""

            ;;

            2)

            ;;

        esac

    done

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo "  Instalando versión 2.x..."
    echo ""
    # Descargar el repo
      mkdir -p $HOME/scripts/python/ 2> /dev/null
      cd $HOME/scripts/python/
      rm -rf $HOME/scripts/python/*
      if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install git
        echo ""
      fi
      git clone https://github.com/volatilityfoundation/volatility.git

    # Crear el ambiente virtual
      curl -sL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
      apt-get -y install python2
      python2 /tmp/get-pip.py
      python2 -m pip install virtualenv
      mkdir -p $HOME/PythonVirtualEnvironments/ 2> /dev/null
      cd $HOME/PythonVirtualEnvironments/
      rm -rf $HOME/PythonVirtualEnvironments/volatility2/*
      python2 -m virtualenv volatility2
      source $HOME/PythonVirtualEnvironments/volatility2/bin/activate
      pip2 install pyinstaller==3.6

    # Compilar
      mv $HOME/scripts/python/volatility/ $HOME/scripts/python/volatility2/
      cd $HOME/scripts/python/volatility2/
      apt-get -y install python-dev
      apt-get -y install upx
      apt-get -y install binutils
      # pyinstaller --onefile vol.py --hidden-import=modulo1
      pyinstaller --onefile vol.py

    # Mover el binario a la carpeta de binarios del usuario
      mkdir -p $HOME/bin/
      cp $HOME/scripts/python/volatility2/dist/vol $HOME/bin/volatility2

    # Desactivar el entorno virtual
      deactivate

    # Notificar fin de ejecución del script
      echo ""
      echo "  El script ha finalizado. El script compilado se ha copiado a:"
      echo ""
      echo "    $HOME/bin/volatility2"
      echo ""
      echo "  El binario debe ser usado con precaución. Es mejor correr el script directamente con python, de la siguiente manera:"
      echo ""
      echo "    source $HOME/PythonVirtualEnvironments/volatility2/bin/activate"
      echo "    python2.7 $HOME/scripts/python/volatility2/vol.py [Argumentos]"
      echo "    deactivate"
      echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
