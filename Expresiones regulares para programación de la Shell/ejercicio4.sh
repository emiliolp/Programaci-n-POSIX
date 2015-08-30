#!/bin/bash

wget -q https://twitter.com/GeoPortalMityc						#Guarda el contenido de la web en un fichero html
echo "Descargando la web https://twitter.com/GeoPortalMityc..."

echo "Listado de precios de GeoPortalMityc ordenados por precio del Combustible:"	

cat GeoPortalMityc | sed -n -e 's/^.*EcoPrecio \(.\{7,8\}\) \(.\{1,2\}\) \(.*\) es \(.*\)€.*$/Precio: "\4"€ Combustible: "\1 \2" Ciudad: "\3"/p' | sort -n -k 2 -t '"'								#Muestra la oferta ordenada por precio

echo "Listado de precios de GeoPortalMityc ordenados por localidad:"
cat GeoPortalMityc | sed -n -e 's/^.*EcoPrecio \(.\{7,8\}\) \(.\{1,2\}\) \(.*\) es \(.*\)€.*$/Precio: "\4"€ Combustible: "\1 \2" Ciudad: "\3"/p' | sort -k 6 -t '"'								#Muestra la oferta ordenada por localidad

rm GeoPortalMityc
