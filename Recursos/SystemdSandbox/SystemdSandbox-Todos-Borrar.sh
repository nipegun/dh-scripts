#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar todos los contenedores systemd de un Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

vCarpetaPorDefectoParaContenedores='/var/lib/machines'

# Verificar que la carpeta existe
if [ ! -d "$vCarpetaPorDefectoParaContenedores" ]; then
  echo "La carpeta $vCarpetaPorDefectoParaContenedores no existe."
  exit 1
fi

# Listar subcarpetas
aCarpetas=$(sudo find "$vCarpetaPorDefectoParaContenedores" -mindepth 1 -maxdepth 1 -type d)

# Si no hay carpetas, salir
if [ -z "$aCarpetas" ]; then
  echo "No hay carpetas para borrar en $vCarpetaPorDefectoParaContenedores."
  exit 0
fi

# Borrar cada carpeta individualmente
for vCarpeta in $aCarpetas; do
  echo "Borrando $vCarpeta..."
  sudo rm -rf "$vCarpeta"
done

echo "Todas las carpetas dentro de $vCarpetaPorDefectoParaContenedores fueron borradas."

