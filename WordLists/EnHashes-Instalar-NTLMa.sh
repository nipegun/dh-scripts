#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar en Debian las diferentes Wordlists con hashes NTLM pre-calculados
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/WordLists/EnHashes-Instalar-NTLMa.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/WordLists/EnHashes-Instalar-NTLMa.sh | sed 's-sudo--g' | bash
#
# Ejecución remota como root indicando diferentes carpetas (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/WordLists/EnHashes-Instalar-NTLMa.sh | sed 's-sudo--g' | bash -s "/WordLists/tmp" "/WordLists"
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/h-resources/refs/heads/main/WordLists/EnHashes-Instalar-NTLMa.sh | nano -
# ----------

# Definir cual va a ser la carpeta temporal
  vCarpetaTemporal="${1:-/tmp}"                              # No hay que poner barra final
# Definbir la carpeta de WordLists
  vCarpetaDeWordLists="${2:-"$HOME"/HackingTools/WordLists}" # No hay que poner barra final

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Instalar paquetes necesarios para ejecutar correctamente el script
  sudo apt-get -y update
  sudo apt-get -y install dialog
  sudo apt-get -y install curl
  sudo apt-get -y install p7zip-full

# Función para calcular el espacio libre disponible
  fCalcularEspacioLibre() {
    local vGBsNecesarios="$1"
    # Verificar que la variable global vCarpetaTemporal esté definida
      if [ -z "$vCarpetaTemporal" ] || [ -z "$vGBsNecesarios" ]; then
        false
        return
      fi
    # Convertir GB necesarios a KB (1 GiB = 1024 * 1024 KB)
      local vEspacioNecesarioEnKB
      vEspacioNecesarioEnKB=$(echo "$vGBsNecesarios * 1024 * 1024" | bc | cut -d'.' -f1)
    # Obtener espacio libre en KB de la partición correspondiente a la ruta
      local vEspacioLibreEnKB
      vEspacioLibreEnKB=$(df -k "$vCarpetaTemporal" | tail -1 | tr -s ' ' | cut -d ' ' -f 4)
    # Comparar y retornar true o false
      [ "$vEspacioLibreEnKB" -ge "$vEspacioNecesarioEnKB" ] && true || false
  }

# Crear el menú
  menu=(dialog --checklist "Marca las WordLists EnHashes que quieras instalar:" 22 80 16)
    opciones=(
      1 "WeakPass RockYou NTLM           (  0,7 GB descomprimido)" off
      2 "WeakPass 4 Latin NTLM           ( 95,0 GB descomprimido)" off
      3 "WeakPass 4 Merged NTLM          (158,6 GB descomprimido)" off
      4 "WeakPass 4 Policy NTLM          ( 14,3 GB descomprimido)" off
      5 "WeakPass 4a Latin NTLM          (358.6 GB descomprimido)" off
      6 "WeakPass 4a Policy NTLM         ( 78,0 GB descomprimido)" off
      7 "WeakPass All in One Policy NTLM (xxx,x GB descomprimido)" off
      8 "WeakPass All in One Latin NTLM  (xxx,x TB descomprimido)" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando la WordList WeakPass RockYou NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 0.7; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/rockyou.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/rockyou.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/rockyou.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-RockYou/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-RockYou/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/rockyou.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-RockYou/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-RockYou/rockyou.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-RockYou.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/rockyou.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass RockYou NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            2)

              echo ""
              echo "  Instalando la WordList WeakPass 4 Latin NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 95; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/weakpass_4.latin.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/weakpass_4.latin.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/weakpass_4.latin.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Latin/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Latin/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4.latin.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Latin/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Latin/weakpass_4.latin.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-4Latin.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/weakpass_4.latin.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4 Latin NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            3)

              echo ""
              echo "  Instalando la WordList WeakPass 4 Merged NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 158.6; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/weakpass_4.merged.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/weakpass_4.merged.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/weakpass_4.merged.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Merged/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Merged/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4.merged.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Merged/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Merged/weakpass_4.merged.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-4Merged.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/weakpass_4.merged.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4 Merged NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            4)

              echo ""
              echo "  Instalando la WordList WeakPass 4 Policy NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 14.3; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/weakpass_4.policy.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/weakpass_4.policy.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/weakpass_4.policy.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Policy/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Policy/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4.policy.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Policy/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4Policy/weakpass_4.policy.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-4Policy.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/weakpass_4.policy.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4 Policy NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            5)

              echo ""
              echo "  Instalando la WordList WeakPass 4a Latin NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 358.6; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/weakpass_4a.latin.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/weakpass_4a.latin.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/weakpass_4a.latin.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aLatin/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aLatin/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4a.latin.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aLatin/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aLatin/weakpass_4a.latin.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-4aLatin.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/weakpass_4a.latin.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4a Latin NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            6)

              echo ""
              echo "  Instalando la WordList WeakPass 4a Policy NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 78; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/weakpass_4a.policy.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/weakpass_4a.policy.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/weakpass_4a.policy.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aPolicy/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aPolicy/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4a.policy.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aPolicy/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-4aPolicy/weakpass_4a.policy.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-4aPolicy.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/weakpass_4a.policy.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4a Policy NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            7)

              echo ""
              echo "  Instalando la WordList WeakPass All in One Policy NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 153; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/all_in_one.policy.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/all_in_one.policy.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/all_in_one.policy.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOPolicy/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOPolicy/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/all_in_one.policy.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOPolicy/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOPolicy/all_in_one.policy.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-AiOPolicy.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/all_in_one.policy.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass All in One Policy NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

            8)

              echo ""
              echo "  Instalando la WordList WeakPass All in One Latin NTLM..."
              echo ""
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 563; then
                  # Descargar archivo comprimido
                    sudo rm -f "$vCarpetaTemporal"/all_in_one.latin.txt.ntlm.txt.7z 2> /dev/null
                    curl -L https://weakpass.com/pre-computed/download/all_in_one.latin.txt.ntlm.txt.7z -o "$vCarpetaTemporal"/all_in_one.latin.txt.ntlm.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Borrar la carpeta existente
                      rm -rf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOLatin/ 2> /dev/null
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOLatin/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/all_in_one.latin.txt.ntlm.txt.7z -o"$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOLatin/ # No hay que dejar espacio entre -o y la ruta del directorio
                    # Renombar el archivo de wordlist a su nombre final
                      mv -vf "$vCarpetaDeWordLists"/EnHashes/NTLM/WeakPass-AiOLatin/all_in_one.latin.txt.ntlm.txt "$vCarpetaDeWordLists"/EnHashes/NTLM/NTLM-WeakPass-AiOLatin.txt
                    # Borrar el archivo comprimido recién descomprimido
                      rm -vf "$vCarpetaTemporal"/all_in_one.latin.txt.ntlm.txt.7z
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass All in One Latin NTLM...${cFinColor}"
                  echo ""
                fi

            ;;

        esac

    done
