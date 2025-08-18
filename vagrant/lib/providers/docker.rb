require_relative "../utils/ip"

module Provider
  def self.configure(node, node_index, node_name, options)
    node.vm.provider :docker do |domain|
      name_format  = options.dig("domain", "name_format")
      network_args = docker_network_args(node_index, options.dig("network", "private"))

      domain.name        = format(name_format, node_name)
      domain.image       = options.fetch("image")
      domain.volumes     = options.dig("storage", "volumes")
      domain.create_args = options.dig("domain", "create_arguments") + network_args
    end
  end

  def self.docker_network_args(node_index, options)
    args = ["--network=#{options.fetch('name')}"]
    args << "--ip=#{IPUtils.increment_ip(options.fetch('start_ip'), node_index)}"
    args
  end
end
