# frozen_string_literal: true

require_relative 'base'

class ShellProvisioner < BaseProvisioner
  NAME = :shell

  protected

  def configure(provisioner)
    assign(provisioner, :inline, :path)
  end
end
