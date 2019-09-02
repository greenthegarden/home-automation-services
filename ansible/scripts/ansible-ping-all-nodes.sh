#!/usr/bin/env bash

extension="yml"
inventory="hosts"

read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}.${extension}"
if [ ! -f ${inventory} ] ; then
  echo "Inventory file ${inventory} not found!"
  exit
fi

ansible all -i ${inventory} --module-name=ping
