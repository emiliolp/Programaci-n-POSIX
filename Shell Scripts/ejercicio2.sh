#! /bin/bash
function ficheros()				#Función para comprobar la existencia del fichero pasado
{
	if [ -d $1 ]
	then
		echo -n "El directorio $1 ya existe desea sobreescribir? s/n: "
		read op
		if [ $op == "s" ]
		then
			rm -dfr $1
			mkdir $1
			return 1
		else
			return 0
		fi
	else
		mkdir $1
		return 1
	fi
}

	echo -n "Introduzca el directorio donde copiar los ejecutables: " 
	read -t5 exe				#Espera 5 segundos a que el usuario introduzca un nombre

	if [ -z $exe ]				#Si no ha pasado ningún argumento
	then

		echo -e "\nSe ha pasado el tiempo el directorio por defecto es /bin"
		exe=bin				#Asigna a ejec el nombre bin
	fi

	if ficheros $exe
	then
						#Si la respuesta es negativa, vuelve a preguntar un nuevo nombre
		echo -n "Introduzca el directorio donde copiar los ejecutables: "
		read exe
		mkdir $exe
		echo "Directorio $exe creado"
			
	fi


	echo -n "Introduzca el directorio donde copiar las librerias: " 
	read -t5 lib

	if [ -z $lib ]
	then

		echo -e "\nSe ha pasado el tiempo el directorio por defecto es /lib"
		lib=lib
	fi

	if ficheros $lib
	then
		echo -n "Introduzca el directorio donde copiar las librerias: " 
		read lib	
		rm -dfr $lib
		echo "Directorio $lib creado"
	fi

	echo -n "Introduzca el directorio donde copiar las imagenes: " 
	read -t5 imagen

	if [ -z $imagen ]
	then

		echo -e "\nSe ha pasado el tiempo el directorio por defecto es /img"
		imagen=img
	fi
	
	if ficheros $imagen
	then
		echo -n "Introduzca el directorio donde copiar el código fuente: " 
		read imagen
		mkdir $imagen
		echo "Directorio $imagen creado"
	fi

	echo -n "Introduzca el directorio donde copiar las cabeceras: "
	 read -t5 header

	if [ -z $header ]
	then

		echo -e "\nSe ha pasado el tiempo la cabecera por defecto es /include"
		header=include
	fi
	
	if ficheros $header
	then
		echo -n "Introduzca el directorio donde copiar las cabeceras: "
		read header
		mkdir $header
		echo "Directorio $header creado"
	fi

echo "Utilizando los ficheros:"
echo "$exe para almacenar los ficheros ejecutables"
echo "$lib para almacenar las librerías"
echo "$imagen para almacenar los ficheros de imagen"
echo "$header para almacenar los ficheros de cabeceras"

cont1=0					#Contadores que suman los ficheros añadidos a cada uno de los directorios
cont2=0
cont3=0
cont4=0

for i				
do						#Se ejecuta lo siguiente para cada carpeta introducida por comando
	

	for x in $(find $i)			#Recorre cada directorio
	do

		nombre=$(basename $x)
		if [[ $nombre == lib* ]]	#Comprueba si el fichero tiene extensión de librería
		then
			let cont1+=1
			date>>ejercicio2.log
			cp -v $x ./$lib>>ejercicio2.log

 
		elif [[ $nombre == *.jpg ]] || [[ $nombre == *.gif ]]|| [[ $nombre == *.png ]]	#Comprueba si es imagen
		then
			nombresinex=$((basename $nombre) | cut -d "." -f1)
			date>>ejercicio2.log
			cp $x ./$imagen>>ejercicio2.log
			let cont2+=1
			if [[ $nombre == *.c ]]
			then
				echo "Compilando Archivo $x">>ejercicio2.log
				gcc -o $nombresinex $x>>ejercicio2.log
				echo "Moviendo el archivo $nombresinex a la carpeta $exe">>ejercicio2.log
				date>>ejercicio2.log
				mv $nombresinex ./$exe>>ejercicio2.log
				let cont2+=1

				g++ -o $nombresinex $x>>ejercicio2.log
				echo "Moviendo el archivo $nombresinex a la carpeta $exe">>ejercicio2.log
				date>>ejercicio2.log
				mv $nombresinex ./$exe>>ejercicio2.log
				let cont2+=1
			fi

		elif [[ $nombre == *.h ]]				#Comprueba si es cabecera
		then
			let cont3+=1
			date>>ejercicio2.log
			cp -v $x ./$header>>ejercicio2.log


		fi

		if [ -x $nombre ]					#Comprueba si tiene permisos de ejecución
		then
			let cont4+=1
			date>>ejercicio2.log
			cp -v $i/$x ./$exe>>ejercicio2.log

		fi

	done
done



echo "Número de ficheros ejecutables: $cont2">>ejercicio2.log
echo "Número de librerias: $cont1">>ejercicio2.log
echo "Número de imágenes: $cont3">>ejercicio2.log
echo "Número de ficheros de cabecera es $cont4">>ejercicio2.log


