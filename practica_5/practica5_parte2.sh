#!/bin/bash
#820731, Román Gracia, Inés, M, 3, A

if [ $# -ne 1 ]; then
  echo "Uso: $0 <direccion IP>"
  exit 1
fi

ssh as@$1 "sudo sfdisk -s"
ssh as@$1 "sudo sfdisk -l"
ssh as@$1 "df -hT | grep -v tmpfs"
