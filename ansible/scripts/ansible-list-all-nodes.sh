#!/usr/bin/env bash

extension="yml"
inventory="hosts"

read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}.${extension}"

ansible all -i ${inventory} --list-hosts
