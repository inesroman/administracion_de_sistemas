#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

if [ $EUID -ne 0 ]
then
    echo "Este script necesita privilegios de administracion"   
    exit 1
fi

if [ $# -ne 2 ]
then 
    echo "Numero incorrecto de parametros"
else
    # Añadir usuarios
    if [ $1 = "-a" ]
    then
        OLDIFS=$IFS
        IFS=,
        # Lee el fichero con los campos de los usuarios a añadir
        while read username password fullname
        do
            if [ "$username" = "" -o "$password" = "" -o "$fullname" = "" ]
            then
                # Uno de los campos en nulo y, por tanto, inválido
                echo "Campo ivalido"
                exit 1
            fi
            # Se añade el nuevo usuario
            useradd -m -k /etc/skel -U -K UID_MIN=1815 -c "$fullname" "$username" 2>/dev/null
            if [ $? -eq 0 ]
            then
                # Si se ha añadido correctamente se hacen las configuraciones correspondientes
                echo "$username:$password" | chpasswd
                usermod "$username" -f 30
                echo "$fullname ha sido creado"
            else
                echo "El usuario $username ya existe"
            fi
        done < "$2"    
        IFS=$OLDIFS
    # Borrar usuarios
    elif [ $1 = "-s" ]
    then
        OLDIFS=$IFS
        IFS=,
        if [ ! -d /extra/backup ]
        then
            # Se crea el directorio de backup si no ecxiste
            mkdir -p /extra/backup
        fi
        while read username password fullname
        do
            if [ "$username" = "" ]
            then
                # Si el campo de usarname es nulo, el usuario es inválido
                echo "Campo ivalido"
                exit 1
            fi
            # Copia de seguridad antes de borrar el usuario
            userhome="$(getent passwd "$username" | cut -d: -f6)"
            tar czf /extra/backup/"$username".tar "$userhome" 2>/dev/null
            if [ $? -eq 0 ]
            then
                # Se borra si la copia de seguridad ha sido realizada correctamente
                userdel -f "$username" 2>/dev/null
            fi
        done < "$2"
        IFS=$OLDIFS  
    else 
        # La opción pasada al script no es ni -a ni -s
        echo "Opcion invalida" 1>&2
    fi
fi