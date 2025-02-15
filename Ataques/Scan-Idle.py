#!/usr/bin/env python3

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#sudo apt-get -y install python3-scapy

# ----------
# Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Scan-Idle.py | python3
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Scan-Idle.py | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Scan-Idle.py | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Scan-Idle.py | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/Ataques/Scan-Idle.py | nano -
# ----------

# Uso: sudo ./idlescan.py 172.16.0.105 172.16.0.109 80

import argparse
from scapy.all import *

def idle_scan(zombie_ip, victim_ip, victim_port):
    # Step 1: Probe initial IP ID of the zombie
    syn_ack = IP(dst=zombie_ip)/TCP(dport=80, flags="SA")
    response = sr1(syn_ack, timeout=2, verbose=0)
    initial_ipid = response.id if response else None

    if initial_ipid is None:
        print("[!] Fallo al obtener el IPID del zombie.")
        return

    print(f"[*] IPID inicial del zombie: {initial_ipid}")

    # Step 2: Send spoofed SYN packet to victim
    spoofed_syn = IP(src=zombie_ip, dst=victim_ip)/TCP(dport=victim_port, flags="S")
    send(spoofed_syn, verbose=0)

    # Step 3: Probe final IP ID of the zombie
    response = sr1(syn_ack, timeout=2, verbose=0)
    final_ipid = response.id if response else None

    if final_ipid is None:
        print("[!] Fallo al obtener el IPID final del zombie.")
        return

    print(f"[*] IPID final del zombie: {final_ipid}")

    # Step 4: Analyze results
    ipid_difference = final_ipid - initial_ipid
    if ipid_difference == 1:
        print(f"[+] Port {victim_port} on {victim_ip} is CLOSED.")
    elif ipid_difference == 2:
        print(f"[+] Port {victim_port} on {victim_ip} is OPEN.")
    else:
        print("[!] Comportamiento inesperado o error de host en el zombie.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Idle Scan using a zombie host.")
    parser.add_argument("zombie_ip", help="IP address of the zombie host")
    parser.add_argument("victim_ip", help="IP address of the target")
    parser.add_argument("victim_port", type=int, help="Port to scan on the target")
    args = parser.parse_args()

    idle_scan(args.zombie_ip, args.victim_ip, args.victim_port)
