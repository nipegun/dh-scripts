!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar la máxima cantidad posible de WordLists en texto plano en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/WordLists/EnTextoPlano-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/WordLists/EnTextoPlano-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/WordLists/EnTextoPlano-Instalar.sh | nano -
# ----------

# Definir cual va a ser la carpeta temporal
  vCarpetaTemporal="${1:-/tmp}"                            # No hay que poner barra final
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
      1 "  Instalar WordLists de Debian"                       on
      2 "  Descargar WordLists de SecLists"                    on
      3 "  Descargar WordLists de CSL-LABS"                    on
      4 "  Descargar WordLists de CrackStation"                on
      5 "  Descargar WordList WeakPass 4a"                     on
      6 "  Descargar RockYou"                                  on
      7 "    Eliminar caracteres de tabulación"                on
      8 "      Preparar WordLists de caracteres incrementales" on
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando WordLists de Debian..."
              echo ""
              sudo apt-get -y update
              # 
              sudo apt-get -y --reinstall install cracklib-runtime
              sudo apt-get -y --reinstall install miscfiles
              sudo apt-get -y --reinstall install wamerican
              sudo apt-get -y --reinstall install wamerican-huge
              sudo apt-get -y --reinstall install wamerican-insane
              sudo apt-get -y --reinstall install wamerican-large
              sudo apt-get -y --reinstall install wamerican-small
              sudo apt-get -y --reinstall install wbrazilian
              sudo apt-get -y --reinstall install wbritish
              sudo apt-get -y --reinstall install wbritish-huge
              sudo apt-get -y --reinstall install wbritish-insane
              sudo apt-get -y --reinstall install wbritish-large
              sudo apt-get -y --reinstall install wbritish-small
              sudo apt-get -y --reinstall install wbulgarian
              sudo apt-get -y --reinstall install wcanadian
              sudo apt-get -y --reinstall install wcanadian-huge
              sudo apt-get -y --reinstall install wcanadian-insane
              sudo apt-get -y --reinstall install wcanadian-large
              sudo apt-get -y --reinstall install wcanadian-small
              sudo apt-get -y --reinstall install wcatalan
              sudo apt-get -y --reinstall install wdanish
              sudo apt-get -y --reinstall install wdutch
              sudo apt-get -y --reinstall install wesperanto
              sudo apt-get -y --reinstall install wfaroese
              sudo apt-get -y --reinstall install wfrench
              sudo apt-get -y --reinstall install wgalician-minimos
              sudo apt-get -y --reinstall install wgerman-medical
              sudo apt-get -y --reinstall install wirish
              sudo apt-get -y --reinstall install witalian
              sudo apt-get -y --reinstall install wmanx
              sudo apt-get -y --reinstall install wngerman
              sudo apt-get -y --reinstall install wnorwegian
              sudo apt-get -y --reinstall install wogerman
              sudo apt-get -y --reinstall install wpolish
              sudo apt-get -y --reinstall install wportuguese
              sudo apt-get -y --reinstall install wspanish
              sudo apt-get -y --reinstall install wswedish
              sudo apt-get -y --reinstall install wswiss
              sudo apt-get -y --reinstall install wukrainian
              sudo apt-get -y --reinstall install scowl
              cd /usr/share/dict/
              sudo gzip -v -f -d -k connectives.gz
              sudo gzip -v -f -d -k propernames.gz
              sudo gzip -v -f -d -k web2a.gz
              # Borrar la carpeta vieja
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/ 2> /dev/null
              # Copiar WordLists a la carpeta Debian
                mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/scowl/
                cp -fv /usr/share/dict/scowl/*                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/scowl/
                cp -fv /usr/share/dict/american-english        "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-huge   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-insane "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-large  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-small  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/bokmaal                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/brazilian               "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-huge    "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-insane  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-large   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-small   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/bulgarian               "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english        "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-huge   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-insane "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-large  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-small  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/catalan                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/connectives             "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/cracklib-small          "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/danish                  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/dutch                   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/esperanto               "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/faroese                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/french                  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/galician-minimos        "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/german-medical          "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/irish                   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/italian                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/manx                    "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ngerman                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /etc/dictionaries-common/norsk          "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/nynorsk                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ogerman                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/polish                  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/portuguese              "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/propernames             "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/spanish                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/swedish                 "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/swiss                   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ukrainian               "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/web2                    "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/web2a                   "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/
                cp -fv /etc/dictionaries-common/words          "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/

              # Recorrer todos los archivos y cambiar la extensión a txt
                find "$vCarpetaDeWordLists"/EnTextoPlano/Packs/Debian/ -type f | while read -r file; do
                  # Omitir si ya es .txt
                  if [[ "$file" == *.txt ]]; then
                    continue
                  fi

                  filename=$(basename "$file")
                  dir=$(dirname "$file")

                  # Si no hay punto, no tiene extensión
                  if [[ "$filename" != *.* ]]; then
                    newname="${file}.txt"
  
                  else
                    name="${filename%.*}"
                    ext="${filename##*.}"

                    # Si extensión es numérica → agregar .txt al nombre completo
                    if [[ "$ext" =~ ^[0-9]+$ ]]; then
                      newname="${file}.txt"

                    # Si extensión es NO numérica → eliminar extensión y poner .txt (si no existe ya)
                    else
                      newname="${dir}/${name}.txt"
                    fi
                  fi

                  # Evitar sobrescritura
                  if [[ ! -e "$newname" ]]; then
                    mv "$file" "$newname"
                    echo "Renombrado: $file → $newname"
                  else
                    echo "Ya existe: $newname – no se renombró $file"
                  fi

                done

            ;;

            2)

              echo ""
              echo "  Descargando WordLists de SecLists..."
              echo ""
              # Borrar la carpeta vieja
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/ 2> /dev/null
              # Posicionarse en la carpeta
                cd "$vCarpetaDeWordLists"/EnTextoPlano/Packs/
              # Clonar el repo de SecLists
                export LC_ALL=C.UTF-8  # Forzar UTF-8 para evitar problemas de codificación
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone --depth 1 https://github.com/danielmiessler/SecLists.git

              # Borrar carpetas sobrantes
                # Archivos de la raiz
                  rm -f "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/SecLists.png
                  rm -f "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/LICENSE
                  rm -f "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/CONTRIBUTORS.md
                  rm -f "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/CONTRIBUTING.md
                # Archivos README.md
                  find "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/ -type f -name README.md -exec rm -f {} \;
                  rm -f "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Infrastructure/IPGenerator.sh
                # Archivos de inteligencia artificial
                  rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Ai 2> /dev/null
                  rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Ai 2> /dev/null

              # Descomprimir archivos comprimidos
                cd "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/
                #bzip2 -d "500-worst-passwords.txt.bz2"
                tar -xvzf "SCRABBLE-hackerhouse.tgz"
                rm "SCRABBLE-hackerhouse.tgz"
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/SCRABBLE/fetch.sh
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/SCRABBLE/mangle.py
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Default-Credentials/scada-pass.csv
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Default-Credentials/default-passwords.csv
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Pattern-Matching/grepstrings-auditing-php.md
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Payloads/
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Web-Shells/
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Fuzzing/
                # No convierten bien a UTF8
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/DNS/FUZZSUBS_CYFARE_2.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-files-lowercase.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/trickest-robots-disallowed-WordLists/top-10000.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-files.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/combined_words.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/trickest-cms-WordList/dolibarr.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/trickest-cms-WordList/dolibarr-all-levels.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/Django.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-directories.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-small-directories.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-medium-directories.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/dutch_passWordList.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Cracked-Hashes/milw0rm-dictionary.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/fortinet-2021.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet-withcount.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet2.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/myspace-withcount.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Honeypot-Captures/python-heralding-sep2019.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/10-million-password-list-top-100.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/Language-Specific/Spanish_common-usernames-and-passwords.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/10-million-password-list-top-100000.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Usernames/Honeypot-Captures/multiplesources-users-fabian-fingerle.de.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Miscellaneous/control-chars.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Miscellaneous/Moby-Project/Moby-Language-II/german.txt
                  #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/Miscellaneous/Moby-Project/Moby-Language-II/japanese.txt

              # Borrar resto de archivos del repositorio
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/.bin/
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/.git/
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/.github/
                rm -f  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/.gitattributes
                rm -f  "$vCarpetaDeWordLists"/EnTextoPlano/Packs/SecLists/.gitignore

            ;;

            3)

              echo ""
              echo "  Descargando WordLists de CSL-LABS..."
              echo ""
              # Borrar posible descarga anterior
                rm -rf "$vCarpetaTemporal"/CrackingWordLists/ 2> /dev/null
              # Posicionarse en la carpeta temporal
                cd "$vCarpetaTemporal"/
              # Clonar el repo de CSL-LABS
                export LC_ALL=C.UTF-8  # Forzar UTF-8 para evitar problemas de codificación
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone --depth 1 https://github.com/CSL-LABS/CrackingWordLists.git
              # Borrar la carpeta vieja
                rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/ 2> /dev/null
              # Mover carpeta
                mv "$vCarpetaTemporal"/CrackingWordLists/dics/ "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/
              #
                cd "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/
                tar -xvzf ROCKYOU-CSL.tar.gz
                rm -f ROCKYOU-CSL.tar.gz
                #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/ROCKYOU-CSL.txt
                #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/misc/sports.txt
                #rm -rf "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/misc/top_songs.txt
                find "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CSL-LABS/ -type f -name "*.dic" -exec bash -c 'mv "$0" "${0%.dic}.txt"' {} \;

            ;;

            4)

              echo ""
              echo "  Descargando WordLists de CrackStation..."
              echo ""
              curl -L https://crackstation.net/files/crackstation.txt.gz -o "$vCarpetaTemporal"/crackstation.txt.gz
              cd "$vCarpetaTemporal"/
              gunzip -v "$vCarpetaTemporal"/crackstation.txt.gz
              mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CrackStation/ 2> /dev/null
              mv "$vCarpetaTemporal"/crackstation.txt "$vCarpetaDeWordLists"/EnTextoPlano/Packs/CrackStation/

            ;;

            5)

              echo ""
              echo "  Descargando WordList WeakPass 4a..."
              echo ""
              # Comprobar si el paquete p7zip-full está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s p7zip-full 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete p7zip-full no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install p7zip-full
                  echo ""
                fi
              # Calcular espacio libre disponible antes de instalar la WordList
                if fCalcularEspacioLibre 90; then
                  # Descargar archivo comprimido
                    curl -L https://weakpass.com/download/2015/weakpass_4a.txt.7z -o "$vCarpetaTemporal"/weakpass_4a.txt.7z
                  # Descomprimir archivo hacia la ubicación final
                    # Asegurarse de que la carpeta final exista
                      mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/WeakPass/4a/ 2> /dev/null
                    # Descomprimir
                      7z x "$vCarpetaTemporal"/weakpass_4a.txt.7z -o"$vCarpetaDeWordLists"/EnTextoPlano/Packs/WeakPass/4a/ -aoa # No hay que dejar espacio entre -o y la ruta del directorio
                else
                  echo ""
                  echo -e "${cColorRojo}    La carpeta $vCarpetaTemporal no tiene espacio disponible para descargar la WordList WeakPass 4a...${cFinColor}"
                  echo ""
                fi

            ;;

            6)

              echo ""
              echo "  Descargando RockYou..."
              echo ""

              # Descargar archivo comprimido
                curl -L http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2 -o /tmp/rockyou.txt.bz2
              # Asegurarse de que la carpeta final exista
                mkdir -p "$vCarpetaDeWordLists"/EnTextoPlano/Packs/RockYou/ 2> /dev/null
              # Descomprimir
                bzip2 -dk /tmp/rockyou.txt.bz2 && mv /tmp/rockyou.txt "$vCarpetaDeWordLists"/EnTextoPlano/Packs/RockYou/rockyou-unsorted.txt
              # Ordenar alfabéticamente
                sort "$vCarpetaDeWordLists"/EnTextoPlano/Packs/RockYou/rockyou-unsorted.txt -o "$vCarpetaDeWordLists"/EnTextoPlano/Packs/RockYou/RockYou.txt --parallel=$(nproc)

            ;;

            7)

              echo ""
              echo "  Eliminando caracteres de tabulación..."
              echo ""

              vCarpetaInicio="$vCarpetaDeWordLists/EnTextoPlano/Packs/"
              find "$vCarpetaInicio" -type f -name "*.txt" -print0 | while IFS= read -r -d '' vArchivo; do
                sed -i 's/\t//g' "$vArchivo"
              done

            ;;

            8)

              echo ""
              echo "  Preparando WordLists de caracteres incrementales..."
              echo "  Dependiendo de la capacidad de proceso del sistema, puede tardar más de 10 minutos."
              echo ""

              # Crear WordLists
                export LC_ALL=C.UTF-8  # Forzar UTF-8 para evitar problemas de codificación

                vCarpetaInicio="$vCarpetaDeWordLists/EnTextoPlano/Packs/"
                vCarpetaDestino="$vCarpetaDeWordLists/EnTextoPlano/PorCantCaracteres/"
                rm "$vCarpetaDestino"* 2> /dev/null

                mkdir -p "$vCarpetaDestino"
                cd "$vCarpetaDestino" || exit 1

                vCaracteresMin=1
                vCaracteresMax=64

              # Crear los archivos
                for ((i=vCaracteresMin; i<=vCaracteresMax; i++)); do
                  > "All${i}Characters.txt"
                done

              # Popular los archivos
                find "$vCarpetaInicio" -type f -name "*.txt" -print0 | while IFS= read -r -d '' file; do
                  iconv -c -f UTF-8 -t UTF-8 "$file" | awk -v min="$vCaracteresMin" -v max="$vCaracteresMax" '
                  {
                    len = length($0);
                    if (len >= min && len <= max)
                      print $0 >> ("All" len "Characters.txt");
                  }'
                done

              # Eliminar caracteres no imprimibles de todos los archivos y sanitizar algunas líneas
                for vArchivo in "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/*.txt; do
                  sed -e 's/^[[:space:]]*//' "$vArchivo" | grep -a -P '^[\x20-\x7E]+$' > "$vArchivo.tmp"
                  mv -f "$vArchivo.tmp" "$vArchivo"
                done

              # Ordenar y eliminar líneas duplicadas
                find "$vCarpetaDestino" -type f -name "*.txt" | while read -r vArchivo; do
                  sort "$vArchivo" | uniq > "$vArchivo.tmp" && mv "$vArchivo.tmp" "$vArchivo"
                done
                echo ""

              # Asegurarse de que cada arhivo tenga la cantidad correcta de caracteres por linea
                for vArchivo in "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All*Characters.txt; do
                  vCantidad=$(basename "$vArchivo" | sed -E 's/All([0-9]+)Characters\.txt/\1/')
                  grep -E "^.{$vCantidad}$" "$vArchivo" > "$vArchivo.tmp"
                  mv -f "$vArchivo.tmp" "$vArchivo"
                done

              # Corregir nombres de los archivos con un sólo número
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All1Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All01Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All2Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All02Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All3Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All03Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All4Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All04Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All5Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All05Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All6Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All06Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All7Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All07Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All8Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All08Characters.txt
                mv "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All9Characters.txt "$vCarpetaDeWordLists"/EnTextoPlano/PorCantCaracteres/All09Characters.txt

              # Notificar fin de la ejecución
                echo ""
                echo "  Se han procesado todos los .txt de $vCarpetaInicio y se han creado nuevas WordLists con su contenido."
                echo "  Puedes encontrarlas en $vCarpetaDestino"
                echo ""

            ;;

        esac

    done
