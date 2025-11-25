#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar RustScan en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/RustScan-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/RustScan-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/RustScan-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/RustScan-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/RustScan-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 13 (x)...${cFinColor}"
    echo ""

    # Obtener el número de la última versión
      echo ""
      echo "    Obteniendo el número de versión de la release latest..."
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
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      vUltVersRustScan=$(curl -sL https://api.github.com/repos/bee-san/RustScan/releases/latest | jq -r '.tag_name')
      echo ""
      echo "      El número de versión es $vUltVersRustScan"
      echo ""

    # Obtener el número de la última versión
      echo ""
      echo "    Descargando el archivo zip de la última versión..."
      echo ""
      curl -L https://github.com/bee-san/RustScan/releases/download/$vUltVersRustScan/x86_64-linux-rustscan.tar.gz.zip -o /tmp/rustscan.zip

    # Descomprimir el zip
      echo ""
      echo "    Descomprimiendo el zip..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/rustscan.zip -d /tmp

    # Descomprimir el tar.gz
      echo ""
      echo "    Descomprimiendo el tar.gz..."
      echo ""
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      tar -xzvf /tmp/x86_64-linux-rustscan.tar.gz -C /tmp/

    # Mover el binario a carpeta de binarios
      echo ""
      echo "    Moviendo el binario a /usr/bin/..."
      echo ""
      find /tmp/ -type f -name rustscan -exec sudo cp -v {} /usr/bin/ \;
      # Darle permisos de ejecución
        sudo chmod +x /usr/bin/rustscan

    # Crear el alias en .bashrc
      echo ""
      echo "    Creando alias en el -bashrc del usuario..."
      echo ""
      echo "alias rs='rustscan --accessible -g --ulimit 5000 -a '" | tee -a $HOME/.bashrc

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada."
      echo "      RustScan se ha instalado correctamente."
      echo ""
      echo "      Para ejecutar escaneos:"
      echo ""
      echo "        rustscan -a 172.16.0.0/24"
      echo "        rustscan -a 192.168.1.10 -p 22,80,443"
      echo "        rustscan -a 192.168.1.10 -b 1000             # Permite indicar la cantidad de hilos"
      echo "        rustscan -a 192.168.1.10 -oG ~/Resultado.txt # Guardar los resultados a un archivo"
      echo ""
      echo "          Para escanear con RustScan y luego pasar los resultados a Nmap automáticamente:"
      echo ""
      echo "            rustscan -a 192.168.1.1 -- -sV # Para escanear y, lo que detecta, pasarlo a nmap para ver las versiones de servicios"
      echo "            rustscan -a 192.168.1.1 -- -O  # Para escanear y, lo que detecta, pasarlo a nmap para ver cual es el sistema operativo"
      echo ""
      echo "             -- indica que los argumentos posteriores se enviarán a Nmap."
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZMap para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Obtener el número de la última versión
      echo ""
      echo "    Obteniendo el número de versión de la release latest..."
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
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      vUltVersRustScan=$(curl -sL https://api.github.com/repos/bee-san/RustScan/releases/latest | jq -r '.tag_name')
      echo ""
      echo "      El número de versión es $vUltVersRustScan"
      echo ""

    # Obtener el número de la última versión
      echo ""
      echo "    Descargando el archivo zip de la última versión..."
      echo ""
      curl -L https://github.com/bee-san/RustScan/releases/download/$vUltVersRustScan/x86_64-linux-rustscan.tar.gz.zip -o /tmp/rustscan.zip

    # Descomprimir el zip
      echo ""
      echo "    Descomprimiendo el zip..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/rustscan.zip -d /tmp

    # Descomprimir el tar.gz
      echo ""
      echo "    Descomprimiendo el tar.gz..."
      echo ""
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      tar -xzvf /tmp/x86_64-linux-rustscan.tar.gz -C /tmp/

    # Mover el binario a carpeta de binarios
      echo ""
      echo "    Moviendo el binario a /usr/bin/..."
      echo ""
      find /tmp/ -type f -name rustscan -exec sudo cp -v {} /usr/bin/ \;
      # Darle permisos de ejecución
        sudo chmod +x /usr/bin/rustscan

    # Crear el alias en .bashrc
      echo ""
      echo "    Creando alias en el -bashrc del usuario..."
      echo ""
      echo "alias rs='rustscan --accessible -g --ulimit 5000 -a '" | tee -a $HOME/.bashrc

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada."
      echo "      RustScan se ha instalado correctamente."
      echo ""
      echo "      Para ejecutar escaneos:"
      echo ""
      echo "        rustscan -a 172.16.0.0/24"
      echo "        rustscan -a 192.168.1.10 -p 22,80,443"
      echo "        rustscan -a 192.168.1.10 -b 1000             # Permite indicar la cantidad de hilos"
      echo "        rustscan -a 192.168.1.10 -oG ~/Resultado.txt # Guardar los resultados a un archivo"
      echo ""
      echo "          Para escanear con RustScan y luego pasar los resultados a Nmap automáticamente:"
      echo ""
      echo "            rustscan -a 192.168.1.1 -- -sV # Para escanear y, lo que detecta, pasarlo a nmap para ver las versiones de servicios"
      echo "            rustscan -a 192.168.1.1 -- -O  # Para escanear y, lo que detecta, pasarlo a nmap para ver cual es el sistema operativo"
      echo ""
      echo "             -- indica que los argumentos posteriores se enviarán a Nmap."
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de RustScan para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

