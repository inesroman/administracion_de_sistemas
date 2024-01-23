#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

if [ $# -lt 2 ]; then
  echo "Uso: $0 <grupo_volumen> <partition1> <partition2> ..."
  exit 1
fi

if [ $EUID -ne 0 ]; then 
  echo "Este script necesita privilegios de administracion"
  exit 1
fi

vg_group="$1"
shift
vgextend "$vg_group" "$@"
