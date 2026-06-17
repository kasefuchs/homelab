# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/config'
require_relative 'lib/provider/base'
require_relative 'lib/provisioner/base'

options = Config.new

Vagrant.configure('2') do |config|
  options.nodes.each do |node_name, node_options|
    provider_options = node_options.fetch(:provider)
    provisioners_options = node_options.fetch(:provisioners, [])

    config.vm.define(node_name) do |machine|
      machine.vm.box = node_options[:box]

      BaseProvider.for(provider_options).apply(machine)
      provisioners_options.each do |provisioner_options|
        BaseProvisioner.for(provisioner_options).apply(machine)
      end
    end
  end
end
