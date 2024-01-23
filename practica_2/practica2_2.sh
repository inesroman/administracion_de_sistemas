#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

# En cada iteracion del bucle se comprueba un parametro pasado al script, 
# los parametros entrecomillados se consideran uno solo aunque contengan espacios 
for fichero in "$@"
    do  
        if [ -f "$fichero" ] # Si el parametro es un fichero regular
        then
            more "$fichero" # Se imprime en la salida estandar su contenido
        else
            echo "$fichero no es un fichero"
        fi
done
