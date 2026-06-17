# frozen_string_literal: true

require_relative '../component'

class BaseProvider < BaseComponent
  def self.for(config)
    super(config, path: __dir__, suffix: 'Provider')
  end

  def apply(machine)
    machine.vm.provider(name) { |p| configure(p) }
  end
end
