#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para escanear vulnerabilidades con nmap en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Descubrimientos/Vulnerabilidades-EnIPoSubred-TodosLosPuertos.sh | bash -s "192.168.1.0/24"
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Descubrimientos/Vulnerabilidades-EnIPoSubred-TodosLosPuertos.sh | sed 's-sudo--g' | bash -s "192.168.1.3"
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Descubrimientos/Vulnerabilidades-EnIPoSubred-TodosLosPuertos.sh | nano -
# ----------

vIPoSubred="$1"

# Comprobar si el paquete nmap está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s nmap 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete nmap no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install nmap
    echo ""
  fi

# Actualizar la base de datos
  sudo nmap --script-updatedb

# Ejecutar script vuln
  echo ""
  echo "  Ejecutando script vuln..."
  echo ""
  sudo nmap -sV -p- --script=vuln,vulners "$vIPoSubred" -oN ~/ResultadoNmap-vuln.txt

# Ejecutar script vulners
  echo ""
  echo "  Ejecutando script vulners..."
  echo ""
  sudo nmap -sV -p- --script=vulners "$vIPoSubred" -oN ~/ResultadoNmap-vulners.txt
# Escaneo de vulnerabilidades vulscan

# Ejecutar script vulscan
  echo ""
  echo "  Ejecutando script vulscan..."
  echo ""
  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install git
      echo ""
    fi
  cd /usr/share/nmap/scripts/
  sudo git clone https://github.com/scipag/vulscan.git
  sudo nmap -sV -p- --script=vulscan/vulscan.nse "$vIPoSubred" -oN ~/ResultadoNmap-vulscan.txt


# Ejecutar script exploit
  echo ""
  echo "  Ejecutando script exploit..."
  echo ""
  sudo nmap -sV --script=exploit "$vIPoSubred" -oN ~/ResultadoNmap-exploits.txt

