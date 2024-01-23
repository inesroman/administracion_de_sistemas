# PRELIMINARES
1. Instalar el paquete para trabajar con volumenes logicos y comprobar la correcta instalacion:
    > sudo apt-get install lvm2
    > systemctl list-units

2. Instalar parted
    > sudo apt-get install parted

3. Apagar la máquina y crear disco de 32MB: 

# PARTE 1
1. Comprobar que el disco se ha creado y ver su nombre (en este caso /dev/sdb):
    > sudo fdisk -l

2. Generar una tabla de particiones GUID:
    > sudo parted /dev/sdb mklabel gpt

3. Crear las particiones alineadas y asignarles sistemas de archivos:
    > sudo parted /dev/sdb mkpart primary ext3 1MiB 16MiB
    > sudo parted /dev/sdb mkpart primary ext4 16MiB 31MiB

4. Formatear las particiones con los sistemas de archivos correspondientes:
    > sudo mkfs -t ext3 /dev/sdb1
    > sudo mkfs -t ext4 /dev/sdb2

5. Crear los directorios de montaje para las particiones:
    > sudo mkdir /mnt/p1
    > sudo mkdir /mnt/p2

6. Montar las particiones:
    > sudo mount -t ext3 /dev/sdb1 /mnt/p1
    > sudo mount -t ext4 /dev/sdb2 /mnt/p2

7. Verificar el correcto montaje en el archivo /etc/mtab, asegurándonos de 
    que las siguientes líneas estén presentes en el archivo:
    "/dev/sdb1 /mnt/p1 ext3 rw,relatime 0 0"
    "/dev/sdb2 /mnt/p2 ext4 rw,relatime 0 0" 
    y agregar estas mismas líneas al archivo /etc/fstab

# PARTE 2
Ejecutamos el script en las máquinas debian-as1 (y debian-as2):
    > ./practica5_parte2.sh 192.168.56.11   (192.168.56.12 para debian-as2)

# PARTE 3 
1. Tras añdir el nuevo disco a la máquina, creamos una partición tipo lvm:
    > sudo fdisk /dev/sdc
        n (nueva partición)
        p (partición primaria)
        1 (número de partición)
        [enter] (primer sector)
        [enter] (último sector)
        t (cambiar tipo de partición)
        8e (tipo lvm)
        w (salir)
    > sudo parted /dev/sdc set 1 lvm on

2. Creamos un grupo volumen de nombre vg_p5:
    > sudo vgcreate vg_p5 /dev/sdc1

3. Desmontamos las particiones:
    > sudo umount /mnt/p1
    > sudo umount /mnt/p2

4. Lanzamos el nuevo script:
    > sudo ./practica5_parte3_vg.sh vg_p5 /dev/sdb1 /dev/sdb2

5. Comprobamos que se ha extendido el grupo volumen:
    > sudo vgdisplay

6. Lanzamos el último script:
    > sudo mkdir /mnt/lv1
    > echo "vg_p5,lv1,8MiB,ext4,/mnt/lv1" | sudo ./practica5_parte3_lv.sh

7. Comprobamos el correcto funcionamiento del script:
    > sudo lvdisplay