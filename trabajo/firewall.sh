# Limpiar tablas anteriores
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establecer políticas predeterminadas
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir conexiones locales
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexiones internas
iptables -A FORWARD -i enp0s8 -j ACCEPT
iptables -A FORWARD -i enp0s9 -j ACCEPT
iptables -A INPUT -i enp0s8 -j ACCEPT
iptables -A INPUT -i enp0s9 -j ACCEPT

# Permitir conexiones desde la red "Host-only"
iptables -A INPUT -i enp0s10 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i enp0s10 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Configuración de NAT para la red "Host-only"
iptables -t nat -A POSTROUTING -o enp0s10 -j SNAT --to 192.168.57.2

# Redirección de puertos para el servidor web en debian2
iptables -A FORWARD -i enp0s10 -p tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j DNAT --to 192.168.58.2

# Redirección de puertos para el servidor SSH en debian5
iptables -A FORWARD -i enp0s10 -p tcp --dport 22 -j ACCEPT
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 22 -j DNAT --to 192.168.60.2

# Permitir conexiones de entrada y salida hacia Internet
iptables -A INPUT -i enp0s3 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i enp0s3 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s3 -j SNAT --to 192.168.57.2

# Preservación de las reglas iptables
iptables-save > /etc/iptables/rules.v4
