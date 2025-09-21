#!/bin/bash

sudo pip uninstall SQLAlchemy --break-system-packages
sudo pip install SQLAlchemy==1.3.24 --break-system-packages
sudo rm -f /usr/share/legion/app/importers/NmapImporter.py
sudo curl -L https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/extra/legion/NmapImporter.py -o /usr/share/legion/app/importers/NmapImporter.py

# Instalar en venv
  echo ""
  echo "  Instalando Legion en el venv..."
  echo "" 
  cd ~/
  sudo rm -rf ~/HackingTools/Legion/
  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install git
    echo ""
  fi
  git clone https://github.com/Hackman238/legion.git ~/HackingTools/Legion
  # Instalar dependencias
    sudo ~/HackingTools/Legion/deps/installDeps.sh
    sudo apt-get -y install xterm
  eyewitness
  phantomjs
  cd ~/HackingTools/Legion/
  python3 -m venv venv
  source ~/HackingTools/Legion/venv/bin/activate
  ~/HackingTools/Legion/deps/installPythonLibs.sh
  curl -L https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaGUI/extra/legion/NmapImporter.py -o ~/HackingTools/Legion/app/importers/NmapImporter.py
  # Instalar phantomjs
    echo ""
    echo "  Instalando phantomjs..."
    echo ""
    curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/ParaCLI/phantomjs-Instalar.sh | bash

  # Notificar fin de ejecución del script
    echo ""
    echo "  Legion instalado correctamente en el venv. Para ejecutarlo:"
    echo ""
    echo "    cd ~/HackingTools/Legion/"
    echo "    source venv/bin/activate"
    echo "      sudo python3 legion.py"
    echo "    deactivate"
    echo ""

# 


  
# Instalar a nivel de sistema
  cat requirements.txt | xargs sudo pip3 install --break-system-packages 
  cp ~/HackingTools/Legion/app/importers/NmapImporter.py ~/HackingTools/Legion/app/importers/NmapImporter.py.bak 
  chmod +x legion.py
  
echo ""
echo "  Legion instalado. Ejecutalo con:"
echo ""
echo "    sudo python3 legion.py"
echo ""

# Instalar en
