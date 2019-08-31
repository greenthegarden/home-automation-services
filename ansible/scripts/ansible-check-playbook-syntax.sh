#!/usr/bin/env bash

extension="yml"
inventory="hosts"
playbook="common"

read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}.${extension}"

read -p "Enter playbook file name [${playbook}]: " playbook_input
playbook="${playbook_input:-${playbook}}.${extension}"

if [ -f ${inventory} ] && [ -f ${playbook} ] ; then
  echo "Checking playbook ${playbook} with inventory ${inventory}"
  ansible-playbook -i ${inventory} --syntax-check ${playbook}
else
  echo "Check inventory and playbook files"
  exit
fi
