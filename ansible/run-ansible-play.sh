#!/usr/bin/env bash

# default values
extension="yml"
inventory="hosts"
playbook="site"
requirements="requirements"
use_retry=false
use_sudo=false
use_vault=false
vault_details="dev@prompt"
vault_password=false
verbose_level="v"

script=$0

function usage {
    echo "usage: $script [-bhl:rpsv] [-l limit_arg] [-v verbose_level]"
    echo "  -b      use --ask-become-pass option"
    echo "  -h      display help"
    echo "  -r      use retry"
    echo "  -p      use --ask-vault-pass option"
    echo "  -l limit_arg      "
    echo "  -v verbose_level  specify verbose level: v, vv, or vvv"
    exit 1
}

# get command line arguments
while getopts "bhl:rpsv:" opt ;
do
  case $opt in
    b) use_sudo=true;;
    l) limit_arg=$OPTARG;;
    r) use_retry=true;;
    p) vault_password=true;;
    s) use_vault=true;;
    v) verbose_level=$OPTARG;;
    h) usage
    exit 0;;
    *) usage
    exit 1;;
  esac
done

# prompt for variables
read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}"
inventory_file="${inventory}.${extension}"
if [ ! -f "${inventory_file}" ] ;
then
  echo "Inventory file ${inventory_file} not found"
  exit
fi

read -p "Enter playbook file name [${playbook}]: " playbook_input
playbook="${playbook_input:-${playbook}}"
playbook_file="${playbook}.${extension}"
if [ ! -f "${playbook_file}" ] ;
then
  echo "Playbook file ${playbook_file} not found"
  exit
fi

if [ ${use_retry} = true ] ;
then
  retry_file="${playbook}.retry"
  if [ -f ${retry_file} ] ;
  then
    echo "Will retry with file ${retry_file}"
    limits="--limit @${retry_file}"
  else
    echo "Retry file ${retry_file} not found"
    exit
  fi
fi

if [ ${use_vault} = true ] ;
then
  read -p "Enter vault details [${vault_details}]: " vault_details_input
  vault_details="${vault_details_input:-${vault_details}}"
  vault_arg="--vault-id ${vault_details}"
fi

options=""
if [ ${vault_password} = true ] ;
then
  options="${options} --ask-vault-pass"
fi

if [ ${use_sudo} = true ] ;
then
  options="${options} --ask-become-pass"
fi

verbose_arg=""
if [ ! -z ${verbose_level+x} ] ;
then
  verbose_arg="-${verbose_level}"
  echo "Verbose level set to ${verbose_level}"
fi

requirements_file="${requirements}.${extension}"
if [ -f "${requirements_file}" ] ;
then
  echo "Getting dependent roles defined in ${requirements_file} ..."
  ansible-galaxy install -r ${requirements_file}
fi

echo "Running playbook ${playbook_file} with inventory ${inventory_file} with options ${options}"
ansible-playbook -i ${inventory_file} ${options} ${vault_arg} ${verbose_arg} ${playbook_file} ${limits}
