#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

# Se guarda en la variable dir el ultimo directorio 
# modificado en el directorio de $HOME con nombre binXXX
dir=$(stat -c %n,%Y "$HOME"/* | sort -t',' -k2 -n | cut -d',' -f1 | egrep "$HOME/bin[0-9A-Za-z]{3}$" | head -n1)

# Si no se ha encontrado un directorio con esas caracteristicas se crea uno
if [ ! "$dir" -o ! -d "$dir" ]
then
    dir=$(mktemp -d "$HOME"/binXXX)
    echo "Se ha creado el directorio $dir"
fi

echo "Directorio destino de copia: $dir"

count=0 # Contador de ficheros copiados a dir

# La variable i en cada iteracion tomara el valor de cada uno
# de los ficheros/directorios del directorio actual de trabajo
for i in *
do  
    if  [ -f "$i" -a -x "$i" ] # Comprueba si es un fichero regular y ejecutable
    then
        cp "$i" "$dir" # Copia el fichero a dir
        echo "./$i ha sido copiado a $dir"
        count=$(( ++count )) # Aumenta el contador de ficheros copiados
    fi
done

# Finalmente se imprimira el total de ficheros 
# copiados del directorio actual de trabajo a dir
if [ $count -gt 0 ]
then
    echo "Se han copiado $count archivos"
else
    echo "No se ha copiado ningun archivo"
fi
