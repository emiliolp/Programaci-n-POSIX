#! /bin/bash
let salir
for i				 
do 									#Comprueba que los argumentos pasados sean ficheros o directorios
	if [ ! -d $i ];					
	then
		echo "Introduce un directorio y/o fichero existente "
	else
		salir=0							#Para que se ejecute el resto del programa se debe pasar al menos un 										fichero o directorio existente
	fi
done

if [ $salir -eq 0 ]
then
	if [ ! -d Copia ]						#Si no existe el fichero Copia lo crea
	then
		mkdir Copia
	fi

	for x in $(find \Copia -name "*.tar")
	do 
		hora=$(( $(date +"%s") - $(stat -c "%Y" $x) )) 		#Cálculo de la hora de creación
		if [ $hora -gt "200" ] #Si el tiempo de creación supera los 200 segundos el programa lo elimina
		then
		
			echo "Borrando $x con un tiempo de [$hora] segundos..."
			rm $x #Elimina el fichero
		fi
	done
	
	file=copia-$USER-$(date +"%s").tar				#Guarda el nombre del futuro archivo comprimido
	tar zcvf $file $*						#Crea el archivo comprimido
	mv $file \Copia							#Mueve el comprimido a la carpeta copia
fi
