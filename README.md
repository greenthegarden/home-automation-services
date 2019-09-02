# Home Automation Services

## Description

The [Home Automation Service](http://github.com/greenthegarden/home-automation-services) project is a set of [Ansible](https://www.ansible.com/) scripts, as configuration-as-code, to deploy services on to pre-configured nodes, which have either [Docker](https://www.docker.com) or [Hashicorp Nomad](https://www.nomad.io) pre-installed. The services are mainly those suitable for home automation. All the services are suitable to be hosted on a combination of smaller systems, such as Raspberry Pis, Intel-based systems, or Cloud Infrastructure; anything where Docker is supported.

The ability to provision the following services are included:

* [EMQX MQTT Broker](https://www.emqx.io/)
* [Home Assistant](https://www.home-assistant.io/)
* [Nextcloud](https://nextcloud.com/):
* [openHAB](https://www.openhab.org/)

## Dependencies

[Ansible](https://www.ansible.com/) is required to be installed on the machine the scripts will be run from. See []() for instructions on how to install Ansible. If Pip is available the script [scripts/install_ansible.sh](scripts/install_ansible.sh) can be utilised to install Ansible.

The services are deployed as Docker containers via the [Hashicorp Nomad](https://www.nomad.io) orchestration tool. The project [HCNP](https://github/greenthegarden/home-cloud-native-platform/) provides a capability to provision nodes with the necessary dependencies.

Ssh keys are required in order access each of the nodes. If not available create an ssh key using the script [scripts/create_keys.sh](scripts/create_keys.sh) and copy it across to the nodes using [scripts/copy_keys.sh](scripts/copy_keys.sh). If a non-default ssh key path is used, ensure the key path is defined in the Ansible inventory file, see the following section for details.

## Installing

### Inventory

Copy the [Ansible Inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) example file [ansible/hosts-example.yml](ansible/hosts-example.yml) to `ansible/hosts.yml` and edit the file to suit the hosts the services are to be deployed on. Ensure the ssh key path is correctly set if ssh keys have been generated.

A number of scripts are provided to check the inventory file and hosts within the inventory:

| File | Description |
| ---- | ----------- |
| [ansible/ansible-list-all-nodes.sh](ansible/ansible-list-all-nodes.sh) | Get the details of the nodes specified in the inventory file. |
| [ansible/ansible-ping-all-nodes.sh](ansible/ansible-ping-all-nodes.sh) |Test the ability to connect via ssh from the controller to each node specified in the inventory file. |
| [ansible/ansible-get-facts.sh](ansible/ansible-get-facts.sh) | Get the facts about the specified node. |

### Playbooks

The following [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) are provided to deploy individual services. In addition, the playbook, [site.yml](site.yml), agregates multiple plays to install all the services at once. If changes are made to the playbooks, the syntax can be checked using the script [ansible/ansible-check-playbook-syntax.sh](ansible/ansible-check-playbook-syntax.sh). The script [ansible/ansible-run-play.sh](ansible/ansible-run-play.sh) can be utilised to run any of the playbooks.

| Playbook | Description |
| -------- | ----------- |
| [ansible/emqx.yml](ansible/emqx.yml) | Deploys the |
| [ansible/home-assistant.yml](ansible/home-assistant.yml) | |
| [ansible/nextcloud.yml](ansible/nextcloud.yml) | Deploys the |
| [ansible/openhab.yml](ansible/openhab.yml) | |
