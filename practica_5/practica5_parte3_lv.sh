#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

if [ $EUID -ne 0 ]; then 
  echo "Este script necesita privilegios de administracion"
  exit 1
fi

while IFS=',' read -r group_name lv_name size fs_type mount_dir; do
  # Verifica si el volumen lógico ya existe
  vdir=$(lvdisplay "$group_name/$lv_name" -Co "lv_path" | 
    grep "$group_name/$lv_name" | tr -d '[[:space:]]') &> /dev/null
  if [ -n "$vdir" ]; then
    # El volumen lógico existe, se extiende
    lvextend -L$size "$vdir"
    resize2fs "$vdir"
  else
    # El volumen lógico no existe, lo creamos
    lvcreate -n "$lv_name" -L "$size" "$group_name"
    
    if [ $? -eq 0 ]; then       
      # Crea el directorio de montaje si no existe
      if [ ! -d "$mount_dir" ]; then
        mkdir -p "$mount_dir"
      fi
      vdir=$(lvdisplay "$group_name/$lv_name" -Co "lv_path" | 
        grep "$group_name/$lv_name" | tr -d '[[:space:]]') &> /dev/null
          
      # Crea el sistema de archivos
      mkfs -t "$fs_type" "$vdir"

      # Monta el volumen lógico
      mount "$vdir" "$mount_dir"
      
      # Agrega la línea correspondiente al fichero /etc/fstab
      echo "$vdir $mount_dir $fs_type defaults 0 0" | tee -a /etc/fstab
    fi
  fi
done