#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Dockers para atacar en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | nano -
#
# Más información aquí: https://github.com/vulhub/vulhub
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
      1 "Descargar repo de Github de dockers vulnerables de vulhub" on
      2 "Comprobar disponibilidad de docker-compose"                on
      3 "  Construir la imagen de x"                                off
      4 "  Construir la imagen de x"                                off
      5 "  Construir la imagen de x"                                off
      6 "  Construir la imagen de x"                                off
      7 "  Construir la imagen de x"                                off
      8 "  Construir la imagen de x"                                off
      9 "  Construir la imagen de x"                                off
     10 "  Construir la imagen de x"                                off
     11 "  Construir la imagen de x"                                off
     12 "  Construir la imagen de x"                                off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Descargando repo de Github de dockers vulnerables de vulhub..."
          echo ""
          # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install curl
              echo ""
            fi
          sudo rm -f /tmp/vulhub-master.zip 2> /dev/null
          curl -L https://github.com/vulhub/vulhub/archive/master.zip -o /tmp/vulhub-master.zip
          cd /tmp/
          # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}    El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install unzip
              echo ""
            fi
          sudo rm -rf /tmp/vulhub-master/ 2> /dev/null
          unzip vulhub-master.zip
          cd vulhub-master

        ;;

        2)

          echo ""
          echo "  Comprobando disponibilidad de docker-compose..."
          echo ""
          # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}    El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install docker-compose
              echo ""
            fi

        ;;

        3)

          echo ""
          echo "  Construyendo la imagen de appweb (CVE-2018-8715)..."
          echo ""
          cd /tmp/vulhub-master/appweb/CVE-2018-8715/
          sudo docker compose build
          sudo docker compose up -d

        ;;

        4)

          echo ""
          echo "  Construyendo la imagen de bash (CVE-2014-6271)..."
          echo ""
          cd /tmp/vulhub-master/bash/CVE-2014-6271/
          sudo docker compose build
          sudo docker compose up -d

        ;;


        5)

          echo ""
          echo "  Construyendo la imagen de cgi (CVE-2016-5385)..."
          echo ""
          cd /tmp/vulhub-master/cgi/CVE-2016-5385/
          sudo docker compose build
          sudo docker compose up -d

        ;;

        6)

          echo ""
          echo "  Construyendo la imagen de confluence (CVE-2023-22527)..."
          echo ""
          cd /tmp/vulhub-master/confluence/CVE-2023-22527/
          sudo docker compose build
          sudo docker compose up -d

        ;;

        7)

          echo ""
          echo "  Construyendo la imagen de django (CVE-2022-34265)..."
          echo ""
          cd /tmp/vulhub-master/django/CVE-2022-34265/
          sudo docker compose build
          sudo docker compose up -d

        ;;

        8)

          echo ""
          echo "  Construyendo la imagen de dns-zone-transfer..."
          echo ""
          cd /tmp/vulhub-master/dns-zone-transfer/
          sudo docker compose build
          sudo docker compose up -d

        ;;

        9)

          echo ""
          echo "  Construyendo la imagen de drupal (CVE-2019-6341)..."
          echo ""
          cd /tmp/vulhub-master/drupal/CVE-2019-6341/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       10)

          echo ""
          echo "  Construyendo la imagen de elasticsearch (CVE-2015-5531)..."
          echo ""
          cd /tmp/vulhub-master/elasticsearch/CVE-2015-5531/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       11)

          echo ""
          echo "  Construyendo la imagen de ffmpeg (CVE-2017-9993)..."
          echo ""
          cd /tmp/vulhub-master/ffmpeg/CVE-2017-9993/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       12)

          echo ""
          echo "  Construyendo la imagen de geoserver (CVE-2024-36401)..."
          echo ""
          cd /tmp/vulhub-master/geoserver/CVE-2024-36401/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       13)

          echo ""
          echo "  Construyendo la imagen de ghostscript (CVE-2019-6116)..."
          echo ""
          cd /tmp/vulhub-master/ghostscript/CVE-2019-6116/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       14)

          echo ""
          echo "  Construyendo la imagen de git (CVE-2017-8386)..."
          echo ""
          cd /tmp/vulhub-master/git/CVE-2017-8386/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       15)

          echo ""
          echo "  Construyendo la imagen de gitlab (CVE-2021-22205)..."
          echo ""
          cd /tmp/vulhub-master/gitlab/CVE-2021-22205/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       16)

          echo ""
          echo "  Construyendo la imagen de grafana (CVE-2021-43798)..."
          echo ""
          cd /tmp/vulhub-master/grafana/CVE-2021-43798/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       17)

          echo ""
          echo "  Construyendo la imagen de grafana (admin-ssrf)..."
          echo ""
          cd /tmp/vulhub-master/grafana/admin-ssrf/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       18)

          echo ""
          echo "  Construyendo la imagen de httpd (CVE-2021-42013)..."
          echo ""
          cd /tmp/vulhub-master/httpd/CVE-2021-42013/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       19)

          echo ""
          echo "  Construyendo la imagen de imagemagick (CVE-2022-44268)..."
          echo ""
          cd /tmp/vulhub-master/imagemagick/CVE-2022-44268/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       20)

          echo ""
          echo "  Construyendo la imagen de influxdb (CVE-2019-20933)..."
          echo ""
          cd /tmp/vulhub-master/influxdb/CVE-2019-20933/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       21)

          echo ""
          echo "  Construyendo la imagen de jenkins (CVE-2024-23897)..."
          echo ""
          cd /tmp/vulhub-master/jenkins/CVE-2024-23897/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       22)

          echo ""
          echo "  Construyendo la imagen de joomla (CVE-2023-23752)..."
          echo ""
          cd /tmp/vulhub-master/joomla/CVE-2023-23752/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       23)

          echo ""
          echo "  Construyendo la imagen de kibana (CVE-2020-7012)..."
          echo ""
          cd /tmp/vulhub-master/kibana/CVE-2020-7012/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       24)

          echo ""
          echo "  Construyendo la imagen de libssh (CVE-2018-10933)..."
          echo ""
          cd /tmp/vulhub-master/libssh/CVE-2018-10933/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       25)

          echo ""
          echo "  Construyendo la imagen de magento (2.2-sqli)..."
          echo ""
          cd /tmp/vulhub-master/magento/2.2-sqli/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       26)

          echo ""
          echo "  Construyendo la imagen de mongo-express (CVE-2019-10758)..."
          echo ""
          cd /tmp/vulhub-master/mongo-express/CVE-2019-10758/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       27)

          echo ""
          echo "  Construyendo la imagen de mysql (CVE-2012-2122)..."
          echo ""
          cd /tmp/vulhub-master/mysql/CVE-2012-2122/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       28)

          echo ""
          echo "  Construyendo la imagen de nexus (CVE-2024-4956)..."
          echo ""
          cd /tmp/vulhub-master/nexus/CVE-2024-4956/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       29)

          echo ""
          echo "  Construyendo la imagen de nginx (CVE-2017-7529)..."
          echo ""
          cd /tmp/vulhub-master/nginx/CVE-2017-7529/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       30)

          echo ""
          echo "  Construyendo la imagen de nginx (insecure-configuration)..."
          echo ""
          cd /tmp/vulhub-master/nginx/insecure-configuration/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       31)

          echo ""
          echo "  Construyendo la imagen de nginx (nginx-parsing-vulnerability)..."
          echo ""
          cd /tmp/vulhub-master/nginx/nginx-parsing-vulnerability/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       32)

          echo ""
          echo "  Construyendo la imagen de node (CVE-2017-16082)..."
          echo ""
          cd /tmp/vulhub-master/node/CVE-2017-16082/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       33)

          echo ""
          echo "  Construyendo la imagen de ntopng (CVE-2021-28073)..."
          echo ""
          cd /tmp/vulhub-master/ntopng/CVE-2021-28073/
          sudo docker compose build
          sudo docker compose up -d

        ;;

       34)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       35)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       36)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       37)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       38)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       39)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       40)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

       41)

          echo ""
          echo "  Construyendo la imagen de x..."
          echo ""
          cd /tmp/vulhub-master/x
          sudo docker compose build
          sudo docker compose up -d

        ;;

    esac

done
