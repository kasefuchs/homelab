# frozen_string_literal: true

require_relative 'base'

class LibvirtProvider < BaseProvider
  NAME = :libvirt

  protected

  def configure(provider)
    assign(provider, :cpus, :memory)
  end
end
