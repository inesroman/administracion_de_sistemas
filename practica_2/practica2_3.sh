#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

# La sintaxis de ejecucion del script sera incorrecta 
# si no se le ha pasado un unico parametro
if [ $# -ne 1 ]
then 
    echo "Sintaxis: practica2_3.sh <nombre_archivo>"
else # La sintaxis es correcta
    if [ -f "$1" ] # Si el parametro pasado es un fichero regular
    then 
        chmod ug+x "$1" # Se añade permiso de ejecucion al usuario y al grupo
        stat -c %A "$1" # Se imprimen los permisos del fichero
    else
        echo "$1 no existe" 
    fi
fi
