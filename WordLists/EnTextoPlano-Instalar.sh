#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar la máxima cantidad posible de WordLists en texto plano en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/WordLists/EnTextoPlano-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/WordLists/EnTextoPlano-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/WordLists/EnTextoPlano-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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
      1 "  Instalar WordLists de Debian"                       on
      2 "  Descargar WordLists de SecLists"                    on
      3 "  Descargar WordLists de CSL-LABS"                    on
      4 "  Descargar WordLists de CrackStation"                on
      5 "  Descargar WordList WeakPass 4a"                     on
      6 "  Reservado"                                          off
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
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/ 2> /dev/null
              # Copiar WordLists a la carpeta Debian
                mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/scowl/
                cp -fv /usr/share/dict/scowl/*                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/scowl/
                cp -fv /usr/share/dict/american-english        ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-huge   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-insane ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-large  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/american-english-small  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/bokmaal                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/brazilian               ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-huge    ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-insane  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-large   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/british-english-small   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/bulgarian               ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english        ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-huge   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-insane ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-large  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/canadian-english-small  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/catalan                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/connectives             ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/cracklib-small          ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/danish                  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/dutch                   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/esperanto               ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/faroese                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/french                  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/galician-minimos        ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/german-medical          ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/irish                   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/italian                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/manx                    ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ngerman                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /etc/dictionaries-common/norsk          ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/nynorsk                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ogerman                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/polish                  ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/portuguese              ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/propernames             ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/spanish                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/swedish                 ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/swiss                   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/ukrainian               ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/web2                    ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /usr/share/dict/web2a                   ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/
                cp -fv /etc/dictionaries-common/words          ~/HackingTools/WordLists/EnTextoPlano/Packs/Debian/

              # Recorrer todos los archivos y cambiar la extensión a txt
                find "$HOME""/HackingTools/WordLists/EnTextoPlano/Packs/Debian/" -type f | while read -r file; do
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
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/ 2> /dev/null
              # Posicionarse en la carpeta
                cd ~/HackingTools/WordLists/EnTextoPlano/Packs/
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
                  rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/SecLists.png
                  rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/LICENSE
                  rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/CONTRIBUTORS.md
                  rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/CONTRIBUTING.md
                # Archivos README.md
                  find ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/ -type f -name README.md -exec rm -f {} \;
                  rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Infrastructure/IPGenerator.sh
                # Archivos de inteligencia artificial
                  rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Ai 2> /dev/null
                  rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Ai 2> /dev/null

              # Descomprimir archivos comprimidos
                cd ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/
                #bzip2 -d "500-worst-passwords.txt.bz2"
                tar -xvzf "SCRABBLE-hackerhouse.tgz"
                rm "SCRABBLE-hackerhouse.tgz"
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/SCRABBLE/fetch.sh
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/SCRABBLE/mangle.py
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Default-Credentials/scada-pass.csv
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Default-Credentials/default-passwords.csv
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Pattern-Matching/grepstrings-auditing-php.md
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Payloads/
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Web-Shells/
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Fuzzing/
                # No convierten bien a UTF8
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/DNS/FUZZSUBS_CYFARE_2.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-files-lowercase.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/trickest-robots-disallowed-WordLists/top-10000.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-files.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/combined_words.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/trickest-cms-WordList/dolibarr.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/trickest-cms-WordList/dolibarr-all-levels.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/CMS/Django.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-large-directories.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-small-directories.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Discovery/Web-Content/raft-medium-directories.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/dutch_passWordList.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Cracked-Hashes/milw0rm-dictionary.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/fortinet-2021.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet-withcount.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet2.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/honeynet.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Leaked-Databases/myspace-withcount.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Honeypot-Captures/python-heralding-sep2019.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/10-million-password-list-top-100.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/Language-Specific/Spanish_common-usernames-and-passwords.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Passwords/Common-Credentials/10-million-password-list-top-100000.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Usernames/Honeypot-Captures/multiplesources-users-fabian-fingerle.de.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Miscellaneous/control-chars.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Miscellaneous/Moby-Project/Moby-Language-II/german.txt
                  #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/Miscellaneous/Moby-Project/Moby-Language-II/japanese.txt

              # Borrar resto de archivos del repositorio
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/.bin/
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/.git/
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/.github/
                rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/.gitattributes
                rm -f ~/HackingTools/WordLists/EnTextoPlano/Packs/SecLists/.gitignore

            ;;

            3)

              echo ""
              echo "  Descargando WordLists de CSL-LABS..."
              echo ""
              # Borrar posible descarga anterior
                rm -rf /tmp/CrackingWordLists/ 2> /dev/null
              # Posicionarse en la carpeta /tmp
                cd /tmp/
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
                rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/ 2> /dev/null
              # Asegurarse de que la carpeta base exista
                mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/ 2> /dev/null
              # Mover carpeta
                mv /tmp/CrackingWordLists/dics/ ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/
              #
                cd ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/
                tar -xvzf ROCKYOU-CSL.tar.gz
                rm -f ROCKYOU-CSL.tar.gz
                #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/ROCKYOU-CSL.txt
                #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/misc/sports.txt
                #rm -rf ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/misc/top_songs.txt
                find ~/HackingTools/WordLists/EnTextoPlano/Packs/CSL-LABS/ -type f -name "*.dic" -exec bash -c 'mv "$0" "${0%.dic}.txt"' {} \;

            ;;

            4)

              echo ""
              echo "  Descargando WordLists de CrackStation..."
              echo ""
              curl -L https://crackstation.net/files/crackstation.txt.gz -o /tmp/crackstation.txt.gz
              cd /tmp/
              gunzip -v /tmp/crackstation.txt.gz
              mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/CrackStation/ 2> /dev/null
              mv /tmp/crackstation.txt ~/HackingTools/WordLists/EnTextoPlano/Packs/CrackStation/

            ;;

            5)

              echo ""
              echo "  Descargando WordList WeakPass 4a..."
              echo ""
              # Comprobar si el paquete p7zip-full está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s p7zip-full 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete p7zip-full no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install p7zip-full
                  echo ""
                fi
              curl -L https://weakpass.com/download/2015/weakpass_4a.txt.7z -o /tmp/weakpass_4a.txt.7z
              mkdir -p ~/HackingTools/WordLists/EnTextoPlano/Packs/WeakPass/4a/ 2> /dev/null
              7z x /tmp/weakpass_4a.txt.7z -o"$HOME""/HackingTools/WordLists/EnTextoPlano/Packs/WeakPass/4a/" -aoa # No hay que dejar espacio entre -o y la ruta del directorio

            ;;

            6)

              echo ""
              echo "  Reservado..."
              echo ""

              #

            ;;

            7)

              echo ""
              echo "  Eliminando caracteres de tabulación..."
              echo ""

              vCarpetaInicio="$HOME/HackingTools/WordLists/EnTextoPlano/Packs/"
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

                vCarpetaInicio="$HOME/HackingTools/WordLists/EnTextoPlano/Packs/"
                vCarpetaDestino="$HOME/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/"
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
                for vArchivo in ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/*.txt; do
                  sed -e 's/^[[:space:]]*//' "$vArchivo" | grep -a -P '^[\x20-\x7E]+$' > "$vArchivo.tmp"
                  mv -f "$vArchivo.tmp" "$vArchivo"
                done

              # Ordenar y eliminar líneas duplicadas
                find "$vCarpetaDestino" -type f -name "*.txt" | while read -r vArchivo; do
                  sort "$vArchivo" | uniq > "$vArchivo.tmp" && mv "$vArchivo.tmp" "$vArchivo"
                done
                echo ""

              # Asegurarse de que cada arhivo tenga la cantidad correcta de caracteres por linea
                for vArchivo in ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All*Characters.txt; do
                  vCantidad=$(basename "$vArchivo" | sed -E 's/All([0-9]+)Characters\.txt/\1/')
                  grep -E "^.{$vCantidad}$" "$vArchivo" > "$vArchivo.tmp"
                  mv -f "$vArchivo.tmp" "$vArchivo"
                done

              # Corregir nombres de los archivos con un sólo número
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All1Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All01Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All2Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All02Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All3Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All03Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All4Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All04Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All5Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All05Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All6Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All06Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All7Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All07Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All8Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All08Characters.txt
                mv ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All9Characters.txt ~/HackingTools/WordLists/EnTextoPlano/PorCantCaracteres/All09Characters.txt

              # Notificar fin de la ejecución
                echo ""
                echo "  Se han procesado todos los .txt de $vCarpetaInicio y se han creado nuevas WordLists con su contenido."
                echo "  Puedes encontrarlas en $vCarpetaDestino"
                echo ""

            ;;

        esac

    done

