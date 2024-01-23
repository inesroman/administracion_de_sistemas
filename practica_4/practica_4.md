# PARTE 1
1. Hacemos dos clones enlazados de la máquina as_base: "debian-as1" y "debian-as2".
2. Creamos una red Host-only Network: 
    Herramientas > Crear > Host-only Networks
    - IPv4 address: 192.168.56.1
    - Máscara de red: 255.255.255.0
    - Servidor de DHCP: inhabilitado
3. Definimos los siguientes adaptadores de red para las dos máquinas:
    debian-asX > Configuración > Red > Adaptador 1 > NAT
    debian-asX > Configuración > Red > Adaptador 2 > Adaptador solo anfitrión

# PARTE 2
1. Configuramos ambas máquinas para poder hacer sudo sin contraseña.
    Si sudo no esta instalado:
    > su root (introducir contraseña de root)
    > apt update && apt install sudo
    Se edita el fichero /etc/sudoers, añadiéndole la línea:
    "as ALL=(ALL) NOPASSWD:ALL"
2. En la máquina debian-as1 editamos el archivo /etc/network/interfaces y añadimos al final:
        auto enp0s8
        iface enp0s8 inet static
            address 192.168.56.11
            netmask 255.255.255.0
    (Lo mismo para debian-as2, pero la dirección es 192.168.56.12)
    Para aplicar los cambios:
    > sudo systemctl restart networking
3. Comprobamos que las máquinas se pueden comunicar con el host mediante ping.
4. En el archivo de /etc/ssh/sshd_config de ambas máquinas, añadimos la línea:
    "PermitRootLogin no"
    y guardamos los cambios:
    > sudo systemctl restart ssh
5. Comprobamos que nos podemos conectar a ambas máquinas mediante ssh

# PARTE 3
En la máquina host:
1. Creamos la clave pública ed25519 y el fichero de la clave privada id_as_ed25519:
    > ssh-keygen -t ed25519 -f ~/.ssh/id_as_ed25519
2. Copiamos la clave pública a las máquinas debian-as1 y debian-as2:
    > ssh-copy-id -i ~/.ssh/id_as_ed25519.pub as@192.168.56.11
    > ssh-copy-id -i ~/.ssh/id_as_ed25519.pub as@192.168.56.12
3. Editamos el fichero ~/.ssh/config y añadimos las líneas:
    "Host 192.168.56.11
       IdentityFile ~/.ssh/id_as_ed25519
    Host 192.168.56.12
       IdentityFile ~/.ssh/id_as_ed25519"

# PARTE 4
Para el script de esta prátcica "practica_4.sh" se ha reutilizado el código de 
la prátcica anterior "practica_3.sh", al que se le han realizado algunos pequeños 
cambios:
 - Se le pasa un parámetro más que corresponde con un fichero con las direcciones ip
    de las máquinas donde se crean o borran usuarios.
 - El bucle de creación/borrado de usuarios está contenido en un bucle que lee las
    ips de las máquinas donde se han de realizar estas operaciones.
 - Todos los comandos empleados para la creación y borrado de usuarios ahora deberán
    ser pasados a la máquina de la cual conocemos su dirección ip. Habrá que tener 
    cuidado a la hora de pasar los comandos teniendo en cuenta las reglas de expansión
    de variables, así como los controles de flujo del código.
