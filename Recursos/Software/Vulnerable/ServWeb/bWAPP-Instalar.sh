#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar bWAPP en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/bWAPP-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/bWAPP-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/Vulnerable/ServWeb/bWAPP-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar el servidor web
      echo ""
      echo "    Instalando el servidor web..."
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install apache2

    # Instalar php
      echo ""
      echo "    Instalando PHP..."
      echo ""
      sudo apt-get -y install php
      sudo apt-get -y install libapache2-mod-php

    # Instalar el servidor de bases de datos
      echo ""
      echo "    Instalando el servidor de bases de datos..."
      echo ""
      sudo apt-get -y install mariadb-server
      # Agregar o cambiar la contraseña al usuario root de MySQL
        sudo mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootMySQL'; FLUSH PRIVILEGES;"
      # Crear la base de datos
        sudo mysql -uroot -prootMySQL -e "CREATE DATABASE bWAPP;"
      # Asegurar el servidor (opcional)
        #sudo mysql_secure_installation
      # Instalar compatibilidad de PHO con mysql
        sudo apt-get -y install php-mysql

    # Obtener el número de la última versión disponible
      echo ""
      echo "    Obteniendo el número de la última vesión de bWAPP disponible..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      vNumVers=$(curl -sL https://sourceforge.net/projects/bwapp/files/bWAPP/ | sed 's->->\n-g' | grep bWAPPv | grep title | grep v[0-9] | grep folder | cut -d'"' -f2 | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      El número de la última versión es $vNumVers"
      echo ""
      
    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      curl -L https://downloads.sourceforge.net/project/bwapp/bWAPP/bWAPPv"$vNumVers"/bWAPPv"$vNumVers".zip -o /tmp/bWAPP.zip

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/bWAPP.zip -d /tmp/bWAPPv"$vNumVers"

    # Mover carpeta a la raíz del servidor web
      echo ""
      echo "    Moviendo archivos a la raiz del servidor web..."
      echo ""
      sudo mkdir -p /var/www/bWAPP/
      sudo mv /tmp/bWAPPv"$vNumVers"/bWAPP/ /var/www/
      sudo mkdir /var/www/bWAPP/logs/
      sudo chown www-data:www-data /var/www/ -R

    # Dar permisos absolutos a las carpetas 'passwords', 'images', 'documents' and 'logs'.
    # Es opcional, pero permite jugar con sqlmap and Metasploit.
      sudo chmod 777 /var/www/bWAPP/passwords/
      sudo chmod 777 /var/www/bWAPP/images/
      sudo chmod 777 /var/www/bWAPP/documents/
      sudo chmod 777 /var/www/bWAPP/logs/

    # Modificar configuración relativa a la base de datos en algunos archivos .php
      sudo sed -i -e 's|$db_password = "";|$db_password = "rootMySQL";|g' /var/www/bWAPP/admin/settings.php
      sudo sed -i -e 's|if(!mysqli_select_db($link,"bWAPP"))|if(mysqli_select_db($link,"bWAPP"))|g' /var/www/bWAPP/install.php

    # Instalar compatibilidad con SSL
      echo ""
      echo "    Instalando compatibilidad con SSL..."
      echo ""
      sudo apt-get -y install openssl

    # Crear el certificado auto-firmado
      echo ""
      echo "    Creando el certificado autofirmado..."
      echo ""
      echo "[req]"                        > /tmp/openssl.cnf
      echo "default_bits       = 2048"   >> /tmp/openssl.cnf
      echo "prompt             = no"     >> /tmp/openssl.cnf
      echo "default_md         = sha256" >> /tmp/openssl.cnf
      echo "distinguished_name = dn"     >> /tmp/openssl.cnf
      echo ""                            >> /tmp/openssl.cnf
      echo "[dn]"                        >> /tmp/openssl.cnf
      echo "C  = ES"                     >> /tmp/openssl.cnf
      echo "ST = Madrid"                 >> /tmp/openssl.cnf
      echo "L  = Madrid"                 >> /tmp/openssl.cnf
      echo "O  = bWAPP"                  >> /tmp/openssl.cnf
      echo "OU = bWAPPMiUnidad"          >> /tmp/openssl.cnf
      echo "CN = bWAPP.com"              >> /tmp/openssl.cnf
      sudo mkdir /etc/apache2/ssl
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/autocertssl.key -out /etc/apache2/ssl/autocertssl.crt -config /tmp/openssl.cnf

    # Habilitar la configuración de bWAPP para apache
      echo ""
      echo "    Habilitar la configuración de bWAPP para apache..."
      echo ""
      echo '<VirtualHost *:80>'                                       | sudo tee    /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerAdmin webmaster@localhost'                        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo ''                                                         | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '<VirtualHost *:443>'                                      | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerName yourdomain.com'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLEngine on'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateFile    /etc/apache2/ssl/autocertssl.crt' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateKeyFile /etc/apache2/ssl/autocertssl.key' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  <Directory /var/www/html>'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '    AllowOverride All'                                    | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  </Directory>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf

    # Activar el módullo SSL de apache
      echo ""
      echo "    Activando el módulo SSL de apache..."
      echo ""
      sudo a2enmod ssl

    # Deshabilitar el sistio web por defecto de apache
      echo ""
      echo "    Deshabilitando los sitios por defecto de apache..."
      echo ""
      sudo a2dissite 000-default
      sudo a2dissite default-ssl.conf

    # Activar el sitio
      echo ""
      echo "    Activando el sitio..."
      echo ""
      sudo a2ensite bWAPP
      sudo systemctl reload apache2
      sudo systemctl restart apache2
      sudo systemctl status apache2 --no-pager

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Para ejecutar la instalación, visita en un navegador:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal/install.php"
      echo ""
      echo "    Luego entra en:"
      echo ""
      echo "      example: https://$vIPLocal/login.php"
      echo ""
      echo "    ...y loguéate con las credenciales bee/bug"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Instalar el servidor web
      echo ""
      echo "    Instalando el servidor web..."
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install apache2

    # Instalar php
      echo ""
      echo "    Instalando PHP..."
      echo ""
      sudo apt-get -y install php
      sudo apt-get -y install libapache2-mod-php

    # Instalar el servidor de bases de datos
      echo ""
      echo "    Instalando el servidor de bases de datos..."
      echo ""
      sudo apt-get -y install mariadb-server
      # Agregar o cambiar la contraseña al usuario root de MySQL
        sudo mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootMySQL'; FLUSH PRIVILEGES;"
      # Crear la base de datos
        sudo mysql -uroot -prootMySQL -e "CREATE DATABASE bWAPP;"
      # Asegurar el servidor (opcional)
        #sudo mysql_secure_installation
      # Instalar compatibilidad de PHO con mysql
        sudo apt-get -y install php-mysql

    # Obtener el número de la última versión disponible
      echo ""
      echo "    Obteniendo el número de la última vesión de bWAPP disponible..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      vNumVers=$(curl -sL https://sourceforge.net/projects/bwapp/files/bWAPP/ | sed 's->->\n-g' | grep bWAPPv | grep title | grep v[0-9] | grep folder | cut -d'"' -f2 | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      El número de la última versión es $vNumVers"
      echo ""
      
    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      curl -L https://downloads.sourceforge.net/project/bwapp/bWAPP/bWAPPv"$vNumVers"/bWAPPv"$vNumVers".zip -o /tmp/bWAPP.zip

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/bWAPP.zip -d /tmp/bWAPPv"$vNumVers"

    # Mover carpeta a la raíz del servidor web
      echo ""
      echo "    Moviendo archivos a la raiz del servidor web..."
      echo ""
      sudo mkdir -p /var/www/bWAPP/
      sudo mv /tmp/bWAPPv"$vNumVers"/bWAPP/ /var/www/
      sudo mkdir /var/www/bWAPP/logs/
      sudo chown www-data:www-data /var/www/ -R

    # Dar permisos absolutos a las carpetas 'passwords', 'images', 'documents' and 'logs'.
    # Es opcional, pero permite jugar con sqlmap and Metasploit.
      sudo chmod 777 /var/www/bWAPP/passwords/
      sudo chmod 777 /var/www/bWAPP/images/
      sudo chmod 777 /var/www/bWAPP/documents/
      sudo chmod 777 /var/www/bWAPP/logs/

    # Modificar configuración relativa a la base de datos en algunos archivos .php
      sudo sed -i -e 's|$db_password = "";|$db_password = "rootMySQL";|g' /var/www/bWAPP/admin/settings.php
      sudo sed -i -e 's|if(!mysqli_select_db($link,"bWAPP"))|if(mysqli_select_db($link,"bWAPP"))|g' /var/www/bWAPP/install.php

    # Instalar compatibilidad con SSL
      echo ""
      echo "    Instalando compatibilidad con SSL..."
      echo ""
      sudo apt-get -y install openssl

    # Crear el certificado auto-firmado
      echo ""
      echo "    Creando el certificado autofirmado..."
      echo ""
      echo "[req]"                        > /tmp/openssl.cnf
      echo "default_bits       = 2048"   >> /tmp/openssl.cnf
      echo "prompt             = no"     >> /tmp/openssl.cnf
      echo "default_md         = sha256" >> /tmp/openssl.cnf
      echo "distinguished_name = dn"     >> /tmp/openssl.cnf
      echo ""                            >> /tmp/openssl.cnf
      echo "[dn]"                        >> /tmp/openssl.cnf
      echo "C  = ES"                     >> /tmp/openssl.cnf
      echo "ST = Madrid"                 >> /tmp/openssl.cnf
      echo "L  = Madrid"                 >> /tmp/openssl.cnf
      echo "O  = bWAPP"                  >> /tmp/openssl.cnf
      echo "OU = bWAPPMiUnidad"          >> /tmp/openssl.cnf
      echo "CN = bWAPP.com"              >> /tmp/openssl.cnf
      sudo mkdir /etc/apache2/ssl
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/autocertssl.key -out /etc/apache2/ssl/autocertssl.crt -config /tmp/openssl.cnf

    # Habilitar la configuración de bWAPP para apache
      echo ""
      echo "    Habilitar la configuración de bWAPP para apache..."
      echo ""
      echo '<VirtualHost *:80>'                                       | sudo tee    /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerAdmin webmaster@localhost'                        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo ''                                                         | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '<VirtualHost *:443>'                                      | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerName yourdomain.com'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLEngine on'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateFile    /etc/apache2/ssl/autocertssl.crt' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateKeyFile /etc/apache2/ssl/autocertssl.key' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  <Directory /var/www/html>'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '    AllowOverride All'                                    | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  </Directory>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf

    # Activar el módullo SSL de apache
      echo ""
      echo "    Activando el módulo SSL de apache..."
      echo ""
      sudo a2enmod ssl

    # Deshabilitar el sistio web por defecto de apache
      echo ""
      echo "    Deshabilitando los sitios por defecto de apache..."
      echo ""
      sudo a2dissite 000-default
      sudo a2dissite default-ssl.conf

    # Activar el sitio
      echo ""
      echo "    Activando el sitio..."
      echo ""
      sudo a2ensite bWAPP
      sudo systemctl reload apache2
      sudo systemctl restart apache2
      sudo systemctl status apache2 --no-pager

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Para ejecutar la instalación, visita en un navegador:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal/install.php"
      echo ""
      echo "    Luego entra en:"
      echo ""
      echo "      example: https://$vIPLocal/login.php"
      echo ""
      echo "    ...y loguéate con las credenciales bee/bug"
      echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 10 (Buster)...${cFinColor}"
    echo ""

    # Instalar el servidor web
      echo ""
      echo "    Instalando el servidor web..."
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install apache2

    # Instalar php
      echo ""
      echo "    Instalando PHP..."
      echo ""
      sudo apt-get -y install php
      sudo apt-get -y install libapache2-mod-php

    # Instalar el servidor de bases de datos
      echo ""
      echo "    Instalando el servidor de bases de datos..."
      echo ""
      sudo apt-get -y install mariadb-server
      # Agregar o cambiar la contraseña al usuario root de MySQL
        sudo mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootMySQL'; FLUSH PRIVILEGES;"
      # Crear la base de datos
        sudo mysql -uroot -prootMySQL -e "CREATE DATABASE bWAPP;"
      # Asegurar el servidor (opcional)
        #sudo mysql_secure_installation
      # Instalar compatibilidad de PHO con mysql
        sudo apt-get -y install php-mysql

    # Obtener el número de la última versión disponible
      echo ""
      echo "    Obteniendo el número de la última vesión de bWAPP disponible..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      vNumVers=$(curl -sL https://sourceforge.net/projects/bwapp/files/bWAPP/ | sed 's->->\n-g' | grep bWAPPv | grep title | grep v[0-9] | grep folder | cut -d'"' -f2 | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      El número de la última versión es $vNumVers"
      echo ""
      
    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      curl -L https://downloads.sourceforge.net/project/bwapp/bWAPP/bWAPPv"$vNumVers"/bWAPPv"$vNumVers".zip -o /tmp/bWAPP.zip

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/bWAPP.zip -d /tmp/bWAPPv"$vNumVers"

    # Mover carpeta a la raíz del servidor web
      echo ""
      echo "    Moviendo archivos a la raiz del servidor web..."
      echo ""
      sudo mkdir -p /var/www/bWAPP/
      sudo mv /tmp/bWAPPv"$vNumVers"/bWAPP/ /var/www/
      sudo mkdir /var/www/bWAPP/logs/
      sudo chown www-data:www-data /var/www/ -R

    # Dar permisos absolutos a las carpetas 'passwords', 'images', 'documents' and 'logs'.
    # Es opcional, pero permite jugar con sqlmap and Metasploit.
      sudo chmod 777 /var/www/bWAPP/passwords/
      sudo chmod 777 /var/www/bWAPP/images/
      sudo chmod 777 /var/www/bWAPP/documents/
      sudo chmod 777 /var/www/bWAPP/logs/

    # Modificar configuración relativa a la base de datos en algunos archivos .php
      sudo sed -i -e 's|$db_password = "";|$db_password = "rootMySQL";|g' /var/www/bWAPP/admin/settings.php
      sudo sed -i -e 's|if(!mysqli_select_db($link,"bWAPP"))|if(mysqli_select_db($link,"bWAPP"))|g' /var/www/bWAPP/install.php

    # Instalar compatibilidad con SSL
      echo ""
      echo "    Instalando compatibilidad con SSL..."
      echo ""
      sudo apt-get -y install openssl

    # Crear el certificado auto-firmado
      echo ""
      echo "    Creando el certificado autofirmado..."
      echo ""
      echo "[req]"                        > /tmp/openssl.cnf
      echo "default_bits       = 2048"   >> /tmp/openssl.cnf
      echo "prompt             = no"     >> /tmp/openssl.cnf
      echo "default_md         = sha256" >> /tmp/openssl.cnf
      echo "distinguished_name = dn"     >> /tmp/openssl.cnf
      echo ""                            >> /tmp/openssl.cnf
      echo "[dn]"                        >> /tmp/openssl.cnf
      echo "C  = ES"                     >> /tmp/openssl.cnf
      echo "ST = Madrid"                 >> /tmp/openssl.cnf
      echo "L  = Madrid"                 >> /tmp/openssl.cnf
      echo "O  = bWAPP"                  >> /tmp/openssl.cnf
      echo "OU = bWAPPMiUnidad"          >> /tmp/openssl.cnf
      echo "CN = bWAPP.com"              >> /tmp/openssl.cnf
      sudo mkdir /etc/apache2/ssl
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/autocertssl.key -out /etc/apache2/ssl/autocertssl.crt -config /tmp/openssl.cnf

    # Habilitar la configuración de bWAPP para apache
      echo ""
      echo "    Habilitar la configuración de bWAPP para apache..."
      echo ""
      echo '<VirtualHost *:80>'                                       | sudo tee    /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerAdmin webmaster@localhost'                        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo ''                                                         | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '<VirtualHost *:443>'                                      | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerName yourdomain.com'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLEngine on'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateFile    /etc/apache2/ssl/autocertssl.crt' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateKeyFile /etc/apache2/ssl/autocertssl.key' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  <Directory /var/www/html>'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '    AllowOverride All'                                    | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  </Directory>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf

    # Activar el módullo SSL de apache
      echo ""
      echo "    Activando el módulo SSL de apache..."
      echo ""
      sudo a2enmod ssl

    # Deshabilitar el sistio web por defecto de apache
      echo ""
      echo "    Deshabilitando los sitios por defecto de apache..."
      echo ""
      sudo a2dissite 000-default
      sudo a2dissite default-ssl.conf

    # Activar el sitio
      echo ""
      echo "    Activando el sitio..."
      echo ""
      sudo a2ensite bWAPP
      sudo systemctl reload apache2
      sudo systemctl restart apache2
      sudo systemctl status apache2 --no-pager

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Para ejecutar la instalación, visita en un navegador:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal/install.php"
      echo ""
      echo "    Luego entra en:"
      echo ""
      echo "      example: https://$vIPLocal/login.php"
      echo ""
      echo "    ...y loguéate con las credenciales bee/bug"
      echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    # Poner repositorios
      cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori
      echo "deb http://archive.debian.org/debian/ stretch main contrib non-free"      > /etc/apt/sources.list
      echo "deb-src http://archive.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list

    # Instalar el servidor web
      echo ""
      echo "    Instalando el servidor web..."
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install apache2

    # Instalar php
      echo ""
      echo "    Instalando PHP..."
      echo ""
      sudo apt-get -y install php
      sudo apt-get -y install libapache2-mod-php

    # Instalar el servidor de bases de datos
      echo ""
      echo "    Instalando el servidor de bases de datos..."
      echo ""
      sudo apt-get -y install mariadb-server
      # Agregar o cambiar la contraseña al usuario root de MySQL
        sudo mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('rootMySQL'); FLUSH PRIVILEGES;"
        sudo mysql -uroot -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost'; FLUSH PRIVILEGES;"

      # Crear la base de datos
        sudo mysql -uroot -prootMySQL -e "CREATE DATABASE bWAPP;"
      # Asegurar el servidor (opcional)
        #sudo mysql_secure_installation
      # Instalar compatibilidad de PHO con mysql
        sudo apt-get -y install php-mysql

    # Obtener el número de la última versión disponible
      echo ""
      echo "    Obteniendo el número de la última vesión de bWAPP disponible..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      vNumVers=$(curl -sL https://sourceforge.net/projects/bwapp/files/bWAPP/ | sed 's->->\n-g' | grep bWAPPv | grep title | grep v[0-9] | grep folder | cut -d'"' -f2 | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      El número de la última versión es $vNumVers"
      echo ""
      
    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      curl -L https://downloads.sourceforge.net/project/bwapp/bWAPP/bWAPPv"$vNumVers"/bWAPPv"$vNumVers".zip -o /tmp/bWAPP.zip

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install unzip
          echo ""
        fi
      unzip /tmp/bWAPP.zip -d /tmp/bWAPPv"$vNumVers"

    # Mover carpeta a la raíz del servidor web
      echo ""
      echo "    Moviendo archivos a la raiz del servidor web..."
      echo ""
      sudo mkdir -p /var/www/bWAPP/
      sudo mv /tmp/bWAPPv"$vNumVers"/bWAPP/ /var/www/
      sudo mkdir /var/www/bWAPP/logs/
      sudo chown www-data:www-data /var/www/ -R

    # Dar permisos absolutos a las carpetas 'passwords', 'images', 'documents' and 'logs'.
    # Es opcional, pero permite jugar con sqlmap and Metasploit.
      sudo chmod 777 /var/www/bWAPP/passwords/
      sudo chmod 777 /var/www/bWAPP/images/
      sudo chmod 777 /var/www/bWAPP/documents/
      sudo chmod 777 /var/www/bWAPP/logs/

    # Modificar configuración relativa a la base de datos en algunos archivos .php
      sudo sed -i -e 's|$db_password = "";|$db_password = "rootMySQL";|g' /var/www/bWAPP/admin/settings.php
      sudo sed -i -e 's|if(!mysqli_select_db($link,"bWAPP"))|if(mysqli_select_db($link,"bWAPP"))|g' /var/www/bWAPP/install.php

    # Instalar compatibilidad con SSL
      echo ""
      echo "    Instalando compatibilidad con SSL..."
      echo ""
      sudo apt-get -y install openssl

    # Crear el certificado auto-firmado
      echo ""
      echo "    Creando el certificado autofirmado..."
      echo ""
      echo "[req]"                        > /tmp/openssl.cnf
      echo "default_bits       = 2048"   >> /tmp/openssl.cnf
      echo "prompt             = no"     >> /tmp/openssl.cnf
      echo "default_md         = sha256" >> /tmp/openssl.cnf
      echo "distinguished_name = dn"     >> /tmp/openssl.cnf
      echo ""                            >> /tmp/openssl.cnf
      echo "[dn]"                        >> /tmp/openssl.cnf
      echo "C  = ES"                     >> /tmp/openssl.cnf
      echo "ST = Madrid"                 >> /tmp/openssl.cnf
      echo "L  = Madrid"                 >> /tmp/openssl.cnf
      echo "O  = bWAPP"                  >> /tmp/openssl.cnf
      echo "OU = bWAPPMiUnidad"          >> /tmp/openssl.cnf
      echo "CN = bWAPP.com"              >> /tmp/openssl.cnf
      sudo mkdir /etc/apache2/ssl
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/autocertssl.key -out /etc/apache2/ssl/autocertssl.crt -config /tmp/openssl.cnf

    # Habilitar la configuración de bWAPP para apache
      echo ""
      echo "    Habilitar la configuración de bWAPP para apache..."
      echo ""
      echo '<VirtualHost *:80>'                                       | sudo tee    /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerAdmin webmaster@localhost'                        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo ''                                                         | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '<VirtualHost *:443>'                                      | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerName yourdomain.com'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLEngine on'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateFile    /etc/apache2/ssl/autocertssl.crt' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateKeyFile /etc/apache2/ssl/autocertssl.key' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  <Directory /var/www/html>'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '    AllowOverride All'                                    | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  </Directory>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf

    # Activar el módullo SSL de apache
      echo ""
      echo "    Activando el módulo SSL de apache..."
      echo ""
      sudo a2enmod ssl

    # Deshabilitar el sistio web por defecto de apache
      echo ""
      echo "    Deshabilitando los sitios por defecto de apache..."
      echo ""
      sudo a2dissite 000-default
      sudo a2dissite default-ssl.conf

    # Activar el sitio
      echo ""
      echo "    Activando el sitio..."
      echo ""
      sudo a2ensite bWAPP
      sudo systemctl reload apache2
      sudo systemctl restart apache2
      sudo systemctl status apache2 --no-pager

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Para ejecutar la instalación, visita en un navegador:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal/install.php"
      echo ""
      echo "    Luego entra en:"
      echo ""
      echo "      example: https://$vIPLocal/login.php"
      echo ""
      echo "    ...y loguéate con las credenciales bee/bug"
      echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    # Poner repositorios
      cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori
      echo "deb http://archive.debian.org/debian/ jessie main contrib non-free"      > /etc/apt/sources.list
      echo "deb-src http://archive.debian.org/debian/ jessie main contrib non-free" >> /etc/apt/sources.list

    # Instalar el servidor web
      echo ""
      echo "    Instalando el servidor web..."
      echo ""
      sudo apt-get -y --allow-unauthenticated update
      sudo apt-get -y --allow-unauthenticated install apache2

    # Instalar php
      echo ""
      echo "    Instalando PHP..."
      echo ""
      sudo apt-get -y --allow-unauthenticated install php5
      sudo apt-get -y --allow-unauthenticated install libapache2-mod-php5

    # Instalar el servidor de bases de datos
      echo ""
      echo "    Instalando el servidor de bases de datos..."
      echo ""
      sudo apt-get -y --allow-unauthenticated install mariadb-server
      # Agregar o cambiar la contraseña al usuario root de MySQL
        sudo mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('rootMySQL'); FLUSH PRIVILEGES;"
        sudo mysql -uroot -prootMySQL -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost'; FLUSH PRIVILEGES;"

      # Crear la base de datos
        sudo mysql -uroot -prootMySQL -e "CREATE DATABASE bWAPP;"
      # Asegurar el servidor (opcional)
        #sudo mysql_secure_installation
      # Instalar compatibilidad de PHO con mysql
        sudo apt-get -y --allow-unauthenticated install php5-mysql

    # Obtener el número de la última versión disponible
      echo ""
      echo "    Obteniendo el número de la última vesión de bWAPP disponible..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y --allow-unauthenticated update
          sudo apt-get -y --allow-unauthenticated install curl
          echo ""
        fi
      vNumVers=$(curl -sL https://sourceforge.net/projects/bwapp/files/bWAPP/ | sed 's->->\n-g' | grep bWAPPv | grep title | grep v[0-9] | grep folder | cut -d'"' -f2 | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      El número de la última versión es $vNumVers"
      echo ""
      
    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      curl -L https://downloads.sourceforge.net/project/bwapp/bWAPP/bWAPPv"$vNumVers"/bWAPPv"$vNumVers".zip -o /tmp/bWAPP.zip

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y --allow-unauthenticated update
          sudo apt-get -y --allow-unauthenticated install unzip
          echo ""
        fi
      unzip /tmp/bWAPP.zip -d /tmp/bWAPPv"$vNumVers"

    # Mover carpeta a la raíz del servidor web
      echo ""
      echo "    Moviendo archivos a la raiz del servidor web..."
      echo ""
      sudo mkdir -p /var/www/bWAPP/
      sudo mv /tmp/bWAPPv"$vNumVers"/bWAPP/ /var/www/
      sudo mkdir /var/www/bWAPP/logs/
      sudo chown www-data:www-data /var/www/ -R

    # Dar permisos absolutos a las carpetas 'passwords', 'images', 'documents' and 'logs'.
    # Es opcional, pero permite jugar con sqlmap and Metasploit.
      sudo chmod 777 /var/www/bWAPP/passwords/
      sudo chmod 777 /var/www/bWAPP/images/
      sudo chmod 777 /var/www/bWAPP/documents/
      sudo chmod 777 /var/www/bWAPP/logs/

    # Modificar configuración relativa a la base de datos en algunos archivos .php
      sudo sed -i -e 's|$db_password = "";|$db_password = "rootMySQL";|g' /var/www/bWAPP/admin/settings.php
      sudo sed -i -e 's|if(!mysqli_select_db($link,"bWAPP"))|if(mysqli_select_db($link,"bWAPP"))|g' /var/www/bWAPP/install.php

    # Instalar compatibilidad con SSL
      echo ""
      echo "    Instalando compatibilidad con SSL..."
      echo ""
      sudo apt-get -y --allow-unauthenticated install openssl

    # Crear el certificado auto-firmado
      echo ""
      echo "    Creando el certificado autofirmado..."
      echo ""
      echo "[req]"                        > /tmp/openssl.cnf
      echo "default_bits       = 2048"   >> /tmp/openssl.cnf
      echo "prompt             = no"     >> /tmp/openssl.cnf
      echo "default_md         = sha256" >> /tmp/openssl.cnf
      echo "distinguished_name = dn"     >> /tmp/openssl.cnf
      echo ""                            >> /tmp/openssl.cnf
      echo "[dn]"                        >> /tmp/openssl.cnf
      echo "C  = ES"                     >> /tmp/openssl.cnf
      echo "ST = Madrid"                 >> /tmp/openssl.cnf
      echo "L  = Madrid"                 >> /tmp/openssl.cnf
      echo "O  = bWAPP"                  >> /tmp/openssl.cnf
      echo "OU = bWAPPMiUnidad"          >> /tmp/openssl.cnf
      echo "CN = bWAPP.com"              >> /tmp/openssl.cnf
      sudo mkdir /etc/apache2/ssl
      sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/autocertssl.key -out /etc/apache2/ssl/autocertssl.crt -config /tmp/openssl.cnf

    # Habilitar la configuración de bWAPP para apache
      echo ""
      echo "    Habilitar la configuración de bWAPP para apache..."
      echo ""
      echo '<VirtualHost *:80>'                                       | sudo tee    /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerAdmin webmaster@localhost'                        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo ''                                                         | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '<VirtualHost *:443>'                                      | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ServerName yourdomain.com'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  DocumentRoot /var/www/bWAPP'                            | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLEngine on'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateFile    /etc/apache2/ssl/autocertssl.crt' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  SSLCertificateKeyFile /etc/apache2/ssl/autocertssl.key' | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  <Directory /var/www/html>'                              | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '    AllowOverride All'                                    | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  </Directory>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'                   | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'        | sudo tee -a /etc/apache2/sites-available/bWAPP.conf
      echo '</VirtualHost>'                                           | sudo tee -a /etc/apache2/sites-available/bWAPP.conf

    # Activar el módullo SSL de apache
      echo ""
      echo "    Activando el módulo SSL de apache..."
      echo ""
      sudo a2enmod ssl

    # Deshabilitar el sistio web por defecto de apache
      echo ""
      echo "    Deshabilitando los sitios por defecto de apache..."
      echo ""
      sudo a2dissite 000-default
      sudo a2dissite default-ssl.conf

    # Activar el sitio
      echo ""
      echo "    Activando el sitio..."
      echo ""
      sudo a2ensite bWAPP
      sudo service apache2 reload
      sudo service apache2 restart
      sudo service apache2 status

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada. Para ejecutar la instalación, visita en un navegador:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      https://$vIPLocal/install.php"
      echo ""
      echo "    Luego entra en:"
      echo ""
      echo "      example: https://$vIPLocal/login.php"
      echo ""
      echo "    ...y loguéate con las credenciales bee/bug"
      echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de bWAPP para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
