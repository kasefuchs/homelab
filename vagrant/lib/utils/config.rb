require "yaml"
require_relative "../extensions/hash"

module ConfigUtils
  def self.file_path(layer_name, override)
    filename = override ? "#{layer_name}.override.yaml" : "#{layer_name}.yaml"
    File.join("configs", filename)
  end

  def self.load_layer(layer_name, override)
    path = file_path(layer_name, override)

    File.exist?(path) ? YAML.safe_load_file(path, aliases: true) : {}
  end

  def self.load_layer_with_overrides(layer_name)
    base      = load_layer(layer_name, false)
    overrides = load_layer(layer_name, true)

    base.deep_merge(overrides)
  end
end
