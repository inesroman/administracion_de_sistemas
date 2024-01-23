#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

if [ $# -ne 3 ]
then 
    echo "Numero incorrecto de parametros"
else
    # Añadir usuarios
    if [ $1 = "-a" ]
    then
        # Lee las ips de las máquinas en las que tiene que crear/borrar usuarios
        while read ip
        do
            ssh -n as@$ip
            if [ $? -eq 0 ]
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
                    # Se añade el nuevo usuario en la máquina remota
                    ssh -n as@$ip "sudo useradd -m -k /etc/skel -U -K UID_MIN=1815 -c \"$fullname\" \"$username\" 2>/dev/null &&
                        (echo \"$username:$password\" | sudo chpasswd; sudo usermod \"$username\" -f 30; echo \"$fullname ha sido creado\") ||
                        echo \"El usuario $username ya existe\""
                done < "$2"    
                IFS=$OLDIFS
            else
                echo "$ip no es accesible"
            fi
        done < "$3"
    # Borrar usuarios
    elif [ $1 = "-s" ]
    then
        while read ip
        do
            ssh -n as@$ip
            if [ $? -eq 0 ]
            then
                ssh -n as@$ip "[ ! -d /extra/backup ] && sudo mkdir -p /extra/backup"
                OLDIFS=$IFS
                IFS=,
                while read username password fullname
                do
                    if [ "$username" = "" ]
                    then
                        # Si el campo de usarname es nulo, el usuario es inválido
                        echo "Campo ivalido"
                        exit 1
                    fi
                    # Se borra el suario y se crea la copia de seguridad
                    ssh -n as@$ip "userhome=\$(getent passwd $username | cut -d: -f6);
                    sudo tar czf /extra/backup/$username.tar \$userhome 2>/dev/null;
                    [ \$? -eq 0 ] && sudo userdel -f $username 2>/dev/null"
                done < "$2"
                IFS=$OLDIFS
            else
                echo "$ip no es accesible"
            fi
        done < "$3"  
    else 
        # La opción pasada al script no es ni -a ni -s
        echo "Opcion invalida" 1>&2
    fi
fi