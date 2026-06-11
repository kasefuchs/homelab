# frozen_string_literal: true

class BaseProvider
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def self.for(config)
    kind = config[:kind]

    path = File.expand_path("../#{kind}.rb", __FILE__)
    raise "Module for provider '#{kind}' not found" unless File.exist?(path)

    require path

    class_suffix = kind.split('_').map(&:capitalize).join
    class_name = "#{class_suffix}Provider"
    raise "Class for provider '#{kind}' not found" unless Object.const_defined?(class_name)

    Object.const_get(class_name).new(config)
  end

  def name
    self.class::NAME
  rescue NameError
    raise NotImplementedError, "#{self.class} must define NAME constant"
  end

  def apply(machine)
    machine.vm.provider(name) { |p| configure(p) }
  end

  protected

  def configure(provider)
    raise NotImplementedError, "#{self.class} must define configure_provider method"
  end
end
