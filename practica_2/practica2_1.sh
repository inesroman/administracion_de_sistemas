#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

echo -n "Introduzca el nombre del fichero: "
# Lee el nombre del fichero de entrada
read fichero
if [ -f "$fichero" ] # Si lo que se ha leido es un fichero regular
then 
    echo -n "Los permisos del archivo $fichero son: "
    if [ -r "$fichero" ] # Si tiene permiso de lectura
    then
        echo -n "r"
    else
        echo -n "-"
    fi
    if [ -w "$fichero" ] # Si tiene permiso de escritura
    then
        echo -n "w"
    else
        echo -n "-"
    fi
    if [ -x "$fichero" ] # Si tiene permiso de ejecucion
    then
        echo "x"
    else
        echo "-"
    fi
else
    echo "$fichero no existe"
fi