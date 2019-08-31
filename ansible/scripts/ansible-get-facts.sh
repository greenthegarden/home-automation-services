#!/usr/bin/env bash

extension="yml"
inventory="hosts"
remote_host="localhost"

read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}.${extension}"

read -p "Enter remote host [${remote_host}]: " remote_host_input
remote_host="${remote_host_input:-${remote_host}}"

ansible ${remote_host} -i ${inventory} -m setup
