#!/bin/bash

mkdir ~/Pruebas
cd ~/Pruebas
python3 -m venv cai_env

# Entrar en el entorno virtual
  source ~/Pruebas/cai_env/bin/activate


vVersCAIF=$(pip index versions cai-framework | grep cai-framework)
echo ""
echo "  Se descargará $vVersCAIF..."
echo ""
pip download cai-framework --no-deps --no-binary :all: --only-binary :none:
tar -xvf cai_framework-*.tar.gz

# Convertir en un repo independiente
  cd cai_framework-0.5.5
  git init
  git add .
  git commit -m "Importación inicial del código open-source de CAI Framework"
