#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para corregir las rutas que crea la VPN de TryHackMe en Debian
#
# Descarga directa y post-ejecución (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/ParaCTFs/TryHackMe/OpenVPN-Rutas-Corregir.sh -o /tmp/FixTHMvpn.sh && chmod +x /tmp/FixTHMvpn.sh
#   /tmp/FixTHMvpn.sh '10.100.0.0/16' '10.243.4.1'
#
#
# Ejecución remota (puede requerir permisos sudo):
#   cd /tmp && wget https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/ParaCTFs/TryHackMe/OpenVPN-Rutas-Corregir.sh && | bash /tmp/OpenVPN-Rutas-Corregir.sh [DirecciónDeSubredDeCasa] [IPDeLaMVDeTH]
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/ParaCTFs/TryHackMe/OpenVPN-Rutas-Corregir.sh | sed 's-sudo--g' | bash -s [DirecciónDeSubredDeCasa] [IPDeLaMVDeTH]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/ParaCTFs/TryHackMe/OpenVPN-Rutas-Corregir.sh | nano -
#

# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantParamEsperados=2

# Comprobar que se hayan pasado la cantidad de parámetros correctos. Abortar el script si no.
  if [ $# -ne $cCantParamEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="OpenVPN-CorregirRutas.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [DirecciónDeSubredDeCasa] [IPDeLaMVDeTH]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '10.100.0.0/16' '10.243.4.1'"
      echo ""
      exit
  fi

# Variables

  # Definir la subred de casa
    vSubredDeCasa="$1"
    #echo "  La dirección de subred de la casa es $vSubredDeCasa"
  # Definir IP de la máquina virtual de TH a la que se quiere acceder
    vIPmvTH="$2"
    #echo "  La dirección IP de la máquina virtual de TryHackMe es $vIPmvTH"
  # Calcular dirección de subred /24 de la IP de la máquina virtual
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s ipcalc 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete ipcalc no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install ipcalc
        echo ""
      fi
    vDirSubredMVdeTH=$(ipcalc "$vIPmvTH"/24 | grep etwork | cut -d':' -f2 | sed 's-  - -g' | sed 's-  - -g' | cut -d' ' -f2)
    #echo "  La dirección de subred /24 IP de la IP máquina virtual de TryHackMe es $vDirSubredMVdeTH"

  # Determinar el dispositivo de tunel de la VPN de TryHackMe
    vDevTunVPNDeTH=$(ip a | grep mtu | grep tun | cut -d':' -f2 | cut -d' ' -f2)

# Borrar ruta por defecto
  vGatewayPorDefectoDeTH=$(ip r | grep "$vDevTunVPNDeTH" | grep default | cut -d' ' -f3)
  echo ""
  echo "  Borrando la ruta por defecto via $vGatewayPorDefectoDeTH..."
  echo ""
  sudo ip r d default via "$vGatewayPorDefectoDeTH" dev "$vDevTunVPNDeTH"

# Borrar ruta que colisione con la subred de casa
  echo ""
  echo "  Borrando la ruta a $vSubredDeCasa..."
  echo ""
  sudo ip r d "$vSubredDeCasa" via "$vGatewayPorDefectoDeTH" dev "$vDevTunVPNDeTH"

# Agregar ruta a la máquina virtual
  echo ""
  echo "  Agregando ruta "$vDirSubredMVdeTH" para acceder a la IP de la máquina virtual de TryHackMe..."
  echo ""
  sudo ip r a "$vDirSubredMVdeTH" via "$vGatewayPorDefectoDeTH" dev "$vDevTunVPNDeTH"
