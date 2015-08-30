#! /bin/bash

responde=$(mktemp)
noresponde=$(mktemp)
if [ $# -eq 1 ] && [ -e $1 ];
then
	for x in $(cat $1)				#Recorre las líneas del fichero pasado como argumento
	do
		ping -c 1 $x > /dev/null		#Manda un solo ping
		if [ $? -eq 0 ]				#Si el último comando ejecutado devuelve 0 guarda la información en el formato pedido
		then
			ping -c 1 $x | sed -n -e 's/^.*from \(.*\):.*time=\(.*\) ms/La IP \1 respondió en \2/p' >> $responde
		else					#Si ping devuelve un código de error guarda la información en otro fichero
			ping -c 1 $x | sed -n -e 's/^--- \(.*\) ping .*$/La IP \1 no responde/p' >> $noresponde
		fi
	done
	cat $responde | sort -n -k 6 -t ' '		#Ordena la salida ordenada por la columna 6 (tiempo de respuesta)
	cat $noresponde					#No se ordena salida ya que no hay respuesta
	
else
	echo "Introduce un fichero existente"
fi
