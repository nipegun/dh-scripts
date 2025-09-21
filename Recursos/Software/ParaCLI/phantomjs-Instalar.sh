#!/bin/bash

# Descargar archivo
  sudo rm -f /tmp/phantomjs.xz
  curl -L https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Recursos/Software/ParaCLI/extra/phantomjs/phantomjs.xz -o /tmp/phantomjs.xz
# Descomprimir archivo
  cd /tmp/
  sudo rm -f /tmp/phantomjs
  unxz /tmp/phantomjs.xz
  chmod +x /tmp/phantomjs

  # Copiar a rutas de binarios
    sudo cp -fv /tmp/phantomjs /usr/local/bin/
    sudo cp -fv /tmp/phantomjs /usr/bin/
  
