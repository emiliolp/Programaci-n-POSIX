#!/bin/bash
echo -n "¿Cuál es su edad? "
read edad							#Pide la edad por teclado

if [ $edad -lt 0 ]						#Comprueba que se ha introducido un número igual o mayor a 0
then
	echo "Debe introducir un número igual o superior a 0"
else
	if [ $edad -lt 18 ];					#Si el número es menor que 18 cuenta los años que le faltan
	then
		let falta=18-$edad
		echo "No tienes permitido conducir. Te faltan $falta años."
	else
		r=$RANDOM%99					#Si edad es igual o superior a 18 genera un número aleatorio
		let veces_conducido=($edad-18+1)*$r		#Sumo 1 ya que se incluye tambien la edad 18
		echo "Tienes permitido conducir un coche y has conducido $veces_conducido veces hasta la fecha."
	fi
fi



