#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

echo -n "Introduzca un caracter: "
# Se lee una linea de la entrada estandar
read linea
# Se guarda en una variable el primer caracter de la linea leida
caracter=$(echo "$linea" | cut -c1)
# Se comprueba el valor del caracter y se imprime su correspondiente salida
case $caracter in
    [A-Za-z])
        echo "$caracter es una letra";;
    [0-9])
        echo "$caracter es un numero";;
    *)
        echo "$caracter es un caracter especial";;
esac
