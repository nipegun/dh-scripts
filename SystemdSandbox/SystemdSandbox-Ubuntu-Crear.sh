#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/SystemdSandbox/SystemdSandbox-Ubuntu-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/SystemdSandbox/SystemdSandbox-Ubuntu-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo) (modificando la carpeta donde crear el sandbox):
#  curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/SystemdSandbox/SystemdSandbox-Ubuntu-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-$HOME-/mnt/PartLocalBTRFS-g' /tmp/sb.sh  && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh  [CarpetaAMontar]

# Paquetes mínimos
  vPaqMin="curl"

# Variables
  cFechaDeEjec=$(date +"a%Ym%md%dh%Hm%Ms%S")
  vMirrorUbuntu="http://archive.ubuntu.com/ubuntu"
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
  menu=(dialog --radiolist "Marca la versión del Ubuntu del contenedor y presiona Enter:" 22 70 16)
    opciones=(
      1 "Ubuntu 25.10     (Oracular)" off
      2 "Ubuntu 24.04 LTS (Noble)"    off
      3 "Ubuntu 23.10     (Mantic)"   off
      4 "Ubuntu 23.04     (Lunar)"    off
      5 "Ubuntu 22.10     (Kinetic)"  off
      6 "Ubuntu 22.04 LTS (Jammy)"    off
      7 "Ubuntu 20.04 LTS (Focal)"    off
      8 "Ubuntu 18.04 LTS (Bionic)"   off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Ubuntu 25.10 (Oracular)..."
          echo ""
          vRelease='oracular'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2510: " vNombreDelContenedor

        ;;

        2)

          echo ""
          echo "  Ubuntu 24.04 LTS (Noble)..."
          echo ""
          vRelease='noble'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2404LTS: " vNombreDelContenedor
  
        ;;

        3)

          echo ""
          echo "  Ubuntu 23.10 (Mantic)..."
          echo ""
          vRelease='mantic'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2310: " vNombreDelContenedor

        ;;

        4)

          echo ""
          echo "  Ubuntu 23.04 (Lunar)..."
          echo ""
          vRelease='lunar'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2304: " vNombreDelContenedor

        ;;

        5)

          echo ""
          echo "  Ubuntu 22.10 (Kinetic)..."
          echo ""
          vRelease='kinetic'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2210: " vNombreDelContenedor

        ;;

        6)

          echo ""
          echo "  Ubuntu 22.04 LTS (Jammy)..."
          echo ""
          vRelease='jammy'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2204LTS: " vNombreDelContenedor

        ;;

        7)

          echo ""
          echo "  Ubuntu 20.04 LTS (Focal)..."
          echo ""
          vRelease='focal'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu2004LTS: " vNombreDelContenedor

        ;;

        8)

          echo ""
          echo "  Ubuntu 18.04 LTS (Bionic)..."
          echo ""
          vRelease='bionic'
          read -p "    Introduce el hostname que quieras darle al contenedor. Por ejemplo SystemdSandboxUbuntu1804LTS: " vNombreDelContenedor

        ;;

    esac

  done

# Nuevas variables
  vDirSandbox=""$vCarpetaBase"/Ubuntu-$vRelease-$cFechaDeEjec"

# Crear el sistema de archivos de Ubuntu
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
      echo "  Creando sandbox/contenedor de systemd con Ubuntu "$vRelease" en $vDirSandbox..."
      echo ""
      sudo debootstrap --include="$vPaqMin" "$vRelease" "$vDirSandbox" "$vMirrorUbuntu"
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
  echo "  Iniciando sandbox/contenedor de systemd con Ubuntu..."
  echo ""
  echo "    Copia y ejecuta estas dos líneas dentro del contenedor para preparar el sistema básico:"
  echo ""
  echo "      rm -f /etc/resolv.conf && echo 'nameserver 9.9.9.9' > /etc/resolv.conf"
  echo "      curl -sLk https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/InSystemdSandbox-Ubuntu-Preparar-Base.sh | sed 's-SystemdSandbox-'"$vNombreDelContenedor"'-g' | bash"
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

