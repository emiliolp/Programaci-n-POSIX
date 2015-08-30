#!/bin/bash

#Listar todos los ficheros ocultos de la carpeta personal del usuario ordenados por numero de caracteres
guardado=$(mktemp)
ocultos=$(mktemp)
for archivo in $(ls -a /home/$USER | grep '^\.')
do
	caracteres=$(echo $archivo | wc -m)
	let caracteres=$caracteres-1
	echo $caracteres","$archivo >> $ocultos
done

sort -k1n ocultos | cut -d "," -f 2

#rm ocultos

#Listar por pantalla todos los procesos que el usuario esta ejecutando en el momento.

ps aux |tr -s " "|tr -t " " ","|cut -d "," -f 1,2,9,11 >> $guardado

cat $guardado | sed -n -e '2,$s/\('$USER'\),\([^ ]\{1,\}\),\([^ ]\{1,\}\),\([^ ]\{1,\}\)/PID: "\2" Ejecutable: "\4" Hora Inicio: "\3"/p'
