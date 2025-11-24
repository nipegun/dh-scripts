#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#   curl -sLk https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sudo /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sLk https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo) (modificando la carpeta donde crear el sandbox):
#   curl -sLk https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Debian-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-$HOME-/mnt/PartLocalBTRFS-g' /tmp/sb.sh  && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh  [CarpetaAMontar]

# Paquetes mínimos
  vPaqMin="curl"

# Variables
  cFechaDeEjec=$(date +"a%Ym%md%dh%Hm%Ms%S")
  vMirrorDebian="http://deb.debian.org/debian"
  vMountHost="$(readlink -f "${1:-/home}")"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Crear el menú para la elección de la carpeta raíz
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --radiolist "En que carpeta ráiz quieres crear el contenedor:" 22 60 16)
    opciones=(
      1 "/var/lib/machines"             on
      2 "/tmp"                          off
      3 "Otra (introducir manualmente)" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)
          vCarpetaBase='/var/lib/machines'
        ;;

        2)
          vCarpetaBase='/tmp'
        ;;

        3)
          read -p "    Introduce la ruta absoluta donde quieras crear en contenedor (sin / final): " vCarpetaBase
        ;;

    esac

  done

# Crear el menú
  menu=(dialog --radiolist "Marca la versión del Debian del contenedor y presiona Enter:" 22 70 16)
    opciones=(
      1 "Última versión testing"   off
      2 "Última versión inestable" off
      3 "Última versión estable"   on
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
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianTesting: " vNombreDelContenedor

        ;;

        2)

          echo ""
          echo "  Última versión inestable..."
          echo ""
          vRelease='sid'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianSid: " vNombreDelContenedor
  
        ;;

        3)

          echo ""
          echo "  Última versión estable..."
          echo ""
          vRelease='stable'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianStable: " vNombreDelContenedor

        ;;

        4)

          echo ""
          echo "  Debian 13 (Trixie)..."
          echo ""
          vRelease='trixie'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianTrixie: " vNombreDelContenedor

        ;;

        5)

          echo ""
          echo "  Debian 12 (Bookworm)..."
          echo ""
          vRelease='bookworm'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianBookworm: " vNombreDelContenedor

        ;;

        6)

          echo ""
          echo "  Debian 11 (Bullseye)..."
          echo ""
          vRelease='bullseye'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxDebianBullseye: " vNombreDelContenedor

        ;;

    esac

  done

# Nuevas variables
  vDirSandbox=""$vCarpetaBase"/Debian-$vRelease-$cFechaDeEjec"

# Crear el sistema de archivos de Debian
  # Comprobar si el paquete debootstrap está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s debootstrap 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete debootstrap no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install debootstrap
      echo ""
    fi
  # Sólo proceder si la carpeta no existe previamente
    if [ ! -d "$vDirSandbox" ]; then
      echo ""
      echo "  Creando sandbox/contenedor de systemd con Debian "$vRelease" en $vDirSandbox..."
      echo ""
      sudo debootstrap --include="$vPaqMin" "$vRelease" "$vDirSandbox" "$vMirrorDebian"
    else
      echo ""
      echo "  La carpeta $vDirSandbox ya existe. Abortando..."
      echo ""
      exit
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
  echo "    Copia y ejecuta esta línea dentro del contenedor para preparar el sistema básico:"
  echo ""
  echo "      curl -sLk https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/InSystemdSandbox-Debian-Preparar-Base.sh | sed 's-SystemdSandbox-'"$vNombreDelContenedor"'-g' | bash"
  echo ""
  sudo systemd-nspawn -D "$vDirSandbox" --bind="$vMountHost:/mnt/host" --machine="$vNombreDelContenedor"

# Notificar salida del contenedor
  echo ""
  echo "  Saliendo del contenedor..."
  echo ""
  echo "    Para volver a entrar:"
  echo ""
  echo "      sudo systemd-nspawn -D "$vDirSandbox" --bind='"$vMountHost:/mnt/host"' --machine="$vNombreDelContenedor""
  echo ""
  echo "    Para iniciarlo con systemd:"
  echo ""
  echo "      sudo systemd-nspawn -D "$vDirSandbox" --bind='"$vMountHost:/mnt/host"' --machine="$vNombreDelContenedor" --boot"
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
