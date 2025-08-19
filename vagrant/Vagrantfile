# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"
require_relative "lib/extensions/hash"

common_options = YAML.safe_load_file("options/common.yaml", aliases: true)

provider_name    = common_options.fetch("provider")
provider_path    = "options/#{provider_name}.yaml"
provider_options = File.exist?(provider_path) ? YAML.safe_load_file(provider_path, aliases: true) : {}
override_path    = "options/#{provider_name}.override.yaml"
override_options = File.exist?(provider_path) ? YAML.safe_load_file(override_path, aliases: true) : {}

options = common_options.deep_merge(provider_options).deep_merge(override_options)

require_relative "lib/providers/#{provider_name}"

Vagrant.configure("2") do |config|
  config.vm.box = provider_name != "docker" ? options.fetch("box") : nil
  config.vm.synced_folder ".", "/vagrant", disabled: true

  (options.dig("provision", "shell") || []).each do |command|
    config.vm.provision "shell", inline: command
  end

  (1..options.fetch("nodes", 1)).each do |node_index|
    node_name = format("node-%02d", node_index)

    config.vm.define node_name do |node|
      Provider.configure(node, node_index, node_name, options.deep_dup)

      node.vm.hostname = node_name

      root_host_path = options.dig("persistent", "root")
      (options.dig("persistent", "volumes") || {}).each do |folder_id, mount_options|
        base_host_path = mount_options.fetch("host", File.join(root_host_path, folder_id))
        full_host_path = File.join(base_host_path, node_name)
        FileUtils.mkdir_p(full_host_path) unless Dir.exist?(full_host_path)

        node.vm.synced_folder full_host_path, mount_options.fetch("guest"), id: folder_id
      end

      (options.dig("network", "ports") || {}).each do |port_id, port_options|
        node.vm.network :forwarded_port,
          id:       port_id,
          host:     port_options.fetch("host") + node_index,
          guest:    port_options.fetch("guest"),
          protocol: port_options.fetch("protocol", "tcp")
      end
    end
  end
end
