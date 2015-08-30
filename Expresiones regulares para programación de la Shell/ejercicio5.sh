#!/bin/bash

if [ $# -eq 1 ]			#Comprueba el número de argumentos pasados
then
	case $1 in			#Muestra la información de cada usuario según lo introducido como argumento
		0) cat /etc/passwd | sed -n -e 's/\(.*\):\(.*\):\(.\{1,\}\):\(.*\):\(.*\):\(.*\):\(.*\)/Logname: \1\n->UID: \3\n->GID: \4\n->gecos: \5\n->Home: \6\n->Shell por defecto: \7/p';;
		1) cat /etc/passwd | sed -n -e 's/\(.*\):\(.*\):\(.\{4,\}\):\(.*\):\(.*\):\(.*\):\(.*\)/Logname: \1\n->UID: \3\n->GID: \4\n->gecos: \5\n->Home: \6\n->Shell por defecto: \7/p';;
		*) echo "Introduzca 0 ó 1";;
	esac
else
	echo "Introduzca 0 ó 1"
fi

