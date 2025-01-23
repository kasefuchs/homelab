# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

config = YAML.load_file("config.yml")

BOX_IMAGE = config["box_image"]
NODE_COUNT = config["node_count"]
VM_CPUS = config["vm_cpus"]
VM_MEMORY = config["vm_memory"]
SSH_PORT_PREFIX = config["ssh_port_prefix"]
NEBULA_PORT_PREFIX = config["nebula_port_prefix"]
NETWORK_IP_PREFIX = config["network_ip_prefix"]

Vagrant.configure("2") do |cfg|
	cfg.vm.box = BOX_IMAGE
	cfg.vm.synced_folder ".", "/vagrant", disabled: true

	cfg.vm.provider "virtualbox" do |vb|
		vb.cpus = VM_CPUS
		vb.memory = VM_MEMORY
		vb.linked_clone = true
	end

	(1..NODE_COUNT).each do |idx|
		node_str = "#{idx}".rjust(2, "0")

		cfg.vm.define "node-#{node_str}" do |node|
			node.vm.network "forwarded_port", id: "ssh", host: SSH_PORT_PREFIX + idx, guest: 22, protocol: "tcp"
			node.vm.network "forwarded_port", id: "nebula", host: NEBULA_PORT_PREFIX + idx, guest: 4646, protocol: "udp"
			node.vm.network "private_network", ip: "192.168.56.#{NETWORK_IP_PREFIX + idx}"
		end
	end
end
