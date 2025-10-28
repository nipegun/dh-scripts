#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Alpine-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Alpine-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh [CarpetaAMontar]
#
# Ejecución remota como root (para sistemas sin sudo) (modificando la carpeta donde crear el sandbox):
#  curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/SystemdSandbox/SystemdSandbox-Alpine-Crear.sh -o /tmp/sb.sh && chmod +x /tmp/sb.sh && sed -i 's-$HOME-/mnt/PartLocalBTRFS-g' /tmp/sb.sh  && sed -i 's-sudo--g' /tmp/sb.sh && /tmp/sb.sh  [CarpetaAMontar]

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install curl
      echo ""
    fi

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
  menu=(dialog --checklist "En que carpeta ráiz quieres crear el contenedor:" 22 70 16)
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

          echo ""
          echo "  Creando en /var/lib/machines..."
          echo ""
          vCarpetaBase='/var/lib/machines'

        ;;

        2)

          echo ""
          echo "  Creando en /tmp..."
          echo ""
          vCarpetaBase='/tmp'
  
        ;;

        3)

          echo ""
          echo "  Creando en carpeta personalizada..."
          echo ""
          read -p "    Introduce la ruta absoluta donde quieras crear en contenedor (sin / final): " vCarpetaBase

        ;;

    esac

  done

# Variables
  cFechaDeEjec=$(date +"a%Ym%md%dh%Hm%Ms%S")
  vDirSandbox=""$vCarpetaBase"/Alpine-$vRelease-$cFechaDeEjec"
  sudo mkdir -p "$vDirSandbox" 2> /dev/null
  vNombreContenedor="SystemdSandboxAlpine"
  
  vURLDownloadsAlpine="https://www.alpinelinux.org/downloads/"
  vRelease=$(curl -sL "$vURLDownloadsAlpine" | grep -i current | grep -oP '(?<=<strong>).*?(?=</strong>)')
  vMountHost="${1:-/home}"

# Crear el sandbox si no existe
  # Comprobar si existe o no antes de crearlo
    if [ ! -d "$vDirSandbox" ]; then
      echo ""
      echo "  Creando sandbox/contenedor de systemd con Alpine "$vRelease" en $vDirSandbox..."
      echo ""
      vURLArchivoComprimido=$(curl -sL "$vURLDownloadsAlpine" | grep minirootfs | grep x86_64 | sed 's->->\n-g' | sed 's|&#x2F;|/|g' | grep href | grep -v sha256 | grep -v asc | cut -d'"' -f2)
      curl -sL "$vURLArchivoComprimido" -o /tmp/alpine.tar.gz
      sudo tar -xzf /tmp/alpine.tar.gz -C "$vDirSandbox"
    fi

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
  echo "  Iniciando sandbox/contenedor de systemd con Apline..."
  echo ""
  echo "    Dentro del contenedor pega y ejecuta los siguientes comandos para preparar el sistema básico:"
  echo ""
  echo "      apk update && apk add curl"
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
  echo "    Para borrarlo:"
  echo ""
  echo "      sudo rm -rf "$vDirSandbox""
  echo ""

# Al salir del contenedor, destruirlo
  #echo ""
  #echo "  Destruyendo el sandbox/contenedor de la carpeta "$vDirSandbox"..."
  #echo ""
  #sudo rm -rf "$vDirSandbox"
