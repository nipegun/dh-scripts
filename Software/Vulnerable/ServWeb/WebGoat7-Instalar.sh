#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar WebGoat7 en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/WebGoat7-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/WebGoat7-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/WebGoat7-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en Debian 9. ${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en Debian 9. ${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en Debian 9. ${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en Debian 9. ${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 80 16)
        opciones=(
          1 "Instalar Java JRE"                                                      on
          2 "Instalar la versión 7.1 a nivel de usuario para ejecutar manualmente"   off
          3 "Instalar la versión 7.1 a nivel de sistema como un servicio de systemd" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando OpenJDK..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install default-jre
      
            ;;

            2)

              echo ""
              echo "  Instalando la versión 7.1 a nivel de usuario para ejecutar manualmente..."
              echo ""

              # Crear variable con versión
                vNumUltVers="7.1"

              # Descargar el archivo.jar
                echo ""
                echo "    Descargando el archivo .jar con la última versión..."
                echo ""
                mkdir -p ~/bin/java/
                rm -f ~/bin/java/webgoat*
                curl -L https://github.com/WebGoat/WebGoat/releases/download/$vNumUltVers/webgoat-container-$vNumUltVers-exec.jar -o ~/bin/java/webgoat-$vNumUltVers.jar

              # Crear el script de ejecución
                echo ""
                echo "    Creando el script para ejecutar desde la CLI..."
                echo ""
                mkdir -p ~/scripts/
                echo '#!/bin/bash'                                                                                                      > ~/scripts/WebGoat-Ejecutar.sh
                echo ""                                                                                                                >> ~/scripts/WebGoat-Ejecutar.sh
                echo 'export TZ=Europe/Madrid'                                                                                         >> ~/scripts/WebGoat-Ejecutar.sh
                echo "java -Dfile.encoding=UTF-8 -Dserver.address=0.0.0.0 -Dserver.port=8080 -jar ~/bin/java/webgoat-$vNumUltVers.jar" >> ~/scripts/WebGoat-Ejecutar.sh
                chmod +x                                                                                                                  ~/scripts/WebGoat-Ejecutar.sh

              # Notificar fin de ejecución del script
                echo ""
                echo "    Instalación a nivel de usuario, finalizada. Para lanzarlo, ejecuta:"
                echo ""
                echo "      ~/scripts/WebGoat-Ejecutar.sh"
                echo ""
                echo "    La primera vez que accedas tendrás que registrar un usuario nuevo."
                echo ""

            ;;

            3)

              echo ""
              echo "  Instalando la versión 7.1 a nivel de sistema como servicio de systemd..."
              echo ""

              # Crear variable con versión
                vNumUltVers="7.1"

              # Descargar el archivo.jar
                echo ""
                echo "    Descargando el archivo .jar con la última versión..."
                echo ""
                sudo mkdir -p /opt/WebGoat/bin/
                sudo rm -f /opt/WebGoat/bin/webgoat*
                sudo curl -L https://github.com/WebGoat/WebGoat/releases/download/$vNumUltVers/webgoat-container-$vNumUltVers-exec.jar -o /opt/WebGoat/bin/webgoat-$vNumUltVers.jar

              # Reparar permisos
                sudo chown $USER:$USER /opt/WebGoat -R

              # Crear el usuario admin
              #  echo ""
              #  echo "    Creando el usuario admin..."
              #  echo ""
              #  /usr/bin/java -Dwebgoat.user=admin -Dwebgoat.password=admin -Dwebgoat.role=ROLE_ADMIN -jar /opt/WebGoat/bin/webgoat-$vNumUltVers.jar --server.address=0.0.0.0

              # Crear el archivo para el servicio
                echo ""
                echo "    Creando el archivo del servicio..."
                echo ""
                echo '[Unit]'                                                                                                                                   | sudo tee    /etc/systemd/system/WebGoat.service
                echo 'Description=WebGoat'                                                                                                                      | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'After=network.target'                                                                                                                     | sudo tee -a /etc/systemd/system/WebGoat.service
                echo ''                                                                                                                                         | sudo tee -a /etc/systemd/system/WebGoat.service
                echo '[Service]'                                                                                                                                | sudo tee -a /etc/systemd/system/WebGoat.service
                echo "User=$USER"                                                                                                                               | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'WorkingDirectory=/opt/WebGoat'                                                                                                            | sudo tee -a /etc/systemd/system/WebGoat.service
                echo "ExecStart=/usr/bin/java -Dfile.encoding=UTF-8 -Dserver.address=0.0.0.0 -Dserver.port=8080 -jar /opt/WebGoat/bin/webgoat-$vNumUltVers.jar" | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'Restart=always'                                                                                                                           | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'RestartSec=10'                                                                                                                            | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'StandardOutput=syslog'                                                                                                                    | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'StandardError=syslog'                                                                                                                     | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'SyslogIdentifier=WebGoat'                                                                                                                 | sudo tee -a /etc/systemd/system/WebGoat.service
                echo ''                                                                                                                                         | sudo tee -a /etc/systemd/system/WebGoat.service
                echo '[Install]'                                                                                                                                | sudo tee -a /etc/systemd/system/WebGoat.service
                echo 'WantedBy=multi-user.target'                                                                                                               | sudo tee -a /etc/systemd/system/WebGoat.service

              # Activar e iniciar el servicio
                echo ""
                echo "    Activando e iniciando el servicio..."
                echo ""
                sudo systemctl enable WebGoat --now

              # Mostrar estado del servicio
                echo ""
                echo "    Mostrando estado del servicio..."
                echo ""
                sleep 5
                sudo systemctl status WebGoat.service --no-pager

              # Notificar fin de ejecución del script
              
                echo ""
                echo "    Instalación a nivel de sistema, finalizada. El servicio debería estar corriendo. Para conectarte:"
                echo ""
                vIPLocal=$(hostname -I | sed 's- --g')
                echo "      http://$vIPLocal:8080/WebGoat"
                echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de WebGoat7 para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
