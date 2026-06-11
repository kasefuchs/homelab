# frozen_string_literal: true

require 'yaml'

class Config
  attr_reader :data

  def initialize(path = 'config.yaml')
    raise "Config file doesn't exist" unless File.exist?(path)

    @data = YAML.safe_load_file(path, aliases: true, symbolize_names: true)
  end

  def nodes
    @data.fetch(:nodes)
  end
end
