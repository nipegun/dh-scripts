#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar OpenVAS en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/OpenVAS-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/OpenVAS-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ServWeb/OpenVAS-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar paquetes requeridos
      echo ""
      echo "  Instalando paquetes requeridos..."
      echo ""
      sudo apt -y update
      sudo apt -y install build-essential
      sudo apt -y install curl
      sudo apt -y install cmake
      sudo apt -y install pkg-config
      sudo apt -y install gnupg
      sudo apt -y install libcjson-dev
      sudo apt -y install libcurl4-openssl-dev
      sudo apt -y install libglib2.0-dev
      sudo apt -y install libgpgme-dev
      sudo apt -y install libgnutls28-dev
      sudo apt -y install uuid-dev
      sudo apt -y install libssh-gcrypt-dev
      sudo apt -y install libhiredis-dev
      sudo apt -y install libxml2-dev
      sudo apt -y install libpcap-dev
      sudo apt -y install libnet1-dev
      sudo apt -y install libpaho-mqtt-dev
      sudo apt -y install libldap2-dev
      sudo apt -y install libradcli-dev
      sudo apt -y install libpq-dev
      sudo apt -y install postgresql-server-dev-15
      sudo apt -y install libical-dev
      sudo apt -y install xsltproc
      sudo apt -y install rsync
      sudo apt -y install libbsd-dev
      sudo apt -y install texlive-latex-extra
      sudo apt -y install texlive-fonts-recommended
      sudo apt -y install xmlstarlet
      sudo apt -y install zip
      sudo apt -y install rpm
      sudo apt -y install fakeroot
      sudo apt -y install dpkg
      sudo apt -y install nsis
      sudo apt -y install gpgsm
      sudo apt -y install wget
      sudo apt -y install sshpass
      sudo apt -y install openssh-client
      sudo apt -y install socat
      sudo apt -y install snmp
      sudo apt -y install python3
      sudo apt -y install smbclient
      sudo apt -y install python3-lxml
      sudo apt -y install gnutls-bin
      sudo apt -y install xml-twig-tools
      sudo apt -y install libmicrohttpd-dev
      sudo apt -y install gcc-mingw-w64
      sudo apt -y install libpopt-dev
      sudo apt -y install libunistring-dev
      sudo apt -y install heimdal-dev
      sudo apt -y install perl-base
      sudo apt -y install bison
      sudo apt -y install libgcrypt20-dev
      sudo apt -y install libksba-dev
      sudo apt -y install nmap
      sudo apt -y install libjson-glib-dev
      sudo apt -y install libsnmp-dev
      sudo apt -y install python3
      sudo apt -y install python3-pip
      sudo apt -y install python3-setuptools
      sudo apt -y install python3-packaging
      sudo apt -y install python3-wrapt
      sudo apt -y install python3-cffi
      sudo apt -y install python3-psutil
      sudo apt -y install python3-lxml
      sudo apt -y install python3-defusedxml
      sudo apt -y install python3-paramiko
      sudo apt -y install python3-redis
      sudo apt -y install python3-gnupg
      sudo apt -y install python3-paho-mqtt
      sudo apt -y install python3-venv
      sudo apt -y install python3-impacket
      sudo apt -y install redis-server
      sudo apt -y install mosquitto
      sudo apt -y install postgresql

    # Establecer variables de entorno
      echo ""
      echo "  Estableciendo variables de entorno..."
      echo ""
      export INSTALL_PREFIX=/usr/local
      export PATH=$PATH:$INSTALL_PREFIX/sbin
      export SOURCE_DIR=$HOME/source
      export BUILD_DIR=$HOME/build
      export INSTALL_DIR=$HOME/install
      export GVM_LIBS_VERSION=22.10.0
      export GVMD_VERSION=23.8.1
      export PG_GVM_VERSION=22.6.5
      export GSA_VERSION=23.2.1
      export GSAD_VERSION=22.11.0
      export OPENVAS_SMB_VERSION=22.5.3
      export OPENVAS_SCANNER_VERSION=23.8.2
      export OSPD_OPENVAS_VERSION=22.7.1
      export NOTUS_VERSION=22.6.3
      export GNUPGHOME=/tmp/openvas-gnupg
      export OPENVAS_GNUPG_HOME=/etc/openvas/gnupg

    # Crear el usuario
      echo ""
      echo "  Creando el usuario..."
      echo ""
      getent passwd gvm > /dev/null 2&>1
      if [ $? -eq 0 ]; then
        echo "    El usuario ya existe..."
      else
        sudo useradd -r -M -U -G sudo -s /usr/sbin/nologin gvm
        sudo usermod -aG gvm $USER
      fi

    # Creando un directorio de origen, compilación e instalación
      sudo mkdir -p $SOURCE_DIR
      sudo mkdir -p $BUILD_DIR
      sudo mkdir -p $INSTALL_DIR

    # Importando la clave de firma de Greenbone
      curl -f -L https://www.greenbone.net/GBCommunitySigningKey.asc -o /tmp/GBCommunitySigningKey.asc
      sudo gpg --import /tmp/GBCommunitySigningKey.asc

    # Compilando e instalando los componentes

      # gvm-libs
        sudo curl -f -L https://github.com/greenbone/gvm-libs/archive/refs/tags/v$GVM_LIBS_VERSION.tar.gz -o $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/gvm-libs/releases/download/v$GVM_LIBS_VERSION/gvm-libs-v$GVM_LIBS_VERSION.tar.gz.asc -o $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/gvm-libs && cd $BUILD_DIR/gvm-libs
        sudo cmake $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
          -DCMAKE_BUILD_TYPE=Release \
          -DSYSCONFDIR=/etc \
          -DLOCALSTATEDIR=/var
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/gvm-libs
        sudo make DESTDIR=$INSTALL_DIR/gvm-libs install
        sudo cp -rv $INSTALL_DIR/gvm-libs/* /

      # gvmd
        sudo curl -f -L https://github.com/greenbone/gvmd/archive/refs/tags/v$GVMD_VERSION.tar.gz -o $SOURCE_DIR/gvmd-$GVMD_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/gvmd/releases/download/v$GVMD_VERSION/gvmd-$GVMD_VERSION.tar.gz.asc -o $SOURCE_DIR/gvmd-$GVMD_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gvmd-$GVMD_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/gvmd && cd $BUILD_DIR/gvmd
        sudo cmake $SOURCE_DIR/gvmd-$GVMD_VERSION \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
          -DCMAKE_BUILD_TYPE=Release \
          -DLOCALSTATEDIR=/var \
          -DSYSCONFDIR=/etc \
          -DGVM_DATA_DIR=/var \
          -DGVMD_RUN_DIR=/run/gvmd \
          -DOPENVAS_DEFAULT_SOCKET=/run/ospd/ospd-openvas.sock \
          -DGVM_FEED_LOCK_PATH=/var/lib/gvm/feed-update.lock \
          -DSYSTEMD_SERVICE_DIR=/lib/systemd/system \
          -DLOGROTATE_DIR=/etc/logrotate.d
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/gvmd
        sudo make DESTDIR=$INSTALL_DIR/gvmd install
        sudo cp -rv $INSTALL_DIR/gvmd/* /

      # pg-gvm
        sudo curl -f -L https://github.com/greenbone/pg-gvm/archive/refs/tags/v$PG_GVM_VERSION.tar.gz -o $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/pg-gvm/releases/download/v$PG_GVM_VERSION/pg-gvm-$PG_GVM_VERSION.tar.gz.asc -o $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/pg-gvm && cd $BUILD_DIR/pg-gvm
        sudo cmake $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION -DCMAKE_BUILD_TYPE=Release
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/pg-gvm
        sudo make DESTDIR=$INSTALL_DIR/pg-gvm install
        sudo cp -rv $INSTALL_DIR/pg-gvm/* /

    # Asistente de seguridad de Greenbone

      # GSA
        sudo curl -f -L https://github.com/greenbone/gsa/releases/download/v$GSA_VERSION/gsa-dist-$GSA_VERSION.tar.gz -o $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/gsa/releases/download/v$GSA_VERSION/gsa-dist-$GSA_VERSION.tar.gz.asc -o $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz.asc
        sudo mkdir -p $SOURCE_DIR/gsa-$GSA_VERSION
        sudo tar -C $SOURCE_DIR/gsa-$GSA_VERSION -xvzf $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz
        sudo mkdir -p $INSTALL_PREFIX/share/gvm/gsad/web/
        sudo cp -rv $SOURCE_DIR/gsa-$GSA_VERSION/* $INSTALL_PREFIX/share/gvm/gsad/web/

      # gsad
        sudo curl -f -L https://github.com/greenbone/gsad/archive/refs/tags/v$GSAD_VERSION.tar.gz -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/gsad/releases/download/v$GSAD_VERSION/gsad-$GSAD_VERSION.tar.gz.asc -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/gsad && cd $BUILD_DIR/gsad
        sudo cmake $SOURCE_DIR/gsad-$GSAD_VERSION \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
          -DCMAKE_BUILD_TYPE=Release \
          -DSYSCONFDIR=/etc \
          -DLOCALSTATEDIR=/var \
          -DGVMD_RUN_DIR=/run/gvmd \
          -DGSAD_RUN_DIR=/run/gsad \
          -DLOGROTATE_DIR=/etc/logrotate.d
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/gsad
        sudo make DESTDIR=$INSTALL_DIR/gsad install
        sudo cp -rv $INSTALL_DIR/gsad/* /

      # openvas-smb
        sudo curl -f -L https://github.com/greenbone/openvas-smb/archive/refs/tags/v$OPENVAS_SMB_VERSION.tar.gz -o $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/openvas-smb/releases/download/v$OPENVAS_SMB_VERSION/openvas-smb-v$OPENVAS_SMB_VERSION.tar.gz.asc -o $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/openvas-smb && cd $BUILD_DIR/openvas-smb
        sudo cmake $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
          -DCMAKE_BUILD_TYPE=Release
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/openvas-smb
        sudo make DESTDIR=$INSTALL_DIR/openvas-smb install
        sudo cp -rv $INSTALL_DIR/openvas-smb/* /

      # openvas-scanner
        sudo curl -f -L https://github.com/greenbone/openvas-scanner/archive/refs/tags/v$OPENVAS_SCANNER_VERSION.tar.gz -o $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/openvas-scanner/releases/download/v$OPENVAS_SCANNER_VERSION/openvas-scanner-v$OPENVAS_SCANNER_VERSION.tar.gz.asc -o $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz
        sudo mkdir -p $BUILD_DIR/openvas-scanner && cd $BUILD_DIR/openvas-scanner
        sudo cmake $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION \
          -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
          -DCMAKE_BUILD_TYPE=Release \
          -DINSTALL_OLD_SYNC_SCRIPT=OFF \
          -DSYSCONFDIR=/etc \
          -DLOCALSTATEDIR=/var \
          -DOPENVAS_FEED_LOCK_PATH=/var/lib/openvas/feed-update.lock \
          -DOPENVAS_RUN_DIR=/run/ospd
        sudo make -j$(nproc)
        sudo mkdir -p $INSTALL_DIR/openvas-scanner
        sudo make DESTDIR=$INSTALL_DIR/openvas-scanner install
        sudo cp -rv $INSTALL_DIR/openvas-scanner/* /

      # ospd-openvas
        sudo curl -f -L https://github.com/greenbone/ospd-openvas/archive/refs/tags/v$OSPD_OPENVAS_VERSION.tar.gz -o $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/ospd-openvas/releases/download/v$OSPD_OPENVAS_VERSION/ospd-openvas-v$OSPD_OPENVAS_VERSION.tar.gz.asc -o $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz
        cd $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION
        sudo mkdir -p $INSTALL_DIR/ospd-openvas
        sudo python3 -m pip install --root=$INSTALL_DIR/ospd-openvas --no-warn-script-location .
        sudo cp -rv $INSTALL_DIR/ospd-openvas/* /

      # notus-scanner
        sudo curl -f -L https://github.com/greenbone/notus-scanner/archive/refs/tags/v$NOTUS_VERSION.tar.gz -o $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz
        sudo curl -f -L https://github.com/greenbone/notus-scanner/releases/download/v$NOTUS_VERSION/notus-scanner-v$NOTUS_VERSION.tar.gz.asc -o $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz.asc
        sudo tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz
        cd $SOURCE_DIR/notus-scanner-$NOTUS_VERSION
        sudo mkdir -p $INSTALL_DIR/notus-scanner
        sudo python3 -m pip install --root=$INSTALL_DIR/notus-scanner --no-warn-script-location .
        sudo cp -rv $INSTALL_DIR/notus-scanner/* /

      # greenbone-feed-sync
        sudo mkdir -p $INSTALL_DIR/greenbone-feed-sync
        sudo python3 -m pip install --root=$INSTALL_DIR/greenbone-feed-sync --no-warn-script-location greenbone-feed-sync
        sudo cp -rv $INSTALL_DIR/greenbone-feed-sync/* /

      # gvm-tools
        sudo mkdir -p $INSTALL_DIR/gvm-tools
        sudo python3 -m pip install --root=$INSTALL_DIR/gvm-tools --no-warn-script-location gvm-tools
        sudo cp -rv $INSTALL_DIR/gvm-tools/* /

      # Realizando la configuración del sistema
        sudo cp $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION/config/redis-openvas.conf /etc/redis/
        sudo chown redis:redis /etc/redis/redis-openvas.conf
        sudo echo "db_address = /run/redis-openvas/redis.sock" | sudo tee -a /etc/openvas/openvas.conf

        sudo systemctl enable redis-server@openvas.service --now
        sudo systemctl status redis-server@openvas.service --no-pager
        sudo usermod -aG redis gvm

      # Configurando el broker MQTT Mosquitto
        sudo systemctl enable mosquitto.service --now
        sudo systemctl status mosquitto.service --no-pager
        echo -e "mqtt_server_uri = localhost:1883\ntable_driven_lsc = yes" | sudo tee -a /etc/openvas/openvas.conf

      # Ajustando permisos
        sudo mkdir -p /var/lib/gvm
        sudo mkdir -p /var/lib/openvas
        sudo mkdir -p /var/lib/notus
        sudo mkdir -p /var/log/gvm

        sudo chown -R gvm:gvm /var/lib/gvm
        sudo chown -R gvm:gvm /var/lib/openvas
        sudo chown -R gvm:gvm /var/lib/notus
        sudo chown -R gvm:gvm /var/log/gvm
        sudo chown -R gvm:gvm /run/gvmd     ######## Error

        sudo chmod -R g+srw /var/lib/gvm
        sudo chmod -R g+srw /var/lib/openvas
        sudo chmod -R g+srw /var/log/gvm

        sudo chown gvm:gvm /usr/local/sbin/gvmd
        sudo chmod 6750 /usr/local/sbin/gvmd

      # Validación de fuentes
        curl -f -L https://www.greenbone.net/GBCommunitySigningKey.asc -o /tmp/GBCommunitySigningKey.asc
        sudo mkdir -p $GNUPGHOME
        sudo gpg --import /tmp/GBCommunitySigningKey.asc
        echo "8AE4BE429B60A59B311C2E739823FAA60ED1E580:6:" | sudo gpg --import-ownertrust
        sudo mkdir -p $OPENVAS_GNUPG_HOME
        sudo cp -r /tmp/openvas-gnupg/* $OPENVAS_GNUPG_HOME/ ########### Error
        sudo chown -R gvm:gvm $OPENVAS_GNUPG_HOME

      # Configurar sudo para escaneo
        if sudo grep -Fxq "%gvm ALL = NOPASSWD: /usr/local/sbin/openvas" /etc/sudoers; then
          echo "Los usuarios del grupo gvm ya están configurados para ejecutar la aplicación openvas-scanner como usuario root a través de sudo."
        else
          echo "%gvm ALL = NOPASSWD: /usr/local/sbin/openvas" | sudo tee -a /etc/sudoers
          echo "Se han configurado los usuarios del grupo gvm para ejecutar la aplicación openvas-scanner como usuario root a través de sudo."
        fi

      # Configurando PostgreSQL
        echo "Iniciando PostgreSQL..."
        sudo systemctl start postgresql
        echo "Configurar el usuario gvm, la base de datos gvmd y asignar permisos en PostgreSQL."
        sudo runuser -l postgres -c 'createuser -DRS gvm'
        sudo runuser -l postgres -c 'createdb -O gvm gvmd'
        sudo runuser -l postgres -c 'psql gvmd -c "create role dba with superuser noinherit; grant dba to gvm;"'
      # Corrigir errores al iniciar gvmd: https://github.com/libellux/Libellux-Up-and-Running/issues/50
        echo "Crear los enlaces necesarios y la caché para las bibliotecas compartidas más recientes."
        sudo ldconfig -v

      # Configurando un usuario administrador
        echo "Creando el usuario administrador..."
        sudo /usr/local/sbin/gvmd --create-user=admin

      # Estableciendo el propietario de la importación de fuentes
        echo "Estableciendo el usuario administrador como el propietario de la importación de feeds."
        sudo /usr/local/sbin/gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value `sudo /usr/local/sbin/gvmd --get-users --verbose | grep admin | awk '{print $2}'`

      # Configurando servicios para Systemd
        echo "[Unit]"                                                                                 | sudo tee    $BUILD_DIR/ospd-openvas.service
        echo "Description=OSPd Wrapper for the OpenVAS Scanner (ospd-openvas)"                        | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "Documentation=man:ospd-openvas(8) man:openvas(8)"                                       | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "After=network.target networking.service redis-server@openvas.service mosquitto.service" | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "Wants=redis-server@openvas.service mosquitto.service notus-scanner.service"             | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "ConditionKernelCommandLine=!recovery"                                                   | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo ""                                                                                       | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "[Service]"                                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "Type=exec"                                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "User=gvm"                                                                               | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "Group=gvm"                                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "RuntimeDirectory=ospd"                                                                  | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "RuntimeDirectoryMode=2775"                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "PIDFile=/run/ospd/ospd-openvas.pid"                                                     | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "ExecStart=/usr/local/bin/ospd-openvas --foreground --unix-socket /run/ospd/ospd-openvas.sock --pid-file /run/ospd/ospd-openvas.pid --log-file /var/log/gvm/ospd-openvas.log --lock-file-dir /var/lib/openvas --socket-mode 0o770 --mqtt-broker-address localhost --mqtt-broker-port 1883 --notus-feed-dir /var/lib/notus/advisories" | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "SuccessExitStatus=SIGKILL"                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "Restart=always"                                                                         | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "RestartSec=60"                                                                          | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo ""                                                                                       | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "[Install]"                                                                              | sudo tee -a $BUILD_DIR/ospd-openvas.service
        echo "WantedBy=multi-user.target"                                                             | sudo tee -a $BUILD_DIR/ospd-openvas.service
        sudo cp -v $BUILD_DIR/ospd-openvas.service /etc/systemd/system/

        echo "[Unit]"                                                                                                                                     | sudo tee    $BUILD_DIR/notus-scanner.service
        echo "Description=Notus Scanner"                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "Documentation=https://github.com/greenbone/notus-scanner"                                                                                   | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "After=mosquitto.service"                                                                                                                    | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "Wants=mosquitto.service"                                                                                                                    | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "ConditionKernelCommandLine=!recovery"                                                                                                       | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo ""                                                                                                                                           | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "[Service]"                                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "Type=exec"                                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "User=gvm"                                                                                                                                   | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "RuntimeDirectory=notus-scanner"                                                                                                             | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "RuntimeDirectoryMode=2775"                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "PIDFile=/run/notus-scanner/notus-scanner.pid"                                                                                               | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "ExecStart=/usr/local/bin/notus-scanner --foreground --products-directory /var/lib/notus/products --log-file /var/log/gvm/notus-scanner.log" | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "SuccessExitStatus=SIGKILL"                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "Restart=always"                                                                                                                             | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "RestartSec=60"                                                                                                                              | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo ""                                                                                                                                           | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "[Install]"                                                                                                                                  | sudo tee -a $BUILD_DIR/notus-scanner.service
        echo "WantedBy=multi-user.target"                                                                                                                 | sudo tee -a $BUILD_DIR/notus-scanner.service
        sudo cp -v $BUILD_DIR/notus-scanner.service /etc/systemd/system/

        echo "[Unit]"                                                                                                     | sudo tee    $BUILD_DIR/gvmd.service
        echo "Description=Greenbone Vulnerability Manager daemon (gvmd)"                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "After=network.target networking.service postgresql.service ospd-openvas.service"                            | sudo tee -a $BUILD_DIR/gvmd.service
        echo "Wants=postgresql.service ospd-openvas.service"                                                              | sudo tee -a $BUILD_DIR/gvmd.service
        echo "Documentation=man:gvmd(8)"                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "ConditionKernelCommandLine=!recovery"                                                                       | sudo tee -a $BUILD_DIR/gvmd.service
        echo ""                                                                                                           | sudo tee -a $BUILD_DIR/gvmd.service
        echo "[Service]"                                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "Type=exec"                                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "User=gvm"                                                                                                   | sudo tee -a $BUILD_DIR/gvmd.service
        echo "Group=gvm"                                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "PIDFile=/run/gvmd/gvmd.pid"                                                                                 | sudo tee -a $BUILD_DIR/gvmd.service
        echo "RuntimeDirectory=gvmd"                                                                                      | sudo tee -a $BUILD_DIR/gvmd.service
        echo "RuntimeDirectoryMode=2775"                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "ExecStart=/usr/local/sbin/gvmd --foreground --osp-vt-update=/run/ospd/ospd-openvas.sock --listen-group=gvm" | sudo tee -a $BUILD_DIR/gvmd.service
        echo "Restart=always"                                                                                             | sudo tee -a $BUILD_DIR/gvmd.service
        echo "TimeoutStopSec=10"                                                                                          | sudo tee -a $BUILD_DIR/gvmd.service
        echo ""                                                                                                           | sudo tee -a $BUILD_DIR/gvmd.service
        echo "[Install]"                                                                                                  | sudo tee -a $BUILD_DIR/gvmd.service
        echo "WantedBy=multi-user.target"                                                                                 | sudo tee -a $BUILD_DIR/gvmd.service
        sudo cp -v $BUILD_DIR/gvmd.service /etc/systemd/system/

        echo "[Unit]"                                                                               | sudo tee -a $BUILD_DIR/gsad.service
        echo ""                                                                                     | sudo tee -a $BUILD_DIR/gsad.service
        echo "Description=Greenbone Security Assistant daemon (gsad)"                               | sudo tee -a $BUILD_DIR/gsad.service
        echo "Documentation=man:gsad(8) https://www.greenbone.net"                                  | sudo tee -a $BUILD_DIR/gsad.service
        echo "After=network.target gvmd.service"                                                    | sudo tee -a $BUILD_DIR/gsad.service
        echo "Wants=gvmd.service"                                                                   | sudo tee -a $BUILD_DIR/gsad.service
        echo ""                                                                                     | sudo tee -a $BUILD_DIR/gsad.service
        echo "[Service]"                                                                            | sudo tee -a $BUILD_DIR/gsad.service
        echo "Type=exec"                                                                            | sudo tee -a $BUILD_DIR/gsad.service
        echo "User=gvm"                                                                             | sudo tee -a $BUILD_DIR/gsad.service
        echo "Group=gvm"                                                                            | sudo tee -a $BUILD_DIR/gsad.service
        echo "RuntimeDirectory=gsad"                                                                | sudo tee -a $BUILD_DIR/gsad.service
        echo "RuntimeDirectoryMode=2775"                                                            | sudo tee -a $BUILD_DIR/gsad.service
        echo "PIDFile=/run/gsad/gsad.pid"                                                           | sudo tee -a $BUILD_DIR/gsad.service
        echo "ExecStart=/usr/local/sbin/gsad --foreground --listen=0.0.0.0 --port=9392 --http-only" | sudo tee -a $BUILD_DIR/gsad.service
        echo "Restart=always"                                                                       | sudo tee -a $BUILD_DIR/gsad.service
        echo "TimeoutStopSec=10"                                                                    | sudo tee -a $BUILD_DIR/gsad.service
        echo ""                                                                                     | sudo tee -a $BUILD_DIR/gsad.service
        echo "[Install]"                                                                            | sudo tee -a $BUILD_DIR/gsad.service
        echo "WantedBy=multi-user.target"                                                           | sudo tee -a $BUILD_DIR/gsad.service
        echo "Alias=greenbone-security-assistant.service"                                           | sudo tee -a $BUILD_DIR/gsad.service
        sudo cp -v $BUILD_DIR/gsad.service /etc/systemd/system/

        sudo systemctl daemon-reload

      # Descargar las fuentes de OpenVAS
        echo "Descargar los feeds de OpenVAS. Esto tomará tiempo, no interrumpas este proceso."
        sudo /usr/local/bin/greenbone-feed-sync

        # Activar e iniciar los servicios
          echo ""
          echo "  Activando e iniciando los servicios..."
          echo ""
          sudo systemctl enable notus-scanner --now
          sudo systemctl enable ospd-openvas  --now
          sudo systemctl enable gvmd          --now
          sudo systemctl enable gsad          --now

        # Mostrar el estado de los servicios
          echo ""
          echo "  Mostrando el estado de los servicios..."
          echo ""
          sudo systemctl status notus-scanner --no-pager
          sudo systemctl status ospd-openvas  --no-pager
          sudo systemctl status gvmd          --no-pager
          sudo systemctl status gsad          --no-pager

      # Ponerle password al admin
        sudo -u gvm gvmd --user=admin --new-password=admin
      
      # Notificar fin de ejecución del script
        echo ""
        echo "  El script de instalación de OpenVAS ha finalizado. Para conectarse a la web:"
        echo ""
        vIPGreenBone=$(hostname -I | sed 's- --g')
        echo "    http://$vIPGreenBone:9392"
        echo ""
        echo "    Usuario: admin"
        echo "    Contraseña: admin"
        echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
