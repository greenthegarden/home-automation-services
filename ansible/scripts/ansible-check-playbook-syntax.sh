#!/usr/bin/env bash

extension="yml"
inventory="hosts"
playbook="site"

read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}.${extension}"
if [ ! -f ${inventory} ] ; then
  echo "Inventory file ${inventory} not found!"
  exit
fi

read -p "Enter playbook file name [${playbook}]: " playbook_input
playbook="${playbook_input:-${playbook}}.${extension}"
if [ ! -f ${playbook} ] ; then
  echo "Playbook file ${playbook} not found!"
  exit
fi

ansible-playbook -i ${inventory} --syntax-check ${playbook}
