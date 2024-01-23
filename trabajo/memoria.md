# PRELIMINARES
Instalamos sudo en la máquina as-base-iptables:
> su root 
 (introducir contraseña)
> apt-get sudo
y la configuramos apara que el usuario as pueda ejecutar comandos con sudo sin
que se le pida la constraseña, al archivo /etc/sudoers añadir la línea: 
"as ALL=(ALL) NOPASSWD:ALL" 
A partir de esta máquina creamos 6 clones enlazados de esta:
debian1, debian2, debian3, debian4, debian5 y debian6.

Para facilitar el trabajo con las distintas máquinas podemos cambiarle el 
nombre de "as-base" a "debianX" cambiando el nombre en los archivos
/etc/hostnames y /etc/hosts y apagamos las máquinas.

# CONFIGURACION DE LAS SUBREDES INTERNAS
##  debian1
1. Con la máquina apagada configuramos las redes:
- Adaptador 1: NAT
- Adaptador 2: Red interna 1
- Adaptador 3: Red interna 2
- Adaptador 4: solo-anfitrión (ip 192.168.57.0/24)

2. Encendemos la máquina y modificamos el archivo /etc/network/inerfaces:
> sudo nano /etc/network/interfaces
Añadimos las líneas:
"       
    auto enp0s8
    iface enp0s8 inet static
        address 192.168.58.1
        netmask 255.255.255.0
        
    auto enp0s9
    iface enp0s9 inet static
        address 192.168.59.1
        netmask 255.255.255.0
        up ip route add 192.168.60.0/24 via 192.168.59.2
    
    auto enp0s10
    iface enp0s10 inet static
        address 192.168.57.2
        netmask 255.255.255.0    
                                "

3. Para que la máquina actúe como router, editar el archivo /etc/sysctl.conf:
> sudo nano /etc/sysctl.conf
y descomentar la línea "net.ipv4.ip_forward = 1"

4. Reiniciamos la máquina:
> sudo shutdown -r now

5. Comprobamos que funcionan los cambios, haciendo ping al host y a google:
> ping 192.168.57.1
> ping 8.8.8.8


##  debian2
1. Con la máquina apagada configuramos las redes:
- Adaptador 1: Red interna 1
2. Encendemos la máquina y modificamos el archivo /etc/network/inerfaces:
> sudo nano /etc/network/interfaces
Borramos las lineas en las que se define enp0s3 y añadimos las siguientes líneas:
 "
    auto enp0s3
    iface enp0s3 inet static
        address 192.168.58.2
        netmask 255.255.255.0
        gateway 192.168.58.1
        broadcast 192.168.58.255
                                "   
3. Guardamos los cambios y los aplicamos:
> sudo systemctl restart networking

4. Comprobamos que funciona haciendo ping a la máquina debian1: 
> ping 192.168.58.1

##  debian3 y debian4
1. Con la máquina apagada configuramos las redes:
- Adaptador 1: Red interna 2

2. Encendemos la máquina y modificamos el archivo /etc/network/inerfaces:
> sudo nano /etc/network/interfaces
Borramos las lineas en las que se define enp0s3 y añadimos las siguientes líneas:
 "
    auto enp0s3
    iface enp0s3 inet dhcp
                            "   
Todavía no podemos comprobar que funcionan porque falta el servidor dhcp en debian1.

## Servidor DHCP
1. En la máquina debian1 instalar el servidor DHCP ejecutando el siguiente comando:
> sudo apt-get install isc-dhcp-server

2. Abrir el archivo de configuración del servidor DHCP para editarlo:
> sudo nano /etc/dhcp/dhcpd.conf
Dentro del archivo se descomenta la línea "authotitative": cuando se establece esta directiva en el 
archivo de configuración, el servidor DHCP ignorará las ofertas de otros servidores DHCP en la red y 
responderá únicamente a las solicitudes de clientes DHCP.
Y añadimos las siguientes líneas al final para configurar la red interna 2:
"
    subnet 192.168.59.0 netmask 255.255.255.0 {
        range 192.168.59.3 192.168.59.200;
        option routers 192.168.59.1;
    }  
                                            "
3. Editamos el archivo /etc/default/isc-dhcp-server, cambiamos la línea en la que 
aparece INTERFACESv4 por INTERFACESv4="enp0s9"

4. Reiniciamos la máquina debian1:
> sudo shutdown -r now

5. En las máquinas debian3 y debian4 ejecutamos el siguiente comando:
> sudo systemctl restart networking
y vemos que ip se les ha asginado a ambas máquinas:
> ip route

6. Comprobamos que están conectadas al sistema mediante pings, desde debian3 y debian4:
> ping 192.168.59.1 (debian1)
> ping 192.168.58.2 (debian2)

##  debian5
1. Con la máquina apagada configuramos las redes:
- Adaptador 1: Red interna 3
2. Borramos las lineas en las que se define enp0s3 y añadimos las siguientes líneas:
 "
    auto enp0s3
    iface enp0s3 inet static
        address 192.168.60.2
        netmask 255.255.255.0
        network 192.168.60.0
        gateway 192.168.60.1
                            "   
3. Guardamos los cambios y los aplicamos:
> sudo systemctl restart networking

Cuando se configuré debian6 se podrá probar si conecta con el resto de la red
(excepto con debian3 y debian4 por ahora).

##  debian6
1. Con la máquina apagada configuramos las redes:
- Adaptador 1: Red interna 3
- Adaptador 2: Red interna 2
2. Borramos las lineas en las que se define enp0s3 y añadimos las siguientes líneas:
 "   
    auto enp0s3
    iface enp0s3 inet static
        address 192.168.60.1
        netmask 255.255.255.0

    auto enp0s8
    iface enp0s8 inet static
        address 192.168.59.2
        netmask 255.255.255.0
        network 192.168.59.0
        gateway 192.168.59.1
                                "   

3. Para que la máquina actúe como pasarela ente las redes 2 y 3, editar el archivo /etc/sysctl.conf:
> sudo nano /etc/sysctl.conf
y descomentar la línea "net.ipv4.ip_forward = 1"

4. Reiniciar la máquina:
> sudo shutdown -r now

5. Comprobamos que funciona el sistema mandando pings de todas las máquinas al resto de
máquinas, todos deberán funcionar (reiniciar las máquinas o el servicio de networking 
si es necesario).

# FIREWALL
En debian1, instaral el paquete:
> sudo apt-get install iptables-persistent
para poder guardar y mantener la configuración del firewall en el fichero /etc/iptables/rules.v4.
Crear y ejecutar con permisos de administración un fichero firewall.sh con
los siguientes comandos:

- Limpiar tablas anteriores
    iptables -F
    iptables -X
    iptables -Z
    iptables -t nat -F

- Establecer políticas predeterminadas
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

- Permitir conexiones locales
    iptables -A INPUT -i lo -j ACCEPT

- Permitir conexiones internas
    iptables -A FORWARD -i enp0s8 -j ACCEPT
    iptables -A FORWARD -i enp0s9 -j ACCEPT
    iptables -A INPUT -i enp0s8 -j ACCEPT
    iptables -A INPUT -i enp0s9 -j ACCEPT

- Permitir conexiones desde la red "Host-only"
    iptables -A INPUT -i enp0s10 -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A FORWARD -i enp0s10 -m state --state ESTABLISHED,RELATED -j ACCEPT

- Configuración de NAT para la red "Host-only"
    iptables -t nat -A POSTROUTING -o enp0s10 -j SNAT --to 192.168.57.2

- Redirección de puertos para el servidor web en debian2
    iptables -A FORWARD -i enp0s10 -p tcp --dport 80 -j ACCEPT
    iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j DNAT --to 192.168.58.2

- Redirección de puertos para el servidor SSH en debian5
    iptables -A FORWARD -i enp0s10 -p tcp --dport 22 -j ACCEPT
    iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 22 -j DNAT --to 192.168.60.2

- Permitir conexiones de entrada y salida hacia Internet
    iptables -A INPUT -i enp0s3 -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A FORWARD -i enp0s3 -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -t nat -A POSTROUTING -o enp0s3 -j SNAT --to 192.168.57.2

- Preservación de las reglas iptables
    iptables-save > /etc/iptables/rules.v4

# SERVIDOR WEB
1. En la máquina debian2 instalamos el servidor wed:
> sudo apt-get install apache2

2. Iniciamos el servicio: 
> sudo systemctl start apache2

3. Comprobamos que funciona, desde la máquina local en un navegador web buscamos la direccion
192.168.57.2 (debian1) con puerto 80:
    192.168.57.2:80
y vemos que aparece la página por defecto de apache2.

# SERVIDOR SSH
1. Instalamos ssh en debian5:
> sudo apt-get install ssh

2. Modificamos la configuración de ssh para que no se pueda conectar desde una máquina remota
al root de debian5.
> sudo nano /etc/ssh/sshd_config
Descomentamos la línea en la que se configura PermitRootLogin y ponemos "PermitRootLogin no".

3. Guardamos los cambios y reinciamos el servicio:
> sudo systemctl restart ssh

4. Comprobamos que nos podemos conectar al servidor ssh de debian5 desde la máquina local:
> ssh as@192.168.57.2
