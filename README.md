# Home Cloud Native Platform

Set of [Ansible](https://www.ansible.com/) scripts to automatically configure a set of nodes, such as [Raspberry Pis](https://www.raspberrypi.org/), to host multiple service to support home automation.

The following core services are installed on each node:

* [Git](https://git-scm.com/)
* [Pip](https://pypi.org/project/pip/)
* [Docker](https://www.docker.com/)
* [Hashicorp Consul](https://www.consul.io/)
* [Hashicorp Vault](https://www.hashicorp.com/products/vault/)
* [Hashicorp Nomad](https://www.hashicorp.com/products/nomad)
* [Traefik](https://traefik.io/)

The following services are distributed across the nodes:

* [Portainer](https://www.portainer.io/)
* [EMQX MQTT Broker](https://www.emqx.io/)
* [Nextcloud](https://nextcloud.com/)
* [openHAB](https://www.openhab.org/)
* [Home Assistant](https://www.home-assistant.io/)
* [Kerberos.io](https://www.kerberos.io/)

## Installing

Create an ssh key using [`scripts/create_keys.sh`](scripts/create_keys.sh) and copy is across to the nodes using [`scripts/copy_keys.sh`](scripts/copy_keys.sh).

Ensure Ansible is installed on the controller using [`scripts/install_ansible.sh`](scripts/install_ansible.sh).

Ensure dependent Ansible roles, defined in [`ansible/requirements.sh`](ansible/requirements.sh), are installed from [Ansible Galaxy](https://galaxy.ansible.com/) using [`ansible/ansible-install-dependent-roles.sh`](ansible/ansible-install-dependent-roles.sh).

Configure and [Ansible Inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html), such as [`ansible/hosts.yml`](ansible/hosts.yml) to suit the network. Check the nodes specified within the inventory file using [`ansible/ansible-list-all-nodes.sh`](ansible/ansible-list-all-nodes.sh). Test the connection to the nodes using [`ansible/ansible-ping-all-nodes.sh`](ansible/ansible-ping-all-nodes.sh). Get the facts about a node using [`ansible/ansible-get-facts.sh`](ansible/ansible-get-facts.sh).

Create an [Ansible Playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) to run required roles on specified hosts. Test the playbook syntax using [`ansible/ansible-check-playbook-syntax.sh`](ansible/ansible-check-playbook-syntax.sh). Run the Ansible playbook using [`ansible/ansible-run-play.sh`](ansible/ansible-run-play.sh).

## Playbooks

* [`build-base.yml`](build-base.yml) will provision a node with a base OS with the core services defined above.
* [`home-automation.yml`](home-automation.yml) will add teh full stack of home automation services to a node which has the core service installed to .
