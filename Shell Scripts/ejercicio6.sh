#! /bin/bash
#Resumen: ee9e51458f4642f48efe956962058245ee7127b1
#Contraseña: bye

if [ "$2" == "1" ]						#Si el segundo argumento pasado es 1
then
	echo "Buscando contraseñas de 1 caracter..."

	for x in $(echo {a..z})
	do
		res=$(echo $x | sha1sum | cut -d " " -f1)	#Compara cada una de las combinaciones con un carácter que generan el 									resumen pasado como primer argumento
		if [ "$res" == "$1" ]
		then
			echo "Encontrada la clave: $x"
		fi
	done

else
	if [ "$2" == "2" ]					#Si el segundo argumento pasado es 2
	then
		echo "Buscando contraseñas de 2 caracteres..."

		for x in $(echo {a..z}{a..z})
		do
			res=$(echo $x | sha1sum | cut -d " " -f1)

			if [ "$res" == "$1" ]
			then
				echo "Encontrada la clave: $x"
			fi
		done

	else
		if [ "$2" == "3" ]				#Si el segundo argumento pasado es 3
		then
			echo "Buscando contraseñas de 3 caracteres..."

			for x in $(echo {a..z}{a..z}{a..z})
			do
				res=$(echo $x | sha1sum | cut -d " " -f1)

				if [ "$res" == "$1" ]
				then
					echo "Encontrada la clave: $x"
					exit 1
				fi
			done
		else						#Si no se ha introducido un enterio que no es 1, 2 ó 3
			echo "Debe introducir un entero entre 1 y 3"
		fi
	fi
fi
