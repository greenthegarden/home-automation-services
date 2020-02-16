# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version '>= 1.6.0'
VAGRANTFILE_API_VERSION = '2'

# Require the YAML module and Azure provider plugin
require 'yaml'
require 'vagrant-azure'

# Load settings from vagrant.yml or vagrant.yml.dist
current_dir = File.dirname(File.expand_path(__FILE__))
if File.file?("#{current_dir}/vagrant.yml")
  config_file = YAML.load_file("#{current_dir}/vagrant.yml")
elsif
  config_file = YAML.load_file("#{current_dir}/vagrant.yml.dist")
else
  exit(1)
end

# Get settings from configuration file to enable easier access
controller_node_settings = config_file['configs'][config_file['configs']['use']]['controller_node']
services_node_settings = config_file['configs'][config_file['configs']['use']]['services_node']
vb_settings = config_file['configs'][config_file['configs']['use']]['vb']
services_node_count = config_file['configs']['services_node_count']

# Define references which do not change with names
controller_node_base = "controller-node"
services_node_base = "services-node"

puts "Using configurations for %s" % config_file['configs']['use']
puts "controller_node settings: %s" % controller_node_settings
puts "services_node settngs: %s" % services_node_settings
puts "services_node_count: %s" % services_node_count

# Define scripts
def generate_node_ip(vb_settings, id)
  node_ip_range = vb_settings['ip_range']
  node_ip_id = Integer(id)
  node_ip = [ node_ip_range, node_ip_id ].join('.')
end

# Create and configure the specified systems
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Specify provider order preference
  # For details see https://www.vagrantup.com/docs/providers/basic_usage.html#default-provider
  config.vm.provider "virtualbox"

  # Disable the default /vagrant share
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # # Use local ssh key to connect to remote vagrant box
  # if not Vagrant::Util::Platform.windows? then
  # config.ssh.private_key_path = './ssh_keys/id_rsa'
  # end

  # Set virtualbox provider specific attributes
  config.vm.provider "virtualbox" do |v|
    v.gui = false
  end

  # # Create nodes for services to be deployed on
  (1..services_node_count).each do |i|

    services_node_name = services_node_settings['name'] + "-" + String(i)
    puts "Services node name set to %s" % services_node_name

    services_node_machine = services_node_base + "-" + String(i)

    config.vm.define services_node_machine do |services_node|

      # Specify the hostname of the machine
      services_node.vm.hostname = services_node_name

      # Set node specific VirtualBox configuration/overrides
      services_node.vm.provider "virtualbox" do |vb, override|

        services_node.vm.box = services_node_settings['vb']['box']

        services_node_ip_base = Integer(services_node_settings['vb']['external_ip_base']) + (i-1)
        services_node_ip = generate_node_ip(vb_settings, services_node_ip_base)
        # puts "Services node IP address set to %s" % services_node_ip

        services_node.vm.network :private_network, ip: "172.16.1.#{i + 100}"

        vb.name = services_node_name
        vb.cpus = services_node_settings['vb']['resources']['cpus']
        vb.memory = services_node_settings['vb']['resources']['memory']
        # vb.customize ["modifyvm", :id, "--ioapic", "on"]
        # Enable NAT hosts DNS resolver
        # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

      end

      # Configure ssh access on VM
      public_key = File.read("./ssh_keys/id_ed25519.pub")
      services_node.vm.provision :shell, :inline =>"
        echo 'Copying ansible-vm public SSH Keys to the VM'
        mkdir -p /home/vagrant/.ssh
        chmod 700 /home/vagrant/.ssh
        echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
        chmod -R 600 /home/vagrant/.ssh/authorized_keys
        echo 'Host *' >> /home/vagrant/.ssh/config
        echo 'StrictHostKeyChecking no' >> /home/vagrant/.ssh/config
        echo 'UserKnownHostsFile /dev/null' >> /home/vagrant/.ssh/config
        chmod -R 600 /home/vagrant/.ssh/config
        ", privileged: false

      services_node.vm.post_up_message = "Service node spun up!"

    end

  end


  # Create a machine to run Ansible

  controller_node_machine = controller_node_base

  config.vm.define controller_node_machine do |controller_node|

    controller_node_name = controller_node_settings['name']

    # Specify the hostname of the machine
    controller_node.vm.hostname = controller_node_name

    # Sync ansible folder to remote
    controller_node.vm.synced_folder "./ansible", "/vagrant/ansible", type: "rsync",
      rsync__exclude: [".git/"],
      rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "-z"]

    # Set node specific VirtualBox configuration/overrides
    controller_node.vm.provider "virtualbox" do |vb|

      controller_node.vm.box = controller_node_settings['vb']['box']

      controller_node_ip_base = Integer(controller_node_settings['vb']['external_ip_base'])
      controller_node_ip = generate_node_ip(vb_settings, controller_node_ip_base)
      # puts "Controller node IP address set to %s" % controller_node_ip

      controller_node.vm.network :private_network, ip: "172.16.1.10"

      vb.name = controller_node_name
      vb.memory = controller_node_settings['vb']['resources']['memory']
      vb.cpus = controller_node_settings['vb']['resources']['cpus']
      vb.linked_clone = true
      # vb.customize ["modifyvm", :id, "--ioapic", "on"]
      # Enable NAT hosts DNS resolver
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    end

    # Copy private ssh key to controller and set permissions
    controller_node.vm.provision "file", source: "./ssh_keys/id_ed25519", destination: "/home/vagrant/.ssh/id_ed25519"
    controller_node.vm.provision :shell, :inline =>"
      echo 'Setting permissions on ssh private key'
      chown -R vagrant:vagrant /home/vagrant/.ssh
      chmod 600 /home/vagrant/.ssh/id_ed25519
      ", privileged: false

    # Install Ansible on contoller_node and provision services
    controller_node.vm.provision :ansible_local do |ansible|

      ansible.install_mode = "pip"
      ansible.version = "2.9.2"
      ansible.compatibility_mode = "2.0"
      ansible.install = true
      ansible.limit = "all"
      ansible.verbose = "v"

      ansible.config_file = "ansible/ansible.cfg"
      ansible.inventory_path = "ansible/hosts-vagrant.yml"
      ansible.playbook = "ansible/site.yml"

      ansible.galaxy_role_file = "ansible/requirements.yml"
      ansible.galaxy_roles_path = "ansible/roles"

    end

    controller_node.vm.post_up_message = "Controller node spun up!"

  end

end
