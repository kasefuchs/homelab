# frozen_string_literal: true

require_relative '../component'

class BaseProvisioner < BaseComponent
  def self.for(config)
    super(config, path: __dir__, suffix: 'Provisioner')
  end

  def apply(machine)
    machine.vm.provision(name) { |p| configure(p) }
  end
end
