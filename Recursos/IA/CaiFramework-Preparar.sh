#!/bin/bash

# Definir constantes
  vCarpetaGit="$HOME/Git2"
  vNomRepoGithub='pruebas'
  vNomNuevaCarpeta='CaiFramework'

# Clonar el repo de pruebas
  cd ~
  mkdir "$vCarpetaGit"/ 2> /dev/null
  rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/ 2> /dev/null
  cd "$vCarpetaGit"/
  git clone https://github.com/nipegun/"$vNomRepoGithub".git
  rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/* 2> /dev/null
  mkdir "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/ 2> /dev/null

# Crear entorno virtual de python y descargar dentro
  rm -rf /tmp/"$vNomNuevaCarpeta"/ 2> /dev/null
  mkdir /tmp/"$vNomNuevaCarpeta"/
  cd /tmp/"$vNomNuevaCarpeta"/
  python3 -m venv venv
  # Entrar en el entorno virtual
    source /tmp/"$vNomNuevaCarpeta"/venv/bin/activate
  # Determinar la última versión
    vVersCAIF=$(pip index versions cai-framework | grep cai-framework | cut -d'(' -f2 | cut -d')' -f1)
  # Descargar
    echo ""
    echo "  Se descargará la versión $vVersCAIF..."
    echo ""
    pip download cai-framework --no-deps --no-binary :all: --only-binary :none:
  # Descomprimir
    tar -xvf cai_framework-*.tar.gz -C /tmp/"$vNomNuevaCarpeta"/
  # Desactivar entorno virtual
    deactivate

  # Copiar a la home del usuario
    rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/* 2> /dev/null
    cp -Rv /tmp/"$vNomNuevaCarpeta"/cai_framework-"$vVersCAIF"/src/cai/* "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/

  # Crear el archivo de requirements.txt
    echo 'python-dotenv' | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt
    echo 'openai'        | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt
    echo 'rich'          | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt
    echo 'mako'          | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt
    echo 'wasabi'        | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt
    echo 'cai-framework' | tee -a "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/requirements.txt

# Borrar archivos irrelevantes para la ejecución del código
  #rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/docs/
  #rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/examples/
  #rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/fluency/
  #rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/media/
  #rm -rf "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/tests/
  #rm -f  "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/CITATION.cff
  #rm -f  "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/DISCLAIMER
  #rm -f  "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/LICENSE
  #rm -f  "$vCarpetaGit"/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/LICENSE-MIT

# Entrar al repo local
  cd "$vCarpetaGit"/"$vNomRepoGithub"/

# Crear el provider para ollama
  

# Añadir los cambios
  git add .
  git commit -m "  Agrego mi fork de CaiFramework en carpeta propia."
  git push
  

# Re-descargar el repo
  cd /tmp
  git clone https://github.com/nipegun/"$vNomRepoGithub".git
  cd /tmp/"$vNomRepoGithub"/"$vNomNuevaCarpeta"/

# Re-crear el entorno virtual
  python3 -m venv venv

# Entrar en el entorno virtual e instalar
  source /tmp/"$vNomRepoGithub"/"$vNomNuevaCarpeta"//venv/bin/activate
  python3 -m pip install -e .
  





# Crear el provider para Ollama
  cat > src/cai/sdk/agents/models/ollama_provider.py <<< '
from typing import Optional
import aiohttp
from cai.sdk.agents.models.base_model import Model, ModelResponse

class OllamaChatCompletionsModel(Model):
  """
  Provider para usar modelos locales de Ollama.
  """

  def __init__(self, model: str, api_base: str = "http://localhost:11434"):
    super().__init__(model=model)
    self.api_base = api_base.rstrip("/")

  async def call(
    self,
    prompt: str,
    system_prompt: Optional[str] = None,
    **kwargs
  ) -> ModelResponse:

    url = f"{self.api_base}/api/chat"

    messages = []
    if system_prompt:
      messages.append({"role": "system", "content": system_prompt})
    messages.append({"role": "user", "content": prompt})

    async with aiohttp.ClientSession() as session:
      async with session.post(url, json={
        "model": self.model,
        "messages": messages,
        "stream": False
      }) as resp:
        data = await resp.json()

    content = data["message"]["content"]
    return ModelResponse(output_text=content)
'

# Instalar en el venv
  python3 -m pip install -e . --break-system-packages

# Comprobar que se ha instalado
  python3 - << 'EOF'
import cai
import os
print("CAI cargado desde:", os.path.dirname(cai.__file__))
EOF

# Crear el provider para Ollama











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



resultado = Runner.run_sync(agent, "Escribe 'Hola desde Ollama'")
print(resultado.output)



# Probarlo
  export CAI_MODEL="ollama/llama3.1"
  export OLLAMA_BASE_URL="http://localhost:11434"
  export OPENAI_API_KEY=""     # para que CAI NO use OpenAI

  python3 PruebaAgente.py
