#!/bin/bash

# ----------
# Script de NiPeGun para buscar servicios web en una subred o host
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Descubrimientos/Servicios-EnIPoSubred.sh | bash -s "localhost"
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Descubrimientos/Servicios-EnIPoSubred.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir el objetivo
  vIPoSubred="$1"

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Buscando servicios en $vIPoSubred ... ${cFinColor}"
  echo ""

# Ejecutar nmap
  nmap "$vIPoSubred" -Pn -p- -sV | sed -e 's-\\x20- -g' | sed -e 's-\\r-\n-g' | sed -e 's-\\n-\n-g' | sed -e 's-SF:--g'

