require_relative "../utils/ip"

module Provider
  def self.configure(node, node_index, node_name, options)
    node.vm.provider :docker do |domain|
      name_format = options.dig("domain", "name_format")

      domain.name        = format(name_format, node_name)
      domain.image       = options.fetch("image")
      domain.volumes     = options.dig("storage", "volumes")
      domain.create_args = options.dig("domain", "create_arguments")
    end

    (options.dig("network", "private") || {}).each do |network_name, network_options|
      raw_node_ip = IPUtils.ip_to_int(network_options.fetch("start_ip")) + node_index

      node.vm.network :private_network, name: network_name, ip: IPUtils.int_to_ip(raw_node_ip)
    end
  end
end
