# frozen_string_literal: true

class BaseComponent
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def self.for(config, path:, suffix:)
    kind = config[:kind]
    file_path = File.expand_path("#{kind}.rb", path)

    raise "Module for '#{kind}' doesn't exist" unless File.exist?(file_path)

    require file_path

    class_name = "#{kind.split('_').map(&:capitalize).join}#{suffix}"
    raise "Class '#{class_name}' not defined" unless Object.const_defined?(class_name)

    Object.const_get(class_name).new(config)
  end

  def name
    self.class::NAME
  rescue NameError
    raise NotImplementedError, "#{self.class} must define NAME constant"
  end

  protected

  def configure(target)
    raise NotImplementedError, "#{self.class} must define configure method"
  end

  def assign(target, *keys)
    keys.each do |key|
      next if (value = @config[key]).nil?

      target.public_send("#{key}=", value)
    end
  end
end
