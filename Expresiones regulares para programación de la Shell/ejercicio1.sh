#!/bin/bash

#Mostrar aquellas líneas que contienen un número de teléfono (3 dígitos, espacio, 3 dígitos, espacio, 3 dígitos)

echo "======"
echo "1) Líneas que contienen un número de teléfono:"
cat ficherosPractica2/datos.txt | grep '\([0-9]\{3\}\ \)\{2\}[0-9]\{3\}'
echo "======"

echo "======"
echo "2) Líneas que empiezan por 4 espacios:"
cat ficherosPractica2/datos.txt | grep '^ \{4\}'
echo "======"

echo "======"
echo "3) Líneas que empiezan la letra C (con o sin espacios antes):"
cat ficherosPractica2/datos.txt | grep '^ *C'
echo "======"

echo "======"
echo "4) Líneas que contienen una vocal, un caracter y la misma vocal:"
cat ficherosPractica2/datos.txt | grep '\([aeiou]\).\1'
echo "======"

echo "======"
echo "5) Eliminar líneas vacías:"
cat ficherosPractica2/datos.txt | grep -v "^ *$"
echo "======"

echo "======"
echo "6) Líneas que contienen a y u (en mayúscula o minúscula):"
#cat ficherosPractica2/datos.txt | grep -E '[aA].*[uU]|[uU].*[aA]'
cat ficherosPractica2/datos.txt | grep -i -E 'a.*u|u.*a'
echo "======"

echo "======"
echo "7) Líneas que NO contienen la secuencia de caracteres des:"
cat ficherosPractica2/datos.txt | grep -v 'des'
echo "======"

echo "======"
echo "8) Líneas que contienen cuatro vocales e o más:"
cat ficherosPractica2/datos.txt | grep -i '\(e.*\)\{4,\}'
echo "======"

echo "======"
echo "9) Líneas que contienen una letra mayúscula seguida de una vocal sin tilde:"
cat ficherosPractica2/datos.txt | grep -E '[[:upper:]][aeiou]'
echo "======"

echo "======"
echo "10) Emparejamientos del patrón anterior:"
cat ficherosPractica2/datos.txt | sed -n -e 's/\([[:upper:]][aeiou]\)/"\1"/gp'
echo "======"



