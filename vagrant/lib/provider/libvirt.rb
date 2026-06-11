# frozen_string_literal: true

require_relative 'base'

class LibvirtProvider < BaseProvider
  NAME = 'libvirt'

  protected

  def configure(provider)
    provider.cpus   = config.fetch(:cpus, 2)
    provider.memory = config.fetch(:memory, 1024)
  end
end
