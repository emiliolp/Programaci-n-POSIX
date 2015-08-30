#!/bin/bash
if [ $# -ne 1 ] || [ ! -d $1 ]			#Comprobamos que se ha introducido un directorio como argumento
then
	echo "Introduce directorio existente"
	exit
fi
	
ls=$(mktemp)					#Creamos los archivos temporales
shebang=$(mktemp)

#Primer apartado
for x in $(find $1)
do
	ls -ld $x >> $ls			#Guarda información directorio, fichero o enlace, en el caso de los ficheros solo una línea
done
echo -n "Número de directorios: " 
cat $ls | grep '^d' | wc -l
echo -n "Número de ficheros ejecutables convencionales: " 
cat $ls | grep '^-..x'| wc -l
echo -n "Número de enlaces simbólicos: " 
cat $ls | grep '^l' | wc -l

#Segundo apartado
for file in $(ls $1/etc/init.d)
do
	cat $1/etc/init.d/$file | grep '^#! */bin' >> $shebang	#Busca emparejamientos con cabecera con SheBang y los guarda en aux2
done

bash=$(cat $shebang | grep '^#! */bin/bash' | wc -l)		#Cuenta las líneas con "bash"
sh=$(cat $shebang | grep '^#! */bin/sh' | wc -l)		#Cuenta las líneas con "sh"
echo "$bash scripts con intérprete /bin/bash" 
echo "$sh scripts con intérprete /bin/sh"

#Tercer apartado

aux1=$(mktemp)
aux2=$(mktemp)
	
for nivel in 0 1 2 3 4 5 6 S
do 
	for file in $(ls $1/etc/rc$nivel.d/)			#Guardamos la información de cada script en un fichero temporal
	do 
		if [ "$file" != "README" ]
		then
			echo "$nivel,$file" | sed -e 's/\(^.\),\([SK]\)\([0-9][0-9]\)\(.*$\)/\1,\2,\3,\4/g'>>$aux1
		fi
	done
done

for x in $(cat $aux1)
do
	script=$(echo $x | cut -d "," -f 4)			#Guardamos el nombre del script de cada línea
	if [ $(cat $aux2 | grep -c $script) == 0 ]		#Comprobamos que el script no haya sido analizado antes
	then
		echo "-----"
		echo "Script $script"
		for y in $(cat $aux1)				#Buscamos el valor de script en el archivo comparando los nombres
		do
			nombre=$(echo $y | cut -d "," -f 4)
			if [ "$nombre" == "$script" ]			
			then
				nivel=$(echo $y | cut -d "," -f 1)
				arranque=$(echo $y | cut -d "," -f 2 | grep '^S')
				parada=$(echo $y | cut -d "," -f 2 | grep '^K')
				prioridad=$(echo $y | cut -d "," -f 3)
				
				if [ $arranque ] 		#Imprimimos los datos
				then 			
					echo "Nivel $nivel: Arranque con prioridad $prioridad"
				fi
				if [ $parada ] 
				then			
					echo "Nivel $nivel: Parada con prioridad $prioridad"
				fi
			fi
		done
	fi
	echo $script >>$aux2
done			
		 


#Cuarto apartado

echo "Introduzca el nivel deseado: "
read nivel

while read x
do
	nivelAux=$(echo $x | cut -d "," -f 1)				#En el archivo aux1 buscamos los scripts con el nivel deseado
	if [ "$nivelAux" == "$nivel" ]
	then
		arranque=$(echo $x | cut -d "," -f 2 | grep '^S')
		parada=$(echo $x | cut -d "," -f 2 | grep '^K')
		nombre=$(echo $x | cut -d "," -f 4)	
		prioridad=$(echo $x | cut -d "," -f 3)
		if [ $arranque ]						#La salida será en función de arranque o parada
		then
			echo "Comenzar $nombre con prioridad $prioridad"
		fi

		if [ $parada ]
		then
			echo "Detener $nombre con prioridad $prioridad"
		fi
	fi
done < $aux1
