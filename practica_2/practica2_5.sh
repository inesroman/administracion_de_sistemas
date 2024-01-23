#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

echo -n "Introduzca el nombre de un directorio: "
# Se lee una linea de la entrada estandar
read dir

if [ -d "$dir" ] # Si la linea leida corresponde con el nombre de un directorio
then  
    # Se cuentan las lineas que al mostrar los ficheros 
    # y sus permisos empiezan por -, es decir son ficheros
    num_fich=$(ls -l "$dir" | grep ^- | wc -l)
    
    # Se cuentan las lineas que al mostrar los ficheros 
    # y sus permisos empiezan por d, es decir son directorios
    num_dir=$(ls -l "$dir" | grep ^d | wc -l)
    
    
    echo "El numero de ficheros y directorios en $dir es de $num_fich y $num_dir, respectivamente"
else
    echo "$dir no es un directorio"
fi
