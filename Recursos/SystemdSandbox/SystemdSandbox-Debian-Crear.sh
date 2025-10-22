#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo) (modificando la carpeta donde crear el sandbox):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-$HOME-/mnt/PartLocalBTRFS-g' /tmp/sb.sh  && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh  [CarpetaAMontar]

# Variables
  cFechaDeEjec=$(date +"a%Ym%md%dh%Hm%Ms%S")
  vMirrorDebian="http://deb.debian.org/debian"
  vMountHost="${1:-/home}"
  vNombreContenedor="SystemdSandboxDebian"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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
      1 "Ultima versión testing"   off
      2 "Ultima versión inestable" off
      3 "Ultima versión estable"   off
      4 "Debian 13 (Trixie)"       off
      5 "Debian 12 (Bookworm)"     off
      6 "Debian 11 (Bullseye)"     off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Última versión testing..."
          echo ""
          vRelease='testing'

        ;;

        2)

          echo ""
          echo "  Última versión inestable..."
          echo ""
          vRelease='sid'

        ;;

        3)

          echo ""
          echo "  Última versión estable..."
          echo ""
          vRelease='stable'

        ;;

        4)

          echo ""
          echo "  Debian 13 (Trixie)..."
          echo ""
          vRelease='trixie'

        ;;

        5)

          echo ""
          echo "  Debian 12 (Bookworm)..."
          echo ""
          vRelease='bookworm'

        ;;

        6)

          echo ""
          echo "  Debian 11 (Bullseye)..."
          echo ""
          vRelease='bullseye'

        ;;

    esac

  done

# Nuevas variables
  vDirSandbox="/var/lib/machines/Debian-$vRelease-$cFechaDeEjec"
  sudo mkdir -p "$vDirSandbox" 2> /dev/null

# Crear el sandbox si no existe
  # Comprobar si el paquete debootstrap está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s debootstrap 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete debootstrap no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install debootstrap
      echo ""
    fi
  # Comprobar si existe o no antes de crearlo
    if [ ! -d "$vDirSandbox" ]; then
      echo ""
      echo "  Creando sandbox/contenedor de systemd con Debian "$vRelease" en $vDirSandbox..."
      echo ""
      sudo debootstrap "$vRelease" "$vDirSandbox" "$vMirrorDebian"
    fi
  # Cambiar la contraseña al root
    sudo sed -i 's|^root:[^:]*:|root:$y$j9T$LOfOfRUGz8M9of5AGi7W90$.9KRnLc7Pfz/ON/5dH0Uvr5fQ.0t6KMKAVcfXOVSnU9:|' "$vDirSandbox"/etc/shadow

# Iniciar el sandbox con aislamiento y carpeta compartida
  # Comprobar si el paquete systemd-container está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s systemd-container 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete systemd-container no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install systemd-container
      echo ""
    fi
  echo ""
  echo "  Iniciando sandbox/contenedor de systemd con Debian..."
  echo ""
  echo "    Copia y poega estas dos líneas dentro del contenedor para preparar el sistema básico:"
  echo ""
  echo "      apt-get -y update && apt-get -y install curl"
  echo "      curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/InSystemdSandbox-Debian-Preparar-Base.sh | bash"
  echo ""
  sudo systemd-nspawn -D "$vDirSandbox" --bind="$vMountHost:/mnt/host" --machine="$vNombreContenedor"

# Notificar salida del contenedor
  echo ""
  echo "  Saliendo del contenedor..."
  echo ""
  echo "    Para volver a entrar:"
  echo ""
  echo "      sudo systemd-nspawn -D "$vDirSandbox" --bind='"$vMountHost:/mnt/host"' --machine="$vNombreContenedor""
  echo ""
  echo "    Para iniciarlo con systemd:"
  echo ""
  echo "      sudo systemd-nspawn -D "$vDirSandbox" --bind='"$vMountHost:/mnt/host"' --machine="$vNombreContenedor" --boot"
  echo ""
  echo "      La contraseña del root es raizraiz"
  echo ""
  echo "    Para borrarlo:"
  echo ""
  echo "      sudo rm -rf "$vDirSandbox""
  echo ""

# Al salir del contenedor, destruirlo
  #echo ""
  #echo "  Destruyendo el sandbox/contenedor de la carpeta "$vDirSandbox"..."
  #echo ""
  #sudo rm -rf "$vDirSandbox"
