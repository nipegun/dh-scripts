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

# Instalar en el venv
  python3 -m pip install -e . --break-system-packages

# Comprobar que se ha instalado
  python3 - << 'EOF'
import cai
import os
print("CAI cargado desde:", os.path.dirname(cai.__file__))
EOF

# Prueba mínima para ver si inicia el agente
  echo '#!/usr/bin/env python3'                                                    | tee -a PruebaAgente.py
  echo 'from cai.sdk.agents import Agent, Runner'                                  | tee -a PruebaAgente.py
  echo 'from cai.tools.reconnaissance.exec_code import execute_code'               | tee -a PruebaAgente.py
  echo ''                                                                          | tee -a PruebaAgente.py
  echo 'agent = Agent('                                                            | tee -a PruebaAgente.py
  echo '  name="AgenteLocal",'                                                     | tee -a PruebaAgente.py
  echo '  instructions="Eres un agente de test",'                                  | tee -a PruebaAgente.py
  echo '  tools=[execute_code]'                                                    | tee -a PruebaAgente.py
  echo ')'                                                                         | tee -a PruebaAgente.py
  echo ''                                                                          | tee -a PruebaAgente.py
  echo 'resultado = Runner.run_sync(agent, "print("'Hola desde mi repo local'")")' | tee -a PruebaAgente.py
  echo 'print(resultado.output)'                                                   | tee -a PruebaAgente.py
  chmod +x PruebaAgente.py

# Probarlo
  python3 PruebaAgente.py
